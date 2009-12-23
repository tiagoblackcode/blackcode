//
//  PlayerController.m
//  MyTunes
//
//  Created by Tiago Melo on 12/17/09.
//  Copyright 2009 BlackCode. All rights reserved.
//

#import <EyeTunes/ETTrack.h>
#import <EyeTunes/EyeTunes.h>

#import "MTUtils.h"
#import "MTPreferencesController.h"
#import "MTPlayerController.h"
#import "MTPlayerView.h"
#import "MTCloseButtonView.h"
#import "MTImageView.h"
#import "MTHorizontalLine.h"
#import "MTSliderView.h"
#import "NSImage+Additions.h"


NSString* const kDefaultArtworkFilename = @"default-artwork";
const float kHorizontalLineMinWidth = 260.0;
const float kHorizontalLinePadding = 10.0;

@interface MTPlayerController (Private)

- (NSImage*)defaultArtwork;
- (void)update:(NSTimer*)timer;
- (void)updateTrack;
- (void)updateArtwork;
- (void)resizeControls;

@end

@implementation MTPlayerController

@synthesize currentTrack;

- (id)init
{
	self = [super initWithWindowNibName:@"DefaultPlayer" owner:self];
	if( self ) {
		playerView = nil;
		currentTrack = nil;
		defaultArtwork = [self defaultArtwork];
		needsUpdate = YES;
		updateTimer = [NSTimer timerWithTimeInterval:0.5 
											  target:self 
											selector:@selector(update:) 
											userInfo:nil 
											 repeats:YES];
	}
	return self;
}

- (void)update:(NSTimer*)timer
{
	
	ETTrack *track = [[EyeTunes sharedInstance] currentTrack];
	DescType state = [[EyeTunes sharedInstance] playerState];
	
	needsUpdate |= [track databaseId] != [currentTrack databaseId];
	needsUpdate |= ((currentTrack) && (currentState != state));
	if( needsUpdate ) {
		[self updateTrack];	
		[[[self window] contentView] setNeedsDisplay:YES];
	}
	needsUpdate = NO;
}

- (void)resizeControls
{
	[trackTextView sizeToFit];
	[artistTextView sizeToFit];
	[albumTextView sizeToFit];

	
	float maxWidth, originX, paddingX;
	
	paddingX = [artworkImage frame].origin.x;
	originX = [trackTextView frame].origin.x;
	maxWidth = MTMax( [trackTextView frame].size.width + kHorizontalLinePadding, kHorizontalLineMinWidth );
	[horizontalLine setFrameSize:NSMakeSize(maxWidth, [horizontalLine frame].size.height)];
	
	
	maxWidth = MTMax( maxWidth, [trackTextView frame].size.width );
	maxWidth = MTMax( maxWidth, [artistTextView frame].size.width );
	maxWidth = MTMax( maxWidth, [albumTextView frame].size.width );
	
	NSRect wframe = [[self window] frame];
	wframe.size.width = maxWidth + originX + paddingX;	
	
	[playerView setFrameSize:wframe.size];
	[[self window] setFrame:wframe display:YES animate:NO];
	

}

- (void)updateTrack
{
	ETTrack *track = [[EyeTunes sharedInstance] currentTrack];
	ETTrack *oldTrack = [[self currentTrack] retain];
	currentState = [[EyeTunes sharedInstance] playerState];
	[self setCurrentTrack:track];
	
	
	if( currentTrack != nil ) {
		[trackTextView setStringValue:[currentTrack name]];
		[artistTextView setStringValue:[currentTrack artist]];
		[albumTextView setStringValue:[currentTrack album]];
		if( [currentTrack year] != 0 )
			[albumTextView setStringValue:[[albumTextView stringValue] stringByAppendingFormat:@" (%d)", [currentTrack year]]];

		if( currentState == kETPlayerStatePaused )
			[trackTextView setStringValue:[[trackTextView stringValue] stringByAppendingString:@" (Paused)"]];
		else if (currentState == kETPlayerStateStopped )
					[trackTextView setStringValue:[[trackTextView stringValue] stringByAppendingString:@" (Stopped)"]];
			

		BOOL shouldChangeArtwork = ([currentTrack databaseId] != [oldTrack databaseId]);
		shouldChangeArtwork &= (([[currentTrack album] compare:[oldTrack album]] != NSOrderedSame) || 
								[[currentTrack artist] compare:[oldTrack artist]] != NSOrderedSame);
		if(shouldChangeArtwork)
			[self updateArtwork];
		
	} else {
		[trackTextView setStringValue:@"Not Playing"];
		[artistTextView setStringValue:@""];
		[albumTextView setStringValue:@""];
		[artworkImage changeImageTo:defaultArtwork];
	}
	
	[oldTrack release];
	[self resizeControls];



	
}

- (void)updateArtwork
{
	NSArray *artwork = [currentTrack artwork];
	if( [artwork count] ) {
		NSImage *ref = [NSImage imageWithReflection:[artwork objectAtIndex:0] amountReflected:0.3];
		[artworkImage changeImageTo:ref];
	} else {
		[artworkImage changeImageTo:defaultArtwork];
	}
}

- (NSImage*)defaultArtwork
{
	NSImage *img = [[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForImageResource:kDefaultArtworkFilename]];
	NSImage *result = [NSImage imageWithReflection:img amountReflected:0.3];
	[img release];
	return result;
}




- (void)windowDidLoad
{
	NSLog(@"windowDidLoad:");

	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSUserDefaultsController *controller = [NSUserDefaultsController sharedUserDefaultsController];

	playerView = [[MTPlayerView alloc] initWithFrame:[[[self window] contentView] frame]] ;
	
	NSRect buttonRect = NSMakeRect(6.0, [[[self window] contentView] frame].size.height - 19.0, 13.0, 13.0);
	closeButton = [[MTCloseButtonView alloc] initWithFrame:buttonRect];
	
	[playerView addSubview:closeButton];
	[[[self window] contentView] addSubview:playerView positioned:NSWindowBelow relativeTo:nil];
	
	
	[playerView setMinAlphaValue:[[defaults objectForKey:kPlayerViewMinOpacityKey] floatValue]];
	[playerView setMaxAlphaValue:[[defaults objectForKey:kPlayerViewMaxOpacityKey] floatValue]];

	[horizontalLine bind:@"lineColor"
				toObject:controller
			 withKeyPath:@"values.kPlayerTextColor"
				 options:[NSDictionary dictionaryWithObject:NSUnarchiveFromDataTransformerName forKey:NSValueTransformerNameBindingOption]];
	
	
	[playerView bind:@"minAlphaValue"
			toObject:controller
		 withKeyPath:@"values.kPlayerMinOpacity"
			 options:nil];
	
	[playerView bind:@"maxAlphaValue"
			toObject:controller
		 withKeyPath:@"values.kPlayerMaxOpacity"
			 options:nil];
	
	[playerView bind:@"backgroundColor"
			toObject:controller
		 withKeyPath:@"values.kPlayerBackgroundColor"
			 options:[NSDictionary dictionaryWithObject:NSUnarchiveFromDataTransformerName forKey:NSValueTransformerNameBindingOption]];
			 //options:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:@"NSContinuouslyUpdateValues"]];

	
	[closeButton setTarget:[self window]];
	[closeButton setAction:@selector(orderOut:)];
	
	
	[artworkImage setImage:defaultArtwork];
	[[self window] display];
	
	
	[updateTimer fire];
	[[NSRunLoop currentRunLoop] addTimer:updateTimer forMode:NSDefaultRunLoopMode];
	[pool drain];

}


- (void)showWindow:(id)sender
{
	NSLog(@"showWindow:");
//	[self startStopTimer];
	[super showWindow:sender];
	
}

- (void)windowWillClose:(NSNotification*)window
{
	NSLog(@"windowWillClose:");
//	[self startStopTimer];
}



@end
