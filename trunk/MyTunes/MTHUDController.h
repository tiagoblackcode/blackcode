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
	
	NSMenu *contextualMenu;
	
	float maxAlphaValue;
	float minAlphaValue;

}


- (NSColor*)strokeColor;
- (NSColor*)backgroundColor;
- (void)setStrokeColor:(NSColor *)strokeColor;
- (void)setBackgroundColor:(NSColor*)backgroundColor;

- (void)showPreferences:(id)sender;
- (void)orderClose:(id)sender;

@end
