//
//  GCodeElement.h
//  CamView
//
//  Created on 22.12.15.
//

#import <Foundation/Foundation.h>

#define GCODE_NOCOMMAND     0
#define GCODE_FEED_RATE     1

// Supported G-Codes in Grbl v0.8 (and v0.9)
#define GCODE_CMD_G0       10   // Linear Motions
#define GCODE_CMD_G1       11
#define GCODE_CMD_G2       12   // Arc and Helical Motions
#define GCODE_CMD_G3       13
#define GCODE_CMD_G4       14   // Dwell
#define GCODE_CMD_G10      15   // Set Work Coordinate Offsets
#define GCODE_CMD_G17      16   // Plane Selection
#define GCODE_CMD_G18      17
#define GCODE_CMD_G19      18
#define GCODE_CMD_G20      19   // Units
#define GCODE_CMD_G21      20
#define GCODE_CMD_G28      21   // Go to Pre-Defined Position
#define GCODE_CMD_G30      22
#define GCODE_CMD_G28_1    23   // Set Pre-Defined Position
#define GCODE_CMD_G30_1    24
#define GCODE_CMD_G53      25   // Move in Absolute Coordinates
#define GCODE_CMD_G54      26   // Work Coordinate Systems
#define GCODE_CMD_G55      27   //
#define GCODE_CMD_G56      28   //
#define GCODE_CMD_G57      29   //
#define GCODE_CMD_G58      30   //
#define GCODE_CMD_G59      31   //
#define GCODE_CMD_G80      32   // Motion Mode Cancel
#define GCODE_CMD_G90      33   //
#define GCODE_CMD_G91      34   // Distance Modes
#define GCODE_CMD_G92      35   // Coordinate Offset
#define GCODE_CMD_G92_1    36   // Clear Coordinate System Offsets
#define GCODE_CMD_G93      37   // Feedrate Modes
#define GCODE_CMD_G94      38   //
#define GCODE_CMD_M0       39   // Program Pause and End
#define GCODE_CMD_M2       40   //
#define GCODE_CMD_M30      41   //
#define GCODE_CMD_M3       42   // Spindle Control
#define GCODE_CMD_M4       43   //
#define GCODE_CMD_M5       44   //
#define GCODE_CMD_M8       45   // Coolant Control
#define GCODE_CMD_M9       46   //

// Supported G-Codes in v0.9h
#define GCODE_CMD_G38_2    60   // Probing
#define GCODE_CMD_G43_1    61   // Dynamic Tool Length Offsets
#define GCODE_CMD_G49      62   //

// Supported G-Codes in v0.9i
#define GCODE_CMD_G38_3    80   // Probing
#define GCODE_CMD_G38_4    81   //
#define GCODE_CMD_G38_5    82   //
#define GCODE_CMD_G40      83   // Cutter Radius Compensation Modes
#define GCODE_CMD_G61      84   // Path Control Modes
#define GCODE_CMD_G91_1    85   // Arc IJK Distance Modes

@interface GCodeElement : NSObject {
    BOOL _hasIValue;
    BOOL _hasJValue;
    BOOL _hasKValue;
    BOOL _hasLValue;
    BOOL _hasNValue;
    BOOL _hasPValue;
    BOOL _hasRValue;
    BOOL _hasSValue;
    BOOL _hasTValue;
    BOOL _hasXValue;
    BOOL _hasYValue;
    BOOL _hasZValue;
}

@property (assign) int type;
@property (assign) NSString* comment;
@property (nonatomic) double iValue;
@property (nonatomic) double jValue;
@property (nonatomic) double kValue;
@property (nonatomic) double lValue;
@property (nonatomic) double nValue;
@property (nonatomic) double pValue;
@property (nonatomic) double rValue;
@property (nonatomic) double sValue;
@property (nonatomic) double tValue;
@property (nonatomic) double xValue;
@property (nonatomic) double yValue;
@property (nonatomic) double zValue;
@property (nonatomic) double feedRate;
@property (nonatomic,readonly) BOOL hasXValue;
@property (nonatomic,readonly) BOOL hasYValue;
@property (nonatomic,readonly) BOOL hasZValue;

- (NSString*)toCommand;
- (double)offsetTo:(double)x :(double)y :(double)z;

@end
