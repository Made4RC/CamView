//
//  Overlay.m
//  CamView
//
//  Created on 18.08.15.
//

#import "Overlay.h"


@implementation Overlay
- (int)mCircleSize {
    return mCircleSize;
}
- (void)setCircleSize:(int)size {
	mCircleSize = size;
	[self setNeedsDisplay:YES];
}

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        [self setCircleSize:20];
    }
    
    return self;
}

- (void)dealloc {
    [super dealloc];
}

- (void)drawRect:(NSRect)dirtyRect {
    // Drawing code here.
	NSRect screenRect = [self frame];
    NSBezierPath* path = [NSBezierPath bezierPath];
    
    [path removeAllPoints];
    [path moveToPoint:NSMakePoint(screenRect.size.width/2, 0)];
    [path lineToPoint:NSMakePoint(screenRect.size.width/2, screenRect.size.height)];
    [path moveToPoint:NSMakePoint(0, screenRect.size.height/2)];
    [path lineToPoint:NSMakePoint(screenRect.size.width, screenRect.size.height/2)];
    [path appendBezierPathWithOvalInRect:NSMakeRect(screenRect.size.width/2-mCircleSize/2, screenRect.size.height/2-mCircleSize/2, mCircleSize, mCircleSize)];
    [[NSColor greenColor] set];
    [path setLineWidth:1.0];
    [path stroke];    
}

@end
