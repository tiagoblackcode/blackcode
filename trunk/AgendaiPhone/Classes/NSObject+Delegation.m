//
//  NSObject+Delegation.m
//  AgendaiPhone
//
//  Created by Tiago Melo on 11/19/10.
//  Copyright 2010 BlackCode. All rights reserved.
//

#import "NSObject+Delegation.h"


@implementation NSObject (Delegation)


- (void)informTargetOnMainThread:(id)target
						selector:(SEL)selector
{
	
	if( ![target respondsToSelector:selector] ) return;
	
	
	NSMethodSignature *signature = 
	[target methodSignatureForSelector:selector];
	
	NSInvocation *invocation = 
	[NSInvocation invocationWithMethodSignature:signature];
	
	[invocation setTarget:target];
	[invocation setSelector:selector];
	[invocation setArgument:&self atIndex:2];
	
	[self performInvocationOnMainThread:invocation];
}

- (void)informTargetOnMainThread:(id)target
						selector:(SEL)selector
					  withObject:(id)obj
{
	
	
	if( ![target respondsToSelector:selector] ) return;
	
	NSMethodSignature *signature = 
	[target methodSignatureForSelector:selector];
	
	NSInvocation *invocation = 
	[NSInvocation invocationWithMethodSignature:signature];
	
	
	[invocation setTarget:target];
	[invocation setSelector:selector];
	[invocation setArgument:&self atIndex:2];
	[invocation setArgument:&obj atIndex:3];
	
	
	[self performInvocationOnMainThread:invocation];
	
}



- (void)performInvocationOnMainThread:(NSInvocation*)invocation
{
	
	
	if( ![NSThread mainThread] ) {
		SEL this = @selector(performInvocation:);
		[self performSelectorOnMainThread:this 
							   withObject:invocation 
							waitUntilDone:NO];
	}
	
	[invocation invoke];
	
}



@end
