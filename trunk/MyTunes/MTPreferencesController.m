//
//  PreferencesController.m
//  MyTunes
//
//  Created by Tiago Melo on 12/17/09.
//  Copyright 2009 BlackCode. All rights reserved.
//

#import "MTPreferencesController.h"

NSString* const kPlayerTextColorKey = @"PlayerTextColor";
NSString* const kPlayerBackgroundColorKey = @"PlayerBackgroundColor";
NSString* const kPlayerViewMinAlphaKey = @"PlayerViewMinAlpha";
NSString* const kPlayerViewMaxAlphaKey = @"PlayerViewMaxAlpha";
NSString* const kPlayerUpdateTimeKey = @"PlayerUpdateTime";
NSString* const kPlayerPositionLockedKey = @"PlayerPositionLocked";
NSString* const kPlayerShouldHideWindowWhenIdleKey = @"PlayerShouldHideWindowWhenIdle";
NSString* const kPlayerGlobalAlphaKey = @"PlayerGlobalAlpha";

@implementation MTPreferencesController

+ (void)initialize
{
	[MTPreferencesController registerDefaults];
}

+ (void)registerDefaults
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
	
	NSData *textColor = [NSArchiver archivedDataWithRootObject:[NSColor whiteColor]];
	NSData *backgroundColor = [NSArchiver archivedDataWithRootObject:[NSColor blackColor]];
	NSNumber *minOpacity = [NSNumber numberWithFloat:0.0];
	NSNumber *maxOpacity = [NSNumber numberWithFloat:1.0];
	NSNumber *genOpacity = [NSNumber numberWithFloat:1.0];
	NSNumber *updateTime = [NSNumber numberWithFloat:600];
	NSNumber *locked = [NSNumber numberWithBool:YES];
	NSNumber *hide = [NSNumber numberWithBool:YES];
	
	[dict setObject:textColor forKey:kPlayerTextColorKey];
	[dict setObject:backgroundColor forKey:kPlayerBackgroundColorKey];
	[dict setObject:minOpacity forKey:kPlayerViewMinAlphaKey];
	[dict setObject:maxOpacity forKey:kPlayerViewMaxAlphaKey];
	[dict setObject:genOpacity forKey:kPlayerGlobalAlphaKey];
	[dict setObject:updateTime forKey:kPlayerUpdateTimeKey];
	[dict setObject:locked forKey:kPlayerPositionLockedKey];
	[dict setObject:hide forKey:kPlayerShouldHideWindowWhenIdleKey];
	
	NSUserDefaultsController *defaults = [NSUserDefaultsController sharedUserDefaultsController];
	[defaults setInitialValues:dict];
	[dict release];
	[pool drain];
	
}


- (id)init
{
	self = [super initWithWindowNibName:@"Preferences" owner:self];
	if( self ) {

	}
	return self;
}

@end
