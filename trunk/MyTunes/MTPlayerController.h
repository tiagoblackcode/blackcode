//
//  PlayerController.h
//  MyTunes
//
//  Created by Tiago Melo on 12/17/09.
//  Copyright 2009 BlackCode. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class MTCloseButtonView;
@class MTHUDView;
@class MTHorizontalLine;
@class MTSliderView;
@class MTImageView;
@class ETTrack;

@interface MTPlayerController : NSWindowController {

	MTCloseButtonView *closeButton;
	MTHUDView *playerView;
	IBOutlet MTImageView *artworkImage;
	IBOutlet MTSliderView *sliderView;
	IBOutlet MTHorizontalLine *horizontalLine;
	IBOutlet NSTextField *trackTextView;
	IBOutlet NSTextField *artistTextView;
	IBOutlet NSTextField *albumTextView;
	
	
	NSImage *defaultArtwork;
	NSTimer *updateTimer;
	BOOL needsUpdate;
	
	ETTrack		*currentTrack;
	DescType	currentState;
	int			currentPosition;
	
}

@property (retain) ETTrack *currentTrack;

- (id)init;

@end
