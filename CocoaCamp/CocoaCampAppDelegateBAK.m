//
//  CocoaCampAppDelegate.m
//  CocoaCamp
//
//  Created by Jonathan Freeman on 7/12/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "CocoaCampAppDelegate.h"
#import "ContactManager.h"
#import "SessionViewController.h"
#import "FlickrThumbnailView.h"
#import "AttendeeListViewController.h"
#import "TwitterFeedTableViewController.h"
#import "TabController.h"

@implementation CocoaCampAppDelegate
@synthesize window;
@synthesize tabBarController;
@synthesize bump;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
	TTNavigator* navigator = [TTNavigator navigator];
	navigator.supportsShakeToReload = YES;
	navigator.persistenceMode = TTNavigatorPersistenceModeAll;
	
	TTURLMap* map = navigator.URLMap;
	[map from:@"*" toViewController:[TTWebController class]];
	[map from:@"tt://tabs" toViewController:[TabController class]];
	[map from:@"tt://schedule" toViewController:[SessionViewController class]];
	[map from:@"tt://flickr" toViewController:[FlickrThumbnailView class]];
	[map from:@"tt://people" toViewController:[AttendeeListViewController class]];
	[map from:@"tt://twitter" toViewController:[TwitterFeedTableViewController class]];
	
	[navigator openURLAction:[TTURLAction actionWithURLPath:@"tt://tabs"]];
	
	[self initializeBump];
	return YES;
}

- (void)initializeBump {
	bump = [[Bump alloc] init];
	[bump configAPIKey:@"e2c02bad55a14a129ca2498a4c20e924"]; 
	[bump configHistoryMessage:@"%1 exchanged contacts with %2"]; 
	[bump configActionMessage:@"Bump with another attendee to swap contacts."];
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
}

- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed {
}

- (void)dealloc {
    [tabBarController release];
    [window release];
    [super dealloc];
}

@end

