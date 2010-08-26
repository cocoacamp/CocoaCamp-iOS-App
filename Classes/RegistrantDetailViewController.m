//
//  RegistrantDetailViewController.m
//  CocoaCamp
//
//  Created by Alondo Brewington on 8/22/10.
//  Copyright 2010 DT Squared Software, LLC. All rights reserved.
//

#import "RegistrantDetailViewController.h"
#import "Registrant.h"


@implementation RegistrantDetailViewController
@synthesize currRegistrant, companyLabel, industryLabel, emailLabel, twitterLabel, nameLabel;

#pragma mark -
#pragma mark View lifecycle
			   
- (void) viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	NSString *regName = currRegistrant.firstName;
	regName = [regName stringByAppendingString:@" "];
	regName = [regName stringByAppendingString: currRegistrant.lastName];
	
	nameLabel.text = regName;
	
	NSLog(@"Name = %@ %@ %@", currRegistrant.firstName, currRegistrant.lastName, currRegistrant.company);
	companyLabel.text = currRegistrant.company;
	industryLabel.text = currRegistrant.industry;
	emailLabel.text = currRegistrant.email;
	twitterLabel.text = currRegistrant.twitter;	
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
	[companyLabel release]; 
	[industryLabel release];
	[emailLabel release];
	[twitterLabel release];
	[nameLabel release];
	[super dealloc];
}


@end

