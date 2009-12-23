//
//  AppController.m
//  MyTunes
//
//  Created by Tiago Melo on 12/17/09.
//  Copyright 2009 BlackCode. All rights reserved.
//

#import "AppController.h"

@implementation AppController

- (id)init
{
	self = [super init];
	if( self ) {
		prefs = [[MTPreferencesController alloc] init];
		player = [[MTPlayerController alloc] init];
	}
	return self;
}

- (void)awakeFromNib
{
	[player showWindow:self];
}

- (IBAction)showPlayer:(id)sender
{
	[player showWindow:self];
}

- (IBAction)showPreferences:(id)sender
{
	[prefs showWindow:self];
}

- (void)applicationDidFinishLaunching:(NSNotification*)notification
{
	NSLog(@"applicationDidFinishLaunching:");	
}

@end
