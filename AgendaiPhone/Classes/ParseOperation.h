//
//  ParseOperation.h
//  AgendaiPhone
//
//  Created by Tiago Melo on 11/12/10.
//  Copyright 2010 BlackCode. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ParseOperation : NSOperation {
	
	NSData *data;
	id delegate;
	
	NSMutableArray *elements;
	NSURL *baseURL;

}



@property (nonatomic, assign) id delegate;
@property (nonatomic, readonly) NSMutableArray *elements;
@property (nonatomic, retain) NSData *data;
@property (nonatomic, retain) NSURL* baseURL;


//- (void)parseOperationDidBegin:(ParseOperation*)operation;
//- (void)parseOperationDidEnd:(ParseOperation*)operation;
//- (void)parseOperation:(ParseOperation*)operation didFailWithError:(NSError*)error;

@end
