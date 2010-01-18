//
//  MTITunesController.h
//  MyTunes
//
//  Created by Tiago Melo on 1/8/10.
//  Copyright 2010 BlackCode. All rights reserved.
//

#import <Cocoa/Cocoa.h>


extern NSString* const kITunesNewTrackKey;
extern NSString* const kITunesOldTrackKey;
extern NSString* const kITunesNewPlayerStateKey;
extern NSString* const kITunesOldPlayerStateKey;
extern NSString* const kITunesNewPlayerPositionKey;
extern NSString* const kITunesOldPlayerPositionKey;

enum {
	kMTPlayerStateStopped		= 'kPSS',
	kMTPlayerStatePlaying		= 'kPSP',
	kMTPlayerStatePaused		= 'kPSp',
	kMTPlayerStateFastForwarding = 'kPSF',
	kMTPlayerStateRewinding		= 'kPSR'
};


@class ETTrack;

@interface MTITunesController : NSObject {

	id delegate;
	NSTimer *updateTimer;

	
	BOOL			needsUpdate;
	ETTrack*		currentTrack;
	DescType		currentState;
	int			currentPosition;
	
}

- (id)initWithDelegate:(id)delegate;
- (void)startTimer;
- (void)stopTimer;


@property (assign) BOOL needsUpdate;
@property (assign) id delegate;
@property (retain) ETTrack *currentTrack;
@property (assign) DescType currentState;
@property (assign) int currentPosition;

 
@end
