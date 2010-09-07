//
//  TwitterFeedTableViewController.m
//  CocoaCamp
//
//  Created by Warren Moore on 9/1/10.
//  Copyright 2010 Auerhaus Development, LLC. All rights reserved.
//

#import "TwitterFeedTableViewController.h"
#import "SBJSON.h"
#import "NSString+XMLEntities.h"

@implementation TwitterFeedTableViewController

static NSString *TweetSearchURL = @"http://search.twitter.com/search.json";
static NSString *RFC822DateFormat = @"EEE, dd MMM yyyy HH:mm:ss z";

-(id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)bundle {
	if (self = [super initWithNibName:nibName bundle:bundle]){
		self.title = @"Twitter";
		UIImage* image = [UIImage imageNamed:@"bird.png"];
		self.tabBarItem = [[[UITabBarItem alloc] initWithTitle:@"Twitter" image:image tag:0] autorelease];
	}
	return self;
}


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	if (tweets == nil){
		tweets = [[NSMutableArray alloc] init];
		tweetSearchURLSuffix = @"?q=cocoacamp";
		
		dateParser = [[NSDateFormatter alloc] init];
		[dateParser setDateFormat:RFC822DateFormat];
		
		CGRect frame = CGRectMake(self.view.frame.size.width/2-15, self.view.frame.size.height/2-15, 30, 30);
		activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:frame];
		[activityIndicator startAnimating];
		activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
		[activityIndicator sizeToFit];
		activityIndicator.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin |
										UIViewAutoresizingFlexibleRightMargin |
										UIViewAutoresizingFlexibleTopMargin |
										UIViewAutoresizingFlexibleBottomMargin);
		
		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh 
																								target:self 
																								action:@selector(refreshTweets)] autorelease];
		[self refreshTweets];
	}
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)refreshTweets {
	[self.view addSubview:activityIndicator];
	tweetData = [[NSMutableData alloc] init];
	NSURL *searchURL = [NSURL URLWithString:[TweetSearchURL stringByAppendingString:tweetSearchURLSuffix]];
	
	NSLog(@"Issuing request for tweets to URL: %@", searchURL);
	
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:searchURL];
	[[NSURLConnection alloc] initWithRequest:request delegate:self];
	[request release];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[tweetData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	SBJSON *jsonParser = [[SBJSON alloc] init];

	NSString *twitterJSON = [[NSString alloc] initWithData:tweetData encoding:NSUTF8StringEncoding];
	NSDictionary *twitterAssoc = [jsonParser objectWithString:twitterJSON error:nil];
	
	NSArray *newTweets = [[twitterAssoc objectForKey:@"results"] retain];
	
	// do some preprocessing on tweets to make our lives easier later
	for(NSDictionary *tweet in newTweets)
	{
		NSString *tweetText = [[tweet objectForKey:@"text"] stringByDecodingXMLEntities];
		
		CGSize tweetSize = [tweetText sizeWithFont:[UIFont systemFontOfSize:12.0] 
								 constrainedToSize:CGSizeMake(225.0, 1000.0)
									 lineBreakMode:UILineBreakModeWordWrap];
		
		// risky business.
		[(NSMutableDictionary *)tweet setObject:tweetText forKey:@"text"];
		[(NSMutableDictionary *)tweet setObject:[NSNumber numberWithFloat:tweetSize.height] forKey:@"display_height"];
	}
	
	NSLog(@"Will add an additional %d tweets to the existing %d tweets.", [newTweets count], [tweets count]);
	
	NSArray *oldTweets = tweets;
	tweets = [[newTweets arrayByAddingObjectsFromArray:tweets] retain]; // add new tweets to beginning of timeline
	[oldTweets release];
	[newTweets release];
	
	[tweetSearchURLSuffix release];
	tweetSearchURLSuffix = [[twitterAssoc objectForKey:@"refresh_url"] retain];  // cache refresh URL in case we refresh before being dismissed
	
	[twitterJSON release];
	[tweetData release];
	[connection release];

	[self.tableView reloadData];
	[activityIndicator removeFromSuperview];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	[tweetData release];
	[connection release];

	[activityIndicator removeFromSuperview];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [tweets count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSDictionary *tweet = [tweets objectAtIndex:indexPath.row];
	CGFloat height = [[tweet objectForKey:@"display_height"] floatValue] + 24.0; // compensate for text area insets and y-position
	return MAX(60.0, height); // clamp to minimum height
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"TweetCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

	UILabel *senderLabel;
	UILabel *dateLabel;
	UITextView *contentText;
	TTImageView *avatarImageView;

	if (cell == nil) {

		NSArray *bundleObjects = [[NSBundle mainBundle] loadNibNamed:@"TwitterFeedTableViewCell" owner:nil options:nil];
			  
		cell = [bundleObjects objectAtIndex:0];
		
		avatarImageView = (TTImageView *)[cell viewWithTag:1];
		avatarImageView.defaultImage = [UIImage imageNamed:@"loading.png"];
	}
	
	senderLabel = (UILabel *)[cell viewWithTag:2];
	dateLabel = (UILabel *)[cell viewWithTag:3];
	contentText = (UITextView *)[cell viewWithTag:4];
	avatarImageView = (TTImageView *)[cell viewWithTag:1];
	
	NSDictionary *tweet = [tweets objectAtIndex:indexPath.row];
	
	NSDate *tweetDate = [dateParser dateFromString:[tweet objectForKey:@"created_at"]];

	senderLabel.text = [tweet objectForKey:@"from_user"];
	dateLabel.text = [tweetDate prettyStringRelativeToDate:[NSDate date]];

	contentText.text = [tweet objectForKey:@"text"];
	CGFloat height = [[tweet objectForKey:@"display_height"] floatValue];
	[contentText setFrame:CGRectMake(60.0, 20.0, 240.0, height)];

	avatarImageView.urlPath = [tweet objectForKey:@"profile_image_url"];
		
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

#pragma mark -
#pragma mark Table view delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	return nil; // No selection allowed
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
	[dateParser release];
	[tweets release];
	[activityIndicator release];
}


- (void)dealloc {
    [super dealloc];
}

@end

/* Logic taken from JavaScript Pretty Date by John Resig
 * 
 */
@implementation NSDate (PrettyDate)
- (NSString *)prettyStringRelativeToDate:(NSDate *)priorDate {
	NSTimeInterval secondDiff = [priorDate timeIntervalSinceDate:self];
	NSInteger dayDiff = (NSInteger)floor(secondDiff / 86400);
	
	if(dayDiff < 0)
	{
		return @"In the future";
	}
	else if(dayDiff == 0)
	{
		if(secondDiff < 60)
			return @"Just now";
		else if(secondDiff < 120)
			return @"1 minute ago";
		else if(secondDiff < 3600)
			return [NSString stringWithFormat:@"%d minutes ago", (NSInteger)floor(secondDiff/60)];
		else if(secondDiff < 7200)
			return @"1 hour ago";
		else if(secondDiff < 86400)
			return [NSString stringWithFormat:@"%d hours ago", (NSInteger)floor(secondDiff/3600)];
	}
	else if(dayDiff == 1)
		return @"Yesterday";
	else if(dayDiff < 7)
		return [NSString stringWithFormat:@"%d days ago", dayDiff];
	else if(dayDiff == 7)
		return @"1 week ago";
	else
		return [NSString stringWithFormat:@"%d weeks ago", ((dayDiff + 3) / 7)];  // Resig uses ceil; this seems smoother
	
	return @"Sometime";
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
	return YES;
}
@end
