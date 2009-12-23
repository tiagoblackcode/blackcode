//
//  MTTextView.m
//  MyTunes
//
//  Created by Tiago Melo on 12/17/09.
//  Copyright 2009 BlackCode. All rights reserved.
//

#import "MTCloseButtonView.h"


@implementation MTCloseButtonView

- (id)initWithFrame:(NSRect)frame
{
	self = [super initWithFrame:frame];
	if( self ) {
		[self setBezelStyle:NSRoundedBezelStyle];
		[self setButtonType:NSMomentaryChangeButton];
		[self setBordered:NO];
		[self setImage:[NSImage imageNamed:@"hud_titlebar-close"]];
		[self setTitle:@""];
		[self setImagePosition:NSImageBelow];
		[self setFocusRingType:NSFocusRingTypeNone];
	}
	return self;
}

@end
