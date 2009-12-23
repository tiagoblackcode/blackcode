//
//  AppController.h
//  MyTunes
//
//  Created by Tiago Melo on 12/17/09.
//  Copyright 2009 BlackCode. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "MTPlayerController.h"
#import "MTPreferencesController.h"

@interface AppController : NSObject {

	MTPreferencesController *prefs;
	MTPlayerController *player;
}

- (IBAction)showPreferences:(id)sender;
- (IBAction)showPlayer:(id)sender;

@end
