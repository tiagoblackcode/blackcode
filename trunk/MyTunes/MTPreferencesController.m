//
//  PreferencesController.m
//  MyTunes
//
//  Created by Tiago Melo on 12/17/09.
//  Copyright 2009 BlackCode. All rights reserved.
//

#import "MTPreferencesController.h"

NSString *kPlayerTextColorKey = @"kPlayerTextColor";
NSString *kPlayerBackgroundColorKey = @"kPlayerBackgroundColor";
NSString *kPlayerViewMinOpacityKey = @"kPlayerViewMinOpacity";
NSString *kPlayerViewMaxOpacityKey = @"kPlayerViewMaxOpacity";



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
	
	[dict setObject:textColor forKey:kPlayerTextColorKey];
	[dict setObject:backgroundColor forKey:kPlayerBackgroundColorKey];
	[dict setObject:minOpacity forKey:kPlayerViewMinOpacityKey];
	[dict setObject:maxOpacity forKey:kPlayerViewMaxOpacityKey];
	
	
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
