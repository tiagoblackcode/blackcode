//
//  MTPlayerView.m
//  MyTunes
//
//  Created by Tiago Melo on 12/17/09.
//  Copyright 2009 BlackCode. All rights reserved.
//

#import "MTPlayerView.h"

float kTrackingAreaPadding = 5.0;

@implementation MTPlayerView

- (id)initWithFrame:(NSRect)frame
{
	self = [super initWithFrame:frame];
	if( self ) {
		
		trackingArea = 
		[[NSTrackingArea alloc] initWithRect:[self frame] 
									 options:(NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways | NSTrackingMouseMoved) 
									   owner:self 
									userInfo:nil];
		minAlphaValue = 0.0;
		maxAlphaValue = 1.0;
		[self cacheView];
		[self setAlphaValue:minAlphaValue];
		[self addTrackingArea:trackingArea];
	}
	return self;
	
}

- (void)updateTrackingAreas
{
	[super updateTrackingAreas];
	NSLog(@"updateTrackingAreas");
	[self removeTrackingArea:trackingArea];
	[trackingArea release];
	trackingArea = 
	[[NSTrackingArea alloc] initWithRect:[self frame] 
								 options:(NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways | NSTrackingMouseMoved) 
								   owner:self 
								userInfo:nil];
	[self addTrackingArea:trackingArea];
}




- (void)orderOut:(id)sender
{
	[[self window] orderOut:sender];
	NSLog(@"orderOut:");
	
}

- (void)rightMouseDown:(NSEvent *)theEvent
{
	NSLog(@"rightMouseDown:");
}


- (void)mouseEntered:(NSEvent *)event
{
	[self fadeIn];		
}


- (void)mouseExited:(NSEvent *)event
{
	[self fadeOut];
}

- (void)cacheView
{
	NSRect frame = [self frame];
	frame.origin.x = 0;
	frame.origin.y = 0;
	
	[cachedView release];
	cachedView = [[NSImage alloc] initWithSize:frame.size];
	[cachedView lockFocus];
		[[NSColor whiteColor] setStroke];
		[[[NSColor blackColor] colorWithAlphaComponent:0.5] setFill];
		NSBezierPath *path = [[NSBezierPath alloc] init];	

		[path appendBezierPathWithRoundedRect:frame xRadius:10 yRadius:10];
		[path fill];
		[path stroke];
		[path release];
	[cachedView unlockFocus];
}

- (void)fadeIn
{
	if( [self alphaValue] >= maxAlphaValue)
		return;
	
	NSNumber *number = [NSNumber numberWithFloat:0.05];
	[fadeTimer invalidate];
	fadeTimer = [NSTimer scheduledTimerWithTimeInterval:0.010 
												 target:self 
											   selector:@selector(fadeTimer:) 
											   userInfo:number repeats:YES];
}

- (void)fadeOut
{
	if( [self alphaValue] <= minAlphaValue )
		return;
	
	NSNumber *number = [NSNumber numberWithFloat:-0.05];
	[fadeTimer invalidate];
	fadeTimer = [NSTimer scheduledTimerWithTimeInterval:0.010 
												 target:self 
											   selector:@selector(fadeTimer:) 
											   userInfo:number repeats:YES];
}

- (void)fadeTimer:(NSTimer*)timer
{
	[self setAlphaValue:[self alphaValue]+[[timer userInfo] floatValue]];
	[self setNeedsDisplay:YES];
	
	if( [self alphaValue] >= maxAlphaValue ) {
		[self setAlphaValue:maxAlphaValue];
		[fadeTimer invalidate];
		fadeTimer = nil;
	}
	
	if( [self alphaValue] <= minAlphaValue ) {
		[self setAlphaValue:minAlphaValue];
		[fadeTimer invalidate];
		fadeTimer = nil;
	}
	
}


- (void)drawRect:(NSRect)rect
{
	//[super drawRect:rect];
	[cachedView drawInRect:rect fromRect:NSZeroRect operation:NSCompositeCopy fraction:[self alphaValue]];	
}



@end
