//
//  RegistrantDetailViewController.m
//  CocoaCamp
//
//  Created by Alondo Brewington on 8/22/10.
//  Copyright 2010 DT Squared Software, LLC. All rights reserved.
//

#import "RegistrantDetailViewController.h"
#import "Registrant.h"
#import "ContactManager.h"
#import "Bump.h"
#import "CocoaCampAppDelegate.h"



@implementation RegistrantDetailViewController
@synthesize currRegistrant, nameLabel;


NSString *AppUserRegistrantIDKey = @"AppUserRegistrantIDKey";

#pragma mark -
#pragma mark View lifecycle



- (void) viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];

	
	NSString *regName = [NSString stringWithFormat: @"Hi, %@ %@!", currRegistrant.firstName, currRegistrant.lastName];
	
	nameLabel.text = regName;
	
	self.navigationItem.title = regName;
	[self storeCurrentProfileAsIdentity];

}

- (void)storeCurrentProfileAsIdentity {
	[[NSUserDefaults standardUserDefaults] setObject:currRegistrant.rid forKey:AppUserRegistrantIDKey];
	NSLog(@"Wrote %@ to defaults as registrant ID for current user.", currRegistrant.rid);
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
    [currRegistrant release];
	[nameLabel release];
	[super dealloc];
}



#pragma mark -
#pragma mark Contact exchange methods

- (IBAction)initiateContactExchange:(id)sender {
	NSNumber *appUserRegistrantID = [[NSUserDefaults standardUserDefaults] objectForKey:AppUserRegistrantIDKey];
	if(appUserRegistrantID)
	{
		[self performContactExchange];
	}
	else
	{
		UIAlertView *noIdentityAlertView = [[UIAlertView alloc] initWithTitle:@"No User Identity" 
																	  message:@"Please set your identity by tapping \"This Is Me!\" in your attendee profile" 
																	 delegate:self 
															cancelButtonTitle:@"Got it" 
															otherButtonTitles:nil];
		[noIdentityAlertView show];
		[noIdentityAlertView release];
	}
}

- (void)performContactExchange {
	NSNumber *appUserRegistrantID = [[NSUserDefaults standardUserDefaults] objectForKey:AppUserRegistrantIDKey];
	
	if(!appUserRegistrantID)
	{
		NSLog(@"Did not receive a valid registrant id in performContactExchange. Bailing...");
		return;
	}
	Registrant *appUser = self.currRegistrant;
	BumpContact *bumpContact = [[ContactManager sharedInstance] bumpContactForRegistrant:appUser];
	Bump *bump = [(CocoaCampAppDelegate *)[[UIApplication sharedApplication] delegate] bump];
	[bump configParentView:self.view];
	[bump connectToDoContactExchange:bumpContact];
	
	[appUser release];
	
}

@end

