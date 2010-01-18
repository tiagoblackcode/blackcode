//
//  MTHorizontalLine.m
//  MyTunes
//
//  Created by Tiago Melo on 12/19/09.
//  Copyright 2009 BlackCode. All rights reserved.
//

#import "MTHorizontalLine.h"


@implementation MTHorizontalLine


@synthesize minValue;
@synthesize maxValue;

+ (void)initialize
{
	[self exposeBinding:@"lineColor"];
	
}

- (id)initWithFrame:(NSRect)frameRect
{

	self = [super initWithFrame:frameRect];
	if( self ) {
		minValue = 0.0;
		maxValue = 1.0;
	}
	return self;
	
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
	[path setLineWidth:1.5];
	[path setLineCapStyle:NSRoundLineCapStyle];
	[path moveToPoint:NSMakePoint(NSMinX(dirtyRect), NSMidY(dirtyRect))];
	[path lineToPoint:NSMakePoint(NSMaxX(dirtyRect), NSMidY(dirtyRect))];
	[path stroke];
		
	
}

- (void)mouseDown:(NSEvent *)theEvent
{
	
}

@end
