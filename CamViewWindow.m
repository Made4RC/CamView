//
//  CamViewWindow.m
//  CamView
//
//  Created on 02.12.15.
//

#import "CamViewWindow.h"
#import "CamViewController.h"


@implementation CamViewWindow

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)keyDown:(NSEvent *)event {
    //NSLog(@"keyDown:%@", event);
    
    switch ([event keyCode]) {
        case 123:
            NSLog(@"left");
            break;
        case 126:
            NSLog(@"up");
            break;
        case 124:
            NSLog(@"right");
            break;
        case 125:
            NSLog(@"down");
            break;
        case 49:
            [[self windowController] writeString:@"!"];
            NSLog(@"space");
            break;
        default:
            break;
    }
    
    [super keyDown:event];
}

- (BOOL)acceptsFirstResponder {
    return YES;
}

@end
