//
//  GCode.h
//  CamView
//
//  Created on 22.12.15.
//

#import <Foundation/Foundation.h>
#import "GCodeElement.h"

@interface GCode : NSObject {
}

@property (assign) NSArray* elements;
@property (readonly) NSArray* boundaries;

- (void)readFromURL:(NSURL*)url;
- (void)readFromPath:(NSString*)path;
- (void)readFromString:(NSString*)string;
- (NSString*)toCommands;
- (NSString*)stringByRemovingRange:(NSString*)theString :(NSRange)theRange;

- (GCode*)shift:(float)deltaX :(float)deltaY :(float)deltaZ;
- (GCode*)rotate:(float)angle;
- (GCode*)scale:(float)factor;

@end
