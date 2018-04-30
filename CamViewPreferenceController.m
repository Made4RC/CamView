//
//  CamViewPreferenceController.m
//  CamView
//
//  Created on 02.04.17.
//

#import "CamViewPreferenceController.h"

@implementation CamViewPreferenceController

- (void)awakeFromNib {
    // -155,3
    [mCameraOffsetX setFloatValue:[[[NSUserDefaults standardUserDefaults] objectForKey:@"CameraOffsetX"] floatValue]];
    // -0.1
    [mCameraOffsetY setFloatValue:[[[NSUserDefaults standardUserDefaults] objectForKey:@"CameraOffsetY"] floatValue]];
}
// Handle window closing notifications for your device input
- (void)windowWillClose:(NSNotification *)notification {
}
// Handle deallocation of memory for your objects
- (void)dealloc {
    [super dealloc];
}

- (IBAction)close:(id)sender {
    [mWindow close];
}

- (void)controlTextDidChange:(NSNotification *)notification {
    NSTextField *textField = [notification object];
    if ([notification object] == mCameraOffsetX) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithFloat:[textField floatValue]] forKey:@"CameraOffsetX"];
    } else if ([notification object] == mCameraOffsetY) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithFloat:[textField floatValue]] forKey:@"CameraOffsetY"];
    }
}
@end
