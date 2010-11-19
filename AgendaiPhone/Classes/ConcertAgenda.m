//
//  ConcertAgenda.m
//  AgendaiPhone
//
//  Created by Tiago Melo on 11/15/10.
//  Copyright 2010 BlackCode. All rights reserved.
//

#import "ConcertAgenda.h"

#import "DownloadOperation.h"
#import "ParseOperation.h"
#import "ParseHighlightsOperation.h"

#import "NSObject+Delegation.h"


static NSString* const kDidBeginUpdateNotification = @"didBeginUpdate";
static NSString* const kDidEndUpdateNotification = @"didEndUpdate";

static NSString* const kDidBeginDownloadNotification = @"didBeginDownload";
static NSString* const kDidEndDownloadNotification = @"didEndDownload";

static NSString* const kDidBeginParsingNotification = @"didBeginParsing";
static NSString* const kDidEndParsingNotification = @"didEndParsing";


static NSString* const kUpdateErrorKey = @"updateError";

static id sharedInstance = nil;

@interface ConcertAgenda ()

- (void)_initialize;
- (void)_fetchHighlights;
- (void)_fetchConcerts;
- (void)_beginDownloading;
- (void)_beginParsing;
- (void)_endParsing;
- (void)_postNotification:(NSString*)notificationName;

- (void)_postNotification:(NSString*)notificationName 
				withError:(NSError*)theError;

@end

@implementation ConcertAgenda

@synthesize delegate, highlights, concerts, updateTime;

+ (id)sharedInstance
{
	if( !sharedInstance ) {
		sharedInstance = [[ConcertAgenda alloc] init];
	}
	return [[sharedInstance retain] autorelease] ;
}


- (id)init
{
	self = [super init];
	if( !self ) return nil;
	
	[self _initialize];
	return self;
}

- (void)dealloc
{
	[self cancelAllDownloads];
	[self cancelAllOperations];
	
	[highlights release];
	[concerts release];
	[pendingOperations release];
	[connectionPool release];
	[parseQueue release];
	[updateTime release];
	 
	[super dealloc];
}

- (void)_initialize
{
	highlights = [[NSMutableArray alloc] init];
	concerts = [[NSMutableArray alloc] init];
	pendingOperations = [[NSMutableArray alloc] init];
	connectionPool = [[NSMutableArray alloc] init];
	parseQueue = [[NSOperationQueue alloc] init];
	updateTime = nil;
}


#pragma mark API methods

- (void)update
{
	
	if( [connectionPool count] > 0 ) {
		[self cancelAllDownloads];
		[self cancelAllOperations];
	}
	
	
	[self informTargetOnMainThread:delegate 
						  selector:@selector(agendaDidBeginUpdate:)];
	
	[self _postNotification:kDidBeginUpdateNotification];
	[self _beginDownloading];
}

- (void)cancelAllDownloads
{	
	[connectionPool makeObjectsPerformSelector:@selector(cancel)];
	[connectionPool removeAllObjects];
}

- (void)cancelAllOperations
{
	[parseQueue cancelAllOperations];
}

#pragma mark DownloadOperation delegate methods

- (void)downloadDidStart:(DownloadOperation*)theDownload
{
	NSLog(@"[%@ %s%@",self, _cmd, theDownload);

}

- (void)downloadDidFail:(DownloadOperation*)theDownload 
			  withError:(NSError*)theError
{
	
	NSLog(@"[%@ %s%@",self, _cmd, theDownload);
	
	[self informTargetOnMainThread:delegate 
						  selector:@selector(agenda:didFailWithError:)
						withObject:theError];
	
	[self _postNotification:kDidEndDownloadNotification
				  withError:theError];
	
	[connectionPool makeObjectsPerformSelector:@selector(cancel)];
	[connectionPool removeAllObjects];
	
	[parseQueue cancelAllOperations];
	
}


- (void)downloadDidEnd:(DownloadOperation*)theDownload
{
	
	NSLog(@"[%@ %s%@",self, _cmd, theDownload);
	
	[connectionPool removeObject:theDownload];
	
	ParseOperation *operation = [theDownload userInfo];
	[operation setData:[theDownload data]];
	[operation setBaseURL:[[theDownload request] URL]];
	[pendingOperations addObject:operation];
	
	
	if( [connectionPool count] == 0 ) {
		[self _postNotification:kDidEndDownloadNotification];
		[self _beginParsing];
	}

}

#pragma mark ParseOperation delegate methods

- (void)parseOperationDidBegin:(ParseOperation*)operation
{
	
	NSLog(@"[%@ %s%@",self, _cmd, operation);
	
}

- (void)parseOperation:(ParseOperation*)operation 
	  didFailWithError:(NSError*)theError
{
	
	NSLog(@"[%@ %s%@",self, _cmd, operation);
	[self informTargetOnMainThread:delegate 
						  selector:@selector(agenda:didFailWithError:)
						withObject:theError];
	
}

- (void)parseOperationDidEnd:(ParseOperation*)operation
{
	NSLog(@"[self %s%@", _cmd, operation);
	if( [operation isKindOfClass:[ParseHighlightsOperation class]] ) {
		[highlights removeAllObjects];
		[highlights addObjectsFromArray:[operation elements]];
	}
}


#pragma mark Observing

- (void)observeValueForKeyPath:(NSString *)keyPath 
					  ofObject:(id)object 
						change:(NSDictionary *)change 
					   context:(void *)context
{
	
	if( object == parseQueue ) {
		if( ![keyPath compare:@"operationCount"] ) {
			NSNumber *count = [change valueForKey:NSKeyValueChangeNewKey];
			if( [count intValue] == 0 ) {
				[self _endParsing];
			}
		}
	}
}




#pragma mark Helper methods

- (void)_beginDownloading
{
	
	[self _postNotification:kDidBeginDownloadNotification];
	
	[self _fetchHighlights];
	//[self _fetchConcerts];
	
}

- (void)_beginParsing
{
	
	[self _postNotification:kDidBeginParsingNotification];
	
	
	[parseQueue addObserver:self 
				 forKeyPath:@"operationCount" 
					options:NSKeyValueObservingOptionNew 
					context:nil];
	

	[parseQueue addOperations:pendingOperations 
			waitUntilFinished:NO];
	
	[pendingOperations removeAllObjects];
}

- (void)_endParsing
{
	[self informTargetOnMainThread:delegate 
						  selector:@selector(agendaDidEndUpdate:)];
	
	[self _postNotification:kDidEndParsingNotification];
	[self _postNotification:kDidEndUpdateNotification];	
}



- (void)_fetchHighlights
{
	
	
	NSURL *url = [NSURL URLWithString:@"http://pt.yeaaaah.com/pt"];
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	
	
	DownloadOperation *download =
	[[DownloadOperation alloc] initWithRequest:request];
	
	ParseOperation *operation = 
	[[ParseHighlightsOperation alloc] init];
		
	[connectionPool addObject:download];
	
	[operation setDelegate:self];
	[download setDelegate:self];
	[download setUserInfo:operation];
	[download setName:@"Highlights"];
	[download start];
	
	[download release];
	[operation release];
	
}

- (void)_fetchConcerts
{
	NSURL *url = [NSURL URLWithString:@"http://pt.yeaaaah.com/pt"];
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	
	
	DownloadOperation *download =
	[[DownloadOperation alloc] initWithRequest:request];
	
	ParseOperation *operation = 
	[[ParseHighlightsOperation alloc] init];
	
	[connectionPool addObject:download];
	
	[operation setDelegate:self];
	[download setDelegate:self];
	[download setUserInfo:operation];
	[download setName:@"Concerts"];
	[download start];
	
	[download release];
	[operation release];
	
}

- (void)_postNotification:(NSString*)notificationName
{
	[self _postNotification:notificationName withError:nil];
}

- (void)_postNotification:(NSString*)notificationName 
				withError:(NSError*)theError
{
	
	NSNotificationCenter *center = 
	 [NSNotificationCenter defaultCenter];
	
	NSNotification *notification = nil;
	NSDictionary *dict = nil;
	
	if( theError ) {
	dict = 
 	 [NSDictionary dictionaryWithObject:theError 
								 forKey:kUpdateErrorKey];
			
	}
	
	notification = 
	[NSNotification notificationWithName:notificationName
								  object:self
								userInfo:dict];
	
	[center postNotification:notification];
}



@end
