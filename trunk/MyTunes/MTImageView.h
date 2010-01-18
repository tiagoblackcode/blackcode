//
//  MTImageView.h
//  MyTunes
//
//  Created by Tiago Melo on 12/18/09.
//  Copyright 2009 BlackCode. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface MTImageView : NSImageView {

	NSTimer *imageTimer;
}

- (void)changeImageTo:(NSImage*)newImage;

@end
