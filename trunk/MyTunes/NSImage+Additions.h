//
//  NSImage+Additions.h
//  MyTunes
//
//  Created by Tiago Melo on 12/18/09.
//  Copyright 2009 BlackCode. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface NSImage (Additions)

+(NSImage*)reflectedImage:(NSImage*)source amountReflected:(float)fraction;
+(NSImage*)imageWithReflection:(NSImage*)source amountReflected:(float)fraction;
-(void)composeImageWithTransitionFrom:(NSImage*)from to:(NSImage*)to ratio:(float)ratio;
@end
