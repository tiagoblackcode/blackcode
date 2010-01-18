//
//  PlayerController.h
//  MyTunes
//
//  Created by Tiago Melo on 12/17/09.
//  Copyright 2009 BlackCode. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@class MTStarView;
@class MTHUDView;
@class MTHorizontalLine;
@class MTImageView;

@class MTHUDController;
@class MTITunesController;

@interface MTPlayerController : NSWindowController {
	
	IBOutlet MTStarView *starView;
	IBOutlet MTImageView *artworkImage;
	IBOutlet MTHorizontalLine *horizontalLine;
	IBOutlet NSSlider *sliderView;
	IBOutlet NSTextField *trackTextView;
	IBOutlet NSTextField *artistTextView;
	IBOutlet NSTextField *albumTextView;


	MTITunesController *iTunesController;
	MTHUDController *hudController;
	
	NSImage *defaultArtwork;
	NSTimer *updateTimer;
	BOOL needsUpdate;
	BOOL hideWhenIdle;
	
}

- (id)init;

@end
