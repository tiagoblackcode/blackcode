//
//  ParseOperation.m
//  AgendaiPhone
//
//  Created by Tiago Melo on 11/12/10.
//  Copyright 2010 BlackCode. All rights reserved.
//

#import "ParseOperation.h"

@implementation ParseOperation

@synthesize data, delegate, elements, baseURL;


- (id)init
{
	self = [super init];
	if (!self) return nil;
		
	elements = [[NSMutableArray alloc] init];
	return self;
}


- (void)dealloc
{
	[baseURL release];

	[data release];
	delegate = nil;
	
	[super dealloc];
}

@end
