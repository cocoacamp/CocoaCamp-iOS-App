//
//  FirstViewController.m
//  CocoaCamp
//
//  Created by Jonathan Freeman on 7/12/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "FirstViewController.h"
#import "CocoaCampAppDelegate.h"
#import "ContactManager.h"

@implementation FirstViewController

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
	BumpContact *contact = [[BumpContact alloc] init]; 
	contact.image = [UIImage imageNamed:@"someimage.png"]; 
	contact.firstName = @"John"; 
	contact.middleName = @"T.";
	contact.lastName = @"Appleseed"; 
	contact.prefix = @"Mr."; 
	contact.suffix = @"Esquire"; 
	contact.companyName = @"Bump"; 
	contact.department = @"Engineering"; 
	contact.jobTitle = @"Software Engineer";
	NSMutableArray *email_list = [[NSMutableArray alloc] initWithCapacity:3]; 
	NSMutableDictionary* email_addr = [[NSMutableDictionary alloc] initWithCapacity:2]; 
	[email_addr setObject:@"api@bu.mp" forKey:BUMP_EMAIL_ADDRESS]; 
	[email_addr setObject:BUMP_FIELD_TYPE_WORK forKey:BUMP_FIELD_TYPE];
	[email_list addObject:email_addr]; 
	[email_addr release];
	email_addr = [[NSMutableDictionary alloc] initWithCapacity:2]; 
	[email_addr setObject:@"someone@g.com" forKey:BUMP_EMAIL_ADDRESS]; 
	[email_addr setObject:BUMP_FIELD_TYPE_HOME forKey:BUMP_FIELD_TYPE]; 
	[email_list addObject:email_addr];
	[email_addr release]; 
	contact.emailAddresses = email_list;
	
	Bump *bump = [(CocoaCampAppDelegate *)[[UIApplication sharedApplication] delegate] bump];
	[bump configParentView:self.view];
	[bump connectToDoContactExchange:contact];
}

@end
