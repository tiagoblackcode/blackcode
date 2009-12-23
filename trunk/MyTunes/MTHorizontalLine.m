//
//  MTHorizontalLine.m
//  MyTunes
//
//  Created by Tiago Melo on 12/19/09.
//  Copyright 2009 BlackCode. All rights reserved.
//

#import "MTHorizontalLine.h"


@implementation MTHorizontalLine

- (void)drawRect:(NSRect)dirtyRect
{
	NSBezierPath *path = [NSBezierPath bezierPath];
	[[NSColor whiteColor] setStroke];
	[path setLineWidth:3.0];
	[path setLineCapStyle:NSRoundLineCapStyle];
	[path moveToPoint:NSMakePoint(NSMinX(dirtyRect), NSMaxY(dirtyRect))];
	[path lineToPoint:NSMakePoint(NSMaxX(dirtyRect), NSMaxY(dirtyRect))];
	[path stroke];
}

@end
