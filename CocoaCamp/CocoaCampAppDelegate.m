//
//  CocoaCampAppDelegate.m
//  CocoaCamp
//
//  Created by Rusty Zarse on 8/2/11.
//  Copyright 2011 LeVous, LLC. All rights reserved.
// 

#import "CocoaCampAppDelegate.h"
#import "ContactManager.h"
#import "SessionViewController.h"
#import "FlickrThumbnailView.h"
#import "AttendeeListViewController.h"
#import "TwitterFeedTableViewController.h"
#import "TabController.h"
#import "RssNewsViewController.h"

@implementation CocoaCampAppDelegate

@synthesize window = _window, tabBarController, bump;

- (void)initializeBump {
	bump = [[Bump alloc] init];
	[bump configAPIKey:@"e2c02bad55a14a129ca2498a4c20e924"]; 
	[bump configHistoryMessage:@"%1 exchanged contacts with %2"]; 
	[bump configActionMessage:@"Bump with another attendee to swap contacts."];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    TTNavigator* navigator = [TTNavigator navigator];
	navigator.supportsShakeToReload = YES;
	navigator.persistenceMode = TTNavigatorPersistenceModeAll;
	
    // force init
    [[CoreDataManager sharedUIThreadInstance] managedObjectContext];
    
	TTURLMap* map = navigator.URLMap;
	[map from:@"*" toViewController:[TTWebController class]];
	[map from:@"tt://tabs" toViewController:[TabController class]];
	[map from:@"tt://schedule" toViewController:[SessionViewController class]];
	[map from:@"tt://flickr" toViewController:[FlickrThumbnailView class]];
	[map from:@"tt://people" toViewController:[AttendeeListViewController class]];
	[map from:@"tt://twitter" toViewController:[TwitterFeedTableViewController class]];
	[map from:@"tt://news" toViewController:[RssNewsViewController class]];
	
	[navigator openURLAction:[TTURLAction actionWithURLPath:@"tt://tabs"]];
	
	[self initializeBump];
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application{
    NSString *something = @"";
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

@end
