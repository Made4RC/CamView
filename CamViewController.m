//
//  CamViewController.m
//  CamView
//
//  Created on 18.08.15.
//

#import "CamViewController.h"

@implementation CamViewController

- (void)awakeFromNib {
    // Make crosshair be visible over video
    [mParentView setWantsLayer:YES];

    // Initialze User's preset values or default if never used before
    NSDictionary *appDefaults = [NSDictionary dictionaryWithObjectsAndKeys:
                                 @"CrosshairDiameter",        @"BaudRate", @"LockXY",                       @"StepWidth", @"MachinePort", @"Camera", @"LockGotoX0Y0",                 @"CameraOffsetX",            @"CameraOffsetY",
                                 [NSNumber numberWithInt:20], @"19200",    [NSNumber numberWithBool:FALSE], @"10mm",      @"",            @"",       [NSNumber numberWithBool:FALSE], [NSNumber numberWithInt:0], [NSNumber numberWithInt:0],
                                 nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];

    // set default values in GUI ...
    
    // ... for "General", ...
    [mTabView selectFirstTabViewItem:NULL];
    [mUnlockButton setEnabled:FALSE];
    [mCycleStartButton setEnabled:FALSE];
    [mFeedHoldButton setEnabled:FALSE];
    [mHomingButton setEnabled:FALSE];
    [mSoftResetButton setEnabled:FALSE];

    // ... for "Control", ...
    [mMachineSelect setEnabled:TRUE];
    [mBaudRate setEnabled:TRUE];
    [self refreshMachinePortList:@"Choose machine port ..."];
    if ([[mMachineSelect itemTitles] containsObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"MachinePort"]]) {
        [mMachineSelect selectItemWithTitle:[[NSUserDefaults standardUserDefaults] objectForKey:@"MachinePort"]];
    }
    [mBaudRate selectItemWithTitle:[[NSUserDefaults standardUserDefaults] objectForKey:@"BaudRate"]];
    [self refreshCameraList:@"Choose camera ..."];
    if ([[mCameraSelect itemTitles] containsObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"Camera"]]) {
        [mCameraSelect selectItemWithTitle:[[NSUserDefaults standardUserDefaults] objectForKey:@"Camera"]];
    }
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"LockConnect"] boolValue]) {
        [mLockConnectButton setImage:[NSImage imageNamed:@"NSLockLockedTemplate"]];
    } else {
        [mLockConnectButton setImage:[NSImage imageNamed:@"NSLockUnlockedTemplate"]];
    }
    [_configStepPulse setEnabled:NO];
    [_configStepIdleDelay setEnabled:NO];
    [_configStepPortInvertMask setEnabled:NO];
    [_configDirectionPortInvertMask setEnabled:NO];
    [_configStepEnableInvert setEnabled:NO];
    [_configLimitPinsInvert setEnabled:NO];
    [_configPobePinInvert setEnabled:NO];
    [_configStatusReport setEnabled:NO];
    [_configJunctionDeviation setEnabled:NO];
    [_configArcTolerance setEnabled:NO];
    [_configReportInches setEnabled:NO];
    [_configSoftLimits setEnabled:NO];
    [_configHardLimits setEnabled:NO];
    [_configHomingCycle setEnabled:NO];
    [_configHomingDirInvertMask setEnabled:NO];
    [_configHomingFeed setEnabled:NO];
    [_configHomingSeek setEnabled:NO];
    [_configHomingDebounce setEnabled:NO];
    [_configHomingPullOff setEnabled:NO];
    [_configMaxSpindleRPM setEnabled:NO];
    [_configMinSpindleRPM setEnabled:NO];
    [_configLaserMode setEnabled:NO];
    [_configXStepsPerMM setEnabled:NO];
    [_configYStepsPerMM setEnabled:NO];
    [_configZStepsPerMM setEnabled:NO];
    [_configXMaXRate setEnabled:NO];
    [_configYMaXRate setEnabled:NO];
    [_configZMaXRate setEnabled:NO];
    [_configXAcceleration setEnabled:NO];
    [_configYAcceleration setEnabled:NO];
    [_configZAcceleration setEnabled:NO];
    [_configXMaxTravel setEnabled:NO];
    [_configYMaxTravel setEnabled:NO];
    [_configZMaxTravel setEnabled:NO];
    [_configXYPependicularityCompensation setEnabled:NO];
    [_configRevertButton setEnabled:NO];
    
    // ... for "Jog", ...
    [mOverlayView setCircleSize:[[[NSUserDefaults standardUserDefaults] objectForKey:@"CrosshairDiameter"] intValue]];
    [mCircleSlider setIntValue:[[[NSUserDefaults standardUserDefaults] objectForKey:@"CrosshairDiameter"] intValue]];
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"LockXY"] boolValue]) {
        [mLockZeroXYButton setImage:[NSImage imageNamed:@"NSLockLockedTemplate"]];
    } else {
        [mLockZeroXYButton setImage:[NSImage imageNamed:@"NSLockUnlockedTemplate"]];        
    }
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"LockGotoX0Y0"] boolValue]) {
        [mLockGotoX0Y0Button setImage:[NSImage imageNamed:@"NSLockLockedTemplate"]];
    } else {
        [mLockGotoX0Y0Button setImage:[NSImage imageNamed:@"NSLockUnlockedTemplate"]];
    }
    [mStepWidth selectItemWithTitle:[[NSUserDefaults standardUserDefaults] objectForKey:@"StepWidth"]];
    [mStepWithButton setSelectedSegment:[mStepWidth indexOfSelectedItem]];
    [mLocationButton setImage:[NSImage imageNamed:@"Icon_Milling.png"]];
    [mLocationButton setEnabled:FALSE];
    [mHomingButton setEnabled:FALSE];
    [mCopyMaschinePosButton setEnabled:FALSE];
    [mP1Button setEnabled:FALSE];
    [mP2Button setEnabled:FALSE];
    [mZeroXButton setEnabled:FALSE];
    [mLockZeroXYButton setEnabled:FALSE];
    [mZeroYButton setEnabled:FALSE];
    [mZeroZButton setEnabled:FALSE];
    [mZeroAllButton setEnabled:FALSE];
    [mStepPlusXButton setEnabled:FALSE];
    [mStepPlusXMinuxYButton setEnabled:FALSE];
    [mStepMinusYButton setEnabled:FALSE];
    [mStepMinusXMinusYButton setEnabled:FALSE];
    [mStepMinusXButton setEnabled:FALSE];
    [mStepMinusXPlusYButton setEnabled:FALSE];
    [mStepPlusYButton setEnabled:FALSE];
    [mStepPlusXPlusYButton setEnabled:FALSE];
    [mStepMinusZButton setEnabled:FALSE];
    [mStepPlusZButton setEnabled:FALSE];
    [mZGotoX0Button setEnabled:FALSE];
    [mLockGotoX0Y0Button setEnabled:FALSE];
    [mZGotoY0Button setEnabled:FALSE];
    [mZGotoZ0Button setEnabled:FALSE];
    [mStepWidth setEnabled:FALSE];
    [mStepWithButton setEnabled:FALSE];
    [mCustomCommand setEnabled:FALSE];

    // ... and for "Work".
    [mSendGCode setEnabled:FALSE];
    lineNumberView = [[MarkerLineNumberView alloc] initWithScrollView:scrollView];
    [scrollView setVerticalRulerView:lineNumberView];
    [scrollView setHasHorizontalRuler:NO];
    [scrollView setHasVerticalRuler:YES];
    [scrollView setRulersVisible:YES];
    [mNCData setFont:[NSFont userFixedPitchFontOfSize:[NSFont smallSystemFontSize]]];
    
    // Create necessary variables
    grbl = [[GRBLProtocol alloc] init];
    [grbl setDelegate:self];
    mCaptureSession = [[QTCaptureSession alloc] init];
    currentPosition = POSITION_MILLING;
    _lastJogWasMinusZ = FALSE;
    wasCustomCommand = FALSE;
    isChecking = FALSE;

    // keep grbl and gui sync'ed
    _responseTimer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(syncGUI:) userInfo:nil repeats:YES];
    
    
    
    
    
    
    // Testcode
    /*
    GCode* ncData = [[GCode alloc] init];
    [ncData readFromURL:[NSURL URLWithString:@"file:///Users/nkolb/Documents/Modellbau/yaRES/20180426%20yaRES/Fertigung/Tragflaeche/ZZ_Temp.nc"]];
    
    NSLog(@"X %.02fmm to %.02fmm", [[[ncData boundaries] objectAtIndex:0] floatValue], [[[ncData boundaries] objectAtIndex:1] floatValue]);
    NSLog(@"Y %.02fmm to %.02fmm", [[[ncData boundaries] objectAtIndex:2] floatValue], [[[ncData boundaries] objectAtIndex:3] floatValue]);
    NSLog(@"Z %.02fmm to %.02fmm", [[[ncData boundaries] objectAtIndex:4] floatValue], [[[ncData boundaries] objectAtIndex:5] floatValue]);
    */
}
// Handle window closing notifications for your device input
- (void)windowWillClose:(NSNotification *)notification {
	
	[mCaptureSession stopRunning];
    
    if ([[mCaptureVideoDeviceInput device] isOpen])
        [[mCaptureVideoDeviceInput device] close];
    
    if ([[mCaptureAudioDeviceInput device] isOpen])
        [[mCaptureAudioDeviceInput device] close];
    
}
// Handle deallocation of memory for your objects
- (void)dealloc {
    [_responseTimer invalidate];
    _responseTimer = nil;
    [_statusMessageTimer invalidate];
    _statusMessageTimer = nil;
	[mCaptureSession release];
	[mCaptureVideoDeviceInput release];
    [mCaptureAudioDeviceInput release];
	[mCaptureMovieFileOutput release];
	
	[super dealloc];
}


// ##########################################################################
#pragma mark General
// ##########################################################################
- (IBAction)mMenuSwitchPanelClicked:(id)sender {
    [mTabView selectTabViewItemAtIndex:[sender tag]];
}
- (void)setStatusMessage:(int)type :(NSString*)message {
    if ([message length]==0)
        return;
    NSLog(@"Statustext: %@", message);
    
    if (_statusMessageTimer!=nil) {
        [_statusMessageTimer invalidate];
        _statusMessageTimer = nil;
    }
    
    if (type==STATUS_MESSAGE_INFO) {
        [mMessageIcon setImage:[NSImage imageNamed:@"NSStatusAvailable"]];
    } else if (type==STATUS_MESSAGE_WARNING) {
        [mMessageIcon setImage:[NSImage imageNamed:@"NSStatusPartiallyAvailable"]];
    } else if (type==STATUS_MESSAGE_ERROR) {
        [mMessageIcon setImage:[NSImage imageNamed:@"NSStatusUnavailable"]];
    }

    [mMessageText setStringValue:message];
//    [mMessageText setAlphaValue:1.0];
    
    _statusMessageTimer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(clearStatusMessage:) userInfo:nil repeats:NO];
}
- (void)setStatusMessage2:(NSDictionary*)dict {
    NSString* type = [dict objectForKey:@"type"];
    NSString* message = [dict objectForKey:@"message"];
    
    [self setStatusMessage:[type integerValue] :message];
}
- (void)clearStatusMessage:(NSTimer*)timer {
/*
    NSViewAnimation *fadeOutAnim;
    NSMutableDictionary *dict = nil;
    dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:mMessageText, NSViewAnimationTargetKey,
            NSViewAnimationFadeOutEffect, NSViewAnimationEffectKey, nil];
    fadeOutAnim = [[NSViewAnimation alloc] initWithViewAnimations:[NSArray arrayWithObjects:
                                                                   dict, nil]];
    [fadeOutAnim setDuration:2];
    [fadeOutAnim setAnimationCurve:NSAnimationEaseOut];
    [fadeOutAnim setAnimationBlockingMode:NSAnimationNonblocking];
    
    [fadeOutAnim startAnimation];
    [fadeOutAnim release];
*/
    //NSLog(@"cleard Status");
    //NSLog(@"current content: %@", [mMessageText stringValue]);
    [mMessageIcon setImage:[NSImage imageNamed:@"NSStatusNone"]];
    [mMessageText setStringValue:@""];
//    [mMessageText setAlphaValue:1.0];

    [_statusMessageTimer invalidate];
    _statusMessageTimer = nil;
}
- (IBAction)mPreferencesClicked:(id)sender {
    NSWindowController *controllerWindow = [[NSWindowController alloc] initWithWindowNibName:@"PreferencesWindow"];
    [controllerWindow showWindow:self];
}
- (IBAction)mUnlockClicked:(id)sender {
    [grbl sendCommand:@"$X"];
}
- (IBAction)mCycleStartClicked:(id)sender {
    [grbl writeString:@"~"];
}
- (IBAction)mFeedHoldClicked:(id)sender {
    [grbl writeString:@"!"];
}
- (IBAction)mSoftResetClicked:(id)sender {
    [grbl writeString:[NSString stringWithFormat:@"%c",'\x18']];
}
- (void)syncGUI:(NSTimer*)timer {
    if ([grbl isConnected]) {
        // GUI-Updates
        // General
        [mUnlockButton setEnabled:TRUE];
        [mCycleStartButton setEnabled:TRUE];
        [mFeedHoldButton setEnabled:TRUE];
        [mHomingButton setEnabled:TRUE];
        [mSoftResetButton setEnabled:TRUE];
        
        // Control
        [mMachineSelect setEnabled:FALSE];
        [mBaudRate setEnabled:FALSE];
        [mMachineConnectionControl setTitle:@"Disconnect"];
        [_refreshMachinePort setEnabled:FALSE];
        
        // Jog
        if ([mCaptureSession isRunning]) {
            [mLocationButton setEnabled:FALSE];
            [mHomingButton setEnabled:FALSE];
            [mCopyMaschinePosButton setEnabled:FALSE];
            [mP1Button setEnabled:FALSE];
            [mP2Button setEnabled:FALSE];
        } else {
            [mLocationButton setEnabled:TRUE];
            [mHomingButton setEnabled:TRUE];
            [mCopyMaschinePosButton setEnabled:TRUE];
            [mP1Button setEnabled:TRUE];
            [mP2Button setEnabled:TRUE];
        }
        [mZeroXButton setEnabled:TRUE];
        [mLockZeroXYButton setEnabled:TRUE];
        [mZeroYButton setEnabled:TRUE];
        [mZeroZButton setEnabled:TRUE];
        [mZeroAllButton setEnabled:TRUE];
        [mStepPlusXButton setEnabled:TRUE];
        [mStepPlusXMinuxYButton setEnabled:TRUE];
        [mStepMinusYButton setEnabled:TRUE];
        [mStepMinusXMinusYButton setEnabled:TRUE];
        [mStepMinusXButton setEnabled:TRUE];
        [mStepMinusXPlusYButton setEnabled:TRUE];
        [mStepPlusYButton setEnabled:TRUE];
        [mStepPlusXPlusYButton setEnabled:TRUE];
        [mStepMinusZButton setEnabled:TRUE];
        [mStepPlusZButton setEnabled:TRUE];
        [mZGotoX0Button setEnabled:TRUE];
        [mLockGotoX0Y0Button setEnabled:TRUE];
        [mZGotoY0Button setEnabled:TRUE];
        [mZGotoZ0Button setEnabled:TRUE];
        [mStepWidth setEnabled:TRUE];
        [mStepWithButton setEnabled:TRUE];
        [mCustomCommand setEnabled:TRUE];
        [_configRevertButton setEnabled:YES];
        
        // Work
        [mSendGCode setEnabled:FALSE];
    } else {
        // General
        [mUnlockButton setEnabled:FALSE];
        [mCycleStartButton setEnabled:FALSE];
        [mFeedHoldButton setEnabled:FALSE];
        [mHomingButton setEnabled:FALSE];
        [mSoftResetButton setEnabled:FALSE];
        [_machineState setStringValue:@"offline"];
        [_machineState setTextColor:[NSColor blackColor]];
        
        // Control
        [mMachineSelect setEnabled:TRUE];
        [mBaudRate setEnabled:TRUE];
        [mMachineConnectionControl setTitle:@"Connect"];
        [_refreshMachinePort setEnabled:TRUE];
        [_configStepPulse setEnabled:NO];
        [_configStepIdleDelay setEnabled:NO];
        [_configStepPortInvertMask setEnabled:NO];
        [_configDirectionPortInvertMask setEnabled:NO];
        [_configStepEnableInvert setEnabled:NO];
        [_configLimitPinsInvert setEnabled:NO];
        [_configPobePinInvert setEnabled:NO];
        [_configStatusReport setEnabled:NO];
        [_configJunctionDeviation setEnabled:NO];
        [_configArcTolerance setEnabled:NO];
        [_configReportInches setEnabled:NO];
        [_configSoftLimits setEnabled:NO];
        [_configHardLimits setEnabled:NO];
        [_configHomingCycle setEnabled:NO];
        [_configHomingDirInvertMask setEnabled:NO];
        [_configHomingFeed setEnabled:NO];
        [_configHomingSeek setEnabled:NO];
        [_configHomingDebounce setEnabled:NO];
        [_configHomingPullOff setEnabled:NO];
        [_configMaxSpindleRPM setEnabled:NO];
        [_configMinSpindleRPM setEnabled:NO];
        [_configLaserMode setEnabled:NO];
        [_configXStepsPerMM setEnabled:NO];
        [_configYStepsPerMM setEnabled:NO];
        [_configZStepsPerMM setEnabled:NO];
        [_configXMaXRate setEnabled:NO];
        [_configYMaXRate setEnabled:NO];
        [_configZMaXRate setEnabled:NO];
        [_configXAcceleration setEnabled:NO];
        [_configYAcceleration setEnabled:NO];
        [_configZAcceleration setEnabled:NO];
        [_configXMaxTravel setEnabled:NO];
        [_configYMaxTravel setEnabled:NO];
        [_configZMaxTravel setEnabled:NO];
        [_configRevertButton setEnabled:NO];
        
        // Jog
        [mLocationButton setEnabled:FALSE];
        [mHomingButton setEnabled:FALSE];
        [mCopyMaschinePosButton setEnabled:FALSE];
        [mP1Button setEnabled:FALSE];
        [mP2Button setEnabled:FALSE];
        [mZeroXButton setEnabled:FALSE];
        [mLockZeroXYButton setEnabled:FALSE];
        [mZeroYButton setEnabled:FALSE];
        [mZeroZButton setEnabled:FALSE];
        [mZeroAllButton setEnabled:FALSE];
        [mStepPlusXButton setEnabled:FALSE];
        [mStepPlusXMinuxYButton setEnabled:FALSE];
        [mStepMinusYButton setEnabled:FALSE];
        [mStepMinusXMinusYButton setEnabled:FALSE];
        [mStepMinusXButton setEnabled:FALSE];
        [mStepMinusXPlusYButton setEnabled:FALSE];
        [mStepPlusYButton setEnabled:FALSE];
        [mStepPlusXPlusYButton setEnabled:FALSE];
        [mStepMinusZButton setEnabled:FALSE];
        [mStepPlusZButton setEnabled:FALSE];
        [mZGotoX0Button setEnabled:FALSE];
        [mLockGotoX0Y0Button setEnabled:FALSE];
        [mZGotoY0Button setEnabled:FALSE];
        [mZGotoZ0Button setEnabled:FALSE];
        [mStepWidth setEnabled:FALSE];
        [mStepWithButton setEnabled:FALSE];
        [mCustomCommand setEnabled:FALSE];
        [mSoftResetButton setEnabled:FALSE];
        
        // Work
        [mSendGCode setEnabled:FALSE];
    }

    switch ([grbl state]) {
        case GRBL_STATE_ALARM:
            [_machineState setStringValue:@"ALARM"];
            [_machineState setTextColor:[NSColor redColor]];
            [mUnlockButton setEnabled:TRUE];
            [mLocationButton setEnabled:FALSE];
            [mHomingButton setEnabled:FALSE];
            [mCopyMaschinePosButton setEnabled:FALSE];
            [mP1Button setEnabled:FALSE];
            [mP2Button setEnabled:FALSE];
            [mFeedHoldButton setEnabled:FALSE];
            [mCycleStartButton setEnabled:FALSE];
            [mSendGCode setEnabled:FALSE];
            break;
        case GRBL_STATE_CHECK:
            [_machineState setStringValue:@"Check"];
            [_machineState setTextColor:[NSColor blackColor]];
            [mUnlockButton setEnabled:FALSE];
            if ([mCaptureSession isRunning]) {
                [mLocationButton setEnabled:FALSE];
                [mHomingButton setEnabled:FALSE];
                [mCopyMaschinePosButton setEnabled:FALSE];
                [mP1Button setEnabled:FALSE];
                [mP2Button setEnabled:FALSE];
            }
            [mFeedHoldButton setEnabled:FALSE];
            [mCycleStartButton setEnabled:FALSE];
            if ([[mNCData string] length] > 0) {
                [mSendGCode setEnabled:TRUE];
            }
            break;
        case GRBL_STATE_HOLD:
            [_machineState setStringValue:@"Hold"];
            [_machineState setTextColor:[NSColor blackColor]];
            [mUnlockButton setEnabled:FALSE];
            [mLocationButton setEnabled:FALSE];
            [mHomingButton setEnabled:FALSE];
            [mCopyMaschinePosButton setEnabled:FALSE];
            [mP1Button setEnabled:FALSE];
            [mP2Button setEnabled:FALSE];
            [mFeedHoldButton setEnabled:FALSE];
            [mCycleStartButton setEnabled:TRUE];
            [mSendGCode setEnabled:FALSE];
            break;
        case GRBL_STATE_IDLE:
            [_machineState setStringValue:@"Idle"];
            [_machineState setTextColor:[NSColor colorWithSRGBRed:0.0 green:0.6 blue:0.0 alpha:1.0]];
            [mUnlockButton setEnabled:FALSE];
            if ([mCaptureSession isRunning]) {
                [mLocationButton setEnabled:TRUE];
            }
            [mHomingButton setEnabled:TRUE];
            [mCopyMaschinePosButton setEnabled:TRUE];
            [mP1Button setEnabled:TRUE];
            [mP2Button setEnabled:TRUE];
            [mFeedHoldButton setEnabled:FALSE];
            [mCycleStartButton setEnabled:FALSE];
            if ([[mNCData string] length] > 0) {
                [mSendGCode setEnabled:TRUE];
            }
            break;
        case GRBL_STATE_NO_CONNECTION:
            [_machineState setStringValue:@"offline"];
            [_machineState setTextColor:[NSColor blackColor]];
            [mUnlockButton setEnabled:FALSE];
            [mLocationButton setEnabled:FALSE];
            [mFeedHoldButton setEnabled:FALSE];
            [mCycleStartButton setEnabled:FALSE];
            [mSendGCode setEnabled:FALSE];
            break;
        case GRBL_STATE_RUN:
            [_machineState setStringValue:@"Run"];
            [_machineState setTextColor:[NSColor colorWithSRGBRed:1.0 green:0.6 blue:0.0 alpha:1.0]];
            [mUnlockButton setEnabled:FALSE];
            [mLocationButton setEnabled:FALSE];
            [mHomingButton setEnabled:FALSE];
            [mCopyMaschinePosButton setEnabled:FALSE];
            [mP1Button setEnabled:FALSE];
            [mP2Button setEnabled:FALSE];
            [mFeedHoldButton setEnabled:TRUE];
            [mCycleStartButton setEnabled:FALSE];
            [mSendGCode setEnabled:FALSE];
            break;
            
        default:
            [_machineState setStringValue:@"unknown"];
            [_machineState setTextColor:[NSColor redColor]];
            [mUnlockButton setEnabled:FALSE];
            [mLocationButton setEnabled:FALSE];
            [mHomingButton setEnabled:FALSE];
            [mCopyMaschinePosButton setEnabled:FALSE];
            [mP1Button setEnabled:FALSE];
            [mP2Button setEnabled:FALSE];
            [mFeedHoldButton setEnabled:FALSE];
            [mCycleStartButton setEnabled:FALSE];
            [mSendGCode setEnabled:FALSE];
            break;
    }

    if ([grbl xLimitReached]) {
        [mXLimitReached setHidden:FALSE];
    } else {
        [mXLimitReached setHidden:TRUE];
    }
    if ([grbl yLimitReached]) {
        [mYLimitReached setHidden:FALSE];
    } else {
        [mYLimitReached setHidden:TRUE];
    }
    if ([grbl zLimitReached]) {
        [mZLimitReached setHidden:FALSE];
    } else {
        [mZLimitReached setHidden:TRUE];
    }
    [_machineCoordinateX1 setStringValue:[grbl machineCoordinateX]];
    [_machineCoordinateX2 setStringValue:[grbl machineCoordinateX]];
    [_machineCoordinateY1 setStringValue:[grbl machineCoordinateY]];
    [_machineCoordinateY2 setStringValue:[grbl machineCoordinateY]];
    [_machineCoordinateZ1 setStringValue:[grbl machineCoordinateZ]];
    [_machineCoordinateZ2 setStringValue:[grbl machineCoordinateZ]];
    [_workCoordinateX1 setStringValue:[grbl workCoordinateX]];
    [_workCoordinateX2 setStringValue:[grbl workCoordinateX]];
    [_workCoordinateY1 setStringValue:[grbl workCoordinateY]];
    [_workCoordinateY2 setStringValue:[grbl workCoordinateY]];
    [_workCoordinateZ1 setStringValue:[grbl workCoordinateZ]];
    [_workCoordinateZ2 setStringValue:[grbl workCoordinateZ]];
    [_feedRate setStringValue:[NSString stringWithFormat:@"%d mm/min", [grbl feedRate]]];
}
- (void)controlTextDidEndEditing:(NSNotification *)notification {
    if ( [[[notification userInfo] objectForKey:@"NSTextMovement"] intValue] == NSReturnTextMovement ) {
        NSString* command = [mCustomCommand stringValue];
        wasCustomCommand = TRUE;
        [grbl sendCommand:command];
        [mCustomCommand setStringValue:@""];
    }
    
    if ([notification object] == _gcodeModifiyShiftX ||
        [notification object] == _gcodeModifiyShiftY ||
        [notification object] == _gcodeModifiyShiftZ ||
        [notification object] == _gcodeModifiyAngle ||
        [notification object] == _gcodeModifiyScale ) {
        [self processGCodeFile];
    }
}


// ##########################################################################
#pragma mark Control
// ##########################################################################
- (void)refreshMachinePortList:(NSString *)selectedText {
	io_object_t serialPort;
	io_iterator_t serialPortIterator;
	
	// remove everything from the pull down list
	[mMachineSelect removeAllItems];
	
	// ask for all the serial ports
	IOServiceGetMatchingServices(kIOMasterPortDefault, IOServiceMatching(kIOSerialBSDServiceValue), &serialPortIterator);
	
	// loop through all the serial ports and add them to the array
	while ((serialPort = IOIteratorNext(serialPortIterator))) {
		[mMachineSelect addItemWithTitle:
         (NSString*)IORegistryEntryCreateCFProperty(serialPort, CFSTR(kIOCalloutDeviceKey),  kCFAllocatorDefault, 0)];
		IOObjectRelease(serialPort);
	}
	
	// add the selected text to the top
	[mMachineSelect insertItemWithTitle:selectedText atIndex:0];
	[mMachineSelect selectItemAtIndex:0];
	
	IOObjectRelease(serialPortIterator);
}
- (IBAction)mRefreshMachinePortClicked:(id)sender {
    [self refreshMachinePortList:@"Choose machine port ..."];
    if ([[mMachineSelect itemTitles] containsObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"MachinePort"]]) {
        [mMachineSelect selectItemWithTitle:[[NSUserDefaults standardUserDefaults] objectForKey:@"MachinePort"]];
    }

    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"LockConnect"] boolValue]) {
        [self refreshCameraList:@"Choose camera ..."];
    }
}
- (IBAction)mMachineSelectChangend:(id)sender {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[mMachineSelect titleOfSelectedItem] forKey:@"MachinePort"];
    //[mBaudRate titleOfSelectedItem]
}
- (IBAction)mBaudRateChanged:(id)sender {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[mBaudRate itemTitleAtIndex:[mBaudRate indexOfSelectedItem]] forKey:@"BaudRate"];
}
- (IBAction)mMachineConnectClicked:(id)sender {
    if (![grbl isConnected]) {
        if ([[mMachineSelect titleOfSelectedItem] isEqual: @"Choose machine port ..."]) {
            [self setStatusMessage:STATUS_MESSAGE_WARNING :@"Please select port first."];
        } else {
            // open the serial port
            NSString *error =[grbl connect:[mMachineSelect titleOfSelectedItem] :[[mBaudRate titleOfSelectedItem] intValue]];
            
            if(error==nil) {
                [self setStatusMessage:STATUS_MESSAGE_INFO :@"Connection established."];

                if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"LockConnect"] boolValue]) {
                    if ([mCaptureSession isRunning]) {
                        // Switch to Jog-Tab
                        [mTabView selectTabViewItemAtIndex:1];
                    } else {
                        [self mCameraConnectClicked:sender];
                    }
                }
            } else {
                [self setStatusMessage:STATUS_MESSAGE_ERROR :error];
            }
        }
    } else {
        [grbl disconnect];
        [self setStatusMessage:STATUS_MESSAGE_INFO :@"Connection closed."];
    }
}
- (void)refreshCameraList:(NSString *)selectedText {
    // remove everything from the pull down list
    [mCameraSelect removeAllItems];
    
    NSArray *a = [QTCaptureDevice inputDevicesWithMediaType:QTMediaTypeVideo];
    for (id myArrayElement in a) {
        [mCameraSelect addItemWithTitle:[myArrayElement localizedDisplayName]];
    }
    
    // add the selected text to the top
    [mCameraSelect insertItemWithTitle:selectedText atIndex:0];
    [mCameraSelect selectItemAtIndex:0];
}
- (IBAction)mCameraSelectChangend:(id)sender {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[mCameraSelect titleOfSelectedItem] forKey:@"Camera"];
}
- (IBAction)mRefreshCameraListClicked:(id)sender {
    [self refreshCameraList:@"Choose camera ..."];
    if ([[mCameraSelect itemTitles] containsObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"Camera"]]) {
        [mCameraSelect selectItemWithTitle:[[NSUserDefaults standardUserDefaults] objectForKey:@"Camera"]];
    }
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"LockConnect"] boolValue]) {
        [self refreshMachinePortList:@"Choose machine port ..."];
    }
}
- (IBAction)mCameraConnectClicked:(id)sender {
    NSLog(@"CamConnect");
    if ([mCameraSelect indexOfSelectedItem] == 0) {
        [self setStatusMessage:STATUS_MESSAGE_WARNING :@"No camera port selected."];
        return;
    }
    
    if ([mCaptureSession isRunning]) {
        [mCameraSelect setEnabled:TRUE];
        [mCameraConnectionControl setTitle:@"Connect"];
        
        [mCaptureSession stopRunning];
        [mLocationButton setEnabled:FALSE];
        
    } else {
        [mCameraSelect setEnabled:FALSE];
        [mCameraConnectionControl setTitle:@"Disconnect"];
        
        // Connect inputs and outputs to the session
        BOOL success = NO;
        NSError *error;
        
        // Find a video device
        NSArray *devices = [QTCaptureDevice inputDevicesWithMediaType:QTMediaTypeVideo];
        
        if ([devices count] == 0) {
            return;
        }
        QTCaptureDevice *videoDevice = [devices objectAtIndex:[mCameraSelect indexOfSelectedItem]-1];
        
        
        success = [videoDevice open:&error];
        
        
        // If a video input device can't be found or opened, try to find and open a muxed input device
        if (!success) {
            videoDevice = [QTCaptureDevice defaultInputDeviceWithMediaType:QTMediaTypeMuxed];
            success = [videoDevice open:&error];
            
        }
        
        if (!success) {
            videoDevice = nil;
            // Handle error
            [self setStatusMessage:STATUS_MESSAGE_ERROR :[error localizedDescription]];
            return;
        }
        
        if (videoDevice) {
            //Add the video device to the session as a device input
            mCaptureVideoDeviceInput = [[QTCaptureDeviceInput alloc] initWithDevice:videoDevice];
            success = [mCaptureSession addInput:mCaptureVideoDeviceInput error:&error];
            if (!success) {
                // Handle error
                [self setStatusMessage:STATUS_MESSAGE_ERROR :[error localizedDescription]];
                return;
            }
            
            // Associate the capture view in the UI with the session
            [mCaptureView setCaptureSession:mCaptureSession];
            
            [mCaptureSession startRunning];
        }
        if ([grbl isConnected]) {
            [mLocationButton setEnabled:TRUE];
            // to Jog-Tab
            [mTabView selectTabViewItemAtIndex:1];
        }
    }
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"LockConnect"] boolValue]) {
        [self mMachineConnectClicked:sender];
    }
}
- (IBAction)lockConnectButtonClicked:(id)sender {
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"LockConnect"] boolValue]) {
        [mLockConnectButton setImage:[NSImage imageNamed:@"NSLockUnlockedTemplate"]];
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:[NSNumber numberWithBool:FALSE] forKey:@"LockConnect"];
    } else {
        [mLockConnectButton setImage:[NSImage imageNamed:@"NSLockLockedTemplate"]];
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:[NSNumber numberWithBool:TRUE] forKey:@"LockConnect"];
    }
}
- (void)appendToCommunicationProtocol:(NSDictionary*)dict {
    NSString* type = [dict objectForKey:@"type"];
    NSString* command = [dict objectForKey:@"command"];
    NSString* message = [dict objectForKey:@"message"];

    // add the text to the textarea
    NSMutableAttributedString *attrString;
    if ([type integerValue] == STATUS_MESSAGE_INFO) {
        attrString = [[NSMutableAttributedString alloc] initWithString:[command stringByAppendingFormat:@"\r\n"]];
        [attrString addAttribute:NSBackgroundColorAttributeName
                           value:[NSColor colorWithCalibratedRed:0.72f green:1.0f blue:0.72f alpha:1.0f]
                           range:NSMakeRange(0, [attrString length])];
        
        if (wasCustomCommand) {
            [mCustomCommand insertItemWithObjectValue:command atIndex:0];
            int maxCustomCommands = 10;
            if ([mCustomCommand numberOfItems]>maxCustomCommands) {
                [mCustomCommand removeItemAtIndex:maxCustomCommands];
            }
            _lastJogWasMinusZ = FALSE;
            wasCustomCommand = FALSE;
        }
    } else if ([type integerValue] == STATUS_MESSAGE_WARNING) {
        attrString = [[NSMutableAttributedString alloc] initWithString:[command stringByAppendingFormat:@": %@\r\n", message]];
        [attrString addAttribute:NSBackgroundColorAttributeName
                           value:[NSColor colorWithCalibratedRed:1.0f green:1.0f blue:0.72f alpha:1.0f]
                           range:NSMakeRange(0, [attrString length])];
    } else if ([type integerValue] == STATUS_MESSAGE_ERROR ) {
        attrString = [[NSMutableAttributedString alloc] initWithString:[command stringByAppendingFormat:@": %@\r\n", message]];
        [attrString addAttribute:NSBackgroundColorAttributeName
                           value:[NSColor colorWithCalibratedRed:1.0f green:0.72f blue:0.72f alpha:1.0f]
                           range:NSMakeRange(0, [attrString length])];
    } else {
        attrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"Unknown response\r\n"]];
    }
    
    NSTextStorage *textStorage = [serialOutputArea textStorage];
	[textStorage beginEditing];
	[textStorage appendAttributedString:attrString];
	[textStorage endEditing];
	[attrString release];
	
	// scroll to the bottom
	NSRange myRange;
	myRange.length = 1;
	myRange.location = [textStorage length];
	[serialOutputArea scrollRangeToVisible:myRange]; 
}
- (void)tabView:(NSTabView *)tabView willSelectTabViewItem:(NSTabViewItem *)tabViewItem {
    if ([tabView indexOfTabViewItem:tabViewItem] == 1) {
        if ([grbl isConnected]) {
            [grbl sendCommand:@"$$"];
        }
    }
}
- (void)setConfigurationParameter:(NSString*)key :(NSString*)value {
    switch ([key integerValue]) {
        case GRBL_CONFIG_STEP_PULSE:
            if (value != nil) {
                [_configStepPulse setStringValue:value];
                [_configStepPulse setEnabled:YES];
            }
            break;
        case GRBL_CONFIG_STEP_IDLE_DELAY:
            if (value != nil) {
                [_configStepIdleDelay setStringValue:value];
                [_configStepIdleDelay setEnabled:YES];
            }
            break;
        case GRBL_CONFIG_STEP_PORT_INVERT_MASK:
            if (value != nil) {
                if ([value integerValue] & InvertX) {
                    [_configStepPortInvertMask  setSelected:YES forSegment:0];
                } else {
                    [_configStepPortInvertMask  setSelected:NO forSegment:0];
                }
                if ([value integerValue] & InvertY) {
                    [_configStepPortInvertMask  setSelected:YES forSegment:1];
                } else {
                    [_configStepPortInvertMask  setSelected:NO forSegment:1];
                }
                if ([value integerValue] & InvertZ) {
                    [_configStepPortInvertMask  setSelected:YES forSegment:2];
                } else {
                    [_configStepPortInvertMask  setSelected:NO forSegment:2];
                }
                [_configStepPortInvertMask  setEnabled:YES];
            }
            break;
        case GRBL_CONFIG_DIRECTION_PORT_INVERT_MASK:
            if (value != nil) {
                if ([value integerValue] & InvertX) {
                    [_configDirectionPortInvertMask  setSelected:YES forSegment:0];
                } else {
                    [_configDirectionPortInvertMask  setSelected:NO forSegment:0];
                }
                if ([value integerValue] & InvertY) {
                    [_configDirectionPortInvertMask  setSelected:YES forSegment:1];
                } else {
                    [_configDirectionPortInvertMask  setSelected:NO forSegment:1];
                }
                if ([value integerValue] & InvertZ) {
                    [_configDirectionPortInvertMask  setSelected:YES forSegment:2];
                } else {
                    [_configDirectionPortInvertMask  setSelected:NO forSegment:2];
                }
                [_configDirectionPortInvertMask  setEnabled:YES];
            }
            break;
        case GRBL_CONFIG_STEP_ENABLE_INVERT:
            if (value != nil) {
                if ([value isEqualTo:@"1"]) {
                    [_configStepEnableInvert setState:NSOnState];
                } else {
                    [_configStepEnableInvert setState:NSOffState];
                }
                [_configStepEnableInvert setEnabled:YES];
            }
            break;
        case GRBL_CONFIG_LIMIT_PINS_INVERT:
            if (value != nil) {
                if ([value isEqualTo:@"1"]) {
                    [_configLimitPinsInvert setState:NSOnState];
                } else {
                    [_configLimitPinsInvert setState:NSOffState];
                }
                [_configLimitPinsInvert setEnabled:YES];
            }
            break;
        case GRBL_CONFIG_PROBE_PIN_INVERT:
            if (value != nil) {
                if ([value isEqualTo:@"1"]) {
                    [_configPobePinInvert setState:NSOnState];
                } else {
                    [_configPobePinInvert setState:NSOffState];
                }
                [_configPobePinInvert setEnabled:YES];
            }
            break;
        case GRBL_CONFIG_STATUS_REPORT:
            if (value != nil) {
                if ([value isEqualTo:@"1"]) {
                    [_configStatusReport  setSelected:YES forSegment:0];
                    [_configStatusReport  setSelected:NO forSegment:1];
                } else if ([value isEqualTo:@"2"]) {
                    [_configStatusReport  setSelected:NO forSegment:0];
                    [_configStatusReport  setSelected:YES forSegment:1];
                } else {
                    [_configStatusReport  setSelected:YES forSegment:0];
                    [_configStatusReport  setSelected:NO forSegment:1];
                }
                [_configStatusReport setEnabled:YES];
            }
            break;
        case GRBL_CONFIG_JUNCTION_DEVIATION:
            if (value != nil) {
                [_configJunctionDeviation setStringValue:value];
                [_configJunctionDeviation setEnabled:YES];
            }
            break;
        case GRBL_CONFIG_ARC_TOLERANCE:
            if (value != nil) {
                [_configArcTolerance setStringValue:value];
                [_configArcTolerance setEnabled:YES];
            }
            break;
        case GRBL_CONFIG_REPORT_INCHES:
            if (value != nil) {
                if ([value isEqualTo:@"1"]) {
                    [_configReportInches setState:NSOnState];
                } else {
                    [_configReportInches setState:NSOffState];
                }
                [_configReportInches setEnabled:YES];
            }
            break;
        case GRBL_CONFIG_SOFT_LIMITS:
            if (value != nil) {
                if ([value isEqualTo:@"1"]) {
                    [_configSoftLimits setState:NSOnState];
                } else {
                    [_configSoftLimits setState:NSOffState];
                }
                [_configSoftLimits setEnabled:YES];
            }
            break;
        case GRBL_CONFIG_HARD_LIMITS:
            if (value != nil) {
                if ([value isEqualTo:@"1"]) {
                    [_configHardLimits setState:NSOnState];
                } else {
                    [_configHardLimits setState:NSOffState];
                }
                [_configHardLimits setEnabled:YES];
            }
            break;
        case GRBL_CONFIG_HOMING_CYCLE:
            if (value != nil) {
                if ([value isEqualTo:@"1"]) {
                    [_configHomingCycle setState:NSOnState];
                } else {
                    [_configHomingCycle setState:NSOffState];
                }
                [_configHomingCycle setEnabled:YES];
            }
            break;
        case GRBL_CONFIG_HOMING_DIR_INVERT_MASK:
            if (value != nil) {
                if ([value integerValue] & InvertX) {
                    [_configHomingDirInvertMask  setSelected:YES forSegment:0];
                } else {
                    [_configHomingDirInvertMask  setSelected:NO forSegment:0];
                }
                if ([value integerValue] & InvertY) {
                    [_configHomingDirInvertMask  setSelected:YES forSegment:1];
                } else {
                    [_configHomingDirInvertMask  setSelected:NO forSegment:1];
                }
                if ([value integerValue] & InvertZ) {
                    [_configHomingDirInvertMask  setSelected:YES forSegment:2];
                } else {
                    [_configHomingDirInvertMask  setSelected:NO forSegment:2];
                }
                [_configHomingDirInvertMask  setEnabled:YES];
            }
            break;
        case GRBL_CONFIG_HOMING_FEED:
            if (value != nil) {
                [_configHomingFeed setStringValue:value];
                [_configHomingFeed setEnabled:YES];
            }
            break;
        case GRBL_CONFIG_HOMING_SEEK:
            if (value != nil) {
                [_configHomingSeek setStringValue:value];
                [_configHomingSeek setEnabled:YES];
            }
            break;
        case GRBL_CONFIG_HOMING_DEBOUNCE:
            if (value != nil) {
                [_configHomingDebounce setStringValue:value];
                [_configHomingDebounce setEnabled:YES];
            }
            break;
        case GRBL_CONFIG_HOMING_PULL_OFF:
            if (value != nil) {
                [_configHomingPullOff setStringValue:value];
                [_configHomingPullOff setEnabled:YES];
            }
            break;
        case GRBL_CONDIG_MAX_SPINDLE_RPM:
            [_configMaxSpindleRPM setStringValue:value];
            [_configMaxSpindleRPM setEnabled:YES];
            break;
        case GRBL_CONDIG_MIN_SPINDLE_RPM:
            [_configMinSpindleRPM setStringValue:value];
            [_configMinSpindleRPM setEnabled:YES];
            break;
        case GRBL_CONDIG_LASER_MODE:
            if (value != nil) {
                if ([value isEqualTo:@"1"]) {
                    [_configLaserMode setState:NSOnState];
                } else {
                    [_configLaserMode setState:NSOffState];
                }
                [_configLaserMode setEnabled:YES];
            }
            break;
        case GRBL_CONFIG_XY_PERPENDICULARTY_COMPENSATION:
            [_configXYPependicularityCompensation setStringValue:value];
            [_configXYPependicularityCompensation setEnabled:YES];
            break;
        case GRBL_CONFIG_X_STEPS_PER_MM:
            if (value != nil) {
                [_configXStepsPerMM setStringValue:value];
                [_configXStepsPerMM setEnabled:YES];
            }
            break;
        case GRBL_CONFIG_Y_STEPS_PER_MM:
            if (value != nil) {
                [_configYStepsPerMM setStringValue:value];
                [_configYStepsPerMM setEnabled:YES];
            }
            break;
        case GRBL_CONFIG_Z_STEPS_PER_MM:
            if (value != nil) {
                [_configZStepsPerMM setStringValue:value];
                [_configZStepsPerMM setEnabled:YES];
            }
            break;
        case GRBL_CONFIG_X_MAX_RATE:
            if (value != nil) {
                [_configXMaXRate setStringValue:value];
                [_configXMaXRate setEnabled:YES];
            }
            break;
        case GRBL_CONFIG_Y_MAX_RATE:
            if (value != nil) {
                [_configYMaXRate setStringValue:value];
                [_configYMaXRate setEnabled:YES];
            }
            break;
        case GRBL_CONFIG_Z_MAX_RATE:
            if (value != nil) {
                [_configZMaXRate setStringValue:value];
                [_configZMaXRate setEnabled:YES];
            }
            break;
        case GRBL_CONFIG_X_ACCELERATION:
            if (value != nil) {
                [_configXAcceleration setStringValue:value];
                [_configXAcceleration setEnabled:YES];
            }
            break;
        case GRBL_CONFIG_Y_ACCELERATION:
            if (value != nil) {
                [_configYAcceleration setStringValue:value];
                [_configYAcceleration setEnabled:YES];
            }
            break;
        case GRBL_CONFIG_Z_ACCELERATION:
            if (value != nil) {
                [_configZAcceleration setStringValue:value];
                [_configZAcceleration setEnabled:YES];
            }
            break;
        case GRBL_CONFIG_X_MAX_TRAVEL:
            if (value != nil) {
                [_configXMaxTravel setStringValue:value];
                [_configXMaxTravel setEnabled:YES];
            }
            break;
        case GRBL_CONFIG_Y_MAX_TRAVEL:
            if (value != nil) {
                [_configYMaxTravel setStringValue:value];
                [_configYMaxTravel setEnabled:YES];
            }
            break;
        case GRBL_CONFIG_Z_MAX_TRAVEL:
            if (value != nil) {
                [_configZMaxTravel setStringValue:value];
                [_configZMaxTravel setEnabled:YES];
            }
            break;
            
        default:
            break;
    }
}
- (IBAction)saveConfiguration:(id)sender {
    NSDictionary* configuration = [grbl configuration];
    if (![[_configStepPulse stringValue] isEqualToString:[configuration objectForKey:@"0"]]) {
        [grbl sendCommand:[NSString stringWithFormat:@"$0=%@", [_configStepPulse stringValue]]];
    }
    
    if (![[_configStepIdleDelay stringValue] isEqualToString:[configuration objectForKey:@"1"]]) {
        [grbl sendCommand:[NSString stringWithFormat:@"$1=%@", [_configStepIdleDelay stringValue]]];
    }
    
    int binaryValue = 0;
    if ([_configStepPortInvertMask isSelectedForSegment:0]) {
        binaryValue += 1;
    }
    if ([_configStepPortInvertMask isSelectedForSegment:1]) {
        binaryValue += 2;
    }
    if ([_configStepPortInvertMask isSelectedForSegment:2]) {
        binaryValue += 4;
    }
    if (![[NSString stringWithFormat:@"%d",binaryValue] isEqualToString:[configuration objectForKey:@"2"]]) {
        [grbl sendCommand:[NSString stringWithFormat:@"$2=%d", binaryValue]];
    }
    
    binaryValue = 0;
    if ([_configDirectionPortInvertMask isSelectedForSegment:0]) {
        binaryValue += 1;
    }
    if ([_configDirectionPortInvertMask isSelectedForSegment:1]) {
        binaryValue += 2;
    }
    if ([_configDirectionPortInvertMask isSelectedForSegment:2]) {
        binaryValue += 4;
    }
    if (![[NSString stringWithFormat:@"%d",binaryValue] isEqualToString:[configuration objectForKey:@"3"]]) {
        [grbl sendCommand:[NSString stringWithFormat:@"$3=%d", binaryValue]];
    }
    
    if ([_configStepEnableInvert state]!=[[configuration objectForKey:@"4"] integerValue]) {
        [grbl sendCommand:[NSString stringWithFormat:@"$4=%ld", (long)[_configStepEnableInvert state]]];
    }
    
    if ([_configLimitPinsInvert state]!=[[configuration objectForKey:@"5"] integerValue]) {
        [grbl sendCommand:[NSString stringWithFormat:@"$5=%ld", (long)[_configLimitPinsInvert state]]];
    }
    
    if ([_configPobePinInvert state]!=[[configuration objectForKey:@"6"] integerValue]) {
        [grbl sendCommand:[NSString stringWithFormat:@"$6=%ld", (long)[_configPobePinInvert state]]];
    }
    
    binaryValue = 0;
    if ([_configStatusReport isSelectedForSegment:0]) {
        binaryValue = 1;
    } else if ([_configStatusReport isSelectedForSegment:1]) {
        binaryValue = 2;
    } else {
        binaryValue = 1;
    }
    if (![[NSString stringWithFormat:@"%d",binaryValue] isEqualToString:[configuration objectForKey:@"10"]]) {
        [grbl sendCommand:[NSString stringWithFormat:@"$10=%d", binaryValue]];
    }

    if (![[_configJunctionDeviation stringValue] isEqualToString:[configuration objectForKey:@"11"]]) {
        [grbl sendCommand:[NSString stringWithFormat:@"$11=%@", [_configJunctionDeviation stringValue]]];
    }

    if (![[_configArcTolerance stringValue] isEqualToString:[configuration objectForKey:@"12"]]) {
        [grbl sendCommand:[NSString stringWithFormat:@"$12=%@", [_configArcTolerance stringValue]]];
    }

    if ([_configReportInches state]!=[[configuration objectForKey:@"13"] integerValue]) {
        [grbl sendCommand:[NSString stringWithFormat:@"$13=%ld", (long)[_configReportInches state]]];
    }

    if ([_configSoftLimits state]!=[[configuration objectForKey:@"20"] integerValue]) {
        [grbl sendCommand:[NSString stringWithFormat:@"$20=%ld", (long)[_configSoftLimits state]]];
    }

    if ([_configHardLimits state]!=[[configuration objectForKey:@"21"] integerValue]) {
        [grbl sendCommand:[NSString stringWithFormat:@"$21=%ld", (long)[_configHardLimits state]]];
    }

    if ([_configHomingCycle state]!=[[configuration objectForKey:@"22"] integerValue]) {
        [grbl sendCommand:[NSString stringWithFormat:@"$22=%ld", (long)[_configHomingCycle state]]];
    }

    binaryValue = 0;
    if ([_configHomingDirInvertMask isSelectedForSegment:0]) {
        binaryValue += 1;
    }
    if ([_configHomingDirInvertMask isSelectedForSegment:1]) {
        binaryValue += 2;
    }
    if ([_configHomingDirInvertMask isSelectedForSegment:2]) {
        binaryValue += 4;
    }
    if (![[NSString stringWithFormat:@"%d",binaryValue] isEqualToString:[configuration objectForKey:@"23"]]) {
        [grbl sendCommand:[NSString stringWithFormat:@"$23=%d", binaryValue]];
    }

    if (![[_configHomingFeed stringValue] isEqualToString:[configuration objectForKey:@"24"]]) {
        [grbl sendCommand:[NSString stringWithFormat:@"$24=%@", [_configHomingFeed stringValue]]];
    }

    if (![[_configHomingSeek stringValue] isEqualToString:[configuration objectForKey:@"25"]]) {
        [grbl sendCommand:[NSString stringWithFormat:@"$25=%@", [_configHomingSeek stringValue]]];
    }
    
    if (![[_configHomingDebounce stringValue] isEqualToString:[configuration objectForKey:@"26"]]) {
        [grbl sendCommand:[NSString stringWithFormat:@"$26=%@", [_configHomingDebounce stringValue]]];
    }

    if (![[_configHomingPullOff stringValue] isEqualToString:[configuration objectForKey:@"27"]]) {
        [grbl sendCommand:[NSString stringWithFormat:@"$27=%@", [_configHomingPullOff stringValue]]];
    }
    if (![[_configMaxSpindleRPM stringValue] isEqualToString:[configuration objectForKey:@"30"]]) {
        [grbl sendCommand:[NSString stringWithFormat:@"$30=%@", [_configMaxSpindleRPM stringValue]]];
    }
    if (![[_configMinSpindleRPM stringValue] isEqualToString:[configuration objectForKey:@"31"]]) {
        [grbl sendCommand:[NSString stringWithFormat:@"$31=%@", [_configMinSpindleRPM stringValue]]];
    }

    binaryValue = 0;
    if ([_configLaserMode state] == NSOnState) {
        binaryValue = 1;
    }
    if (![[NSString stringWithFormat:@"%d",binaryValue] isEqualToString:[configuration objectForKey:@"32"]]) {
        [grbl sendCommand:[NSString stringWithFormat:@"$32=%d", binaryValue]];
    }

    if (![[_configXYPependicularityCompensation stringValue] isEqualToString:[configuration objectForKey:@"33"]]) {
        [grbl sendCommand:[NSString stringWithFormat:@"$33=%0.4f", [_configXYPependicularityCompensation floatValue]]];
    }

    
    if ((long)[_configXStepsPerMM integerValue] != (long)[[configuration objectForKey:@"100"] integerValue]) {
        [grbl sendCommand:[NSString stringWithFormat:@"$100=%@", [_configXStepsPerMM stringValue]]];
    }
    if ((long)[_configYStepsPerMM integerValue] != (long)[[configuration objectForKey:@"101"] integerValue]) {
        [grbl sendCommand:[NSString stringWithFormat:@"$101=%@", [_configYStepsPerMM stringValue]]];
    }
    if ((long)[_configZStepsPerMM integerValue] != (long)[[configuration objectForKey:@"102"] integerValue]) {
        [grbl sendCommand:[NSString stringWithFormat:@"$102=%@", [_configZStepsPerMM stringValue]]];
    }

    if ((long)[_configXMaXRate integerValue] != (long)[[configuration objectForKey:@"110"] integerValue]) {
        [grbl sendCommand:[NSString stringWithFormat:@"$110=%@", [_configXMaXRate stringValue]]];
    }
    if ((long)[_configYMaXRate integerValue] != (long)[[configuration objectForKey:@"111"] integerValue]) {
        [grbl sendCommand:[NSString stringWithFormat:@"$111=%@", [_configYMaXRate stringValue]]];
    }
    if ((long)[_configZMaXRate integerValue] != (long)[[configuration objectForKey:@"112"] integerValue]) {
        [grbl sendCommand:[NSString stringWithFormat:@"$112=%@", [_configZMaXRate stringValue]]];
    }

    if ((long)[_configXAcceleration integerValue] != (long)[[configuration objectForKey:@"120"] integerValue]) {
        [grbl sendCommand:[NSString stringWithFormat:@"$120=%@", [_configXAcceleration stringValue]]];
    }
    if ((long)[_configYAcceleration integerValue] != (long)[[configuration objectForKey:@"121"] integerValue]) {
        [grbl sendCommand:[NSString stringWithFormat:@"$121=%@", [_configYAcceleration stringValue]]];
    }
    if ((long)[_configZAcceleration integerValue] != (long)[[configuration objectForKey:@"122"] integerValue]) {
        [grbl sendCommand:[NSString stringWithFormat:@"$122=%@", [_configZAcceleration stringValue]]];
    }

    if ((long)[_configXMaxTravel integerValue] != (long)[[configuration objectForKey:@"130"] integerValue]) {
        [grbl sendCommand:[NSString stringWithFormat:@"$130=%@", [_configXMaxTravel stringValue]]];
    }
    if ((long)[_configYMaxTravel integerValue] != (long)[[configuration objectForKey:@"131"] integerValue]) {
        [grbl sendCommand:[NSString stringWithFormat:@"$131=%@", [_configYMaxTravel stringValue]]];
    }
    if ((long)[_configZMaxTravel integerValue] != (long)[[configuration objectForKey:@"132"] integerValue]) {
        [grbl sendCommand:[NSString stringWithFormat:@"$132=%@", [_configZMaxTravel stringValue]]];
    }
    [grbl sendCommand:@"$$"];
}
- (IBAction)restoreConfigurationDefaults:(id)sender {
    NSAlert *alert = [[NSAlert alloc] init];
    [alert addButtonWithTitle:@"OK"];
    [alert addButtonWithTitle:@"Cancel"];
    [alert setMessageText:@"Restore configuration to defaults?"];
    [alert setInformativeText:@"Restoring settings to factory default will overwrite all current parameters."];
    [alert setAlertStyle:NSWarningAlertStyle];
    
    if ([alert runModal] != NSAlertFirstButtonReturn) {
        [alert release];
        return;
    }
    [alert release];
    
    [grbl sendCommand:@"$RST=$"];
    [grbl sendCommand:@"$$"];
}


// ##########################################################################
#pragma mark Jog
// ##########################################################################
- (IBAction)mCircleSliderChanged:(id)sender {
    [mOverlayView setCircleSize:[mCircleSlider intValue]];
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithInt:[mCircleSlider intValue]] forKey:@"CrosshairDiameter"];
}
- (IBAction)mLocationButtonClicked:(id)sender {
    if (![mCaptureSession isRunning]) {
        [self setStatusMessage:STATUS_MESSAGE_WARNING :@"Connect to camera first."];
        return;
    }
    
    float deltaX = [[[NSUserDefaults standardUserDefaults] objectForKey:@"CameraOffsetX"] floatValue];
    float deltaY = [[[NSUserDefaults standardUserDefaults] objectForKey:@"CameraOffsetY"] floatValue];
    
    float currentXValue = 0.0;
    float currentYValue = 0.0;
    
    if (currentPosition == POSITION_MILLING) {
        [mLocationButton setImage:[NSImage imageNamed:@"Icon_Camera.png"]];
        currentXValue = [[grbl workCoordinateX] floatValue] - deltaX;
        currentYValue = [[grbl workCoordinateY] floatValue] - deltaY;
        currentPosition = POSITION_CAMERA;
    } else if (currentPosition == POSITION_CAMERA) {
        [mLocationButton setImage:[NSImage imageNamed:@"Icon_Milling.png"]];
        currentXValue = [[grbl workCoordinateX] floatValue] + deltaX;
        currentYValue = [[grbl workCoordinateY] floatValue] + deltaY;
        currentPosition = POSITION_MILLING;
    }
    
    NSString *command = [NSString stringWithFormat:@"G92 X%f Y%f", currentXValue, currentYValue];
    [grbl sendCommand:command];
}
- (IBAction)mHomingButtonClicked:(id)sender {
    //[grbl sendCommandAndParseResponse:@"$H"];
}
- (IBAction)mCopyMaschinePosButtonClicked:(id)sender {
    float currentXValue = [[grbl machineCoordinateX] floatValue];
    float currentYValue = [[grbl machineCoordinateY] floatValue];
    float currentZValue = [[grbl machineCoordinateZ] floatValue];
    
    NSString *command = [NSString stringWithFormat:@"G92 X%f Y%f Z%f", currentXValue, currentYValue, currentZValue];
    [grbl sendCommand:command];
}
- (IBAction)mP1ButtonClicked:(id)sender {
    NSString *command = @"G28";
    
    NSUInteger flags = [[NSApp currentEvent] modifierFlags];
    if (flags & NSAlternateKeyMask) {
        command = @"G28.1";
    }
    
    [grbl sendCommand:command];
}
- (IBAction)mP2ButtonClicked:(id)sender {
    NSString *command = @"G30";

    NSUInteger flags = [[NSApp currentEvent] modifierFlags];
    if (flags & NSAlternateKeyMask) {
        command = @"G30.1";
    }
    
    [grbl sendCommand:command];
}
- (IBAction)mZeroXClicked:(id)sender {
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"LockXY"] boolValue]) {
        [grbl sendCommand:@"G92 X0 Y0"];
    } else {
        [grbl sendCommand:@"G92 X0"];
    }
    _lastJogWasMinusZ = FALSE;
}
- (IBAction)mZeroYClicked:(id)sender {
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"LockXY"] boolValue]) {
        [grbl sendCommand:@"G92 X0 Y0"];
    } else {
        [grbl sendCommand:@"G92 Y0"];
    }
    _lastJogWasMinusZ = FALSE;
}
- (IBAction)mZeroZClicked:(id)sender {
    [grbl sendCommand:@"G92 Z0"];
    _lastJogWasMinusZ = FALSE;
}
- (IBAction)mZeroAllClicked:(id)sender {
    [grbl sendCommand:@"G92 X0 Y0 Z0"];
    _lastJogWasMinusZ = FALSE;
}
- (IBAction)lockZeroXYButtonClicked:(id)sender {
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"LockXY"] boolValue]) {
        [mLockZeroXYButton setImage:[NSImage imageNamed:@"NSLockUnlockedTemplate"]];
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:[NSNumber numberWithBool:FALSE] forKey:@"LockXY"];
    } else {
        [mLockZeroXYButton setImage:[NSImage imageNamed:@"NSLockLockedTemplate"]];
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:[NSNumber numberWithBool:TRUE] forKey:@"LockXY"];
    }        
}
- (IBAction)mStepWidthClicked:(id)sender {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[mStepWidth itemTitleAtIndex:[mStepWidth indexOfSelectedItem]] forKey:@"StepWidth"];
    _lastJogWasMinusZ = FALSE;
    [mStepWithButton setSelectedSegment:[mStepWidth indexOfSelectedItem]];
}
- (IBAction)mStepWidthButtonClicked:(id)sender {
    [mStepWidth selectItemAtIndex:[mStepWithButton selectedSegment]];
    _lastJogWasMinusZ = FALSE;
}
- (IBAction)mStepClicked:(id)sender {
    NSArray *steps = [[NSArray alloc] initWithObjects:@"0.1", @"1", @"10", @"25", @"50", @"100", nil];
    float stepWith = [[steps objectAtIndex:[mStepWidth indexOfSelectedItem]] floatValue];
                      
    NSString *command = @"G91";
    [grbl sendCommand:command];
    
    if ([sender tag] == 10) { // +x
        command = [NSString stringWithFormat:@"G0 X %f", stepWith];
        _lastJogWasMinusZ = FALSE;
    } else if ([sender tag] == 20) { // +x -y
        command = [NSString stringWithFormat:@"G0 X %f Y -%f", stepWith, stepWith];
        _lastJogWasMinusZ = FALSE;
    } else if ([sender tag] == 30) { // -y
        command = [NSString stringWithFormat:@"G0 Y -%f", stepWith];
        _lastJogWasMinusZ = FALSE;
    } else if ([sender tag] == 40) { // -x -y
        command = [NSString stringWithFormat:@"G0 X -%f Y -%f", stepWith, stepWith];
        _lastJogWasMinusZ = FALSE;
    } else if ([sender tag] == 50) { // -x
        command = [NSString stringWithFormat:@"G0 X -%f", stepWith];
        _lastJogWasMinusZ = FALSE;
    } else if ([sender tag] == 60) { // -x +y
        command = [NSString stringWithFormat:@"G0 X -%f Y %f", stepWith, stepWith];
        _lastJogWasMinusZ = FALSE;
    } else if ([sender tag] == 70) { // +y
        command = [NSString stringWithFormat:@"G0 Y %f", stepWith];
        _lastJogWasMinusZ = FALSE;
    } else if ([sender tag] == 80) { // +x +y
        command = [NSString stringWithFormat:@"G0 X %f Y %f", stepWith, stepWith];
        _lastJogWasMinusZ = FALSE;
    } else if ([sender tag] == 100) { // +z
        command = [NSString stringWithFormat:@"G0 Z %f", stepWith];
        _lastJogWasMinusZ = FALSE;
    } else if ([sender tag] == 110) { // -z
        if (_lastJogWasMinusZ==FALSE) {
            NSAlert *alert = [[NSAlert alloc] init];
            [alert addButtonWithTitle:@"OK"];
            [alert addButtonWithTitle:@"Cancel"];
            [alert setMessageText:@"Move to negative Z coordinate?"];
            [alert setInformativeText:@"Moving towards negative Z coordinates can possibly damage your machine"];
            [alert setAlertStyle:NSWarningAlertStyle];
            
            if ([alert runModal] != NSAlertFirstButtonReturn) {
                [alert release];
                return;
            }
            [alert release];
        }
        
        command = [NSString stringWithFormat:@"G0 Z -%f", stepWith];
        _lastJogWasMinusZ = TRUE;
    }
    [grbl sendCommand:command];
}
- (IBAction)mGotoX0Clicked:(id)sender {
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"LockGotoX0Y0"] boolValue]) {
        [grbl sendCommand:@"G90 X0 Y0"];
    } else {
        [grbl sendCommand:@"G90 X0"];
    }
    _lastJogWasMinusZ = FALSE;
}
- (IBAction)mGotoY0Clicked:(id)sender {
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"LockGotoX0Y0"] boolValue]) {
        [grbl sendCommand:@"G90 X0 Y0"];
    } else {
        [grbl sendCommand:@"G90 Y0"];
    }
    _lastJogWasMinusZ = FALSE;
}
- (IBAction)mGotoZ0Clicked:(id)sender {
    [grbl sendCommand:@"G90 Z0"];
    _lastJogWasMinusZ = FALSE;
}
- (IBAction)lockGotoX0Y0ButtonClicked:(id)sender {
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"LockGotoX0Y0"] boolValue]) {
        [mLockGotoX0Y0Button setImage:[NSImage imageNamed:@"NSLockUnlockedTemplate"]];
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:[NSNumber numberWithBool:FALSE] forKey:@"LockGotoX0Y0"];
    } else {
        [mLockGotoX0Y0Button setImage:[NSImage imageNamed:@"NSLockLockedTemplate"]];
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:[NSNumber numberWithBool:TRUE] forKey:@"LockGotoX0Y0"];
    }    
}


// ##########################################################################
#pragma mark Work
// ##########################################################################
- (IBAction)openNCFile:(id)sender {
    NSOpenPanel* openPanel = [NSOpenPanel openPanel];
    
    openPanel.title = @"Choose nc-data file";
    openPanel.showsResizeIndicator = YES;
    openPanel.showsHiddenFiles = NO;
    openPanel.canChooseDirectories = NO;
    openPanel.canCreateDirectories = YES;
    openPanel.allowsMultipleSelection = NO;
    openPanel.allowedFileTypes = [NSArray arrayWithObjects:@"nc",@"txt",nil];;
    
    [openPanel beginSheetModalForWindow:mWindow completionHandler:^(NSInteger result) {
        if (result==NSModalResponseOK) {
            NSArray* files = [openPanel URLs];
            for(NSURL *url in files) {
                NSString* path = [url.path stringByResolvingSymlinksInPath];
                
                [mNCDataFileName setStringValue:path];

                [self processGCodeFile];
            }
        }
    }]; 
}
- (IBAction)mSendGCodeClicked:(id)sender {
        if ([[lineNumberView linesWithMarkers] count] == 1 || [[lineNumberView linesWithMarkers] count] > 2) {
        [self setStatusMessage:STATUS_MESSAGE_ERROR :@"Invalid number of markers found. Send aborted."];
        return;
    }
    
    NSAlert *alert = [[NSAlert alloc] init];
    [alert addButtonWithTitle:@"OK"];
    [alert addButtonWithTitle:@"Cancel"];
    [alert setMessageText:@"Really start work?"];
    [alert setInformativeText:@"Starting the job will send all commands and probably damage your machine or part."];
    [alert setAlertStyle:NSWarningAlertStyle];
    
    if ([alert runModal] != NSAlertFirstButtonReturn) {
        [alert release];
        return;
    }
    [alert release];

    int sendFromLine = 0;
    int sendToLine = 0;
    
    NSString* content = [[mNCData textStorage] string];
    NSArray* lines = [content componentsSeparatedByString:@"\n"];
    if ([[lineNumberView linesWithMarkers] count] == 0) {
        sendToLine = [lines count] - 1;
    } else {
        sendFromLine = [[[lineNumberView linesWithMarkers] objectAtIndex:0] integerValue];
        sendToLine = [[[lineNumberView linesWithMarkers] objectAtIndex:1] integerValue];
    }
    
    NSArray* linesToSend = [lines subarrayWithRange:NSMakeRange(sendFromLine, sendToLine+1-sendFromLine)];
    [grbl sendCommands:linesToSend];
}
- (IBAction)mChangeFeedRateClicked:(id)sender {
    NSLog(@"Cklick");
    NSInteger selectedSegment = [sender selectedSegment];
    NSInteger clickedSegmentTag = [[sender cell] tagForSegment:selectedSegment];

    switch (clickedSegmentTag) {
        case 0: [grbl writeString:[NSString stringWithFormat:@"%c",'\x92']]; break;
        case 1: [grbl writeString:[NSString stringWithFormat:@"%c",'\x91']]; break;
    }
}
- (void)textStorageDidProcessEditing:(NSNotification*)notification {
    [self highlightGCode];
}
- (void)highlightGCode {
    NSTextStorage *textStorage = [mNCData textStorage];
    NSString *content = [textStorage string];

    [textStorage removeAttribute:NSForegroundColorAttributeName
                           range:NSMakeRange(0, [content length])];
    [textStorage removeAttribute:NSFontAttributeName
                           range:NSMakeRange(0, [content length])];
    
    NSString *pattern = @"[GM][0-9]{1,2}";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:NULL];
    NSArray *matches = [regex matchesInString:content options:0 range:NSMakeRange(0, [content length])];
    for (NSTextCheckingResult* match in matches) {
        [textStorage addAttribute:NSFontAttributeName
                            value:[NSFont fontWithName:@"Helvetica-Bold" size:12.0]
                            range:[match range]];
    }
    
    pattern = @"X\\s*-?[0-9\\.]*";
    regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:NULL];
    matches = [regex matchesInString:content options:0 range:NSMakeRange(0, [content length])];
    for (NSTextCheckingResult* match in matches) {
        [textStorage addAttribute:NSForegroundColorAttributeName
                            value:[NSColor colorWithCalibratedRed:1.0f green:0.0f blue:0.0f alpha:1.0f]
                            range:[match range]];
    }
    
    pattern = @"Y\\s*-?[0-9\\.]*";
    regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:NULL];
    matches = [regex matchesInString:content options:0 range:NSMakeRange(0, [content length])];
    for (NSTextCheckingResult* match in matches) {
        [textStorage addAttribute:NSForegroundColorAttributeName
                            value:[NSColor colorWithCalibratedRed:0.0f green:0.85f blue:0.0f alpha:1.0f]
                            range:[match range]];
    }
    
    pattern = @"Z\\s*-?[0-9\\.]*";
    regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:NULL];
    matches = [regex matchesInString:content options:0 range:NSMakeRange(0, [content length])];
    for (NSTextCheckingResult* match in matches) {
        [textStorage addAttribute:NSForegroundColorAttributeName
                            value:[NSColor colorWithCalibratedRed:0.0f green:0.0f blue:1.0f alpha:1.0f]
                            range:[match range]];
    }
    
    pattern = @"[IJ]\\s*-?[0-9\\.]*";
    regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:NULL];
    matches = [regex matchesInString:content options:0 range:NSMakeRange(0, [content length])];
    for (NSTextCheckingResult* match in matches) {
        [textStorage addAttribute:NSForegroundColorAttributeName
                            value:[NSColor colorWithCalibratedRed:1.0f green:0.75f blue:0.0f alpha:1.0f]
                            range:[match range]];
    }
    
    pattern = @"F\\s*[0-9\\.]*";
    regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:NULL];
    matches = [regex matchesInString:content options:0 range:NSMakeRange(0, [content length])];
    for (NSTextCheckingResult* match in matches) {
        [textStorage addAttribute:NSForegroundColorAttributeName
                            value:[NSColor colorWithCalibratedRed:1.0f green:0.5f blue:1.0f alpha:1.0f]
                            range:[match range]];
        [textStorage addAttribute:NSFontAttributeName
                            value:[NSFont fontWithName:@"Helvetica-Bold" size:12.0]
                            range:[match range]];
    }
    
    pattern = @"[PS]\\s*[0-9]*";
    regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:NULL];
    matches = [regex matchesInString:content options:0 range:NSMakeRange(0, [content length])];
    for (NSTextCheckingResult* match in matches) {
        [textStorage addAttribute:NSForegroundColorAttributeName
                            value:[NSColor colorWithCalibratedRed:0.25f green:0.25f blue:0.25f alpha:1.0f]
                            range:[match range]];
    }
    
    pattern = @"\\([^\\)]*\\)";
    regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:NULL];
    matches = [regex matchesInString:content options:0 range:NSMakeRange(0, [content length])];
    for (NSTextCheckingResult* match in matches) {
        [textStorage addAttribute:NSForegroundColorAttributeName
                            value:[NSColor colorWithCalibratedRed:0.0f green:0.0f blue:0.0f alpha:0.3f]
                            range:[match range]];
        [textStorage addAttribute:NSFontAttributeName
                            value:[NSFont fontWithName:@"Helvetica" size:12.0]
                            range:[match range]];
    }
}
- (void)setSendingProgess:(NSNumber*)percent {
    [_sendingProgress setDoubleValue:[percent doubleValue]];
}
- (void)processGCodeFile {
    GCode* ncData = [[GCode alloc] init];
    NSString* fileName = [mNCDataFileName stringValue];
    [ncData readFromString:[[mNCData textStorage] string]];
    
    [ncData readFromPath:fileName];
    ncData = [ncData shift:[_gcodeModifiyShiftX floatValue] :[_gcodeModifiyShiftY floatValue] :[_gcodeModifiyShiftZ floatValue]];
    ncData = [ncData rotate:[_gcodeModifiyAngle floatValue]];
    ncData = [ncData scale:[_gcodeModifiyScale floatValue] :false];
    
    [mNCData setString:[ncData toCommands]];
    [self highlightGCode];
    
    [_gcodeInformationXDimensions setStringValue:[NSString stringWithFormat:@"%.02fmm to %.02fmm", [[[ncData boundaries] objectAtIndex:0] floatValue], [[[ncData boundaries] objectAtIndex:1] floatValue]]];
    [_gcodeInformationYDimensions setStringValue:[NSString stringWithFormat:@"%.02fmm to %.02fmm", [[[ncData boundaries] objectAtIndex:2] floatValue], [[[ncData boundaries] objectAtIndex:3] floatValue]]];
    [_gcodeInformationZDimensions setStringValue:[NSString stringWithFormat:@"%.02fmm to %.02fmm", [[[ncData boundaries] objectAtIndex:4] floatValue], [[[ncData boundaries] objectAtIndex:5] floatValue]]];
/*
     GCode* tmpNCData = [[GCode alloc] init];
     [tmpNCData readFromURL:url];
     
     [ncData setElements:[[tmpNCData elements] copy]];
     [_ncPreview2D setGcodeElements:[tmpNCData elements]];
     [_ncPreview3D setGcodeElements:[tmpNCData elements]];
     
     NSString *content =[ncData toCommands];
     [mNCData setString:content];
     [self highlightGCode];
     [_XRange setStringValue:[NSString stringWithFormat:@"%.02fmm to %.02fmm", [[[ncData boundaries] objectAtIndex:0] floatValue], [[[ncData boundaries] objectAtIndex:1] floatValue]]];
     [_YRange setStringValue:[NSString stringWithFormat:@"%.02fmm to %.02fmm", [[[ncData boundaries] objectAtIndex:2] floatValue], [[[ncData boundaries] objectAtIndex:3] floatValue]]];
     [_ZRange setStringValue:[NSString stringWithFormat:@"%.02fmm to %.02fmm", [[[ncData boundaries] objectAtIndex:4] floatValue], [[[ncData boundaries] objectAtIndex:5] floatValue]]];
     [_workpathLength setStringValue:[NSString stringWithFormat:@"%.01fmm", [ncData length:MeasurmentModeAll]]];
*/
}

#pragma mark-

@end
