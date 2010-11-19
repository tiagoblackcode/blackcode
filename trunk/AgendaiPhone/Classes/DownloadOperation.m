//
//  DownloadOperation.m
//  AgendaiPhone
//
//  Created by Tiago Melo on 11/18/10.
//  Copyright 2010 BlackCode. All rights reserved.
//

#import "DownloadOperation.h"

#import "NSObject+Delegation.h"

@implementation DownloadOperation

@synthesize data, request, name, userInfo, delegate;


- (id)initWithRequest:(NSURLRequest*)theRequest
{
	self = [super init];
	if( !self ) return nil;
	
	request = [theRequest retain];
	
	return self;
}


- (void)start
{
	[connection release];
	connection = 
	 [NSURLConnection connectionWithRequest:request 
								   delegate:self];
	
	[connection retain];
	[connection start];
	
	SEL selector = @selector(downloadDidStart:);
	[self informTargetOnMainThread:delegate 
						  selector:selector];
	
}


- (void)cancel
{
	[connection cancel];
	[connection release];
	connection = nil;
}


#pragma mark NSURLConnection delegate methods
- (void)connection:(NSURLConnection *)theConnection 
didReceiveResponse:(NSURLResponse *)response
{
	

	[data release];
	data = [[NSMutableData alloc] init];
}

- (NSURLRequest *)connection:(NSURLConnection *)theConnection 
			 willSendRequest:(NSURLRequest *)theRequest 
			redirectResponse:(NSURLResponse *)redirectResponse
{
	
	[theRequest retain];
	[request release];
	request = theRequest;
	
	return theRequest;
}

- (void)connection:(NSURLConnection *)theConnection 
  didFailWithError:(NSError *)error
{

	[data release];
	data = nil;
	
	SEL selector = @selector(downloadDidFail:withError:);
	[self informTargetOnMainThread:delegate 
						  selector:selector 
						withObject:error];
}

- (void)connection:(NSURLConnection *)theConnection 
	didReceiveData:(NSData *)theData
{
	[data appendData:theData];
}


- (void)connectionDidFinishLoading:(NSURLConnection *)theConnection
{
	
	SEL selector = @selector(downloadDidEnd:);
	[self informTargetOnMainThread:delegate 
						  selector:selector];
}


@end
