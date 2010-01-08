//
//  MTHorizontalLine.h
//  MyTunes
//
//  Created by Tiago Melo on 12/19/09.
//  Copyright 2009 BlackCode. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface MTHorizontalLine : NSControl {
	
	NSColor *lineColor;

}

- (void)setLineColor:(NSColor *)newColor;
- (NSColor*)lineColor;

@end
