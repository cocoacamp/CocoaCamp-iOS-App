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
#import "CCBranding.h"


@implementation RegistrantDetailViewController
@synthesize headerView;
@synthesize currRegistrant, nameLabel, loading;


NSString *AppUserRegistrantIDKey = @"AppUserRegistrantIDKey";

#pragma mark -
#pragma mark View lifecycle

- (void) viewWillAppear:(BOOL)animated{
	self.loading.hidden = YES;
}

- (void)updateTableViewWithHeaderIfPresent{
    CCBranding *branding = [[CCBranding alloc] init];
    UIView *configuredHeaderView = [branding headerView];
    if (configuredHeaderView) {
        [[self headerView] addSubview:configuredHeaderView];
    }
}

- (void) viewDidLoad
{

	
	NSString *regName = [NSString stringWithFormat: @"Hi, %@ %@!", currRegistrant.firstName, currRegistrant.lastName];
	
	nameLabel.text = regName;
	
	self.navigationItem.title = regName;
	[self storeCurrentProfileAsIdentity];
    
    [self updateTableViewWithHeaderIfPresent];

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
    [self setHeaderView:nil];
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [currRegistrant release];
	[nameLabel release];
    [headerView release];
	[super dealloc];
}



#pragma mark -
#pragma mark Contact exchange methods

- (IBAction)initiateContactExchange:(id)sender {
	[self performContactExchange];
}

- (Bump *)bump{
	return [(CocoaCampAppDelegate *)[[UIApplication sharedApplication] delegate] bump];
}

- (void)performContactExchange {
	isExchanging = YES;
	Bump *bump = self.bump;
	[bump configParentView:self.view];
	[bump setDelegate:self];
	[bump connect];
	self.loading.hidden = NO;
	[self.loading startAnimating];
}

- (void) bumpDidConnect {
	NSLog(@"Bump successfully connected");
	NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.currRegistrant];
	[self.bump send:data];
}

- (void) bumpDidDisconnect:(BumpDisconnectReason)reason {
	if (!isExchanging) return;
	NSLog(@"Bump disconnected for reason %d", reason);
	if (reason != END_USER_QUIT){
		[self bumpFailed];
	}
	self.loading.hidden = YES;
	[self.loading stopAnimating];
}

- (void) bumpConnectFailed:(BumpConnectFailedReason)reason {
	if (!isExchanging) return;
	NSLog(@"Bump connect failed for reason %d", reason);
	if (reason != FAIL_USER_CANCELED && reason != FAIL_NETWORK_UNAVAILABLE){
		[self bumpFailed];
	}
	self.loading.hidden = YES;
	[self.loading stopAnimating];
}

- (void) bumpDataReceived:(NSData *)chunk{
	self.loading.hidden = YES;
	[self.loading stopAnimating];
	isExchanging = NO;
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

