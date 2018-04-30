//
//  GRBLProtocol.h
//  CamView
//
//  Created on 20.12.15.
//

#import <Foundation/Foundation.h>
// import IOKit headers
#include <IOKit/IOKitLib.h>
#include <IOKit/serial/IOSerialKeys.h>
#include <IOKit/IOBSD.h>
#include <IOKit/serial/ioss.h>
#include <sys/ioctl.h>

#define STATUS_MESSAGE_INFO          0
#define STATUS_MESSAGE_WARNING       1
#define STATUS_MESSAGE_ERROR         2

#define GRBL_STATE_NO_CONNECTION    -1
#define GRBL_STATE_IDLE              0
#define GRBL_STATE_RUN               1
#define GRBL_STATE_HOLD              2
#define GRBL_STATE_JOG               3
#define GRBL_STATE_ALARM             4
#define GRBL_STATE_DOOR              5
#define GRBL_STATE_CHECK             6
#define GRBL_STATE_HOME              7
#define GRBL_STATE_SLEEP             8

#define GRBL_CONFIG_STEP_PULSE                  0
#define GRBL_CONFIG_STEP_IDLE_DELAY             1
#define GRBL_CONFIG_STEP_PORT_INVERT_MASK       2
#define GRBL_CONFIG_DIRECTION_PORT_INVERT_MASK  3
#define GRBL_CONFIG_STEP_ENABLE_INVERT          4
#define GRBL_CONFIG_LIMIT_PINS_INVERT           5
#define GRBL_CONFIG_PROBE_PIN_INVERT            6
#define GRBL_CONFIG_STATUS_REPORT              10
#define GRBL_CONFIG_JUNCTION_DEVIATION          11
#define GRBL_CONFIG_ARC_TOLERANCE               12
#define GRBL_CONFIG_REPORT_INCHES               13
#define GRBL_CONFIG_SOFT_LIMITS                 20
#define GRBL_CONFIG_HARD_LIMITS                 21
#define GRBL_CONFIG_HOMING_CYCLE                22
#define GRBL_CONFIG_HOMING_DIR_INVERT_MASK      23
#define GRBL_CONFIG_HOMING_FEED                 24
#define GRBL_CONFIG_HOMING_SEEK                 25
#define GRBL_CONFIG_HOMING_DEBOUNCE             26
#define GRBL_CONFIG_HOMING_PULL_OFF             27
#define GRBL_CONDIG_MAX_SPINDLE_RPM             30
#define GRBL_CONDIG_MIN_SPINDLE_RPM             31
#define GRBL_CONDIG_LASER_MODE                  32
#define GRBL_CONFIG_X_STEPS_PER_MM              100
#define GRBL_CONFIG_Y_STEPS_PER_MM              101
#define GRBL_CONFIG_Z_STEPS_PER_MM              102
#define GRBL_CONFIG_X_MAX_RATE                  110
#define GRBL_CONFIG_Y_MAX_RATE                  111
#define GRBL_CONFIG_Z_MAX_RATE                  112
#define GRBL_CONFIG_X_ACCELERATION              120
#define GRBL_CONFIG_Y_ACCELERATION              121
#define GRBL_CONFIG_Z_ACCELERATION              122
#define GRBL_CONFIG_X_MAX_TRAVEL                130
#define GRBL_CONFIG_Y_MAX_TRAVEL                131
#define GRBL_CONFIG_Z_MAX_TRAVEL                132

typedef enum
{
    StatusMachinePosition   = 1 << 0,
    StatusWorkPosition      = 1 << 1,
    StatusPlannerBuffer     = 1 << 2,
    StatusRXBuffer          = 1 << 3,
    StatusLimitPins         = 1 << 4
} StatusReports;

typedef enum
{
    InvertX = 1 << 0,
    InvertY = 1 << 1,
    InvertZ = 1 << 2
} InvertMask;

@interface GRBLProtocol : NSObject {

    int _serialFileDescriptor; // file handle to the serial port
    struct termios _gOriginalTTYAttrs; // Hold the original termios attributes so we can reset them on quit ( best practice )
    NSTimer *_responseTimer;
    NSThread *_readThread;
    BOOL exitReadThread;
    NSMutableArray *sentCommands;
    id delegate;

    NSString* _version;
    BOOL _xLimit;   // X limit switch toggled
    BOOL _yLimit;   // Y limit switch toggled
    BOOL _zLimit;   // Z limit switch toggled
    float _machineCoordinateX;
    float _machineCoordinateY;
    float _machineCoordinateZ;
    float _workCoordinateX;
    float _workCoordinateY;
    float _workCoordinateZ;
    float _workCoordinateOffsetX;
    float _workCoordinateOffsetY;
    float _workCoordinateOffsetZ;
    int _feed;
    int _spindle;
    
    NSMutableDictionary* _configuration;
}

// ##########################################################################
#pragma mark General
// ##########################################################################
@property (readonly) BOOL isConnected;
@property (readonly) int state;
@property (readonly) int subState;
@property (readonly) NSString* version;
@property (readonly) BOOL xLimitReached;
@property (readonly) BOOL yLimitReached;
@property (readonly) BOOL zLimitReached;
@property (readonly) NSString* machineCoordinateX;
@property (readonly) NSString* machineCoordinateY;
@property (readonly) NSString* machineCoordinateZ;
@property (readonly) NSString* workCoordinateX;
@property (readonly) NSString* workCoordinateY;
@property (readonly) NSString* workCoordinateZ;
@property (readonly) int feedRate;
@property (nonatomic, assign) NSMutableDictionary* configuration;

- (void)setDelegate:(id)delegate;

// ##########################################################################
#pragma mark Connection
// ##########################################################################
- (NSString*)connect:(NSString*)toPath :(speed_t)withBaudRate;
- (void)disconnect;


// ##########################################################################
#pragma mark Sending
// ##########################################################################
- (void)writeString: (NSString *) str;
- (void)writeByte: (uint8_t *) val;
- (void)sendCommand:(NSString*)command;
- (void)sendCommands:(NSArray*)commands;
- (void)reqeustStatus:(NSTimer *)timer;
- (void)senderThread:(NSArray *)commands;
- (int)sentCommandsQueueLength;
- (void)sendProgressToDelegate:(NSNumber*)percent;


// ##########################################################################
#pragma mark Recieving
// ##########################################################################
- (void)recieverThread:(NSThread *)parentThread;
- (void)parseResponse:(NSString*)response;


// ##########################################################################
#pragma mark Testing
// ##########################################################################
- (void)testCommand:(NSString*)command;
- (void)testCommands:(NSArray*)commands;

@end
