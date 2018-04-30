//
//  GCode.m
//  CamView
//
//  Created on 22.12.15.
//

#import "GCode.h"

@implementation GCode

@synthesize elements;
- (NSArray*)boundaries {
    double minX = 1000;
    double maxX = 0;
    double minY = 1000;
    double maxY = 0;
    double minZ = 1000;
    double maxZ = 0;
    
    for (GCodeElement* element in elements) {
        if ([element type] == GCODE_CMD_G0 || [element type] ==  GCODE_CMD_G1) {
            if ([element hasXValue]) {
                minX = MIN([element xValue], minX);
                maxX = MAX([element xValue], maxX);
            }
            if ([element hasYValue]) {
                minY = MIN([element yValue], minY);
                maxY = MAX([element yValue], maxY);
            }
            if ([element hasZValue]) {
                minZ = MIN([element zValue], minZ);
                maxZ = MAX([element zValue], maxZ);
            }
        }
    }
    
    NSMutableArray* returnValue;
    returnValue = [[NSMutableArray alloc] init];
    
    [returnValue addObject:[NSNumber numberWithDouble:minX]];
    [returnValue addObject:[NSNumber numberWithDouble:maxX]];
    [returnValue addObject:[NSNumber numberWithDouble:minY]];
    [returnValue addObject:[NSNumber numberWithDouble:maxY]];
    [returnValue addObject:[NSNumber numberWithDouble:minZ]];
    [returnValue addObject:[NSNumber numberWithDouble:maxZ]];
    
    return returnValue;
}

// ##########################################################################
#pragma mark General
// ##########################################################################
- (id) init {
    self = [super init];
    if (self!=nil) {
        elements = nil;
    }

    return self;
}
- (NSString*)description {
    return [NSString stringWithFormat:@"%@", elements];
}


// ##########################################################################
#pragma mark Functions
// ##########################################################################
- (void)readFromURL:(NSURL*)url {
    NSString* path = [url.path stringByResolvingSymlinksInPath];
    [self readFromPath:path];
}
- (void)readFromPath:(NSString*)path {
    NSString* _path = [path stringByResolvingSymlinksInPath];
    NSString *content =[ NSString stringWithContentsOfFile:_path encoding:NSUTF8StringEncoding error:nil];
    [self readFromString:content];
}
- (void)readFromString:(NSString*)string {
    NSString *content = [string stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    
    NSArray* lines = [content componentsSeparatedByString:@"\n"];
    NSMutableArray* _elements;
    _elements = [[NSMutableArray alloc] init];
    for (NSString* line in lines) {
        [line stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        
        GCodeElement* element = [[GCodeElement alloc] init];
        while ([line length]>0) {
            BOOL itemFound = FALSE;
            
            // Remove leading and training blank's and newline's
            NSRange range = [line rangeOfString:@"^\\s*" options:NSRegularExpressionSearch];
            line = [line stringByReplacingCharactersInRange:range withString:@""];
            range = [line rangeOfString:@"[\\s\\n\\r]*$" options:NSRegularExpressionSearch];
            line = [line stringByReplacingCharactersInRange:range withString:@""];
            
            NSString* pattern;
            NSRegularExpression *regex;
            NSArray *matches;
            
            // Look for commands and arguments
            pattern = @"^[FGIJKLMNPRSTXYZ]\\s*-?[\\d\\.]*";
            regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:NULL];
            matches = [regex matchesInString:line options:0 range:NSMakeRange(0, [line length])];
            if ([matches count]>0) {
                NSTextCheckingResult* match = [matches objectAtIndex:0];
                NSString* substring = [[line substringWithRange:[match range]] uppercaseString];

                if ([substring hasPrefix:@"F"]) {
                    // Sobald ein FeedRate-Kommando gefunden wird, dieses sofort in die Kommandoliste einfügen.
                    // Dadurch kann es sowohl alleine in einer Zeile stehen, als auch innerhalb zB eines G1-Befehls
                    // verschachtelt sein.
                    // Auf jeden Fall werden aber Änderungen des Vorschub's vor dem Befehl ausgeführt 
                    GCodeElement* feedRateElement = [[GCodeElement alloc] init];
                    [feedRateElement setType:GCODE_FEED_RATE];
                    [feedRateElement setFeedRate:[[substring substringFromIndex:1] doubleValue]];
                    [_elements addObject:feedRateElement];
/*
 if ([element type] != GCODE_NOCOMMAND) {
                        [_elements addObject:element];
                        element = [[GCodeElement alloc] init];
                    }
                    [element setType:GCODE_FEED_RATE];
                    [element setFeedRate:[[substring substringFromIndex:1] doubleValue]];
                    [_elements addObject:element];
                    
                    element = [[GCodeElement alloc] init];
*/
                } else if ([substring hasPrefix:@"G"]) {
                    if ([element type] != GCODE_NOCOMMAND) {
                        [_elements addObject:element];
                        element = [[GCodeElement alloc] init];
                    }
                    NSString* value = [substring substringFromIndex:1];
                    if ([value isEqualTo:@"0"] || [value isEqualTo:@"00"]) {
                        [element setType:GCODE_CMD_G0];
                    } else if ([value isEqualTo:@"1"] || [value isEqualTo:@"01"]) {
                        [element setType:GCODE_CMD_G1];
                    } else if ([value isEqualTo:@"2"] || [value isEqualTo:@"02"]) {
                        [element setType:GCODE_CMD_G2];
                    } else if ([value isEqualTo:@"3"] || [value isEqualTo:@"03"]) {
                        [element setType:GCODE_CMD_G3];
                    } else if ([value isEqualTo:@"4"] || [value isEqualTo:@"04"]) {
                        [element setType:GCODE_CMD_G4];
                    } else if ([value isEqualTo:@"17"]) {
                        [element setType:GCODE_CMD_G17];
                    } else if ([value isEqualTo:@"18"]) {
                        [element setType:GCODE_CMD_G18];
                    } else if ([value isEqualTo:@"19"]) {
                        [element setType:GCODE_CMD_G19];
                    } else if ([value isEqualTo:@"20"]) {
                        [element setType:GCODE_CMD_G20];
                    } else if ([value isEqualTo:@"21"]) {
                        [element setType:GCODE_CMD_G21];
                    } else if ([value isEqualTo:@"54"]) {
                        [element setType:GCODE_CMD_G54];
                    } else if ([value isEqualTo:@"55"]) {
                        [element setType:GCODE_CMD_G55];
                    } else if ([value isEqualTo:@"56"]) {
                        [element setType:GCODE_CMD_G56];
                    } else if ([value isEqualTo:@"57"]) {
                        [element setType:GCODE_CMD_G57];
                    } else if ([value isEqualTo:@"58"]) {
                        [element setType:GCODE_CMD_G58];
                    } else if ([value isEqualTo:@"59"]) {
                        [element setType:GCODE_CMD_G59];
                    } else if ([value isEqualTo:@"90"]) {
                        [element setType:GCODE_CMD_G90];
                    } else if ([value isEqualTo:@"91"]) {
                        [element setType:GCODE_CMD_G91];
                    } else if ([value isEqualTo:@"92"]) {
                        [element setType:GCODE_CMD_G92];
                    } else if ([value isEqualTo:@"93"]) {
                        [element setType:GCODE_CMD_G93];
                    } else if ([value isEqualTo:@"94"]) {
                        [element setType:GCODE_CMD_G94];
                    }
                }  else if ([substring hasPrefix:@"I"]) {
                    NSString* value = [substring substringFromIndex:1];
                    [element setIValue:[value doubleValue]];
                }  else if ([substring hasPrefix:@"J"]) {
                    NSString* value = [substring substringFromIndex:1];
                    [element setJValue:[value doubleValue]];
                }  else if ([substring hasPrefix:@"M"]) {
                    if ([element type] != GCODE_NOCOMMAND) {
                        [_elements addObject:element];
                        element = [[GCodeElement alloc] init];
                    }
                    NSString* value = [substring substringFromIndex:1];
                    if ([value isEqualTo:@"0"] || [value isEqualTo:@"00"]) {
                        [element setType:GCODE_CMD_M0];
                    } else if ([value isEqualTo:@"2"] || [value isEqualTo:@"02"]) {
                        [element setType:GCODE_CMD_M2];
                    } else if ([value isEqualTo:@"3"] || [value isEqualTo:@"03"]) {
                        [element setType:GCODE_CMD_M3];
                    } else if ([value isEqualTo:@"4"] || [value isEqualTo:@"04"]) {
                        [element setType:GCODE_CMD_M4];
                    } else if ([value isEqualTo:@"5"] || [value isEqualTo:@"05"]) {
                        [element setType:GCODE_CMD_M5];
                    } else if ([value isEqualTo:@"8"] || [value isEqualTo:@"08"]) {
                        [element setType:GCODE_CMD_M8];
                    } else if ([value isEqualTo:@"9"] || [value isEqualTo:@"09"]) {
                        [element setType:GCODE_CMD_M9];
                    }  else if ([value isEqualTo:@"30"]) {
                        [element setType:GCODE_CMD_M30];
                    }
                }  else if ([substring hasPrefix:@"P"]) {
                    NSString* value = [substring substringFromIndex:1];
                    [element setPValue:[value doubleValue]];
                }  else if ([substring hasPrefix:@"S"]) {
                    NSString* value = [substring substringFromIndex:1];
                    [element setSValue:[value doubleValue]];
                }  else if ([substring hasPrefix:@"X"]) {
                    NSString* value = [substring substringFromIndex:1];
                    [element setXValue:[value doubleValue]];
                }  else if ([substring hasPrefix:@"Y"]) {
                    NSString* value = [substring substringFromIndex:1];
                    [element setYValue:[value doubleValue]];
                }  else if ([substring hasPrefix:@"Z"]) {
                    NSString* value = [substring substringFromIndex:1];
                    [element setZValue:[value doubleValue]];
                }
                
                
                
                
                
                
                itemFound = TRUE;
                line = [self stringByRemovingRange:line :[match range]];
            }
            
            // look for comments
            pattern = @"\\([^\\)]*\\)";
            regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:NULL];
            matches = [regex matchesInString:line options:0 range:NSMakeRange(0, [line length])];
            if ([matches count]>0) {
                NSTextCheckingResult* match = [matches objectAtIndex:0];
                
                if ([[element comment] length] > 0) {
                    [_elements addObject:element];
                    element = [[GCodeElement alloc] init];
                }
                [element setComment:[line substringWithRange:NSMakeRange([match range].location+1, [match range].length-2)]];
                
                itemFound = TRUE;
                line = [self stringByRemovingRange:line :[match range]];
            }
            
            if (!itemFound) {
                break;
            }
        }
        if ([[element comment] length] > 0 || [element type] != GCODE_NOCOMMAND) {
            [_elements addObject:element];
        }
    }
    elements = [NSArray arrayWithArray:_elements];
}
- (NSString*)toCommands {
    NSMutableArray* commands;
    commands = [[NSMutableArray alloc] init];
    
    for (GCodeElement* element in elements) {
        [commands addObject:[element toCommand]];
    }
    
    return [commands componentsJoinedByString:@"\n"];
}


- (NSString*) stringByRemovingRange:(NSString*)theString :(NSRange)theRange {
    NSMutableString* mstr = [theString mutableCopy];
    [mstr deleteCharactersInRange:theRange];
    return [mstr autorelease];
}

- (GCode*)shift:(float)deltaX :(float)deltaY :(float)deltaZ {
    GCode *newValues = self;
    for (GCodeElement* element in [newValues elements]) {
        [element setXValue:[element xValue]+deltaX];
        [element setYValue:[element yValue]+deltaY];
        [element setZValue:[element zValue]+deltaZ];
    }
    return newValues;
}
- (GCode*)rotate:(float)angle {
    GCode *newValues = self;
    angle *= M_PI/180;
    float s = sin(angle);
    float c = cos(angle);
    for (GCodeElement* element in [newValues elements]) {
        // rotate point
        float newX = [element xValue] * c - [element yValue] * s;
        float newY = [element xValue] * s + [element yValue] * c;
        [element setXValue:newX];
        [element setYValue:newY];
    }
    return self;
}
- (GCode*)scale:(float)factor {
    GCode *newValues = self;
    for (GCodeElement* element in [newValues elements]) {
        [element setXValue:[element xValue]*factor];
        [element setYValue:[element yValue]*factor];
        [element setZValue:[element zValue]*factor];
        [element setIValue:[element iValue]*factor];
        [element setJValue:[element jValue]*factor];
    }
    return newValues;
}

@end
