//
//  MTSlider.h
//  MyTunes
//
//  Created by Tiago Melo on 1/13/10.
//  Copyright 2010 BlackCode. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface NSSlider (MTAdditions)

- (void)setLineColor:(NSColor*)newColor;
- (NSColor*)lineColor;

@end
