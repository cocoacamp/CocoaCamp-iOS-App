//
//  SessionViewController.m
//  CocoaCamp
//
//  Created by airportyh on 8/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SessionViewController.h"
#import "JSON.h"
#import "SessionDetailViewController.h"

@implementation SessionViewController
@synthesize schedules, thumbnails;
@synthesize progressInd;

NSDateFormatter *dateFormatter;
NSDateFormatter *timeFormatter;

#pragma mark -
#pragma mark View lifecycle

static NSString *BaseServiceURL = @"http://cocoa:camp@cocoacamp.org";


+ (NSString *) schedulesURL{
	return [NSString stringWithFormat: @"%@/schedule/json", BaseServiceURL];
}

+ (NSString *) thumbnailURL: (NSString *)regID{
	return [NSString stringWithFormat: 
			 @"%@/photos/atlanta/%@-100x100.jpg", BaseServiceURL, regID];
}

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
	if (self.schedules == NULL)
		return 0;
    return [self.schedules count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSDictionary *schedule = [self.schedules objectAtIndex:section];
	NSArray *talksArray = [schedule objectForKey:@"Talk"];
	int count = [talksArray count];
	if (count == 0) return 1;
	else return [talksArray count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	NSDictionary *schedule = [[self.schedules objectAtIndex:section] objectForKey:@"Schedule"];
	NSDate *startTime = [dateFormatter dateFromString:[schedule objectForKey:@"start_time"]];
	NSDate *endTime = [dateFormatter dateFromString:[schedule objectForKey:@"end_time"]];
	NSArray *talksArray = [[self.schedules objectAtIndex:section] objectForKey:@"Talk"];
	
	
	
	NSString *timeDisplay = [NSString stringWithFormat:@"%@-%@", 
							 [timeFormatter stringFromDate:startTime],
							 [timeFormatter stringFromDate:endTime]];
	
	int weekday = [[[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:startTime] weekday];
	
	if (weekday == 6){
		return [NSString stringWithFormat:@"Friday Night %@", timeDisplay];
	}else if (section == 1) {
		return [NSString stringWithFormat:@"Saturday %@", timeDisplay];
	}else if ([talksArray count] <= 1){
		return timeDisplay;
	}else {
		return [NSString stringWithFormat:@"%@ %@", timeDisplay, [schedule objectForKey:@"name"]];
	}

	
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSDictionary *schedule = [self.schedules objectAtIndex:indexPath.section];
	NSArray *talksArray = [schedule objectForKey:@"Talk"];
	
	if ([talksArray count] == 0){
		NSDictionary *sched = [schedule objectForKey:@"Schedule"];
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, 250, 60) reuseIdentifier:@"cell"] autorelease];
			cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
		}
		cell.textLabel.text = [sched objectForKey:@"name"];
		return cell;
	}
	
	
	NSDictionary *talk = [talksArray objectAtIndex:indexPath.row];
	NSString *regID = [talk objectForKey:@"register_id"];
	NSDictionary *reg = [talk objectForKey: @"Register"];
	NSString *speaker = [NSString stringWithFormat: @"%@ %@", 
						 [reg objectForKey: @"first_name"], 
						 [reg objectForKey: @"last_name"]];
	
	static NSString *CellIdentifier = @"talkCell";
    
	UILabel *speakerLabel;
	UILabel *locationLabel;
	UILabel *titleLabel;
	TTImageView *ttImage;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, 250, 60) reuseIdentifier:CellIdentifier] autorelease];
		titleLabel = [[UILabel alloc] initWithFrame: CGRectMake(70, 5, 250, 25)];
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
		
		
		ttImage = [[TTImageView alloc] initWithFrame: CGRectMake(0, 0, 60, 60)];
		ttImage.defaultImage = [UIImage imageNamed:@"loading.png"];
		ttImage.tag = 4;
		[cell.contentView addSubview:ttImage];
		[ttImage release];
		 
    }

    
	titleLabel = (UILabel *)[cell viewWithTag:3];
	speakerLabel = (UILabel *)[cell viewWithTag:2];
	locationLabel = (UILabel *)[cell viewWithTag:1];
	ttImage = (TTImageView *)[cell viewWithTag:4];
	
	
	titleLabel.text = [talk objectForKey:@"title"];
	
	speakerLabel.text = speaker;
	locationLabel.text = [talk objectForKey: @"location"];
	
	[ttImage setImage: nil];
	ttImage.urlPath = [SessionViewController thumbnailURL:regID];
		
	return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	NSDictionary *schedule = [self.schedules objectAtIndex:indexPath.section];
	NSArray *talksArray = [schedule objectForKey:@"Talk"];
	if ([talksArray count] == 0)
		return nil;
	else
		return indexPath;
}

/*
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	NSDictionary *schedule = [self.schedules objectAtIndex:indexPath.section];
	NSArray *talksArray = [schedule objectForKey:@"Talk"];
	if ([talksArray count] == 0)
		return nil;
	else
		return indexPath;
}
*/

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	NSDictionary *schedule = [self.schedules objectAtIndex:indexPath.section];
	NSArray *talksArray = [schedule objectForKey:@"Talk"];
	if ([talksArray count] == 0) return;
	
	NSDictionary *talk = [talksArray objectAtIndex:indexPath.row];
	
	SessionDetailViewController *detailViewController = [[SessionDetailViewController alloc] initWithNibName:@"SessionDetailViewController" bundle:nil];
	
	detailViewController.talk = talk;
	detailViewController.schedule = [schedule objectForKey:@"Schedule"];
	
	[self.navigationController pushViewController:detailViewController animated:YES];
	[detailViewController release];
	 
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

NSMutableData *data;

- (void)connection:(NSURLConnection *)theConnection didReceiveData:(NSData *)incrementalData {
	if (data==nil) { data = [[NSMutableData alloc] initWithCapacity:2048]; } 
	[data appendData:incrementalData];
}

- (void)connectionDidFinishLoading:(NSURLConnection*)connection {
	[connection release];
	SBJSON *jsonParser = [SBJSON new];
	NSString *jsonText = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	self.schedules = [jsonParser objectWithString: jsonText error: NULL];
	[self.progressInd removeFromSuperview];
	[jsonText release];
	[data release];
	data = NULL;
	[self.tableView reloadData];
	
	/* auto scroll to the current session */
	
	//NSDate *now = [dateFormatter dateFromString: @"2010-09-25 18:00:00"];
	NSDate *now = [NSDate date];
	int count = 0;
	for (NSDictionary *item in self.schedules){
		NSDictionary *schedule = [item objectForKey:@"Schedule"];
		NSDate *endTime = [dateFormatter dateFromString:[schedule objectForKey:@"end_time"]];
		if ([now timeIntervalSinceDate:endTime] < 0.0){
			NSUInteger section = count;
			NSUInteger indexArr[] = {section, 0};
			NSIndexPath *ipath = [NSIndexPath indexPathWithIndexes:indexArr length:2];
			[self.tableView scrollToRowAtIndexPath:ipath atScrollPosition:UITableViewScrollPositionTop animated:NO];
			break;
		}
		count++;
	}
	
	
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

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = @"Schedule";
	
	[self.view addSubview: self.progressInd];
	
	dateFormatter = [[NSDateFormatter alloc] init];
	timeFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	[timeFormatter setDateFormat:@"h:mm"];
	
	NSURLRequest* request = [NSURLRequest requestWithURL: [NSURL URLWithString:[SessionViewController schedulesURL]]
											 cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
	[[NSURLConnection alloc] initWithRequest:request delegate:self];
	
	self.thumbnails = [[NSMutableDictionary alloc] init];
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

