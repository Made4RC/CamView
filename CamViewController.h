//
//  CamViewController.h
//  CamView
//
//  Created on 18.08.15.
//

#import <Cocoa/Cocoa.h>
#import "Overlay.h"
#import "NoodleLineNumberView.h"
#import "NoodleLineNumberMarker.h"
#import "MarkerLineNumberView.h"
#import "GRBLProtocol.h"
#import "GCode.h"
#import "CamViewPreferenceController.h"

#define POSITION_MILLING        0
#define POSITION_CAMERA         1

@interface CamViewController : NSObject {
    GRBLProtocol* grbl;
    NSTimer *_responseTimer;
    
    // General
    IBOutlet NSWindow* mWindow;
    IBOutlet NSTabView* mTabView;
    IBOutlet NSButton* mMessageIcon;
    IBOutlet NSTextField* mMessageText;
    IBOutlet NSButton* mSoftResetButton;
    IBOutlet NSButton* mUnlockButton;
    IBOutlet NSButton* mCycleStartButton;
    IBOutlet NSButton* mFeedHoldButton;
    IBOutlet NSTextField* _machineState;
    NSTimer *_statusMessageTimer;
    
    // Control
    IBOutlet NSPopUpButton *mMachineSelect;
    IBOutlet NSButton* _refreshMachinePort;
    IBOutlet NSPopUpButton* mBaudRate;
    IBOutlet NSButton *mMachineConnectionControl;
    IBOutlet NSPopUpButton *mCameraSelect;
    IBOutlet NSButton *mCameraConnectionControl;
    IBOutlet NSButton *mLockConnectButton;
    IBOutlet NSTextView *serialOutputArea;
    IBOutlet NSTextField* _configStepPulse;
    IBOutlet NSTextField* _configStepIdleDelay;
    IBOutlet NSSegmentedControl* _configStepPortInvertMask;
    IBOutlet NSSegmentedControl* _configDirectionPortInvertMask;
    IBOutlet NSButton* _configStepEnableInvert;
    IBOutlet NSButton* _configLimitPinsInvert;
    IBOutlet NSButton* _configPobePinInvert;
    IBOutlet NSSegmentedControl* _configStatusReport;
    IBOutlet NSTextField* _configJunctionDeviation;
    IBOutlet NSTextField* _configArcTolerance;
    IBOutlet NSButton* _configReportInches;
    IBOutlet NSButton* _configSoftLimits;
    IBOutlet NSButton* _configHardLimits;
    IBOutlet NSButton* _configHomingCycle;
    IBOutlet NSSegmentedControl* _configHomingDirInvertMask;
    IBOutlet NSTextField* _configHomingFeed;
    IBOutlet NSTextField* _configHomingSeek;
    IBOutlet NSTextField* _configHomingDebounce;
    IBOutlet NSTextField* _configHomingPullOff;
    IBOutlet NSTextField* _configMaxSpindleRPM;
    IBOutlet NSTextField* _configMinSpindleRPM;
    IBOutlet NSButton* _configLaserMode;
    IBOutlet NSTextField* _configXStepsPerMM;
    IBOutlet NSTextField* _configYStepsPerMM;
    IBOutlet NSTextField* _configZStepsPerMM;
    IBOutlet NSTextField* _configXMaXRate;
    IBOutlet NSTextField* _configYMaXRate;
    IBOutlet NSTextField* _configZMaXRate;
    IBOutlet NSTextField* _configXAcceleration;
    IBOutlet NSTextField* _configYAcceleration;
    IBOutlet NSTextField* _configZAcceleration;
    IBOutlet NSTextField* _configXMaxTravel;
    IBOutlet NSTextField* _configYMaxTravel;
    IBOutlet NSTextField* _configZMaxTravel;
    IBOutlet NSTextField* _configXYPependicularityCompensation;
    IBOutlet NSButton* _configRevertButton;
    
    // Jog
    IBOutlet Overlay *mOverlayView;
    IBOutlet NSSlider *mCircleSlider;
    IBOutlet NSButton *mLocationButton;
    IBOutlet NSButton *mHomingButton;
    IBOutlet NSButton *mCopyMaschinePosButton;
    IBOutlet NSButton *mP1Button;
    IBOutlet NSButton *mP2Button;
    IBOutlet NSButton *mXLimitReached;
    IBOutlet NSButton *mYLimitReached;
    IBOutlet NSButton *mZLimitReached;
    IBOutlet NSTextField* _machineCoordinateX1;
    IBOutlet NSTextField* _machineCoordinateY1;
    IBOutlet NSTextField* _machineCoordinateZ1;
    IBOutlet NSTextField* _workCoordinateX1;
    IBOutlet NSTextField* _workCoordinateY1;
    IBOutlet NSTextField* _workCoordinateZ1;
    IBOutlet NSButton *mZeroXButton;
    IBOutlet NSButton *mLockZeroXYButton;
    IBOutlet NSButton *mZeroYButton;
    IBOutlet NSButton *mZeroZButton;
    IBOutlet NSButton *mZeroAllButton;
    IBOutlet NSButton *mStepPlusXButton;
    IBOutlet NSButton *mStepPlusXMinuxYButton;
    IBOutlet NSButton *mStepMinusYButton;
    IBOutlet NSButton *mStepMinusXMinusYButton;
    IBOutlet NSButton *mStepMinusXButton;
    IBOutlet NSButton *mStepMinusXPlusYButton;
    IBOutlet NSButton *mStepPlusYButton;
    IBOutlet NSButton *mStepPlusXPlusYButton;
    IBOutlet NSButton *mStepMinusZButton;
    IBOutlet NSButton *mStepPlusZButton;
    IBOutlet NSButton *mZGotoX0Button;
    IBOutlet NSButton *mLockGotoX0Y0Button;
    IBOutlet NSButton *mZGotoY0Button;
    IBOutlet NSButton *mZGotoZ0Button;
    IBOutlet NSPopUpButton *mStepWidth;
    IBOutlet NSComboBox *mCustomCommand;
    IBOutlet NSSegmentedControl* mStepWithButton;
    int currentPosition;
    BOOL _lastJogWasMinusZ;
    BOOL wasCustomCommand;
    
    // Work
    IBOutlet NSView *mParentView;
    IBOutlet QTCaptureView *mCaptureView;
    IBOutlet NSTextField *mNCDataFileName;
    IBOutlet NSTextView *mNCData;
    IBOutlet NSTextField *_gcodeInformationXDimensions;
    IBOutlet NSTextField *_gcodeInformationYDimensions;
    IBOutlet NSTextField *_gcodeInformationZDimensions;
    IBOutlet NSTextField* _machineCoordinateX2;
    IBOutlet NSTextField* _machineCoordinateY2;
    IBOutlet NSTextField* _machineCoordinateZ2;
    IBOutlet NSTextField* _workCoordinateX2;
    IBOutlet NSTextField* _workCoordinateY2;
    IBOutlet NSTextField* _workCoordinateZ2;
    IBOutlet NSTextField* _feedRate;
    IBOutlet NSButton *mSendGCode;
    IBOutlet NSScrollView *scrollView;
    NoodleLineNumberView *lineNumberView;
    BOOL isChecking;
    IBOutlet NSTextField* _gcodeModifiyShiftX;
    IBOutlet NSTextField* _gcodeModifiyShiftY;
    IBOutlet NSTextField* _gcodeModifiyShiftZ;
    IBOutlet NSTextField* _gcodeModifiyAngle;
    IBOutlet NSTextField* _gcodeModifiyScale;
    IBOutlet NSProgressIndicator* _sendingProgress;
    
    IBOutlet id textview;
    IBOutlet id window;
    
    QTCaptureSession            *mCaptureSession;
    QTCaptureMovieFileOutput    *mCaptureMovieFileOutput;
    QTCaptureDeviceInput        *mCaptureVideoDeviceInput;
    QTCaptureDeviceInput        *mCaptureAudioDeviceInput;
}

// ##########################################################################
#pragma mark General
// ##########################################################################
- (IBAction)mMenuSwitchPanelClicked:(id)sender;
- (void)setStatusMessage:(int)type :(NSString*)message;
- (void)setStatusMessage2:(NSDictionary*)dict;
- (void)clearStatusMessage:(NSTimer *)timer;
- (IBAction)mPreferencesClicked:(id)sender;
- (IBAction)mSoftResetClicked:(id)sender;
- (IBAction)mUnlockClicked:(id)sender;
- (IBAction)mFeedHoldClicked:(id)sender;
- (IBAction)mCycleStartClicked:(id)sender;


// ##########################################################################
#pragma mark Control
// ##########################################################################
- (void)refreshMachinePortList: (NSString *) selectedText;
- (IBAction)mRefreshMachinePortClicked:(id)sender;
- (IBAction)mMachineSelectChangend:(id)sender;
- (IBAction)mBaudRateChanged:(id)sender;
- (IBAction)mMachineConnectClicked:(id)sender;
- (IBAction)lockConnectButtonClicked:(id)sender;
- (void)appendToCommunicationProtocol:(NSDictionary*)dict;
- (void)setConfigurationParameter:(NSString*)key :(NSString*)value;
- (void)refreshCameraList:(NSString*)selectedText;
- (IBAction)mCameraSelectChangend:(id)sender;
- (IBAction)mRefreshCameraListClicked:(id)sender;
- (IBAction)mCameraConnectClicked:(id)sender;
- (void)tabView:(NSTabView *)tabView willSelectTabViewItem:(NSTabViewItem *)tabViewItem;
- (IBAction)restoreConfigurationDefaults:(id)sender;
- (IBAction)saveConfiguration:(id)sender;

// ##########################################################################
#pragma mark Jog
// ##########################################################################
- (IBAction)mCircleSliderChanged:(id)sender;
- (IBAction)mLocationButtonClicked:(id)sender;
- (IBAction)mHomingButtonClicked:(id)sender;
- (IBAction)mCopyMaschinePosButtonClicked:(id)sender;
- (IBAction)mP1ButtonClicked:(id)sender;
- (IBAction)mP2ButtonClicked:(id)sender;
- (IBAction)mZeroXClicked:(id)sender;
- (IBAction)mZeroYClicked:(id)sender;
- (IBAction)mZeroZClicked:(id)sender;
- (IBAction)mZeroAllClicked:(id)sender;
- (IBAction)lockZeroXYButtonClicked:(id)sender;
- (IBAction)mGotoX0Clicked:(id)sender;
- (IBAction)mGotoY0Clicked:(id)sender;
- (IBAction)mGotoZ0Clicked:(id)sender;
- (IBAction)lockGotoX0Y0ButtonClicked:(id)sender;
- (IBAction)mStepWidthClicked:(id)sender;
- (IBAction)mStepWidthButtonClicked:(id)sender;
- (IBAction)mStepClicked:(id)sender;


// ##########################################################################
#pragma mark Work
// ##########################################################################
- (IBAction)openNCFile:(id)sender;
- (IBAction)mSendGCodeClicked:(id)sender;
- (IBAction)mChangeFeedRateClicked:(id)sender;
- (void)highlightGCode;
- (void)setSendingProgess:(NSNumber*)percent;
- (void)processGCodeFile;

@end
