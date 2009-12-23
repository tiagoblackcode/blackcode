//
//  MTSliderView.h
//  MyTunes
//
//  Created by Tiago Melo on 12/18/09.
//  Copyright 2009 BlackCode. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface MTSliderView : NSView {
	
	NSSlider *slider;
	NSTextView *current;
	NSTextView *total;

}

- (void)initSlider;
- (void)initLabels;

@end
