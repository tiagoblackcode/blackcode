//
//  PlayerController.m
//  MyTunes
//
//  Created by Tiago Melo on 12/17/09.
//  Copyright 2009 BlackCode. All rights reserved.
//

#import <EyeTunes/ETTrack.h>
#import <EyeTunes/EyeTunes.h>

#import "MTHUDController.h"
#import "MTStarView.h"
#import "MTUtils.h"
#import "MTPreferencesController.h"
#import "MTPlayerController.h"
#import "MTImageView.h"
#import "MTHorizontalLine.h"
#import "MTSliderView.h"
#import "NSImage+Additions.h"


NSString* const kDefaultArtworkFilename = @"default-artwork";
const float kHorizontalLineMinWidth = 260.0;
const float kHorizontalLinePadding = 10.0;

@interface MTPlayerController (Private)

- (NSImage*)loadDefaultArtwork;
- (void)update:(NSTimer*)timer;
- (void)updateTrack;
- (void)updateArtwork;
- (void)resizeControls;
- (void)configureBindings;

@end

@implementation MTPlayerController

@synthesize currentTrack;

- (id)init
{
	self = [super initWithWindowNibName:@"DefaultPlayer" owner:self];
	if( self ) {
		currentTrack = nil;
		defaultArtwork = nil;
		needsUpdate = YES;

		hudController = [[MTHUDController alloc] initWithNibName:@"MTHUD" 
														   bundle:nil];
		updateTimer = [NSTimer timerWithTimeInterval:2.0
											  target:self 
											selector:@selector(update:) 
											userInfo:nil 
											 repeats:YES];
		
		
		hideWhenIdle = [[[[NSUserDefaultsController sharedUserDefaultsController] values] 
						 valueForKey:@"kPlayerShouldHideWindowWhenIdle"] boolValue];
	}
	return self;
}




#pragma mark Update Methods

- (void)update:(NSTimer*)timer
{
	
	ETTrack *track = [[EyeTunes sharedInstance] currentTrack];
	DescType state = [[EyeTunes sharedInstance] playerState];
	
	needsUpdate |= [track databaseId] != [currentTrack databaseId];
	needsUpdate |= ((currentTrack) && (currentState != state));
	if( needsUpdate ) {
		[self updateTrack];	
		[[[self window] contentView] setNeedsDisplay:YES];
		[[self window] invalidateShadow];
	}
	needsUpdate = NO;
}

- (void)updateTrack
{
	ETTrack *track = [[EyeTunes sharedInstance] currentTrack];
	ETTrack *oldTrack = [[self currentTrack] retain];
	currentState = [[EyeTunes sharedInstance] playerState];
	[self setCurrentTrack:track];
	
	
	if( currentTrack != nil ) {
		
		if( hideWhenIdle ) {
			[[[self window] animator] setAlphaValue:0.5];
		}
		
		[trackTextView setStringValue:[currentTrack name]];
		[artistTextView setStringValue:[currentTrack artist]];
		[albumTextView setStringValue:[currentTrack album]];
		[starView setHidden:NO];
		[starView setRating:[currentTrack rating]];
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
		if( hideWhenIdle ) {
			[[[self window] animator] setAlphaValue:0.0];
		} else {
			[trackTextView setStringValue:@"Not Playing"];
			[artistTextView setStringValue:@""];
			[albumTextView setStringValue:@""];
			[artworkImage changeImageTo:defaultArtwork];
			[starView setHidden:YES];	
		}
		
	}
	
	[oldTrack release];
	[self resizeControls];



	
}

- (void)updateArtwork
{
	float reflected = ([artworkImage frame].size.height / [artworkImage frame].size.width) - 1;
	NSArray *artwork = [currentTrack artwork];
	if( [artwork count] ) {
		NSImage *ref = [NSImage imageWithReflection:[artwork objectAtIndex:0] amountReflected:reflected];
		[artworkImage changeImageTo:ref];
	} else {
		[artworkImage changeImageTo:defaultArtwork];
	}
}

- (NSImage*)loadDefaultArtwork
{
	float reflected = ([artworkImage frame].size.height / [artworkImage frame].size.width) - 1;
	NSImage *img = [[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForImageResource:kDefaultArtworkFilename]];
	NSImage *result = [NSImage imageWithReflection:img amountReflected:reflected];
	[img release];
	return result;
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
	
	//[hudController setFrame:wframe];
	[[self window] setFrame:wframe display:YES animate:NO];
	[hudController setFrame:[[[self window] contentView] frame]];
	
	
}



#pragma mark Window Notifications

- (void)windowDidLoad
{
	//NSLog(@"windowDidLoad:");

	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	[[self window] setFrameAutosaveName:@"PlayerWindow"];
	[hudController setFrame:[[[self window] contentView] frame]];
	[[[self window] contentView] addSubview:[hudController view] 
								 positioned:NSWindowBelow 
								 relativeTo:nil];
	
	NSNumber *locked = [[[NSUserDefaultsController sharedUserDefaultsController] values] valueForKey:kPlayerPositionLockedKey];
	[[self window] setMovableByWindowBackground:![locked boolValue]];

	
	
	defaultArtwork = [self loadDefaultArtwork];
	[artworkImage setImage:defaultArtwork];
	[self configureBindings];
	
	
	[[[self window] animator] setAlphaValue:0.5];
	
	[updateTimer fire];
	[[NSRunLoop currentRunLoop] addTimer:updateTimer forMode:NSDefaultRunLoopMode];
	[pool drain];

}


- (void)configureBindings
{
	NSUserDefaultsController *controller = [NSUserDefaultsController sharedUserDefaultsController];
	[horizontalLine bind:@"lineColor"
				toObject:controller
			 withKeyPath:MTUDControllerKey(kPlayerTextColorKey)
				 options:[NSDictionary dictionaryWithObject:NSUnarchiveFromDataTransformerName forKey:NSValueTransformerNameBindingOption]];
	
		
	[starView bind:@"fillColor"
		  toObject:controller
	   withKeyPath:MTUDControllerKey(kPlayerTextColorKey)
		   options:[NSDictionary dictionaryWithObject:NSUnarchiveFromDataTransformerName forKey:NSValueTransformerNameBindingOption]];
	
	[[self window] bind:@"alphaValue"
			   toObject:controller
			withKeyPath:MTUDControllerKey(kPlayerGlobalAlphaKey)
				options:nil];
	
	[starView addObserver:self 
			   forKeyPath:@"rating" 
				  options:NSKeyValueObservingOptionNew 
				  context:nil];	
	

	[controller addObserver:self 
				 forKeyPath:MTUDControllerKey(kPlayerPositionLockedKey) 
					options:NSKeyValueObservingOptionNew 
					context:nil];
	
	[controller addObserver:self 
				 forKeyPath:MTUDControllerKey(kPlayerShouldHideWindowWhenIdleKey)
					options:NSKeyValueObservingOptionNew 
					context:nil];
//	[[self window] setMovableByWindowBackground:NO];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if( object == starView ) {
		if( [keyPath compare:@"rating"] == NSOrderedSame ) {
			[currentTrack setRating:[[change valueForKey:NSKeyValueChangeNewKey] intValue]];
			return;
		}
	} 
	
	if( object == [NSUserDefaultsController sharedUserDefaultsController] ) {
		if( [keyPath compare:MTUDControllerKey(kPlayerPositionLockedKey)] == NSOrderedSame ) {
			NSNumber *locked = [[object values] valueForKey:kPlayerPositionLockedKey];
			[[self window] setMovableByWindowBackground:![locked boolValue]];
			return;
		}
		
		if( [keyPath compare:MTUDControllerKey(kPlayerShouldHideWindowWhenIdleKey)] == NSOrderedSame ) {
			NSNumber *locked = [[object values] valueForKey:kPlayerShouldHideWindowWhenIdleKey];
			hideWhenIdle = [locked boolValue];
			return;
		}

		
	}
	
	
	[super observeValueForKeyPath:keyPath 
						 ofObject:object 
						   change:change 
						  context:context];
	 
	
	
}


- (void)showWindow:(id)sender
{
//	NSLog(@"showWindow:");
//	[self startStopTimer];
	[super showWindow:sender];
	
}

- (void)windowWillClose:(NSNotification*)window
{
//	NSLog(@"windowWillClose:");
//	[self startStopTimer];
}



@end
