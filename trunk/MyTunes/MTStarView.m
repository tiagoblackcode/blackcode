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

- (id)initWithFrame:(NSRect)frame
{
	self = [super initWithFrame:frame];
	if( self ) {
		
		fillColor = [NSColor whiteColor];
		dot = [[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForImageResource:kDotImageFilename]];
		star = [[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForImageResource:kStartImageFilename]];
		rating = 2;
		
	}
	return self;
}

- (void)setFillColor:(NSColor*)new
{
	[new retain];
	[fillColor release];
	fillColor = new;
}

- (NSColor*)fillColor
{
	return fillColor;
}

- (void)drawRect:(NSRect)dirtyRect
{
	int interval = 5;
	NSSize blockSize = NSMakeSize( dirtyRect.size.width/interval, dirtyRect.size.height ); 
	NSRect blockRect = dirtyRect;
	blockRect.size = blockSize;
	
	NSPoint drawPoint = NSMakePoint( 0, NSMidY(blockRect) - [star size].height/2 );
	int i;
	for( i=0; i<rating; i++ ) {
		[star drawAtPoint:drawPoint fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
		drawPoint.x += blockSize.width;
	}
	for( i; i<interval; i++ ) {
		[dot drawAtPoint:drawPoint fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
		drawPoint.x += blockSize.width;
	}
	
}

- (int)rating { return rating; }

- (void)setRating:(int)new {
	rating = new;
	[[self superview] setNeedsDisplay:YES];
	[self setNeedsDisplay:YES];
}
	

@end
