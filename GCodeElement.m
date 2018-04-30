//
//  GCodeElement.m
//  CamView
//
//  Created on 22.12.15.
//

#import "GCodeElement.h"

@implementation GCodeElement

@synthesize type;
@synthesize comment;
@synthesize iValue = _iValue;
- (void) setIValue:(double)i {
    _iValue = i;
    _hasIValue = TRUE;
}
- (double)iValue {
    return _iValue;
}
@synthesize jValue = _jValue;
- (void) setJValue:(double)j {
    _jValue = j;
    _hasJValue = TRUE;
}
- (double)jValue {
    return _jValue;
}
@synthesize kValue = _kValue;
- (void) setKValue:(double)k {
    _kValue = k;
    _hasKValue = TRUE;
}
- (double)kValue {
    return _kValue;
}
@synthesize lValue = _lValue;
- (void) setLValue:(double)l {
    _lValue = l;
    _hasLValue = TRUE;
}
- (double)lValue {
    return _lValue;
}
@synthesize nValue = _nValue;
- (void) setNValue:(double)n {
    _nValue = n;
    _hasNValue = TRUE;
}
- (double)nValue {
    return _nValue;
}
@synthesize pValue = _pValue;
- (void) setPValue:(double)p {
    _pValue = p;
    _hasPValue = TRUE;
}
- (double)pValue {
    return _pValue;
}
@synthesize rValue = _rValue;
- (void) setRValue:(double)r {
    _rValue = r;
    _hasRValue = TRUE;
}
- (double)rValue {
    return _rValue;
}
@synthesize sValue = _sValue;
- (void) setSValue:(double)s {
    _sValue = s;
    _hasSValue = TRUE;
}
- (double)sValue {
    return _sValue;
}
@synthesize tValue = _tValue;
- (void) setTValue:(double)t {
    _tValue = t;
    _hasTValue = TRUE;
}
- (double)tValue {
    return _tValue;
}
@synthesize xValue = _xValue;
- (void) setXValue:(double)x {
    _xValue = x;
    _hasXValue = TRUE;
}
- (double)xValue {
    return _xValue;
}
@synthesize yValue = _yValue;
- (void) setYValue:(double)y {
    _yValue = y;
    _hasYValue = TRUE;
}
- (double)yValue {
    return _yValue;
}
@synthesize zValue = _zValue;
- (void) setZValue:(double)z {
    _zValue = z;
    _hasZValue = TRUE;
}
- (double)zValue {
    return _zValue;
}
@synthesize feedRate = _feedRate;
- (double)feedRate {
    return _feedRate;
}
- (void) setFeedRate:(double)feedRate {
    _feedRate = feedRate;
}

- (BOOL)hasXValue {
    return _hasXValue;
}
- (BOOL)hasYValue {
    return _hasYValue;
}
- (BOOL)hasZValue {
    return _hasZValue;
}

// ##########################################################################
#pragma mark General
// ##########################################################################
- (id) init {
    self = [super init];
    if (self!=nil) {
        type = GCODE_NOCOMMAND;
        comment = @"";
        _hasIValue = FALSE;
        _hasJValue = FALSE;
        _hasKValue = FALSE;
        _hasLValue = FALSE;
        _hasNValue = FALSE;
        _hasPValue = FALSE;
        _hasRValue = FALSE;
        _hasSValue = FALSE;
        _hasTValue = FALSE;
        _hasXValue = FALSE;
        _hasYValue = FALSE;
        _hasZValue = FALSE;
    }
    
    return self;
}
- (NSString*)description {
    switch (type) {
        case GCODE_NOCOMMAND:
            return [NSString stringWithFormat:@"No command"];
            break;
        case GCODE_FEED_RATE:
            return [NSString stringWithFormat:@"Change feed rate to %f", _feedRate];
            break;
        case GCODE_CMD_G0:
            return [NSString stringWithFormat:@"Go fast to X%0.4f", _xValue];
            break;
            
        default:
            return nil;
            break;
    }
}


// ##########################################################################
#pragma mark Functions
// ##########################################################################
- (NSString*)toCommand {
    NSString* command = @"";
    switch (type) {
        case GCODE_NOCOMMAND:
            command = @"";
            break;
        case GCODE_FEED_RATE:
            command = [NSString stringWithFormat:@"F%d", (int)_feedRate];
            break;
        case GCODE_CMD_G0:
            command = [NSString stringWithFormat:@"G00"];
            if (_hasXValue)
                command = [command stringByAppendingString:[NSString stringWithFormat:@" X%0.4f", _xValue]];
            if (_hasYValue)
                command = [command stringByAppendingString:[NSString stringWithFormat:@" Y%0.4f", _yValue]];
            if (_hasZValue)
                command = [command stringByAppendingString:[NSString stringWithFormat:@" Z%0.4f", _zValue]];
            break;
        case GCODE_CMD_G1:
            command = [NSString stringWithFormat:@"G01"];
            if (_hasXValue)
                command = [command stringByAppendingString:[NSString stringWithFormat:@" X%0.4f", _xValue]];
            if (_hasYValue)
                command = [command stringByAppendingString:[NSString stringWithFormat:@" Y%0.4f", _yValue]];
            if (_hasZValue)
                command = [command stringByAppendingString:[NSString stringWithFormat:@" Z%0.4f", _zValue]];
            break;
        case GCODE_CMD_G2:
            command = [NSString stringWithFormat:@"G02"];
            if (_hasXValue)
                command = [command stringByAppendingString:[NSString stringWithFormat:@" X%0.4f", _xValue]];
            if (_hasYValue)
                command = [command stringByAppendingString:[NSString stringWithFormat:@" Y%0.4f", _yValue]];
            if (_hasZValue)
                command = [command stringByAppendingString:[NSString stringWithFormat:@" Z%0.4f", _zValue]];
            if (_hasIValue)
                command = [command stringByAppendingString:[NSString stringWithFormat:@" I%0.4f", _iValue]];
            if (_hasJValue)
                command = [command stringByAppendingString:[NSString stringWithFormat:@" J%0.4f", _jValue]];
            break;
        case GCODE_CMD_G3:
            command = [NSString stringWithFormat:@"G03"];
            if (_hasXValue)
                command = [command stringByAppendingString:[NSString stringWithFormat:@" X%0.4f", _xValue]];
            if (_hasYValue)
                command = [command stringByAppendingString:[NSString stringWithFormat:@" Y%0.4f", _yValue]];
            if (_hasZValue)
                command = [command stringByAppendingString:[NSString stringWithFormat:@" Z%0.4f", _zValue]];
            if (_hasIValue)
                command = [command stringByAppendingString:[NSString stringWithFormat:@" I%0.4f", _iValue]];
            if (_hasJValue)
                command = [command stringByAppendingString:[NSString stringWithFormat:@" J%0.4f", _jValue]];
            break;
        case GCODE_CMD_G4:
            command = [NSString stringWithFormat:@"G04"];
            if (_hasPValue)
                command = [command stringByAppendingString:[NSString stringWithFormat:@" P%d", (int)_pValue]];
            else if (_hasSValue)
                command = [command stringByAppendingString:[NSString stringWithFormat:@" P%d (set to P-parameter for grbl compatibiliy)", (int)_sValue*1000]];
            break;
        case GCODE_CMD_G17:
            command = [NSString stringWithFormat:@"G17"];
            break;
        case GCODE_CMD_G18:
            command = [NSString stringWithFormat:@"G18"];
            break;
        case GCODE_CMD_G19:
            command = [NSString stringWithFormat:@"G19"];
            break;
        case GCODE_CMD_G20:
            command = [NSString stringWithFormat:@"G20"];
            break;
        case GCODE_CMD_G21:
            command = [NSString stringWithFormat:@"G21"];
            break;
        case GCODE_CMD_G54:
            command = [NSString stringWithFormat:@"G54"];
            break;
        case GCODE_CMD_G55:
            command = [NSString stringWithFormat:@"G55"];
            break;
        case GCODE_CMD_G56:
            command = [NSString stringWithFormat:@"G56"];
            break;
        case GCODE_CMD_G57:
            command = [NSString stringWithFormat:@"G57"];
            break;
        case GCODE_CMD_G58:
            command = [NSString stringWithFormat:@"G58"];
            break;
        case GCODE_CMD_G59:
            command = [NSString stringWithFormat:@"G59"];
            break;
        case GCODE_CMD_G90:
            command = [NSString stringWithFormat:@"G90"];
            break;
        case GCODE_CMD_G91:
            command = [NSString stringWithFormat:@"G91"];
            break;
        case GCODE_CMD_G92:
            command = [NSString stringWithFormat:@"G92"];
            if (_hasXValue)
                command = [command stringByAppendingString:[NSString stringWithFormat:@" X%0.4f", _xValue]];
            if (_hasYValue)
                command = [command stringByAppendingString:[NSString stringWithFormat:@" Y%0.4f", _yValue]];
            if (_hasZValue)
                command = [command stringByAppendingString:[NSString stringWithFormat:@" Z%0.4f", _zValue]];
            break;
        case GCODE_CMD_G93:
            command = [NSString stringWithFormat:@"G93"];
            break;
        case GCODE_CMD_G94:
            command = [NSString stringWithFormat:@"G94"];
            break;
        case GCODE_CMD_M0:
            command = [NSString stringWithFormat:@"M00"];
            break;
        case GCODE_CMD_M2:
            command = [NSString stringWithFormat:@"M02"];
            break;
        case GCODE_CMD_M3:
            command = [NSString stringWithFormat:@"M03"];
            break;
        case GCODE_CMD_M4:
            command = [NSString stringWithFormat:@"M04"];
            break;
        case GCODE_CMD_M5:
            command = [NSString stringWithFormat:@"M05"];
            break;
        case GCODE_CMD_M8:
            command = [NSString stringWithFormat:@"M08"];
            break;
        case GCODE_CMD_M9:
            command = [NSString stringWithFormat:@"M09"];
            break;
        case GCODE_CMD_M30:
            command = [NSString stringWithFormat:@"M30"];
            break;
        default:
            command = @"";
            break;
    }
    
    if ([comment length]>0) {
        if (type == GCODE_NOCOMMAND) {
            command = [NSString stringWithFormat:@"(%@)", comment];
        } else {
                command = [command stringByAppendingFormat:@" (%@)", comment];
        }
    }
    
    return command;
}
- (double)offsetTo:(double)x :(double)y :(double)z {
    double newX = 0.0;
    double newY = 0.0;
    double newZ = 0.0;

    double offset = 0.0;
    
    switch (type) {
        case GCODE_CMD_G0:
        case GCODE_CMD_G1:
            if (_hasXValue) {
                newX = _xValue;
            } else {
                newX = x;
            }
            if (_hasYValue) {
                newY = _yValue;
            } else {
                newY = y;
            }
            if (_hasZValue) {
                newZ = _zValue;
            } else {
                newZ = z;
            }
            
            offset = sqrt(pow(x-newX, 2)+pow(y-newY, 2)+pow(z-newZ, 2));
            break;
        case GCODE_CMD_G2:
        case GCODE_CMD_G3:
            NSLog(@"TO BE IMPLEMENTED");
            break;
            
        default:
            break;
    }
    
    return offset;
}

@end
