//
//  Overlay.h
//  CamView
//
//  Created on 18.08.15.
//

#import <Cocoa/Cocoa.h>


@interface Overlay : NSView {
@private
    int mCircleSize;
    
}

@property (readwrite,setter=setCircleSize:) int mCircleSize;

@end
