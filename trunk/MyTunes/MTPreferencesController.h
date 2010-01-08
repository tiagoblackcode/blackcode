//
//  PreferencesController.h
//  MyTunes
//
//  Created by Tiago Melo on 12/17/09.
//  Copyright 2009 BlackCode. All rights reserved.
//

#import <Cocoa/Cocoa.h>

extern NSString* const kPlayerTextColorKey;
extern NSString* const kPlayerBackgroundColorKey;
extern NSString* const kPlayerViewMinAlphaKey;
extern NSString* const kPlayerViewMaxAlphaKey;
extern NSString* const kPlayerUpdateTimeKey;
extern NSString* const kPlayerPositionLockedKey;
extern NSString* const kPlayerShouldHideWindowWhenIdleKey;
extern NSString* const kPlayerGlobalAlphaKey;

@interface MTPreferencesController : NSWindowController {

}

+ (void)registerDefaults;


@end
