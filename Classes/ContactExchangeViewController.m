//
//  FirstViewController.m
//  CocoaCamp
//
//  Created by Jonathan Freeman on 7/12/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "ContactExchangeViewController.h"
#import "CocoaCampAppDelegate.h"
#import "ContactManager.h"

@implementation ContactExchangeViewController

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
//    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
//    }
//    return self;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
}

- (void)dealloc {
    [super dealloc];
}

- (IBAction)initiateContactExchange:(id)sender { 
	if(ownerContact)
	{
		[self performContactExchange];
	}
	else
	{
		ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
		picker.peoplePickerDelegate = self;
		[self presentModalViewController:picker animated:YES];
		[picker release];
	}
}

- (void)performContactExchange {
	BumpContact *bumpContact = BumpContactForAddressBookRecord(ownerContact);
	Bump *bump = [(CocoaCampAppDelegate *)[[UIApplication sharedApplication] delegate] bump];
	[bump configParentView:self.view];
	[bump connectToDoContactExchange:bumpContact];
}

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
	[self dismissModalViewControllerAnimated:YES];
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker 
	  shouldContinueAfterSelectingPerson:(ABRecordRef)person 
{
	ownerContact = CFRetain(person);
    [self dismissModalViewControllerAnimated:YES];
	[self performContactExchange];
	return NO;
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker 
	  shouldContinueAfterSelectingPerson:(ABRecordRef)person 
								property:(ABPropertyID)property 
							  identifier:(ABMultiValueIdentifier)identifier 
{
	return NO;
}

@end
