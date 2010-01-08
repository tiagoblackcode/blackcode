//
//  MTStarView.m
//  MyTunes
//
//  Created by Tiago Melo on 12/23/09.
//  Copyright 2009 BlackCode. All rights reserved.
//

#import "MTStarView.h"

const float kStarPadding = 10.0;
NSString* const kDotImageFilename = @"ratingDot.png";
NSString* const kStartImageFilename = @"ratingStar.png";

@implementation MTStarView


+ (void)initialize
{
	[self exposeBinding:@"fillColor"];
	[self exposeBinding:@"rating"];
}

@synthesize colorLayer;
@synthesize cachedView;


- (id)initWithFrame:(NSRect)frame
{
	self = [super initWithFrame:frame];
	if( self ) {
		
		colorLayer = nil;
		cachedView = nil;
		trackingArea = nil;
		[self updateTrackingAreas];
		fillColor = [NSColor whiteColor];
		dot = [[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForImageResource:kDotImageFilename]];
		star = [[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForImageResource:kStartImageFilename]];
		rating = 2;
		
	}
	return self;
}

- (void)updateTrackingAreas
{
	NSLog(@"updateTrackingAreas");
	[super updateTrackingAreas];
	[self removeTrackingArea:trackingArea];
	[trackingArea release];
	trackingArea = [[NSTrackingArea alloc] initWithRect:NSMakeRect(0, 0, [self frame].size.width, [self frame].size.height) 
												options:(NSTrackingActiveAlways | NSTrackingMouseEnteredAndExited | NSTrackingMouseMoved) 
												  owner:self userInfo:nil];
	[self addTrackingArea:trackingArea];
	

}




#pragma mark Getters and Setters

- (void)setFillColor:(NSColor*)new
{
	[new retain];
	[fillColor release];
	fillColor = new;
	[self setColorLayer:nil];
	[[self superview] setNeedsDisplay:YES];
	[self setNeedsDisplay:YES];
}

- (NSColor*)fillColor
{
	return fillColor;
}

- (int)rating 
{ 
	return rating; 
}

- (void)setRating:(int)new {

	[self willChangeValueForKey:@"rating"];
	rating = new;
	[self setDisplayRating:rating];
	[self didChangeValueForKey:@"rating"];

}

- (int)displayRating
{
	return displayRating;
}

- (void)setDisplayRating:(int)new
{
	if( new != displayRating ) {
		displayRating = new;
		[self setCachedView:nil];
		[[self superview] setNeedsDisplay:YES];
		[self setNeedsDisplay:YES];
	}
}

- (void)mouseUp:(NSEvent *)theEvent
{
	[self setRating:[self displayRating]];
}

- (void)mouseDown:(NSEvent *)theEvent
{
	
}


- (void)mouseDragged:(NSEvent *)theEvent
{
	[self setDisplayRating:[self hitTestRating:theEvent]];
}

- (void)mouseEntered:(NSEvent *)theEvent
{
	[self setDisplayRating:[self hitTestRating:theEvent]];
	
}

- (void)mouseMoved:(NSEvent *)theEvent
{
	[self setDisplayRating:[self hitTestRating:theEvent]];
}

- (void)mouseExited:(NSEvent *)theEvent
{
	[self setDisplayRating:[self rating]];	
}


- (BOOL)mouseDownCanMoveWindow
{
	return NO;
}

- (int)hitTestRating:(NSEvent*)theEvent
{
	NSPoint localPoint = [self convertPoint:[theEvent locationInWindow] fromView:nil];
	NSSize blockSize = NSMakeSize( [self frame].size.width/5, [self frame].size.height ); 
	NSRect starRect = NSZeroRect;
	starRect.size = blockSize;

	int i;
	for( i=1; i<=5 && ![self mouse:localPoint inRect:starRect] ; i++ ) {
		starRect.origin.x += blockSize.width;
	}
	
	return i%6;
	
}

#pragma mark Caching

- (void)cacheView
{
	
	int interval = 5;
	NSSize blockSize = NSMakeSize( [self frame].size.width/interval, [self frame].size.height ); 
	
	[cachedView release];
	cachedView = [[NSImage alloc] initWithSize:[self frame].size];
	[cachedView lockFocus];
	
	NSRect frameRect = NSZeroRect;
	frameRect.size = [self frame].size;
	
	NSPoint drawPoint = NSMakePoint( 0, [self frame].size.height/2 - [star size].height/2 );
	int i;
	for( i=0; i<displayRating; i++ ) {
		[star drawAtPoint:drawPoint fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
		drawPoint.x += blockSize.width;
	}
	for( i; i<interval; i++ ) {
		[dot drawAtPoint:drawPoint fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
		drawPoint.x += blockSize.width;
	}
	
	[cachedView unlockFocus];
	
}

- (void)cacheColorLayer
{

	[colorLayer release];
	colorLayer = [[NSImage alloc] initWithSize:[self frame].size];
	[colorLayer lockFocus];
	[fillColor setFill];
	NSRectFill(NSMakeRect(0,0,[self frame].size.width, [self frame].size.height));
	[colorLayer unlockFocus];
	
}

#pragma mark Drawing

- (void)drawRect:(NSRect)dirtyRect
{
	if( cachedView == nil )
		[self cacheView];
	if( colorLayer == nil )
		[self cacheColorLayer];
	
	NSImage *result = [[NSImage alloc] initWithSize:[self frame].size];
	[result lockFocus];	
		[cachedView drawInRect:NSMakeRect(0,0,[result size].width, [result size].height) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
		[colorLayer drawAtPoint:NSMakePoint(0,0) fromRect:NSZeroRect operation:NSCompositeSourceIn fraction:1.0];
	[result unlockFocus];
	[result drawInRect:dirtyRect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:[self alphaValue]];
	[result release];
	
}


	

@end
