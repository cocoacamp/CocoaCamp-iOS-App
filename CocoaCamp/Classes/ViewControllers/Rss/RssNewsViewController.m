//
//  RootViewController.m
//  ARSSReader
//
//  Created by Marin Todorov on 5/25/10.
//  Copyright Marin Todorov 2010. All rights reserved.
//

#import "RssNewsViewController.h"


@implementation RssNewsViewController

#pragma mark -
#pragma mark View lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]){
        self.title = @"News";
        UIImage* image = [UIImage imageNamed:@"news-icon.png"];
        self.tabBarItem = [[[UITabBarItem alloc] initWithTitle:self.title image:image tag:0] autorelease];
	} 
    return self;
    
}

- (void)launchWeb:(id)sender{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.apple.com"]];
}

- (void)configureToolbar{
    
	UIBarButtonItem *launchWebItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                                    target:self 
                                                                                    action:@selector(launchWeb:)] autorelease];
	
	
	self.navigationItem.rightBarButtonItem = launchWebItem;
	
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureToolbar];
    
    rssItems = nil;
	rss = nil;

	self.tableView.backgroundColor = [UIColor clearColor];
	[self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setIndicatorStyle:UIScrollViewIndicatorStyleWhite];
	
	self.tableView.tableHeaderView = [[RssTableHeaderView alloc] initWithText:@"fetching rss feed"];
	
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
	
	if (rss==nil) {
		rss = [[RSSLoader alloc] init];
		rss.delegate = self;
		[rss load];
	}
}

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
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
 */


#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (rss.loaded == YES) {
		return [rssItems count]*2;
	} else {
		return 1;
	}
}

- (UITableViewCell *)getLoadingTableCellWithTableView:(UITableView *)tableView 
{
    static NSString *LoadingCellIdentifier = @"LoadingCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LoadingCellIdentifier];
    
	if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LoadingCellIdentifier] autorelease];
    }
	
	cell.textLabel.text = @"Loading...";
	
	UIActivityIndicatorView* activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	[activity startAnimating];
	[cell setAccessoryView: activity];
	[activity release];
	
    return cell;
}

- (UITableViewCell *)getTextCellWithTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
	static NSString *TextCellIdentifier = @"TextCell";
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TextCellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:TextCellIdentifier] autorelease];
    }
    
	NSDictionary* item = [rssItems objectAtIndex: (indexPath.row-1)/2];
	
	//article preview
	cell.textLabel.font = [UIFont systemFontOfSize:11];
	cell.textLabel.numberOfLines = 3;
	cell.textLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
	cell.backgroundColor = [UIColor clearColor];
	cell.textLabel.backgroundColor = [UIColor clearColor];

	UIView *backView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
	backView.backgroundColor = [UIColor clearColor];
	cell.backgroundView = backView;
	
	CGRect f = cell.textLabel.frame;
	[cell.textLabel setFrame: CGRectMake(f.origin.x+15, f.origin.y, f.size.width-15, f.size.height)];
	cell.textLabel.text = [item objectForKey:@"description"];
	
	return cell;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	if (rss.loaded == NO) {
		return [self getLoadingTableCellWithTableView:tableView];
	}
	
	if (indexPath.row % 2 == 1) {
		return [self getTextCellWithTableView:tableView atIndexPath:indexPath];
	}
	
    static NSString *CellIdentifier = @"TitleCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }

	UIView *backView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
	backView.backgroundColor = [UIColor clearColor];
	cell.backgroundView = backView;
    
	NSDictionary* item = [rssItems objectAtIndex: indexPath.row/2];
	
	cell.textLabel.text = [item objectForKey:@"title"];

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
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
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
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
	
	RssDetailsViewController *detailViewController = [[RssDetailsViewController alloc] initWithNibName:@"RssDetailsViewController" bundle:nil];
	detailViewController.item = [rssItems objectAtIndex:floor(indexPath.row/2)];
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

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
	[rssItems release];
	rssItems = nil;
	
	[rss release];
	rss = nil;
	
    [super dealloc];
}

#pragma mark -
#pragma mark RSSLoaderDelegate
-(void)updatedFeedWithRSS:(NSMutableArray*)items
{
	rssItems = [items retain];
	[self.tableView reloadData];
}

-(void)failedFeedUpdateWithError:(NSError *)error
{
	//
}

-(void)updatedFeedTitle:(NSString*)rssTitle
{
	[(RssTableHeaderView*)self.tableView.tableHeaderView setText:rssTitle];
}

@end
