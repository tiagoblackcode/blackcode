//
//  MTSliderCell.m
//  MyTunes
//
//  Created by Tiago Melo on 1/13/10.
//  Copyright 2010 BlackCode. All rights reserved.
//

#import "MTSliderCell.h"


@implementation MTSliderCell

- (BOOL)_usesCustomTrackImage {
	return YES;
}

- (void)drawBarInside:(NSRect)aRect flipped:(BOOL)flipped
{

	NSBezierPath *path = [NSBezierPath bezierPath];
	[lineColor setStroke];
	[path setLineWidth:2];
	[path setLineCapStyle:NSRoundLineCapStyle];
	[path moveToPoint:NSMakePoint(NSMinX(aRect)+2, NSMidY(aRect))];
	[path lineToPoint:NSMakePoint(NSMaxX(aRect)-4, NSMidY(aRect))];
	[path stroke];
	
}

- (void)drawKnob:(NSRect)knobRect
{

	[lineColor set];
	
	NSRect rect = NSMakeRect(NSMidX(knobRect)-3, NSMidY(knobRect)-5, 6, 10);
	
	NSBezierPath *path = [NSBezierPath bezierPath];
	[path setLineWidth:1];
	[path moveToPoint:NSMakePoint(NSMinX(rect), NSMidY(rect))];
	[path lineToPoint:NSMakePoint(NSMidX(rect), NSMaxY(rect))];
	[path lineToPoint:NSMakePoint(NSMaxX(rect), NSMidY(rect))];
	[path lineToPoint:NSMakePoint(NSMidX(rect), NSMinY(rect))];
	[path closePath];
	[path stroke];
	[path fill];
	
}


- (void)setLineColor:(NSColor*)color
{
	[color retain];
	[lineColor release];
	lineColor = color;
}


@end
