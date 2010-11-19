//
//  Event.h
//  AgendaiPhone
//
//  Created by Tiago Melo on 11/19/10.
//  Copyright 2010 BlackCode. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Event : NSObject {
	
	NSString *artist;
	NSString *location;
	NSDate *date;
	NSURL *linkURL;
	NSURL *imageURL;

}


@property (nonatomic, retain) NSString *artist;
@property (nonatomic, retain) NSString *location;
@property (nonatomic, retain) NSDate *date;
@property (nonatomic, retain) NSURL *linkURL;
@property (nonatomic, retain) NSURL *imageURL;

@end
