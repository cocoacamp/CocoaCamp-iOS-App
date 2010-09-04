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
#import "ContactExchangeViewController.h"
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
	[map from:@"tt://people" toViewController:[ContactExchangeViewController class]];
	
	//if (![navigator restoreViewControllers]) {
		[navigator openURLAction:[TTURLAction actionWithURLPath:@"tt://tabs"]];
	//}
	
    /*
	[window addSubview:tabBarController.view];
    [window makeKeyAndVisible];
	*/
	[self initializeBump];
	return YES;
}

- (void)initializeBump {
	bump = [[Bump alloc] init];
	[bump configAPIKey:@"d8eac91285fa4abfa421c0051a7c0d22"]; 
	[bump setDelegate:self]; 
	[bump configHistoryMessage:@"%1 exchanged contacts with %2"]; 
	[bump configActionMessage:@"Bump with another attendee to swap contacts."];
}

- (void) bumpDidConnect {
	NSLog(@"Bump successfully connected");
}

- (void) bumpDidDisconnect:(BumpDisconnectReason)reason {
	NSLog(@"Bump disconnected for reason %d", reason);
}

- (void) bumpConnectFailed:(BumpConnectFailedReason)reason {
	NSLog(@"Bump connect failed for reason %d", reason);
}

- (void) bumpContactExchangeSuccess:(BumpContact *)contact {
	NSLog(@"Received a contact via exchange. Will save to address book...");
	[[ContactManager sharedInstance] addContactForBumpContact:contact];
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

