//
//  AttendeeListViewController.m
//  CocoaCamp
//
//  Created by Alondo Brewington on 8/22/10.
//  Copyright 2010 DT Squared Software. All rights reserved.
//

#import "AttendeeListViewController.h"
#import "CocoaCampAppDelegate.h"
#import "RegistrantDetailViewController.h"
#import "ContactManager.h"
#import <Three20/Three20.h>
#import "JSON.h"
#import "Bump.h"

NSString *AppUserRegistrantIDKey = @"AppUserRegistrantIDKey";

@implementation AttendeeListViewController
@synthesize attendees, responseData, dictRegistrant;

#pragma mark -
#pragma mark Initialization

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if ((self = [super initWithStyle:style])) {
    }
    return self;
}
*/


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
	
    [super viewDidLoad];
	
	// Uncomment this to see how the table looks with the grouped style
	//self.tableViewStyle = UITableViewStyleGrouped;
	
	// Uncomment this to see how the table cells look against a custom background color
	//self.tableView.backgroundColor = [UIColor yellowColor];
	
	// This demonstrates how to create a table with standard table "fields".  Many of these
	// fields with URLs that will be visited when the row is selected
	
	//Initialize the array.
	responseData = [[NSMutableData data] retain];
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://cocoa:camp@cocoacamp.org/registers/json?user_name=cocoa&password=camp"]];
	[[NSURLConnection alloc] initWithRequest:request delegate:self ];
	presenterIcon = [UIImage imageNamed:@"keynote-icon.png"];
	[self.tableView reloadData];
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}



- (void)viewWillAppear:(BOOL)animated {	
    [super viewWillAppear:animated];
	//Set the title
	self.navigationItem.title = @"Attendees";	
	[self.tableView reloadData];
}

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

#pragma mark -
#pragma mark WebService 
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	//NSLog(@"Got a response") ;
	[responseData setLength:0];
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Connection failed: %@", [error description]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    //[connection release];
	
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    [responseData release];
	
	//Parsing the response data as an array
	NSArray *response = [responseString JSONValue];
	
  	NSMutableArray *listRegistrant = [[NSMutableArray alloc] initWithArray:response];
	
	int index = 0;
	NSDictionary* currentReg = nil;
	NSMutableArray *listAttendees = [[NSMutableArray alloc] initWithObjects:nil];
	
	
	for (index = 0; index < [listRegistrant count]; index++)
	{
		currentReg = [listRegistrant objectAtIndex:index];
		NSDictionary* dictCurrRegData = [currentReg objectForKey:@"Register"];
		
		NSString *regName = [dictCurrRegData objectForKey:@"first_name"];
		regName = [regName stringByAppendingString:@" "];
		regName = [regName stringByAppendingString:[dictCurrRegData objectForKey:@"last_name"]];
		
		[listAttendees addObject:dictCurrRegData];
		
	}
	
	NSSortDescriptor *lnameDesc = [[NSSortDescriptor alloc] initWithKey:@"last_name" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)];
	NSSortDescriptor *fnameDesc = [[NSSortDescriptor alloc] initWithKey:@"first_name" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)];
	
	[listAttendees sortUsingDescriptors:[NSMutableArray arrayWithObjects: fnameDesc, lnameDesc, nil]];
	//[listAttendees sortUsingDescriptors:[NSMutableArray arrayWithObjects:fnameDesc, nil]];
	[lnameDesc release], lnameDesc = nil;
	[fnameDesc release], fnameDesc = nil;
	
	self.attendees = listAttendees;
	NSLog(@"%@ attendees",  [NSString stringWithFormat:@"%d", [self.attendees count]]);

	[listAttendees release];
	
	[self.tableView reloadData];
	
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
	NSDictionary *appUserDictionary = nil;
	
	if(!appUserRegistrantID)
	{
		NSLog(@"Did not receive a valid registrant id in performContactExchange. Bailing...");
		return;
	}
	
	// walk the list of attendees to find the current user. *sigh*
	for(NSDictionary *attendee in attendees)
	{
		if([[attendee valueForKey:@"id"] isEqual:[appUserRegistrantID stringValue]])
			appUserDictionary = attendee; // got lucky
	}
	
	if(appUserDictionary)
	{
		Registrant *appUser = [[Registrant alloc] init];
		appUser.firstName = [appUserDictionary objectForKey:@"first_name"];
		appUser.lastName = [appUserDictionary objectForKey:@"last_name"];
		appUser.company = [appUserDictionary objectForKey:@"company"];
		appUser.twitter = [appUserDictionary objectForKey:@"twitter"];
		appUser.industry = [appUserDictionary objectForKey:@"industry"];
		appUser.email = [appUserDictionary objectForKey:@"email"];
		appUser.rid = [NSNumber numberWithInt:[[appUserDictionary objectForKey:@"id"] integerValue]];
		
		BumpContact *bumpContact = [[ContactManager sharedInstance] bumpContactForRegistrant:appUser];
		Bump *bump = [(CocoaCampAppDelegate *)[[UIApplication sharedApplication] delegate] bump];
		[bump configParentView:self.view];
		[bump connectToDoContactExchange:bumpContact];
		
		[appUser release];
	}
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [attendees count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
	// Configure the cell...
	NSDictionary* currentReg = [attendees objectAtIndex:indexPath.row];
	
	NSString *regName = [currentReg objectForKey:@"first_name"];
	regName = [regName stringByAppendingString:@" "];
	regName = [regName stringByAppendingString:[currentReg objectForKey:@"last_name"]];		

	// add icon if presenting
	NSString *presenter = [currentReg objectForKey:@"present"];
	if ([presenter isEqualToString:@"1"]){
		[[cell imageView] setImage:presenterIcon];
	}else {
		[[cell imageView] setImage:nil];
	}

		
	[[cell textLabel] setText: regName];
    [[cell detailTextLabel] setText:[currentReg objectForKey:@"company"]];
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	
	 RegistrantDetailViewController *detailViewController = [[RegistrantDetailViewController alloc] initWithNibName:@"RegistrantDetailView" bundle:nil];
	
	NSDictionary* currentReg = [attendees objectAtIndex:indexPath.row];
	
	NSString *regName = [currentReg objectForKey:@"first_name"];
	regName = [regName stringByAppendingString:@" "];
	regName = [regName stringByAppendingString:[currentReg objectForKey:@"last_name"]];
	
	Registrant *reg = [[Registrant alloc] init];
	
	reg.firstName = [currentReg objectForKey:@"first_name"];
	reg.lastName = [currentReg objectForKey:@"last_name"];
	reg.company = [currentReg objectForKey:@"company"];
	reg.twitter = [currentReg objectForKey:@"twitter"];
	reg.industry = [currentReg objectForKey:@"industry"];
	reg.email = [currentReg objectForKey:@"email"];
	reg.rid = [NSNumber numberWithInt:[[currentReg objectForKey:@"id"] integerValue]];
	
	NSLog(@"Attendee selected: %@ %@", reg.firstName, reg.lastName);
	
	detailViewController.currRegistrant = reg;
	// Pass the selected object to the new view controller.
	[self.navigationController pushViewController:detailViewController animated:YES];
	[detailViewController release];
	
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
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
	[responseData release];
	[dictRegistrant release];
	[attendees release];
    [super dealloc];
}


@end

