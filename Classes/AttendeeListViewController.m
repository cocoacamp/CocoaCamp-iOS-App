//
//  AttendeeListViewController.m
//  CocoaCamp
//
//  Created by Alondo Brewington on 8/22/10.
//  Copyright 2010 DT Squared Software. All rights reserved.
//

#import "AttendeeListViewController.h"
#import "RegistrantDetailViewController.h"
#import <Three20/Three20.h>
#import "JSON.h"



@implementation AttendeeListViewController
@synthesize attendees, responseData, dictRegistrant, progressInd, attendeeIndex, lstGroupedAttendees;

#pragma mark -
#pragma mark Initialization

-(id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)bundle {
	if (self = [super initWithNibName:nibName bundle:bundle]){
		self.title = @"Hi! And you are...?";
		UIImage* image = [UIImage imageNamed:@"group.png"];
		self.tabBarItem = [[[UITabBarItem alloc] initWithTitle:@"People" image:image tag:0] autorelease];
		UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Not you?" style:UIBarButtonItemStylePlain target:nil action:nil];
		self.navigationItem.backBarButtonItem = backButton;
		
		[backButton release];
	}
	return self;
}

- (UIActivityIndicatorView *)progressInd {
	if (progressInd == nil)
	{
		CGRect frame = CGRectMake(self.view.frame.size.width/2-15, self.view.frame.size.height/2-15, 30, 30);
		progressInd = [[UIActivityIndicatorView alloc] initWithFrame:frame];
		[progressInd startAnimating];
		progressInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
		[progressInd sizeToFit];
		progressInd.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin |
										UIViewAutoresizingFlexibleRightMargin |
										UIViewAutoresizingFlexibleTopMargin |
										UIViewAutoresizingFlexibleBottomMargin);
		
		progressInd.tag = 1;    // tag this view for later so we can remove it from recycled table cells
	}
	return progressInd;
}

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
	if (responseData == nil){
		responseData = [[NSMutableData data] retain];
		NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://cocoa:camp@cocoacamp.org/registers/json?user_name=cocoa&password=camp"]];
		[[NSURLConnection alloc] initWithRequest:request delegate:self ];
		[self.view addSubview: self.progressInd];
	}
	presenterIcon = [UIImage imageNamed:@"keynote-icon.png"];

	//[self.tableView reloadData];
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	//NSLog(@"ViewWillAppear");
	[self.tableView reloadData];
}

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
	[self.progressInd removeFromSuperview];
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
		[listAttendees addObject:dictCurrRegData];
	}
	
	NSSortDescriptor *lnameDesc = [[NSSortDescriptor alloc] initWithKey:@"last_name" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)];
	NSSortDescriptor *fnameDesc = [[NSSortDescriptor alloc] initWithKey:@"first_name" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)];
	
	[listAttendees sortUsingDescriptors:[NSMutableArray arrayWithObjects: lnameDesc, fnameDesc, nil]];
	[lnameDesc release], lnameDesc = nil;
	[fnameDesc release], fnameDesc = nil;
	
	NSMutableArray *lstReg = [[NSMutableArray alloc] init];  
	self.lstGroupedAttendees = lstReg;
	[lstReg release];
	NSMutableArray *regIndex = [NSMutableArray new];
	NSMutableDictionary *lastUserRow = [[NSMutableDictionary alloc] init];
    NSMutableArray *usersAtThisIndex = [[NSMutableArray alloc] init];
	NSMutableDictionary *userRow = [[NSMutableDictionary alloc] init];
	NSString *prevChar = @"";
	for (NSDictionary *row in listAttendees) {		
		NSString *lastName = [row valueForKey:@"last_name"];
		char alphabet = [lastName characterAtIndex:0] ;
		NSString *currChar = [[NSString stringWithFormat:@"%C", alphabet] capitalizedString];
       
		if (![regIndex containsObject: currChar]){  
			// if there was a previous index of users, store them in the userRow array
			if ([usersAtThisIndex count] > 0)
			{
				[userRow setValue:prevChar forKey:@"headerTitle"];
				[userRow setValue:usersAtThisIndex forKey:@"rowValues"]; 
				[lstGroupedAttendees addObject:userRow];
				[usersAtThisIndex release];
				usersAtThisIndex = [[NSMutableArray alloc] init];
				[userRow release];
				userRow = [[NSMutableDictionary alloc] init];
			}
			
			// Create a new index
			[regIndex addObject: currChar];
			prevChar = currChar;
		}		
		[usersAtThisIndex addObject:row];
	}
	//Add last user index
	[lastUserRow setValue:prevChar forKey:@"headerTitle"];
	[lastUserRow setValue:usersAtThisIndex forKey:@"rowValues"];
	[lstGroupedAttendees addObject:lastUserRow];
	[lastUserRow release];
	 
	attendeeIndex = [[lstReg valueForKey:@"headerTitle"] retain];
	//NSLog(@"%@", lstGroupedAttendees);
	//NSLog(@"%@", attendeeIndex);
	self.attendees = listAttendees;
	[listAttendees release];
	[self.tableView reloadData];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return [lstGroupedAttendees count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	return [[[lstGroupedAttendees objectAtIndex:section] objectForKey:@"rowValues"] count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
       cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
	// Configure the cell...
	NSDictionary* currentReg = [[[lstGroupedAttendees objectAtIndex:indexPath.section] objectForKey:@"rowValues"]
												   objectAtIndex:indexPath.row];
	
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


-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
	return [lstGroupedAttendees valueForKey:@"headerTitle"];	
}
 
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{	
	return [attendeeIndex indexOfObject:title];
}

- (NSString *)tableView:(UITableView *)aTableView titleForHeaderInSection:(NSInteger) section{
	return [[lstGroupedAttendees objectAtIndex:section] objectForKey:@"headerTitle"];
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	
	RegistrantDetailViewController *detailViewController = [[RegistrantDetailViewController alloc] initWithNibName:@"RegistrantDetailView" bundle:nil];
	
	NSDictionary* currentReg = [[[lstGroupedAttendees objectAtIndex:indexPath.section] objectForKey:@"rowValues"]
								objectAtIndex:indexPath.row];
	
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
	
	//NSLog(@"Attendee selected: %@ %@", reg.firstName, reg.lastName);
	
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
	[progressInd release];
	[attendeeIndex release];
	[lstGroupedAttendees release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
	return YES;
}

@end

