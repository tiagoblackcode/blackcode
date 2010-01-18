//
//  MTPlayerView.m
//  MyTunes
//
//  Created by Tiago Melo on 12/17/09.
//  Copyright 2009 BlackCode. All rights reserved.
//

#import "MTHUDView.h"

@implementation MTHUDView


@synthesize controller;



- (id)initWithFrame:(NSRect)frame
{
	self = [super initWithFrame:frame];
	if( self ) {
		backgroundColor = [[NSColor blackColor] retain];
		strokeColor = [[NSColor whiteColor] retain];
	}
	return self;
	
}

#pragma mark Getters and Setters

- (NSColor*)backgroundColor
{
	return backgroundColor;
}

- (NSColor*)strokeColor
{
	return strokeColor;
}

- (void)setBackgroundColor:(NSColor *)color
{	
	[color retain];
	[backgroundColor release];
	backgroundColor = color;
	[self setNeedsDisplay:YES];
}

- (void)setStrokeColor:(NSColor *)color
{
	[color retain];
	[strokeColor release];
	strokeColor = color;	
	[self setNeedsDisplay:YES];
}


#pragma mark Event Handling

- (void)updateTrackingAreas
{

	NSRect trackingFrame = [self frame];
	trackingFrame.origin = NSMakePoint(0, 0);
	
	NSUInteger trackingOpts = (NSTrackingMouseEnteredAndExited | 
							   NSTrackingActiveAlways | 
							   NSTrackingAssumeInside);
	
	
	[self removeTrackingArea:trackingArea];
	[trackingArea release];
	trackingArea = 
	[[NSTrackingArea alloc] initWithRect:trackingFrame 
								 options:trackingOpts 
								   owner:self 
								userInfo:nil];
	
	[self addTrackingArea:trackingArea];
	[super updateTrackingAreas];
}



- (void)mouseEntered:(NSEvent *)event
{
	[controller mouseEntered:event];
	[[self nextResponder] mouseExited:event];

}


- (void)mouseExited:(NSEvent *)event
{
	[controller mouseExited:event];
	[[self nextResponder] mouseExited:event];

}

- (void)mouseDown:(NSEvent *)event
{
	[controller mouseDown:event];
	[[self nextResponder] mouseDown:event];
}

- (void)mouseUp:(NSEvent *)event
{
	[controller mouseUp:event];
	[[self nextResponder] mouseUp:event];
}

- (void)rightMouseDown:(NSEvent *)event
{
	[controller rightMouseDown:event];
	[[self nextResponder] rightMouseDown:event];
}

- (void)rightMouseUp:(NSEvent *)event
{
	[controller rightMouseUp:event];
	[[self nextResponder] rightMouseUp:event];
}





#pragma mark Drawing

- (void)drawRect:(NSRect)rect
{

	NSBezierPath *path = [[NSBezierPath alloc] init];
	[path moveToPoint:NSMakePoint(0,0)];
	[path appendBezierPathWithRoundedRect:rect xRadius:10 yRadius:10];
	
	[backgroundColor setFill];
	[strokeColor setStroke];
	[path fill];
	//[path stroke];
	
	[path release];
}



@end
