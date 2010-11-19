//
//  AgendaiPhoneAppDelegate.m
//  AgendaiPhone
//
//  Created by Tiago Melo on 9/6/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "AgendaiPhoneAppDelegate.h"


#import "HighlightsTableViewController.h"
#import "ConcertAgenda.h"

@implementation AgendaiPhoneAppDelegate

@synthesize window;
@synthesize tabBarController;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
	tableViewController = [[HighlightsTableViewController alloc] init];

	ConcertAgenda *agenda = [ConcertAgenda sharedInstance];
	[agenda setDelegate:self];
		
	UIView *view = [[UIView alloc] initWithFrame:[window frame]];
	[view setBackgroundColor:[UIColor lightGrayColor]];
	UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	
	button.frame = CGRectMake(window.frame.size.width/2-50, 50, 100, 30);
	
	[button setTitle:@"Hello" 
			forState:(UIControlStateNormal | 
					  UIControlStateHighlighted | 
					  UIControlStateDisabled | 
					  UIControlStateSelected)];
	
	[button setTitleColor:[UIColor blackColor]
			forState:(UIControlStateNormal | 
					  UIControlStateHighlighted | 
					  UIControlStateDisabled | 
					  UIControlStateSelected)];
	 
	[button addTarget:self 
			   action:@selector(update:) 
	 forControlEvents:UIControlEventTouchUpInside];
	
	
	
	HighlightsTableViewController *table = 
	[[HighlightsTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
	
	[table.view setFrame:CGRectMake(10, 100, window.frame.size.width-20, window.frame.size.height-120)];
	
	[view addSubview:table.view];
	[view addSubview:button];
	
	
	
    // Add the tab bar controller's view to the window and display.	
    [window addSubview:view];
    [window makeKeyAndVisible];

    return YES;
}

- (void)update:(id)sender
{
	
	ConcertAgenda *agenda = [ConcertAgenda sharedInstance];
	[agenda update];
	
}

- (void)agendaDidBeginUpdate:(ConcertAgenda*)agenda
{
	NSLog(@"%@ %s%@", self, _cmd, agenda);
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
}

- (void)agenda:(ConcertAgenda*)agenda didFailWithError:(NSError*)theError
{
	NSLog(@"%@ %s%@ %@", self, _cmd, agenda, theError);
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Coiso" 
													message:[theError localizedDescription]
												   delegate:nil 
										  cancelButtonTitle:@"OK" 
										  otherButtonTitles: nil];
	[alert show];
	[alert release];
	
}

- (void)agendaDidEndUpdate:(ConcertAgenda*)agenda
{
	NSLog(@"%@ %s%@", self, _cmd, agenda);
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
}



- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark UITabBarControllerDelegate methods

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed {
}
*/


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    [tabBarController release];
    [window release];
    [super dealloc];
}

@end

