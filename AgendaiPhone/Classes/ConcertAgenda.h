//
//  ConcertAgenda.h
//  AgendaiPhone
//
//  Created by Tiago Melo on 11/15/10.
//  Copyright 2010 BlackCode. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ConcertAgenda : NSObject {
	
	NSDate *updateTime;
	
	
	NSMutableArray *highlights;
	NSMutableArray *concerts;
	NSMutableArray *pendingOperations;
	NSMutableArray *connectionPool;
	NSOperationQueue *parseQueue;
	
	id delegate;

}

+ (id)sharedInstance;

@property (nonatomic, assign) id delegate;
@property (nonatomic, readonly) NSDate *updateTime;
@property (nonatomic, readonly) NSArray *highlights;
@property (nonatomic, readonly) NSArray *concerts;

- (void)update;
- (void)cancelAllDownloads;
- (void)cancelAllOperations;

//- (NSUInteger)downloadCount;
//- (void)cancel:(NSURLRequest*)request;


//- (void)agendaDidBeginUpdate:(ConcertAgenda*)agenda;
//- (void)agenda:(ConcertAgenda*) didFailWithError:(NSError*)theError;
//- (void)agendaDidEndUpdate:(ConcertAgenda*)agenda;
@end
