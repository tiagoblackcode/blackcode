//
//  MTTextView.m
//  MyTunes
//
//  Created by Tiago Melo on 12/17/09.
//  Copyright 2009 BlackCode. All rights reserved.
//

#import "MTTranslucentButtonView.h"


@implementation MTTranslucentButtonView

- (id)initWithFrame:(NSRect)frame
{
	self = [super initWithFrame:frame];
	if( self ) {
		
	}
	return self;
}

- (void)drawRect:(NSRect)rect
{
	NSImage *button = [[NSImage alloc] initWithSize:rect.size];
	[button lockFocus];
	[super drawRect:rect];
	[button unlockFocus];
	[button drawInRect:rect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:[self alphaValue]];
	[button release];
	[[self superview] setNeedsDisplay:YES];
	//[[self superview] drawRect:[self frame]];
}

@end
