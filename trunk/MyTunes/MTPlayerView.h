//
//  MTPlayerView.h
//  MyTunes
//
//  Created by Tiago Melo on 12/17/09.
//  Copyright 2009 BlackCode. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MTCloseButtonView.h"

@interface MTPlayerView : NSView {
	
	NSColor *backgroundColor;
	NSImage *cachedView;
	NSTrackingArea *trackingArea;
	NSTimer *fadeTimer;
	
	float minAlphaValue;
	float maxAlphaValue;
	float alphaInc;

}

- (void)cacheView;
- (void)fadeIn;
- (void)fadeOut;


@property (assign) float minAlphaValue;
@property (assign) float maxAlphaValue;
@property (retain) NSImage *cachedView;
@property (retain) NSColor *backgroundColor;

@end
