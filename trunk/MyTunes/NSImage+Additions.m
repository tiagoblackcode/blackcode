//
//  NSImage+Additions.m
//  MyTunes
//
//  Created by Tiago Melo on 12/18/09.
//  Copyright 2009 BlackCode. All rights reserved.
//

#import "NSImage+Additions.h"


@implementation NSImage (Additions)

+(NSImage*)reflectedImage:(NSImage*)source amountReflected:(float)fraction
{
	NSRect imageRect = NSMakeRect(0.0f, 0.0f, [source size].width, [source size].height*fraction);
	NSGradient *gradient = [[NSGradient alloc] initWithStartingColor:[NSColor whiteColor] 
														 endingColor:[NSColor clearColor]];
	
	NSImage* reflection = [[NSImage alloc] initWithSize:imageRect.size];
	[reflection setFlipped:YES];
	[reflection lockFocus];
	[gradient drawInRect:imageRect angle:90.0f];
	[source drawAtPoint:NSMakePoint(0,0) 
			   fromRect:NSZeroRect 
			  operation:NSCompositeSourceIn 
			   fraction:0.2];
	[reflection unlockFocus];				
	[gradient release];
	return reflection;
}

+(NSImage*)imageWithReflection:(NSImage*)source amountReflected:(float)fraction {
	
	
	NSImage *reflection = [NSImage reflectedImage:source amountReflected:fraction];
	NSSize resultSize = [source size];
	resultSize.height += [reflection size].height;
	
	NSImage *result = [[NSImage alloc] initWithSize:resultSize];
	[result lockFocus];
	
	[source drawInRect:NSMakeRect(0, [reflection size].height, [source size].width, [source size].height) 
		   fromRect:NSZeroRect 
		  operation:NSCompositeCopy 
		   fraction:1.0];
	[reflection drawInRect:NSMakeRect(0, 0, [reflection size].width, [reflection size].height) 
				  fromRect:NSZeroRect 
				 operation:NSCompositeCopy
				  fraction:1.0];
	[result unlockFocus];
	[reflection release];
	return [result autorelease];
	
	
}
-(void)composeImageWithTransitionFrom:(NSImage*)from to:(NSImage*)to ratio:(float)ratio {
	
	NSRect frame;
	frame.size = [self size];
	frame.origin = NSZeroPoint;
	
	NSRect currentFrame = frame;
	NSRect nextFrame = frame;
	NSRect currentRect = NSZeroRect;
	NSRect nextRect = NSZeroRect;
	
	currentFrame.size.width -= frame.size.width*ratio;
	nextFrame.origin.x += currentFrame.size.width;
	nextFrame.size.width += frame.size.width*(1-ratio);
	
	currentRect.size = [from size];
	currentRect.origin.x += currentRect.size.width*ratio;
	currentRect.size.width -= currentRect.size.width*ratio;
	nextRect.size = [to size];
	nextRect.size.width += nextRect.size.width*(1-ratio);
	
	[self lockFocus];
	[from drawInRect:currentFrame fromRect:currentRect operation:NSCompositeCopy fraction:1.0];
	[to drawInRect:nextFrame fromRect:nextRect operation:NSCompositeCopy fraction:1.0];
	[self unlockFocus];

}

@end
