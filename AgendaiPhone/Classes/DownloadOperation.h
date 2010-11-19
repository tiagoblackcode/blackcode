//
//  DownloadOperation.h
//  AgendaiPhone
//
//  Created by Tiago Melo on 11/18/10.
//  Copyright 2010 BlackCode. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DownloadOperation : NSObject {

	NSString *name;
	
	NSMutableData *data;
	id delegate;
	
	NSURLConnection *connection;
	NSURLRequest *request;
	
	id userInfo;
	
}


@property (nonatomic, readonly) NSData *data;
@property (nonatomic, readonly) NSURLRequest *request;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) id userInfo;
@property (nonatomic, assign) id delegate;

- (id)initWithRequest:(NSURLRequest*)theRequest;
- (void)start;
- (void)cancel;

@end
