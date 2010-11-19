//
//  HighlightsTableViewController.m
//  AgendaiPhone
//
//  Created by Tiago Melo on 9/15/10.
//  Copyright 2010 BlackCode. All rights reserved.
//

#import "HighlightsTableViewController.h"

#import "ConcertAgenda.h"
#import "Event.h"

@implementation HighlightsTableViewController


#pragma mark -
#pragma mark Initialization

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if ((self = [super initWithStyle:style])) {
    }
    return self;
}
*/


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	
	//[self.navigationController setNavigationBarHidden:YES];
	self.navigationItem.title = @"Highlights";
	
	dict = [[NSMutableDictionary alloc] init];
	items = [[NSMutableArray alloc] init];
	itemsCopy = [[NSMutableArray alloc] init];
	
	
	ConcertAgenda *concertAgenda = [ConcertAgenda sharedInstance];
	
	
	
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc addObserver:self
		   selector:@selector(didBeginUpdate:) 
			   name:@"didBeginUpdate" 
			 object:concertAgenda];
	
	[nc addObserver:self 
		   selector:@selector(didEndUpdate:) 
			   name:@"didEndUpdate" 
			 object:concertAgenda];

	
	[concertAgenda update];
}

- (void)didBeginUpdate:(NSNotification*)notification
{
	
	NSLog(@"didBeginUpdate from highlightsTableViewController");	
	
}

- (void)didEndUpdate:(NSNotification*)notification
{
	
	NSLog(@"didEndUpdate from highlightsTableViewController");
	
	[dict removeAllObjects];
	NSArray *array = [[ConcertAgenda sharedInstance] highlights];
	for( Event *e in array ) {
		
		NSMutableArray *specific = [dict objectForKey:e.location];
		if( !specific ) {
			
			specific = [[NSMutableArray alloc] init];
			[dict setObject:specific forKey:e.location];
			[specific release];
		}
		
		[specific addObject:e];
	}
	
	
	[itemsCopy removeAllObjects];
	[itemsCopy addObjectsFromArray:[[dict allKeys] sortedArrayUsingSelector:@selector(compare:)]];
	
	[items removeAllObjects];
	[items addObjectsFromArray:array];
	
//	[items release];
//	items = [[[ConcertAgenda sharedInstance] highlights] retain];
	[self.tableView reloadData];
//	[[self parentViewController].view setNeedsDisplay];
	
}




/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [itemsCopy count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [[dict objectForKey:[itemsCopy objectAtIndex:section]] count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	
	
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle 
									   reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
	NSArray *sub = [dict objectForKey:[itemsCopy objectAtIndex:indexPath.section]];
	Event *event = [sub objectAtIndex:indexPath.row];
	
    [[cell textLabel] setText:[event artist]];
	[[cell detailTextLabel] setText:[event location]];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
		return [itemsCopy objectAtIndex:section];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	/*
	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end

