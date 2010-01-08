//
//  MTPlayerView.m
//  MyTunes
//
//  Created by Tiago Melo on 12/17/09.
//  Copyright 2009 BlackCode. All rights reserved.
//

#import "MTHUDView.h"

@implementation MTHUDView

@synthesize cachedView;
@synthesize controller;



- (id)initWithFrame:(NSRect)frame
{
	self = [super initWithFrame:frame];
	if( self ) {
		backgroundColor = [NSColor blackColor];
		strokeColor = [NSColor whiteColor];
		[self updateTrackingAreas];		
	}
	return self;
	
}

#pragma mark Setters and Getters

- (void)setBackgroundColor:(NSColor *)new
{
//	NSLog(@"setBackgroundColor:");
	[new retain];
	[backgroundColor release];
	backgroundColor = new;
	[self setCachedView:nil];
	
}

- (void)setStrokeColor:(NSColor *)color
{
	[color retain];
	[strokeColor release];
	strokeColor = color;
	[self setCachedView:nil];
}

- (NSColor*)strokeColor { return strokeColor; }
- (NSColor*)backgroundColor { return backgroundColor; }


#pragma mark Event Handling

- (void)updateTrackingAreas
{
	[super updateTrackingAreas];
	[self removeTrackingArea:trackingArea];
	[trackingArea release];
	trackingArea = 
	[[NSTrackingArea alloc] initWithRect:[self frame] 
								 options:(NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways | NSTrackingAssumeInside) 
								   owner:self 
								userInfo:nil];
	[self addTrackingArea:trackingArea];
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



#pragma mark Drawing

- (void)cacheView
{
	NSRect frame = [self frame];
	frame.origin.x = 0;
	frame.origin.y = 0;
	
	[cachedView release];
	cachedView = [[NSImage alloc] initWithSize:frame.size];
	[cachedView lockFocus];
	[strokeColor setStroke];
	[[backgroundColor colorWithAlphaComponent:0.5] setFill];
	NSBezierPath *path = [[NSBezierPath alloc] init];	
	
	[path appendBezierPathWithRoundedRect:frame xRadius:10 yRadius:10];
	[path fill];
	[path stroke];
	[path release];
	[cachedView unlockFocus];
}

- (void)drawRect:(NSRect)rect
{
	//[super drawRect:rect];
	if( [self cachedView] == nil )
		[self cacheView];
	
	[cachedView drawInRect:rect fromRect:NSZeroRect operation:NSCompositeCopy fraction:[self alphaValue]];	
	[[self window] invalidateShadow];
}



@end
