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
@synthesize currRegistrant, nameLabel, loading;


NSString *AppUserRegistrantIDKey = @"AppUserRegistrantIDKey";

#pragma mark -
#pragma mark View lifecycle

- (void) viewWillAppear:(BOOL)animated{
	self.loading.hidden = YES;
}

- (void) viewDidLoad
{

	
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

- (Bump *)bump{
	return [(CocoaCampAppDelegate *)[[UIApplication sharedApplication] delegate] bump];
}

- (void)performContactExchange {
	NSNumber *appUserRegistrantID = [[NSUserDefaults standardUserDefaults] objectForKey:AppUserRegistrantIDKey];
	
	if(!appUserRegistrantID)
	{
		NSLog(@"Did not receive a valid registrant id in performContactExchange. Bailing...");
		return;
	}
	Registrant *appUser = self.currRegistrant;
	Bump *bump = self.bump;
	[bump configParentView:self.view];
	[bump setDelegate:self];
	//[bump connectToDoContactExchange:bumpContact];
	[bump connect];
	[appUser release];
	self.loading.hidden = NO;
	[self.loading startAnimating];
}

- (void) bumpDidConnect {
	NSLog(@"Bump successfully connected");
	NSData *data = [NSKeyedArchiver archivedDataWithRootObject:currRegistrant];
	[self.bump send:data];
}

- (void) bumpDidDisconnect:(BumpDisconnectReason)reason {
	NSLog(@"Bump disconnected for reason %d", reason);
	if (reason != END_USER_QUIT){
		[self bumpFailed];
	}
	self.loading.hidden = YES;
	[self.loading stopAnimating];
}

- (void) bumpConnectFailed:(BumpConnectFailedReason)reason {
	NSLog(@"Bump connect failed for reason %d", reason);
	if (reason != FAIL_USER_CANCELED){
		[self bumpFailed];
	}
	self.loading.hidden = YES;
	[self.loading stopAnimating];
}

- (void) bumpDataReceived:(NSData *)chunk{
	Registrant *contact = [NSKeyedUnarchiver unarchiveObjectWithData:chunk];
	NSLog(@"Got contact: %@, %@, %@", contact.firstName, contact.lastName, contact.email);
	
	NSError *failed = [contact saveAddressBookContact];
	if (failed){
		[self bumpFailed];
	}else {
		NSString *message = [NSString stringWithFormat:@"%@ has been saved to your address book!", contact.fullName];
		UIAlertView *alert = [[UIAlertView alloc] 
							  initWithTitle:@"" 
							  message:message
							  delegate:nil 
							  cancelButtonTitle:@"Hooray!" 
							  otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	
	self.loading.hidden = YES;
	[self.loading stopAnimating];
}

- (void)bumpFailed{
	self.loading.hidden = YES;
	[self.loading stopAnimating];
	UIAlertView *alert = [[UIAlertView alloc] 
						  initWithTitle:@"Sorry" 
						  message:@"I had some trouble exchanging contacts. I Don't know what to say. Use pen and paper?"
						  delegate:nil 
						  cancelButtonTitle:@"Bummer, man!" 
						  otherButtonTitles:nil];
	[alert show];
	[alert release];
}
@end

