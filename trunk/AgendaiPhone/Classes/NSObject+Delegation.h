//
//  NSObject+Delegation.h
//  AgendaiPhone
//
//  Created by Tiago Melo on 11/19/10.
//  Copyright 2010 BlackCode. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSObject (Delegation)


- (void)informTargetOnMainThread:(id)target
						selector:(SEL)selector;

- (void)informTargetOnMainThread:(id)target
						selector:(SEL)selector
					  withObject:(id)obj;


- (void)performInvocationOnMainThread:(NSInvocation*)invocation;

@end
