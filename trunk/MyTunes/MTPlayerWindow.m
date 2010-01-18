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
	return self;
}


- (BOOL)canBecomeKeyWindow
{
	return YES;
}









@end
