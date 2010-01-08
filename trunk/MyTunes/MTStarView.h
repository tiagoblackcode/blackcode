//
//  MTStarView.h
//  MyTunes
//
//  Created by Tiago Melo on 12/23/09.
//  Copyright 2009 BlackCode. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MTStarView : NSView {

	NSColor *fillColor;
	
	NSTrackingArea *trackingArea;
	NSImage *colorLayer;
	NSImage *cachedView;
	
	NSImage *dot;
	NSImage *star;
	int rating;
	int displayRating;

}

@property (retain) NSImage *colorLayer;
@property (retain) NSImage *cachedView;


- (int)hitTestRating:(NSEvent *)theEvent;
- (NSColor*)fillColor;
- (void)setFillColor:(NSColor*)newColor;
- (int)rating;
- (void)setRating:(int)rating;
- (int)displayRating;
- (void)setDisplayRating:(int)displayRating;

@end
