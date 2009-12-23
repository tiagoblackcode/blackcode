//
//  PreferencesController.m
//  MyTunes
//
//  Created by Tiago Melo on 12/17/09.
//  Copyright 2009 BlackCode. All rights reserved.
//

#import "MTPreferencesController.h"

NSString const *kPlayerTextColorKey = @"kPlayerTextColor";
NSString const *kPlayerBackgroundColorKey = @"kPlayerBackgroundColor";
NSString const *kPlayerViewMinOpacityKey = @"kPlayerViewMinOpacity";
NSString const *kPlayerViewMaxOpacityKey = @"kPlayerViewMaxOpacity";
NSString const *kPlayerUpdateTimeKey = @"kPlayerUpdateTime";
NSString const *kPlayerPositionX = @"kPlayerPositionX";
NSString const *kPlayerPositionY = @"kPlayerPositionY";



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
	NSNumber *updateTime = [NSNumber numberWithFloat:600];
	
	[dict setObject:textColor forKey:kPlayerTextColorKey];
	[dict setObject:backgroundColor forKey:kPlayerBackgroundColorKey];
	[dict setObject:minOpacity forKey:kPlayerViewMinOpacityKey];
	[dict setObject:maxOpacity forKey:kPlayerViewMaxOpacityKey];
	[dict setObject:updateTime forKey:kPlayerUpdateTimeKey];
	
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
