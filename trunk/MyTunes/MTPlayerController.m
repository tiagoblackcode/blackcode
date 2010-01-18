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
#import "NSImage+Additions.h"
#import "NSSlider+Additions.h"
#import "MTPlayerController.h"
#import "MTPreferencesController.h"
#import "MTITunesController.h"

#import "MTHUDController.h"
#import "MTStarView.h"
#import "MTImageView.h"
#import "MTHorizontalLine.h"




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

- (void)updateWithFontFamily:(NSString*)fontFamily;
- (void)updateWithFontSize:(NSNumber*)fontSize;

@end

@implementation MTPlayerController


- (id)init
{
	self = [super initWithWindowNibName:@"DefaultPlayer" owner:self];
	if( self ) {

		iTunesController = [[MTITunesController alloc] initWithDelegate:self];
		hideWhenIdle = [[[[NSUserDefaultsController sharedUserDefaultsController] values] 
						 valueForKey:@"kPlayerShouldHideWindowWhenIdle"] boolValue];
	}
	return self;
}



#pragma mark Delegate Methods

- (void)iTunesTrackDidChange:(NSDictionary*)change
{
	id current = [change valueForKey:kITunesNewTrackKey];
	if( ![current isKindOfClass:[NSNull class]] ) {
		
		
		ETTrack *currentTrack = (ETTrack*)current;
		[trackTextView setStringValue:[currentTrack name]];
		[artistTextView setStringValue:[currentTrack artist]];
		[albumTextView setStringValue:[currentTrack album]];
		[starView setHidden:NO];
		[starView setRating:[currentTrack rating]/20];
		if( [currentTrack year] != 0 )
			[albumTextView setStringValue:[[albumTextView stringValue] stringByAppendingFormat:@" (%d)", [currentTrack year]]];	
		
//		id old = [change valueForKey:kITunesOldTrackKey];
//		BOOL shouldChangeArtwork = YES;
//		if(![old isKindOfClass:[NSNull class]]) {
//			shouldChangeArtwork &= ([currentTrack databaseId] != [(ETTrack*)old databaseId]);
//			shouldChangeArtwork &= (([[currentTrack album] compare:[(ETTrack*)old album]] != NSOrderedSame) || 
//											[[currentTrack artist] compare:[(ETTrack*)old artist]] != NSOrderedSame);
//		}
		
		if( [iTunesController currentState] == kMTPlayerStatePaused )
			[trackTextView setStringValue:[[currentTrack name] stringByAppendingString:@" (Paused)"]];
		
//		if( shouldChangeArtwork )
		[self updateArtwork];
		
		

	} else {
		
		[trackTextView setStringValue:@"Not Playing"];
		[artistTextView setStringValue:@""];
		[albumTextView setStringValue:@""];
		[artworkImage changeImageTo:defaultArtwork];
		[starView setHidden:YES];	
		
		
	}
	
	[self resizeControls];
	[[self window] setViewsNeedDisplay:YES];
}

- (void)iTunesPlayerStateDidChange:(NSDictionary*)change
{
	DescType new = [[change valueForKey:kITunesNewPlayerStateKey] intValue];
	NSLog(@"iTunesPlayerStateDidChange:%@", change);
	switch( new ) {
		case kMTPlayerStatePlaying:
			if( [iTunesController currentTrack] ) {
				[trackTextView setStringValue:[[iTunesController currentTrack] name]];
				[self resizeControls];
			}
			[[[self window] animator] setAlphaValue:1.0];
			break;
		case kMTPlayerStatePaused:
			if( [iTunesController currentTrack] ) {
				[trackTextView setStringValue:[[[iTunesController currentTrack] name] stringByAppendingString:@" (Paused)"]];
				[self resizeControls];
			}
			[[[self window] animator] setAlphaValue:1.0];
			break;
		case kMTPlayerStateStopped:
			[[[self window] animator] setAlphaValue:0.0];
			break;
		case kMTPlayerStateFastForwarding:
			break;
		case kMTPlayerStateRewinding:
			break;
		default:
			[[[self window] animator] setAlphaValue:0.0];
			break;
	}
	

	
}

- (void)iTunesPlayerPositionDidChange:(NSDictionary*)change
{
	
	
}


#pragma mark Artwork Methods

- (void)updateArtwork
{
	float reflected = ([artworkImage frame].size.height / [artworkImage frame].size.width) - 1;
	NSArray *artwork = [[iTunesController currentTrack] artwork];
	if( [artwork count] ) {
		NSImage *ref = [NSImage imageWithReflection:[artwork objectAtIndex:0] amountReflected:reflected];
		[artworkImage setImage:ref];
	} else {
		[artworkImage setImage:defaultArtwork];
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

#pragma mark Geometry Methods

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
	
	[[self window] setFrame:wframe display:YES animate:YES];
	
}



#pragma mark Window Notifications


- (void)windowDidLoad
{
	//NSLog(@"windowDidLoad:");

	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSUserDefaultsController *controller = [NSUserDefaultsController sharedUserDefaultsController];

	NSNumber *locked = 
	[[controller values] valueForKey:kPlayerPositionLockedKey];
	[[self window] setFrameAutosaveName:@"PlayerWindow"];
	[[self window] setLevel:kCGDesktopWindowLevel + 1];
	[[self window] setMovableByWindowBackground:![locked boolValue]];
	[[self window] setOpaque:NO];
	[[self window] setBackgroundColor:[NSColor clearColor]];	
	[[[self window] contentView] setAutoresizesSubviews:YES];
	[[[self window] contentView] setWantsLayer:YES];
	
	
	NSRect hudRect = [[[self window] contentView] frame];
	hudRect.origin = NSMakePoint(5, 10);
	hudRect.size.width -= 10;
	hudRect.size.height -= 10;
	
	hudController = [[MTHUDController alloc] init];
	[[hudController view] setFrame:hudRect];
	[[[self window] contentView] addSubview:[hudController view] 
								 positioned:NSWindowBelow 
								 relativeTo:nil];
	
	
	defaultArtwork = [[self loadDefaultArtwork] retain];
	[artworkImage setImage:defaultArtwork];
	
	
	NSString *fontFamily = [[controller values] valueForKey:kPlayerFontFamilyKey];
	NSNumber *fontSize = [[controller values] valueForKey:kPlayerFontSizeKey];
	[self updateWithFontFamily:fontFamily];
	[self updateWithFontSize:fontSize];
	[self resizeControls];

	
	
	[self configureBindings];
	[iTunesController startTimer];
	[pool drain];

}


- (void)showWindow:(id)sender
{
//	NSLog(@"showWindow:");
//	[self startStopTimer];
	[super showWindow:sender];
	
}

- (void)windowWillClose:(NSNotification*)windowNotification
{
	[NSApp terminate:self];

}


#pragma mark Bindings

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
	
	[controller addObserver:self
					 forKeyPath:MTUDControllerKey(kPlayerFontFamilyKey)
						 options:NSKeyValueObservingOptionNew
						 context:nil];
	
	[controller addObserver:self
					 forKeyPath:MTUDControllerKey(kPlayerFontSizeKey)
						 options:NSKeyValueObservingOptionNew
						 context:nil];
	
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if( object == starView ) {
		if( [keyPath compare:@"rating"] == NSOrderedSame ) {
			//[ setRating:[[change valueForKey:NSKeyValueChangeNewKey] intValue]];
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
		
		if( [keyPath compare:MTUDControllerKey(kPlayerFontFamilyKey)] == NSOrderedSame ) {
			NSString *fontFamily = [[object values] valueForKey:kPlayerFontFamilyKey];
			[self updateWithFontFamily:fontFamily];
			[self resizeControls];
			return;
		}
	
		if( [keyPath compare:MTUDControllerKey(kPlayerFontSizeKey)] == NSOrderedSame ) {
			NSNumber *fontSize = [[object values] valueForKey:kPlayerFontSizeKey];
			[self updateWithFontSize:fontSize];
			[self resizeControls];
			return;
		}
		
		
	}
	
	
	[super observeValueForKeyPath:keyPath 
								ofObject:object 
								  change:change 
								 context:context];
	
	
	
}

- (void)updateWithFontFamily:(NSString*)fontFamily
{
	

	NSFont *font = [NSFont fontWithName:fontFamily size:[[trackTextView font] pointSize]];

	[trackTextView setFont:font];
	
	font = [NSFont fontWithName:fontFamily size:[[albumTextView font] pointSize]];
	[albumTextView setFont:font];
	[artistTextView setFont:font];
	

}

- (void)updateWithFontSize:(NSNumber*)fontSize
{
	
	NSFont *font = [NSFont fontWithName:[[trackTextView font] fontName] size:([fontSize floatValue]+2)];
	[trackTextView setFont:font];
	
	font = [NSFont fontWithName:[[albumTextView font] fontName] size:[fontSize floatValue]];
	[albumTextView setFont:font];
	[artistTextView setFont:font];


}	

@end
