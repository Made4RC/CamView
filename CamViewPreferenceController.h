//
//  CamViewPreferenceController.h
//  CamView
//
//  Created on 02.04.17.
//

#import <Foundation/Foundation.h>

@interface CamViewPreferenceController : NSObject {

    IBOutlet NSWindow* mWindow;
    
    IBOutlet NSTextField* mCameraOffsetX;
    IBOutlet NSTextField* mCameraOffsetY;

}

- (IBAction)close:(id)sender;

@end
