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

- (NSColor*) backgroundColor;
- (NSColor*) strokeColor;
- (void)setBackgroundColor:(NSColor *)backgroundColor;
- (void)setStrokeColor:(NSColor *)strokeColor;

@property (retain) NSResponder *controller;

@end
