//
//  MTPlayerView.h
//  MyTunes
//
//  Created by Tiago Melo on 12/17/09.
//  Copyright 2009 BlackCode. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MTHUDView : NSView {
	
	NSResponder *controller;

	NSImage *cachedView;
	NSColor *strokeColor;
	NSColor *backgroundColor;
	
	NSTrackingArea *trackingArea;
	

}

- (void)cacheView;
- (void)setStrokeColor:(NSColor *)color;
- (void)setBackgroundColor:(NSColor *)color;
- (NSColor*)backgroundColor;
- (NSColor*)strokeColor;

@property (retain) NSImage *cachedView;
@property (retain) NSResponder *controller;

@end
