//
//  MTPlayerWindow.m
//  MyTunes
//
//  Created by Tiago Melo on 12/17/09.
//  Copyright 2009 BlackCode. All rights reserved.
//

#import "MTPlayerWindow.h"

@implementation MTPlayerWindow

@synthesize shouldTerminateApplication;

- (id)initWithContentRect:(NSRect)contentRect
				styleMask:(NSUInteger)aStyle
				  backing:(NSBackingStoreType)bufferingType
					defer:(BOOL)flag
{
	aStyle = NSBorderlessWindowMask;
	self = [super initWithContentRect:contentRect styleMask:aStyle backing:bufferingType defer:flag];
	if( self ) {		
//		[self setLevel:kCGDesktopWindowLevel];
		[self setShouldTerminateApplication:YES];
		[self setBackgroundColor:[NSColor clearColor]];
		[self setOpaque:NO];
		[self setMovableByWindowBackground:YES];
	}
	return self;
}

- (void)orderOut:(id)sender
{
	
	[super orderOut:sender];
	if( [self shouldTerminateApplication] )
		[NSApp terminate:self];
	
}

- (BOOL)canBecomeKeyWindow
{
	return YES;
}










@end
