//
//  MTHUDController.h
//  MyTunes
//
//  Created by Tiago Melo on 12/30/09.
//  Copyright 2009 BlackCode. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface MTHUDController : NSViewController {
	
	NSButton *closeButton;
	NSButton *prefsButton;
	
	float maxAlphaValue;
	float minAlphaValue;

}

- (NSColor*)strokeColor;
- (NSColor*)backgroundColor;
- (void)setStrokeColor:(NSColor *)strokeColor;
- (void)setBackgroundColor:(NSColor*)backgroundColor;
- (void)setFrame:(NSRect)frame;


@end
