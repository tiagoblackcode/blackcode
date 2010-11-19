//
//  ParseHighlightsOperation.m
//  AgendaiPhone
//
//  Created by Tiago Melo on 11/12/10.
//  Copyright 2010 BlackCode. All rights reserved.
//

#import "ParseHighlightsOperation.h"
#import "NSObject+Delegation.h"
#import "DocumentRoot.h"

#import "Event.h"

@implementation ParseHighlightsOperation


- (void)main
{
	
	if( self.isCancelled ) return; 
	
	[self informTargetOnMainThread:delegate 
						  selector:@selector(parseOperationDidBegin:)];
	
	//MAIN CODE
	
	NSLog(@"Starting ParseHighlightsOperation");
	[self doTheThing];
	//NSLog(@"BaseURL:%@", baseURL);
	//NSLog(@"DataSize: %d", [data length]);
	
	[self informTargetOnMainThread:delegate 
						  selector:@selector(parseOperationDidEnd:)];	
}


- (void)doTheThing
{
	
	NSString *html = 
	[[NSString alloc] initWithData:data 
						  encoding:NSUTF8StringEncoding];
	
	
	DocumentRoot *root = [Element parseHTML:html];
	
	Element *contents = [root selectElement:@"body div#content_wrapper div#content"];	
	if( contents == nil ) {
		NSLog(@"There was an error in parsing");
	}
	
	[elements removeAllObjects];
	
	
	Element *highlight_link = [contents selectElement:@"a#highlight_link"];
	Element *highlight = [highlight_link selectElement:@"div#highlight"];
	Element *dateElement = [highlight selectElement:@"div.highlight_date"];
	Element *details = [highlight selectElement:@"div.highlight_details"];
	
	
	NSString *imageLink = [highlight attribute:@"style"];
	NSArray *sub = [imageLink componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"()"]];	
	imageLink = [sub objectAtIndex:[sub count]-2];
	
	
	NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
	[inputFormatter setDateFormat:@"dd MMM yyyy"];
	
	
	NSString *day = [[dateElement selectElement:@"div.highlight_date_day"] contentsSource];
	NSString *month = [[dateElement selectElement:@"div.highlight_date_month"] contentsSource];
	NSString *year = @"2010";
	
	NSString *strDate = [[NSString alloc] initWithFormat:@"%@ %@ %@", day, month, year];
	NSDate *date = [inputFormatter dateFromString:strDate];
	
	
	NSLog(@"imageLink: %@", imageLink);
	NSLog(@"link: %@", [[baseURL absoluteString] stringByAppendingFormat:@"%@", [highlight_link attribute:@"href"]]);
	NSLog(@"artist: %@", [[details selectElement:@"div.highlight_details_artist"] contentsSource]);
	NSLog(@"location: %@", [[details selectElement:@"div.highlight_details_location"] contentsSource]);
	NSLog(@"date: %@", date);
	NSLog(@"");
	
	Event *	new = [[Event alloc] init];
	[new setArtist:[[details selectElement:@"div.highlight_details_artist"] contentsSource]];
	[new setLocation:[[details selectElement:@"div.highlight_details_location"] contentsSource]];
	[new setDate:date];
	[new setLinkURL:[NSURL URLWithString:[highlight_link attribute:@"href"] relativeToURL:baseURL]];
	[new setImageURL:[NSURL URLWithString:imageLink]];
	
	[elements addObject:new];
	
	//Highlight *hl = [[Highlight alloc] init];
	//[hl setImageLink:imageLink];
	//[hl setLink:[baseURL stringByAppendingFormat:@"%@", [highlight_link attribute:@"href"]]];
	//[hl setArtist:[[details selectElement:@"div.highlight_details_artist"] contentsSource]];
	//[hl setLocation:[[details selectElement:@"div.highlight_details_location"] contentsSource]];
	//[hl setDate:date];
	//[elements addObject:hl];
	
	
	
	highlight = [contents selectElement:@"div.small_highlights_wrapper"];
	NSArray *smallHighlights = [highlight selectElements:@"a"];
	
	for( Element *e in smallHighlights ) {
		
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		
		imageLink = [[e selectElement:@"div"] attribute:@"style"];
		sub = [imageLink componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"()"]];
		imageLink = [sub objectAtIndex:[sub count]-2];
		
		
		
		NSArray *tokens = [[[e selectElement:@"div div"] contentsSource] componentsSeparatedByString:@"</div>"];
		NSString *artist = [tokens objectAtIndex:[tokens count]-1];
		artist = [artist stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		
		

		[new release];
		new = [[Event alloc] init];
		[new setArtist:artist];
		[new setLocation:[[e selectElement:@"div div div"] contentsSource]];
		[new setDate:nil];
		[new setLinkURL:[NSURL URLWithString:[e attribute:@"href"] relativeToURL:baseURL]];
		[new setImageURL:[NSURL URLWithString:imageLink]];
		
		
		[elements addObject:new];
		//NSLog(@"imageLink: %@", imageLink);
		//NSLog(@"link: %@", [[baseURL absoluteString] stringByAppendingFormat:@"%@", [e attribute:@"href"]]);
		//NSLog(@"artist: %@", artist);
		//NSLog(@"location: %@", [[e selectElement:@"div div div"] contentsSource]);
		//NSLog(@"date: %@", nil);
		//NSLog(@"");
		
		//[hl release];
		//hl = [[Highlight alloc] init];
		
		//[hl setImageLink:imageLink];
		//[hl setLink:[baseURL stringByAppendingFormat:@"%@", [e attribute:@"href"]]];
		//[hl setArtist:artist];
		//[hl setLocation:[[e selectElement:@"div div div"] contentsSource]];
		
		
		
		
		//[highlights addObject:hl];
		
		
		[pool drain];
	}
	
	NSLog(@"elems %@", elements);

}





@end
