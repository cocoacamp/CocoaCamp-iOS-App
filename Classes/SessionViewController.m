//
//  SessionViewController.m
//  CocoaCamp
//
//  Created by airportyh on 8/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SessionViewController.h"
#import "JSON.h"

@implementation SessionViewController
@synthesize sessions;

#pragma mark -
#pragma mark View lifecycle

/*
- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
*/

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
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
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if (self.sessions == NULL)
		return 3;
	NSArray * sessionsArray = [self.sessions objectForKey:@"sessions"];
    return [sessionsArray count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (self.sessions == NULL)
		return 1;
	NSArray *sessionsArray = [self.sessions objectForKey:@"sessions"];
	NSDictionary *session = [sessionsArray objectAtIndex:section];
	NSArray *talksArray = [session objectForKey:@"talks"];
    return [talksArray count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if (self.sessions == NULL){
		if (section == 0)
			return @"Step 1";
		else if(section == 1)
			return @"Step 2";
		else
			return @"Step 3";

	}
	
	NSArray *sessionsArray = [self.sessions objectForKey:@"sessions"];
	NSDictionary *session = [sessionsArray objectAtIndex:section];
	return [NSString stringWithFormat:@"%@ (%@-%@)", 
			[session objectForKey:@"name"], 
			[session objectForKey:@"startTime"],
			[session objectForKey:@"endTime"]];;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	NSString *CellIdentifier;
	if (self.sessions == NULL){
		CellIdentifier = @"cell";
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, 250, 60) reuseIdentifier:CellIdentifier] autorelease];
		}
		if (indexPath.section == 0)
			[cell setText:@"cd web_mock"];
		else if (indexPath.section == 1)
			[cell setText:@"./serve.sh"];
		else
			[cell setText:@"Restart the App"];

		return cell;
	}
	
	
	NSArray *sessionsArray = [self.sessions objectForKey:@"sessions"];
	NSDictionary *session = [sessionsArray objectAtIndex:indexPath.section];
	NSArray *talksArray = [session objectForKey:@"talks"];
	NSDictionary *talk = [talksArray objectAtIndex:indexPath.row];
	
	
    CellIdentifier = [NSString stringWithFormat: @"%@/%@", [session objectForKey:@"name"], [talk objectForKey:@"speaker"]];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, 250, 60) reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
	UILabel *topLabel = [[UILabel alloc] initWithFrame: CGRectMake(70, 10, 250, 25)];
	topLabel.text = [talk objectForKey:@"title"];
    [cell.contentView addSubview:topLabel];
	[topLabel release];

	UILabel *bottomLabel = [[UILabel alloc] initWithFrame: CGRectMake(70, 33, 200, 25)];
	bottomLabel.textColor = [UIColor lightGrayColor];
	bottomLabel.font = [UIFont boldSystemFontOfSize:12];
	bottomLabel.text = [talk objectForKey:@"speaker"];
	[cell.contentView addSubview:bottomLabel];
	[bottomLabel release];
	
	UILabel *locationLabel = [[UILabel alloc] initWithFrame: CGRectMake(140, 33, 170, 25)];
	locationLabel.textColor = [UIColor lightGrayColor];
	locationLabel.font = [UIFont boldSystemFontOfSize:12];
	locationLabel.text = [talk objectForKey:@"location"];
	locationLabel.textAlignment = UITextAlignmentRight; 
	[cell.contentView addSubview:locationLabel];
	[locationLabel release];
	
	UIImageView *image = [[UIImageView alloc] initWithFrame: CGRectMake(10, 5, 50, 50)];
	image.image = [UIImage imageNamed:@"cool-speaker.jpg"];
	[cell.contentView addSubview:image];
	
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
	/*
	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (NSString *)stringWithUrl:(NSURL *)url
{
	NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url
												cachePolicy:NSURLRequestReturnCacheDataElseLoad
											timeoutInterval:30];
	// Fetch the JSON response
	NSData *urlData;
	NSURLResponse *response;
	NSError *error;
	
	// Make synchronous request
	urlData = [NSURLConnection sendSynchronousRequest:urlRequest
									returningResponse:&response
												error:&error];
	
 	// Construct a String around the Data from the response
	return [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	SBJSON *jsonParser = [SBJSON new];
	
	NSString *jsonString = [self stringWithUrl: [NSURL URLWithString: @"http:localhost:3000/sessions.json"]];
	
	// Parse the JSON into an Object
	self.sessions = (NSDictionary *)[jsonParser objectWithString:jsonString error:NULL];
}


- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end

