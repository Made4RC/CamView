//
//  GRBLProtocol.m
//  CamView
//
//  Created on 20.12.15.
//

#import "GRBLProtocol.h"

@implementation GRBLProtocol

- (void)setDelegate:(id)aDelegate {
    delegate = aDelegate; /// Not retained
}

- (BOOL)isConnected {
    if (_serialFileDescriptor>-1) {
        return TRUE;
    } else {
        return FALSE;
    }
}
- (NSString*)version {
    return _version;
}
- (BOOL)xLimitReached {
    return _xLimit;
}
- (BOOL)yLimitReached {
    return _yLimit;
}
- (BOOL)zLimitReached {
    return _zLimit;
}
- (NSString*)machineCoordinateX {
    return [NSString stringWithFormat:@"%0.3f",_machineCoordinateX];
}
- (NSString*)machineCoordinateY {
    return [NSString stringWithFormat:@"%0.3f",_machineCoordinateY];
}
- (NSString*)machineCoordinateZ {
    return [NSString stringWithFormat:@"%0.3f",_machineCoordinateZ];
}
- (NSString*)workCoordinateX {
    return [NSString stringWithFormat:@"%0.3f",_workCoordinateX];
}
- (NSString*)workCoordinateY {
    return [NSString stringWithFormat:@"%0.3f",_workCoordinateY];
}
- (NSString*)workCoordinateZ {
    return [NSString stringWithFormat:@"%0.3f",_workCoordinateZ];
}
- (int)feedRate {
    return _feed;
}
@synthesize configuration = _configuration;
- (void) setConfiguration:(NSDictionary*)dict {
    _configuration = [dict mutableCopy];
}
- (NSDictionary*)configuration {
    return _configuration;
}

// ##########################################################################
#pragma mark General
// ##########################################################################
- (id) init {
    self = [super init];
    if (self!=nil) {
        _serialFileDescriptor = -1;
        exitReadThread = FALSE;
        sentCommands = [[NSMutableArray alloc] init];
        
        _state = GRBL_STATE_NO_CONNECTION;
        _version = @"unknown";
        _xLimit = FALSE;
        _yLimit = FALSE;
        _zLimit = FALSE;
        _machineCoordinateX = 0.0;
        _machineCoordinateY = 0.0;
        _machineCoordinateZ = 0.0;
        _workCoordinateX = 0.0;
        _workCoordinateY = 0.0;
        _workCoordinateZ = 0.0;
        _workCoordinateOffsetX = 0.0;
        _workCoordinateOffsetY = 0.0;
        _workCoordinateOffsetZ = 0.0;
        
        _configuration = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}


// ##########################################################################
#pragma mark Connection
// ##########################################################################
- (NSString*)connect:(NSString*)toPath :(speed_t)withBaudRate {
    int success;
    
    // close the port if it is already open
    if (_serialFileDescriptor != -1) {
        close(_serialFileDescriptor);
        _serialFileDescriptor = -1;
        
        // re-opening the same port REALLY fast will fail spectacularly... better to sleep a sec
        sleep(0.5);
    }
    
    // c-string path to serial-port file
    const char *bsdPath = [toPath cStringUsingEncoding:NSUTF8StringEncoding];
    
    // Hold the original termios attributes we are setting
    struct termios options;
    
    // receive latency ( in microseconds )
    unsigned long mics = 3;
    
    // error message string
    NSString *errorMessage = nil;
    
    // open the port
    // O_NONBLOCK causes the port to open without any delay (we'll block with another call)
    _serialFileDescriptor = open(bsdPath, O_RDWR | O_NOCTTY | O_NONBLOCK );
    
    if (_serialFileDescriptor == -1) {
        // check if the port opened correctly
        errorMessage = @"Error: couldn't open serial port";
    } else {
        // TIOCEXCL causes blocking of non-root processes on this serial-port
        success = ioctl(_serialFileDescriptor, TIOCEXCL);
        if ( success == -1) {
            errorMessage = @"Error: couldn't obtain lock on serial port";
        } else {
            success = fcntl(_serialFileDescriptor, F_SETFL, 0);
            if ( success == -1) {
                // clear the O_NONBLOCK flag; all calls from here on out are blocking for non-root processes
                errorMessage = @"Error: couldn't obtain lock on serial port";
            } else {
                // Get the current options and save them so we can restore the default settings later.
                success = tcgetattr(_serialFileDescriptor, &_gOriginalTTYAttrs);
                if ( success == -1) {
                    errorMessage = @"Error: couldn't get serial attributes";
                } else {
                    // copy the old termios settings into the current
                    //   you want to do this so that you get all the control characters assigned
                    options = _gOriginalTTYAttrs;
                    
                    /*
                     cfmakeraw(&options) is equivilent to:
                     options->c_iflag &= ~(IGNBRK | BRKINT | PARMRK | ISTRIP | INLCR | IGNCR | ICRNL | IXON);
                     options->c_oflag &= ~OPOST;
                     options->c_lflag &= ~(ECHO | ECHONL | ICANON | ISIG | IEXTEN);
                     options->c_cflag &= ~(CSIZE | PARENB);
                     options->c_cflag |= CS8;
                     */
                    cfmakeraw(&options);
                    
                    // set tty attributes (raw-mode in this case)
                    success = tcsetattr(_serialFileDescriptor, TCSANOW, &options);
                    if ( success == -1) {
                        errorMessage = @"Error: coudln't set serial attributes";
                    } else {
                        // Set baud rate (any arbitrary baud rate can be set this way)
                        success = ioctl(_serialFileDescriptor, IOSSIOSPEED, &withBaudRate);
                        if ( success == -1) {
                            errorMessage = @"Error: Baud Rate out of bounds";
                        } else {
                            // Set the receive latency (a.k.a. don't wait to buffer data)
                            success = ioctl(_serialFileDescriptor, IOSSDATALAT, &mics);
                            if ( success == -1) {
                                errorMessage = @"Error: coudln't set serial latency";
                            }
                        }
                    }
                }
            }
        }
    }
    
    // make sure the port is closed if a problem happens
    if ((_serialFileDescriptor != -1) && (errorMessage != nil)) {
        close(_serialFileDescriptor);
        _serialFileDescriptor = -1;
    } else {
        exitReadThread = FALSE;
        _readThread = [[NSThread alloc] initWithTarget:self selector:@selector(recieverThread:) object:nil];
        [_readThread start];
        
        _responseTimer = [NSTimer scheduledTimerWithTimeInterval:0.2f target:self selector:@selector(reqeustStatus:) userInfo:nil repeats:YES];
  
//        NSArray* cmds = [[NSArray alloc] initWithObjects:@"$10=31", @"$$", nil];
//        [self sendCommands:cmds];
    }
    
    return errorMessage;
}
- (void) disconnect {
    exitReadThread = TRUE;
    [self sendCommand:@"?"];
    
    [_responseTimer invalidate];
    _responseTimer = nil;

    
    close(_serialFileDescriptor);
    _serialFileDescriptor = -1;
}


// ##########################################################################
#pragma mark Sending
// ##########################################################################
- (void)writeString:(NSString *)str {
    if(_serialFileDescriptor!=-1) {
        write(_serialFileDescriptor, [str cStringUsingEncoding:NSUTF8StringEncoding], [str length]);
    }
}
- (void)writeByte:(uint8_t *)val {
    if(_serialFileDescriptor!=-1) {
        write(_serialFileDescriptor, val, 1);
    }
}
- (void)sendCommand:(NSString*)command {
    [self writeString:[command stringByAppendingFormat:@"\n"]];
    [sentCommands addObject:command];
    // NSLog(@"Sende: '%@'", command);
}
- (void)sendCommands:(NSArray*)commands {
    [[[NSThread alloc] initWithTarget:self selector:@selector(senderThread:) object:commands] start];
}
- (void)reqeustStatus:(NSTimer *)timer {
    [self writeString:@"?"];
}
- (void)senderThread:(NSArray *)commands {
    __block int queueLength = 0;
    int counter = 0;
    for (NSString* command in commands) {
        counter++;
        dispatch_sync(dispatch_get_main_queue(), ^{
            queueLength = [self sentCommandsQueueLength];
        });
        while (queueLength + [command length] > 127) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                queueLength = [self sentCommandsQueueLength];
            });
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self sendCommand:command];
        });
        dispatch_async(dispatch_get_main_queue(), ^{
            double percent = counter * 100 / [commands count];
            [self sendProgressToDelegate:[NSNumber numberWithDouble:percent]];
        });
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self sendProgressToDelegate:[NSNumber numberWithInt:0]];
    });
}
- (int)sentCommandsQueueLength {
    return [[sentCommands componentsJoinedByString:@"\n"] length];
}
- (void)sendProgressToDelegate:(NSNumber*)percent {
    [delegate performSelector:@selector(setSendingProgess:) withObject:percent];
}


// ##########################################################################
#pragma mark Recieving
// ##########################################################################
- (void)recieverThread:(NSThread *)parentThread {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    // assign a high priority to this thread
    [NSThread setThreadPriority:1.0];
    
    const int BUFFER_SIZE = 1;
    char byte_buffer[BUFFER_SIZE]; // buffer for holding incoming data
    int numBytes=0; // number of bytes read during read
    NSString *text; // incoming text from the serial port
    NSString *inputBuffer = @"";
    
    // this will loop unitl the serial port closes
    while(exitReadThread==FALSE) {
        if ([[NSThread currentThread] isCancelled]) {
            NSLog(@"Cancel");
            [NSThread exit];
        } else {
            // read() blocks until some data is available or the port is closed
            numBytes = read(_serialFileDescriptor, byte_buffer, BUFFER_SIZE); // read up to the size of the buffer
            
            if(numBytes>0) {
                // create an NSString from the incoming bytes (the bytes aren't null terminated)
                text = [NSString stringWithCString:byte_buffer length:numBytes];
                //text = [NSString stringWithCString:byte_buffer encoding:NSASCIIStringEncoding];
                
                // If a complete line was sent, parse it
                if ([text characterAtIndex:[text length]-1] == 10 ) {
                    inputBuffer = [inputBuffer stringByAppendingString:text];
                    // Trim leading LF/CR
                    inputBuffer = [inputBuffer stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    
                    // a complete line has been recieved. send to main thread now
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [self parseResponse:inputBuffer];
                    });
                    
                    inputBuffer = @"";
                } else { // else add the line segment to the buffer
                    inputBuffer = [inputBuffer stringByAppendingString:text];
                }
            } else {
                break; // Stop the thread if there is an error
            }
        }
    }

    [pool release];
}
- (void)parseResponse:(NSString*)response {
    if ([response length] == 0)
        return;
    
    //NSLog(@"Recievd response: '%@'", response);
    if ([response hasPrefix:@"Grbl "]) {
         NSString* version = [NSString stringWithString:[response substringFromIndex:5]];
         _version = [version substringToIndex:NSMaxRange([version rangeOfString:@" "])-1];
    } else if ([response hasPrefix:@"$"]) {
        NSString* string = [response substringFromIndex:1];
        
        NSArray *components = [string componentsSeparatedByString:@"="];
        
        NSString* key = [components objectAtIndex:0];
        NSString* value = [components objectAtIndex:1];
        
        [_configuration setObject:value forKey:key];
        [delegate performSelector:@selector(setConfigurationParameter::) withObject:key withObject:value];
    } else if ([response hasPrefix:@"<"]) {
        NSArray *components = [[response substringWithRange:NSMakeRange(1, [response length]-2)] componentsSeparatedByString:@"|"];
        
        _state = GRBL_STATE_NO_CONNECTION;
        _xLimit = FALSE;
        _yLimit = TRUE;
        _zLimit = TRUE;

        for (NSString *string in components) {
            if ([string hasPrefix:@"Idle"]) {
                _state = GRBL_STATE_IDLE;
            } else if ([string hasPrefix:@"Run"]) {
                _state = GRBL_STATE_RUN;
            } else if ([string hasPrefix:@"Hold"]) {
                _state = GRBL_STATE_HOLD;
                NSArray *subComponents = [response componentsSeparatedByString:@":"];
                _subState = [[subComponents objectAtIndex:1] integerValue];
            } else if ([string hasPrefix:@"Jog"]) {
                _state = GRBL_STATE_JOG;
            } else if ([string hasPrefix:@"Alarm"]) {
                _state = GRBL_STATE_ALARM;
            } else if ([string hasPrefix:@"Door"]) {
                _state = GRBL_STATE_DOOR;
                NSArray *subComponents = [response componentsSeparatedByString:@":"];
                _subState = [[subComponents objectAtIndex:1] integerValue];
            } else if ([string hasPrefix:@"Check"]) {
                _state = GRBL_STATE_CHECK;
            } else if ([string hasPrefix:@"Home"]) {
                _state = GRBL_STATE_HOME;
            } else if ([string hasPrefix:@"Sleep"]) {
                _state = GRBL_STATE_SLEEP;
            } else if ([string hasPrefix:@"MPos:"]) {
                NSArray *values = [string componentsSeparatedByString: @","];
                _machineCoordinateX = [[[values objectAtIndex:0] substringFromIndex:5] floatValue];
                _machineCoordinateY = [[values objectAtIndex:1] floatValue];
                _machineCoordinateZ = [[values objectAtIndex:2] floatValue];
                _workCoordinateX = _machineCoordinateX - _workCoordinateOffsetX;
                _workCoordinateY = _machineCoordinateY - _workCoordinateOffsetY;
                _workCoordinateZ = _machineCoordinateZ -_workCoordinateOffsetZ;
            } else if ([string hasPrefix:@"WPos:"]) {
                NSArray *values = [string componentsSeparatedByString: @","];
                _workCoordinateX = [[[values objectAtIndex:0] substringFromIndex:5] floatValue];
                _workCoordinateY = [[values objectAtIndex:1] floatValue];
                _workCoordinateZ = [[values objectAtIndex:2] floatValue];
                _machineCoordinateX =_workCoordinateX + _workCoordinateOffsetX;
                _machineCoordinateY =_workCoordinateY + _workCoordinateOffsetY;
                _machineCoordinateZ =_workCoordinateZ + _workCoordinateOffsetZ;
            } else if ([string hasPrefix:@"WCO:"]) {
                NSArray *values = [string componentsSeparatedByString: @","];
                _workCoordinateOffsetX = [[[values objectAtIndex:0] substringFromIndex:4] floatValue];
                _workCoordinateOffsetY = [[values objectAtIndex:1] floatValue];
                _workCoordinateOffsetZ = [[values objectAtIndex:2] floatValue];
            } else if ([string hasPrefix:@"Bf:"]) {
            } else if ([string hasPrefix:@"Ln:"]) {
            } else if ([string hasPrefix:@"F:"]) {
                _feed = [[string substringFromIndex:2] floatValue];
                _spindle = 0;
            } else if ([string hasPrefix:@"FS:"]) {
                NSArray *values = [string componentsSeparatedByString: @","];
                _feed = [[[values objectAtIndex:0] substringFromIndex:3] integerValue];
                _spindle = [[values objectAtIndex:1] integerValue];
            } else if ([string hasPrefix:@"Pn:"]) {
                NSString *values = [string substringFromIndex:3];
                if ([values containsString:@"X"]) {
                    _xLimit = TRUE;
                } else if ([values containsString:@"Y"]) {
                    _yLimit = TRUE;
                } else if ([values containsString:@"Z"]) {
                    _zLimit = TRUE;
                }
            } else if ([string hasPrefix:@"A:"]) {
            } else if ([string hasPrefix:@"Ov"]) {
            } else {
                NSLog(@"Unparsed status response: %@", string);
            }
        }
     } else if ([response hasPrefix:@"ok"]) {
         NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
         [dict setObject:[NSNumber numberWithInt:STATUS_MESSAGE_INFO] forKey:@"type"];
         [dict setObject:[sentCommands objectAtIndex:0] forKey:@"command"];
         [dict setObject:@"" forKey:@"message"];
         [delegate performSelector:@selector(appendToCommunicationProtocol:) withObject:dict];
 
         if ([sentCommands count] > 0) {
             [sentCommands removeObjectAtIndex:0];
         }
     } else if ([response hasPrefix:@"error:"]) {
         NSMutableDictionary* errorMessages = [[NSMutableDictionary alloc] init];
         [errorMessages setObject:@"G-code words consist of a letter and a value. Letter was not found." forKey:@"1"];
         [errorMessages setObject:@"Numeric value format is not valid or missing an expected value." forKey:@"2"];
         [errorMessages setObject:@"Grbl '$' system command was not recognized or supported." forKey:@"3"];
         [errorMessages setObject:@"Negative value received for an expected positive value." forKey:@"4"];
         [errorMessages setObject:@"Homing cycle is not enabled via settings." forKey:@"5"];
         [errorMessages setObject:@"Minimum step pulse time must be greater than 3usec" forKey:@"6"];
         [errorMessages setObject:@"EEPROM read failed. Reset and restored to default values." forKey:@"7"];
         [errorMessages setObject:@"Grbl '$' command cannot be used unless Grbl is IDLE. Ensures smooth operation during a job." forKey:@"8"];
         [errorMessages setObject:@"G-code locked out during alarm or jog state" forKey:@"9"];
         [errorMessages setObject:@"Soft limits cannot be enabled without homing also enabled." forKey:@"10"];
         [errorMessages setObject:@"Max characters per line exceeded. Line was not processed and executed." forKey:@"11"];
         [errorMessages setObject:@"Grbl '$' setting value exceeds the maximum step rate supported." forKey:@"12"];
         [errorMessages setObject:@"Safety door detected as opened and door state initiated." forKey:@"13"];
         [errorMessages setObject:@"Build info or startup line exceeded EEPROM line length limit." forKey:@"14"];
         [errorMessages setObject:@"Jog target exceeds machine travel. Command ignored." forKey:@"15"];
         [errorMessages setObject:@"Jog command with no '=' or contains prohibited g-code." forKey:@"16"];
         [errorMessages setObject:@"Unsupported or invalid g-code command found in block." forKey:@"20"];
         [errorMessages setObject:@"More than one g-code command from same modal group found in block." forKey:@"21"];
         [errorMessages setObject:@"Feed rate has not yet been set or is undefined." forKey:@"22"];
         [errorMessages setObject:@"A G or M command value in the block is not an integer. For example, G4 can't be G4.13. Some G-code commands are floating point (G92.1), but these are ignored." forKey:@"23"];
         [errorMessages setObject:@"Two G-code commands that both require the use of the XYZ axis words were detected in the block." forKey:@"24"];
         [errorMessages setObject:@"A G-code word was repeated in the block." forKey:@"25"];
         [errorMessages setObject:@"A G-code command implicitly or explicitly requires XYZ axis words in the block, but none were detected." forKey:@"26"];
         [errorMessages setObject:@"The G-code protocol mandates N line numbers to be within the range of 1-99,999. We think that's a bit silly and arbitrary. So, we increased the max number to 9,999,999. This error occurs when you send a number more than this." forKey:@"27"];
         [errorMessages setObject:@"A G-code command was sent, but is missing some important P or L value words in the line. Without them, the command can't be executed. Check your G-code." forKey:@"28"];
         [errorMessages setObject:@"Grbl supports six work coordinate systems G54-G59. This error happens when trying to use or configure an unsupported work coordinate system, such as G59.1, G59.2, and G59.3." forKey:@"29"];
         [errorMessages setObject:@"The G53 G-code command requires either a G0 seek or G1 feed motion mode to be active. A different motion was active." forKey:@"30"];
         [errorMessages setObject:@"There are unused axis words in the block and G80 motion mode cancel is active." forKey:@"31"];
         [errorMessages setObject:@"A G2 or G3 arc was commanded but there are no XYZ axis words in the selected plane to trace the arc." forKey:@"32"];
         [errorMessages setObject:@"The motion command has an invalid target. G2, G3, and G38.2 generates this error. For both probing and arcs traced with the radius definition, the current position cannot be the same as the target. This also errors when the arc is mathematically impossible to trace, where the current position, the target position, and the radius of the arc doesn't define a valid arc." forKey:@"33"];
         [errorMessages setObject:@"A G2 or G3 arc, traced with the radius definition, had a mathematical error when computing the arc geometry. Try either breaking up the arc into semi-circles or quadrants, or redefine them with the arc offset definition." forKey:@"34"];
         [errorMessages setObject:@"A G2 or G3 arc, traced with the offset definition, is missing the IJK offset word in the selected plane to trace the arc." forKey:@"35"];
         [errorMessages setObject:@"There are unused, leftover G-code words that aren't used by any command in the block." forKey:@"36"];
         [errorMessages setObject:@"The G43.1 dynamic tool length offset command cannot apply an offset to an axis other than its configured axis. The Grbl default axis is the Z-axis." forKey:@"37"];
         
         NSArray *components = [response componentsSeparatedByString:@":"];
         NSString* errorID = [components objectAtIndex:1];
         response = [errorMessages objectForKey:errorID];
         
         NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
         [dict setObject:[NSNumber numberWithInt:STATUS_MESSAGE_ERROR] forKey:@"type"];
         [dict setObject:[sentCommands objectAtIndex:0] forKey:@"command"];
         [dict setObject:response forKey:@"message"];
         [delegate performSelector:@selector(appendToCommunicationProtocol:) withObject:dict];
         [delegate performSelector:@selector(setStatusMessage2:) withObject:dict];

         if ([sentCommands count] > 0) {
             [sentCommands removeObjectAtIndex:0];
         }
     } else if ([response hasPrefix:@"ALARM:"]) {
         NSMutableDictionary* alarmMessages = [[NSMutableDictionary alloc] init];
         [alarmMessages setObject:@"Hard limit triggered. Machine position is likely lost due to sudden and immediate halt. Re-homing is highly recommended." forKey:@"1"];
         [alarmMessages setObject:@"G-code motion target exceeds machine travel. Machine position safely retained. Alarm may be unlocked." forKey:@"2"];
         [alarmMessages setObject:@"Reset while in motion. Grbl cannot guarantee position. Lost steps are likely. Re-homing is highly recommended." forKey:@"3"];
         [alarmMessages setObject:@"Probe fail. The probe is not in the expected initial state before starting probe cycle, where G38.2 and G38.3 is not triggered and G38.4 and G38.5 is triggered." forKey:@"4"];
         [alarmMessages setObject:@"Probe fail. Probe did not contact the workpiece within the programmed travel for G38.2 and G38.4." forKey:@"5"];
         [alarmMessages setObject:@"Homing fail. Reset during active homing cycle." forKey:@"6"];
         [alarmMessages setObject:@"Homing fail. Safety door was opened during active homing cycle." forKey:@"7"];
         [alarmMessages setObject:@"Homing fail. Cycle failed to clear limit switch when pulling off. Try increasing pull-off setting or check wiring." forKey:@"8"];
         [alarmMessages setObject:@"Homing fail. Could not find limit switch within search distance. Defined as 1.5 * max_travel on search and 5 * pulloff on locate phases." forKey:@"9"];
         
         NSArray *components = [response componentsSeparatedByString:@":"];
         NSString* errorID = [components objectAtIndex:1];
         
         NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
         [dict setObject:[NSNumber numberWithInt:STATUS_MESSAGE_ERROR] forKey:@"type"];
         [dict setObject:[alarmMessages objectForKey:errorID] forKey:@"message"];
         [delegate performSelector:@selector(setStatusMessage2:) withObject:dict];
     } else if ([response hasPrefix:@"[MSG:"]) {
         NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
         [dict setObject:[NSNumber numberWithInt:STATUS_MESSAGE_WARNING] forKey:@"type"];
         [dict setObject:[response substringWithRange:NSMakeRange(5, [response length]-6)] forKey:@"message"];
         [delegate performSelector:@selector(setStatusMessage2:) withObject:dict];
     } else {
         NSLog(@"Unknown message: '%@'", response);
     }

   return;
}


// ##########################################################################
#pragma mark Testing
// ##########################################################################
- (void)testCommand:(NSString*)command {
    [self sendCommand:command];
}
- (void)testCommands:(NSArray*)commands {
    for (NSString* command in commands) {
        [self testCommand:command];
    }
}

@end
