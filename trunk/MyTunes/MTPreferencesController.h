//
//  PreferencesController.h
//  MyTunes
//
//  Created by Tiago Melo on 12/17/09.
//  Copyright 2009 BlackCode. All rights reserved.
//

#import <Cocoa/Cocoa.h>

extern NSString const *kPlayerTextColorKey;
extern NSString const *kPlayerBackgroundColorKey;
extern NSString const *kPlayerViewMinOpacityKey;
extern NSString const *kPlayerViewMaxOpacityKey;
extern NSString const *kPlayerUpdateTimeKey;

@interface MTPreferencesController : NSWindowController {

}

+ (void)registerDefaults;


@end
