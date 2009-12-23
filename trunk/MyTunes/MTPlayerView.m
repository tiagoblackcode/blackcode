//
//  MTPlayerView.m
//  MyTunes
//
//  Created by Tiago Melo on 12/17/09.
//  Copyright 2009 BlackCode. All rights reserved.
//

#import "MTPlayerView.h"

#define kFadePeriod 0.05

@implementation MTPlayerView

@synthesize cachedView;

+ (void)initialize
{
	
	[self exposeBinding:@"backgroundColor"];
	[self exposeBinding:@"minAlphaValue"];
	[self exposeBinding:@"maxAlphaValue"];
}

- (id)initWithFrame:(NSRect)frame
{
	self = [super initWithFrame:frame];
	if( self ) {
		
		trackingArea = 
		[[NSTrackingArea alloc] initWithRect:[self frame] 
									 options:(NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways | NSTrackingMouseMoved) 
									   owner:self 
									userInfo:nil];

		cachedView = nil;
		minAlphaValue = 0.0;
		maxAlphaValue = 1.0;
		alphaInc = (maxAlphaValue - minAlphaValue) * kFadePeriod;
		[self addTrackingArea:trackingArea];
		
	}
	return self;
	
}

- (void)setBackgroundColor:(NSColor *)new
{

	[new retain];
	[backgroundColor release];
	backgroundColor = new;
	[self setCachedView:nil];
	[self setNeedsDisplay:YES];
	
}

- (void)setMaxAlphaValue:(float)new
{
	maxAlphaValue = new;
	alphaInc = (maxAlphaValue - minAlphaValue) * kFadePeriod;
	[self setNeedsDisplay:YES];
}

- (void)setMinAlphaValue:(float)new
{

	minAlphaValue = new;
	alphaInc = (maxAlphaValue - minAlphaValue) * 0.05;
	[self setAlphaValue:minAlphaValue];
	[self setNeedsDisplay:YES];
}

- (NSColor*)backgroundColor { return backgroundColor; }
- (float)minAlphaValue { return minAlphaValue; }
- (float)maxAlphaValue { return maxAlphaValue; }

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
		[[backgroundColor colorWithAlphaComponent:0.5] setFill];
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
	
	NSNumber *number = [NSNumber numberWithFloat:alphaInc];
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
	
	NSNumber *number = [NSNumber numberWithFloat:-1*alphaInc];
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
	if( [self cachedView] == nil )
		[self cacheView];
	
	[cachedView drawInRect:rect fromRect:NSZeroRect operation:NSCompositeCopy fraction:[self alphaValue]];	
}



@end
