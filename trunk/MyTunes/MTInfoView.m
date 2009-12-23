//
//  MTInfoView.m
//  MyTunes
//
//  Created by Tiago Melo on 12/18/09.
//  Copyright 2009 BlackCode. All rights reserved.
//

#import "MTInfoView.h"

const float kMarginBetweenLabels = 10.0;

@implementation MTInfoView

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}


- (void)drawRect:(NSRect)dirtyRect {
    [[[NSColor whiteColor] colorWithAlphaComponent:0.5] setFill];
	NSRectFill(dirtyRect);
}

@end
