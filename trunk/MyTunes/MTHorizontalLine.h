//
//  MTHorizontalLine.h
//  MyTunes
//
//  Created by Tiago Melo on 12/19/09.
//  Copyright 2009 BlackCode. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface MTHorizontalLine : NSBox {
	
	NSColor *lineColor;
	
	float minValue;
	float maxValue;

}


@property (assign) float minValue;
@property (assign) float maxValue;

- (void)setLineColor:(NSColor *)newColor;
- (NSColor*)lineColor;

@end
