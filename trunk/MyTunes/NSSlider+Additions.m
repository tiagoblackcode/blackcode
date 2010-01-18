//
//  MTSlider.m
//  MyTunes
//
//  Created by Tiago Melo on 1/13/10.
//  Copyright 2010 BlackCode. All rights reserved.
//

#import "NSSlider+Additions.h"


@implementation NSSlider (MTAdditions)



- (void)setLineColor:(NSColor*)color
{
	[[self cell] setLineColor:color];
	[self setNeedsDisplay:YES];
}

- (NSColor*)lineColor
{
	return [[self cell] lineColor];
}

@end
