//
//  MTSliderView.m
//  MyTunes
//
//  Created by Tiago Melo on 12/18/09.
//  Copyright 2009 BlackCode. All rights reserved.
//

#import "MTSliderView.h"

const float kLabelSize = 50.0;

@implementation MTSliderView

- (id)initWithFrame:(NSRect)frame
{
	self = [super initWithFrame:frame];
	if( self ) {
		[self initSlider];
		[self initLabels];
	}
	return self;
}

- (void)initSlider
{
	NSRect sliderFrame = NSZeroRect;
	sliderFrame.origin.x = kLabelSize;
	sliderFrame.size.width = [self frame].size.width - kLabelSize*2;
	sliderFrame.size.height = [self frame].size.height;	
	slider = [[NSSlider alloc] initWithFrame:sliderFrame];
	[self addSubview:slider];
	
	[[slider cell] setSliderType:NSLinearSlider];
	[slider setMinValue:0.0];
	[slider setMaxValue:1.0];
	[slider setFloatValue:0.0];


}

- (void)initLabels
{
	NSTextField *label = [[NSTextField alloc] init];
	[self addSubview:label];
	
	
	//[label setDrawsBackground:NO];
//	NSRect labelFrame = [label frame];
//	labelFrame.origin.y = NSMidY([self frame]) + 1.5;
//	labelFrame.size.width = kLabelSize;
//	[label setFrame:labelFrame];
//	[label setDrawsBackground:YES];
//	[label setBackgroundColor:[NSColor whiteColor]];
//	[label setTextColor:[NSColor whiteColor]];
//	[label setAlignment:NSRightTextAlignment];
//	[label setStringValue:@"00:00"];

	
	
}

- (void)drawRect:(NSRect)rect {
	
	[[NSColor blackColor] setFill];
	NSRectFill(rect);
	
}

@end
