//
//  MTPlayerWindow.h
//  MyTunes
//
//  Created by Tiago Melo on 12/17/09.
//  Copyright 2009 BlackCode. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MTPlayerWindow : NSWindow {
	
	BOOL shouldTerminateApplication;
	
}

@property (assign) BOOL shouldTerminateApplication;

@end