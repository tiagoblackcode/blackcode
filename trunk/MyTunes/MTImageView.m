//
//  MTImageView.m
//  MyTunes
//
//  Created by Tiago Melo on 12/18/09.
//  Copyright 2009 BlackCode. All rights reserved.
//

#import "MTImageView.h"
#import "NSImage+Additions.h"

NSString * const kCurrentArtworkKey = @"kCurrentArtwork";
NSString * const kNewArtworkKey = @"kNewArtwork";
NSString * const kRatioKey = @"kRatio";


@interface MTImageView (Private)

- (void)transitionTimerFired:(NSTimer*)timer;

@end

@implementation MTImageView


- (void)changeImageTo:(NSImage*)newImage
{
	NSImage *currentImage = [self image];
	NSTimeInterval ti = 0.10;

	if( newImage == currentImage ) {
		return;
	}
	
	NSNumber *ratio = [NSNumber numberWithFloat:0.0];	
	NSMutableDictionary *dict = 
	[[NSMutableDictionary alloc] initWithObjectsAndKeys:currentImage, kCurrentArtworkKey,
														newImage, kNewArtworkKey,
														ratio, kRatioKey, nil];
	
	[imageTimer invalidate];
	imageTimer = 
	[NSTimer scheduledTimerWithTimeInterval:ti
									 target:self 
								   selector:@selector(transitionTimerFired:) 
								   userInfo:dict 
									repeats:YES];
	[dict release];
	
}

- (void)transitionTimerFired:(NSTimer*)timer
{
	NSMutableDictionary *dict = [timer userInfo];
	NSNumber *ratio = [dict valueForKey:kRatioKey];
	NSImage *current = [dict valueForKey:kCurrentArtworkKey];
	NSImage *new = [dict valueForKey:kNewArtworkKey];
	
	float fratio = [ratio floatValue]+0.05;
	if( fratio >= 1.0 ) {
		[self setImage:new];
		[imageTimer invalidate];
		imageTimer = nil;		
	} else {
		ratio = [NSNumber numberWithFloat:fratio];
		[dict setValue:ratio forKey:kRatioKey];
		NSImage *result = [[NSImage alloc] initWithSize:[self frame].size];
		[result composeImageWithTransitionFrom:current to:new ratio:[ratio floatValue]];
		[self setImage:result];
		[result release];
				
	}
	

	[self setNeedsDisplay:YES];
	[[self superview] setNeedsDisplay:YES];
	
	
	
}

@end
