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
	NSImage *dot;
	NSImage *star;
	int rating;

}

- (NSColor*)fillColor;
- (void)setFillColor:(NSColor*)newColor;
- (int)rating;
- (void)setRating:(int)rating;

@end
