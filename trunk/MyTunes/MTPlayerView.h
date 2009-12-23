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
	
	NSImage *cachedView;
	NSTrackingArea *trackingArea;
	NSTimer *fadeTimer;
	
	float minAlphaValue;
	float maxAlphaValue;

}

- (void)fadeIn;
- (void)fadeOut;
- (void)cacheView;

@end
