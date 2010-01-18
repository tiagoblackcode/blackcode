//
//  MTITunesController.m
//  MyTunes
//
//  Created by Tiago Melo on 1/8/10.
//  Copyright 2010 BlackCode. All rights reserved.
//

#import "MTITunesController.h"
#import <EyeTunes/EyeTunes.h>

NSString* const kITunesNewTrackKey = @"kITunesNewTrack";
NSString* const kITunesOldTrackKey = @"kITunesOldTrack";
NSString* const kITunesNewPlayerStateKey = @"kITunesNewPlayerState";
NSString* const kITunesOldPlayerStateKey = @"kITunesOldPlayerState";
NSString* const kITunesNewPlayerPositionKey = @"kITunesNewPlayerPosition";
NSString* const kITunesOldPlayerPositionKey = @"kITunesOldPlayerPositionKey";



@interface MTITunesController (Private)

- (void)update:(NSTimer*)timer;
- (BOOL)trackNeedsUpdate;
- (BOOL)playerStateNeedsUpdate;
- (BOOL)playerPositionNeedsUpdate;

@end


@implementation MTITunesController

@synthesize needsUpdate;
@synthesize delegate;
@synthesize currentTrack;
@synthesize currentState;
@synthesize currentPosition;

- (id)initWithDelegate:(id)del
{
	self = [super init];
	if( self ) {
		delegate = del;
	}
	return self;
}

- (void)startTimer
{
	[updateTimer invalidate];
	updateTimer = [NSTimer timerWithTimeInterval:1.0 
													  target:self 
													selector:@selector(update:) 
													userInfo:nil 
													 repeats:YES];
	needsUpdate = YES;
	[updateTimer fire];
	[[NSRunLoop currentRunLoop] addTimer:updateTimer forMode:NSDefaultRunLoopMode];
	
}

- (void)stopTimer
{
	[updateTimer invalidate];
	updateTimer = nil;
}

- (void)dealloc
{	
	[updateTimer invalidate];
	[currentTrack release];	
	[super dealloc];
}

- (void)update:(NSTimer*)timer
{
	//check for player state change
	BOOL state = needsUpdate || [self playerStateNeedsUpdate];
	BOOL position = needsUpdate || [self playerPositionNeedsUpdate];
	BOOL track = needsUpdate || [self trackNeedsUpdate]; 
	
	NSNumber *oldState, *oldPosition;
	ETTrack *oldTrack;
	if( state ) {
		oldState = [NSNumber numberWithInt:[self currentState]];
		[self setCurrentState:[[EyeTunes sharedInstance] playerState]];
	}
	
	if( position ) {
		oldPosition = [NSNumber numberWithInt:[self currentPosition]];
		[self setCurrentPosition:[[EyeTunes sharedInstance] playerPosition]];
	}
	if( track ) {
		oldTrack = [self currentTrack];
		[[oldTrack retain] autorelease];
		[self setCurrentTrack:[[EyeTunes sharedInstance] currentTrack]];
		NSLog(@"artwork:%@", [[[[EyeTunes sharedInstance] currentTrack] artwork] count] > 0 ? @"YES" : @"NO" );
	}
	
	
	if( state ) {
		
		NSNumber *current = [NSNumber numberWithInt:currentState];
		NSDictionary *change = [NSDictionary dictionaryWithObjectsAndKeys:
										current, kITunesNewPlayerStateKey,
										oldState, kITunesOldPlayerStateKey,
										nil];
		
		[delegate performSelector:@selector(iTunesPlayerStateDidChange:) withObject:change];
		
	}
	
	if( position ) {
		
		NSNumber *current = [NSNumber numberWithInt:currentPosition];
		NSDictionary *change = [NSDictionary dictionaryWithObjectsAndKeys:
										current, kITunesNewPlayerPositionKey,
										oldPosition, kITunesOldPlayerPositionKey,
										nil];
		
		[delegate performSelector:@selector(iTunesPlayerPositionDidChange:) withObject:change];
	}

	
	//check for track change
	if( track ) {
		
		id current = currentTrack;
		id old = oldTrack;
		
		if( current == nil )
			current = [NSNull null];
		if( old == nil )
			old = [NSNull null];
		
		NSDictionary *change = [NSDictionary dictionaryWithObjectsAndKeys:
										current, kITunesNewTrackKey,
										old ,kITunesOldTrackKey,
										nil];
		
		[delegate performSelector:@selector(iTunesTrackDidChange:) withObject:change];

	}
	
	
	
	needsUpdate = NO;
}

- (BOOL)trackNeedsUpdate
{
	ETTrack *track = [[EyeTunes sharedInstance] currentTrack];
	long long int nId = [track persistentId];
	long long int oId = [currentTrack persistentId];
	if( nId != oId )
		return YES;
	else
		return NO;
}

- (BOOL)playerStateNeedsUpdate
{
	DescType nState = [[EyeTunes sharedInstance] playerState];
	if( nState != currentState )
		return YES;
	else
		return NO;
}

- (BOOL)playerPositionNeedsUpdate
{
	int nPosition = [[EyeTunes sharedInstance] playerPosition];
	if( nPosition != currentPosition )
		return YES;
	else
		return NO;
}

@end
