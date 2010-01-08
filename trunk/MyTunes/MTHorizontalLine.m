//
//  MTHorizontalLine.m
//  MyTunes
//
//  Created by Tiago Melo on 12/19/09.
//  Copyright 2009 BlackCode. All rights reserved.
//

#import "MTHorizontalLine.h"


@implementation MTHorizontalLine



+ (void)initialize
{
	[self exposeBinding:@"lineColor"];
	
}

- (void)setLineColor:(NSColor *)new
{
	[new retain];
	[lineColor release];
	lineColor = new;
	[self setNeedsDisplay:YES];
}

- (NSColor*)lineColor
{
	return lineColor;
}
	

- (void)drawRect:(NSRect)dirtyRect
{
	NSBezierPath *path = [NSBezierPath bezierPath];
	[lineColor setStroke];
	[path setLineWidth:2.0];
	[path setLineCapStyle:NSRoundLineCapStyle];
	[path moveToPoint:NSMakePoint(NSMinX(dirtyRect), NSMaxY(dirtyRect))];
	[path lineToPoint:NSMakePoint(NSMaxX(dirtyRect), NSMaxY(dirtyRect))];
	[path stroke];
}

- (void)drawDiamond:(NSRect)diamondRect
{
	[[NSColor whiteColor] set];
	NSRectFill(diamondRect);

}

- (void)mouseDown:(NSEvent *)theEvent
{
	
}

@end
