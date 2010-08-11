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
@synthesize schedules, thumbnails;

NSDateFormatter *dateFormatter;
NSDateFormatter *timeFormatter;

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
    return [schedules count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSDictionary *schedule = [self.schedules objectAtIndex:section];
	NSArray *talksArray = [schedule objectForKey:@"Talk"];
    return [talksArray count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	NSDictionary *schedule = [[self.schedules objectAtIndex:section] objectForKey:@"Schedule"];
	NSDate *startTime = [dateFormatter dateFromString:[schedule objectForKey:@"start_time"]];
	NSDate *endTime = [dateFormatter dateFromString:[schedule objectForKey:@"end_time"]];
	return [NSString stringWithFormat:@"%@-%@ %@", 
			[timeFormatter stringFromDate:startTime],
			[timeFormatter stringFromDate:endTime],
			[schedule objectForKey:@"name"]
			];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

	
	
    static NSString *CellIdentifier = @"cell";
    
	UILabel *speakerLabel;
	UILabel *locationLabel;
	UILabel *titleLabel;
	UIImageView *image;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, 250, 60) reuseIdentifier:CellIdentifier] autorelease];
		titleLabel = [[UILabel alloc] initWithFrame: CGRectMake(70, 10, 250, 25)];
		titleLabel.tag = 3;
		[cell.contentView addSubview:titleLabel];
		[titleLabel release];
		
		speakerLabel = [[UILabel alloc] initWithFrame: CGRectMake(70, 33, 250, 25)];
		speakerLabel.tag = 2;
		speakerLabel.textColor = [UIColor lightGrayColor];
		speakerLabel.font = [UIFont boldSystemFontOfSize:12];
		[cell.contentView addSubview:speakerLabel];
		[speakerLabel release];
		
		locationLabel = [[UILabel alloc] initWithFrame: CGRectMake(170, 33, 140, 25)];
		locationLabel.tag = 1;
		locationLabel.textColor = [UIColor lightGrayColor];
		locationLabel.font = [UIFont boldSystemFontOfSize:12];
		locationLabel.textAlignment = UITextAlignmentRight; 			
		[cell.contentView addSubview:locationLabel];
		[locationLabel release];
		
		image = [[UIImageView alloc] initWithFrame: CGRectMake(10, 5, 50, 50)];
		image.tag = 0;
		[cell.contentView addSubview:image];
		[image release];

    }
    
	titleLabel = (UILabel *)[cell viewWithTag:3];
	speakerLabel = (UILabel *)[cell viewWithTag:2];
	locationLabel = (UILabel *)[cell viewWithTag:1];
	image = (UIImageView *)[cell viewWithTag:0];
	
	
	NSDictionary *schedule = [self.schedules objectAtIndex:indexPath.section];
	NSArray *talksArray = [schedule objectForKey:@"Talk"];
	NSDictionary *talk = [talksArray objectAtIndex:indexPath.row];
	NSString *regID = [talk objectForKey:@"register_id"];
	NSDictionary *reg = [talk objectForKey: @"Register"];
	
	titleLabel.text = [talk objectForKey:@"title"];
	
	speakerLabel.text = [NSString stringWithFormat: @"%@ %@", 
						[reg objectForKey: @"first_name"], 
						[reg objectForKey: @"last_name"]];
	locationLabel.text = [talk objectForKey: @"location"];
	image.image = [UIImage imageWithData:[thumbnails objectForKey:regID]];
	//image.image = [UIImage imageNamed:@"cool-speaker.jpg"];
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
	
	dateFormatter = [[NSDateFormatter alloc] init];
	timeFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	[timeFormatter setDateFormat:@"h:mm"];
	
	SBJSON *jsonParser = [SBJSON new];
	
	NSString *jsonString = [self stringWithUrl: [NSURL URLWithString: @"http://cocoa:camp@cocoacamp.org/schedule/json"]];
	
	// Parse the JSON into an Object
	self.schedules = (NSArray *)[jsonParser objectWithString:jsonString error:NULL];
	
	
	if (self.schedules != NULL){
		
		// download thumbnails
		self.thumbnails = [[NSMutableDictionary alloc] init];
		for (NSDictionary *schedule in self.schedules) {
			NSArray *talks = [schedule objectForKey:@"Talk"];
			for (NSDictionary *talk in talks){
				NSString *regID = [talk objectForKey:@"register_id"];
				NSString *thumbURL = [NSString stringWithFormat: @"http://cocoa:camp@cocoacamp.org/thumbnail/show?id=%@&w=50&h=50", regID];
				NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString: thumbURL]];
				[self.thumbnails setValue:imageData forKey:regID ];
				NSLog(@"fetched thumbnail for %@ at %@", regID, thumbURL);
			}
		}
		
		
	}
}


- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
	[thumbnails release];
}


@end

