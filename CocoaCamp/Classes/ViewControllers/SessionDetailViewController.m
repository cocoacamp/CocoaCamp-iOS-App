//
//  SessionDetailViewController.m
//  CocoaCamp
//
//  Created by airportyh on 8/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SessionDetailViewController.h"
#import "SessionViewController.h"

@implementation SessionDetailViewController
@synthesize talk, schedule, portraitImg, titleText, descriptionText;



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	[timeFormatter setDateFormat:@"h:mma"];
	
	self.title = @"Talk Detail";
	
	NSString *regID = [talk objectForKey:@"register_id"];
	NSDictionary *reg = [talk objectForKey: @"Register"];
	
	NSString *title = [talk objectForKey:@"title"];
	
	NSDate *startTime = [dateFormatter dateFromString:[schedule objectForKey:@"start_time"]];
	NSDate *endTime = [dateFormatter dateFromString:[schedule objectForKey:@"end_time"]];
	
	NSString *speaker = [NSString stringWithFormat: @"%@ %@", 
						 [reg objectForKey: @"first_name"], 
						 [reg objectForKey: @"last_name"]];
	NSString *company = [reg objectForKey:@"company"];
	NSString *twitter = [reg objectForKey:@"twitter"];
	NSString *location = [talk objectForKey: @"location"];
	NSString *timeDisplay = [NSString stringWithFormat:@"%@-%@", 
							 [timeFormatter stringFromDate:startTime],
							 [timeFormatter stringFromDate:endTime]];
	
	
	
	titleText.text = title;
	titleText.font = [UIFont boldSystemFontOfSize:19];
	
	NSString *twitterDisplay = @"";
	if ([twitter length] > 0)
		twitterDisplay = [NSString stringWithFormat:@"<br>Twitter: <a href=\"http://mobile.twitter.com/%@\">@%@</a>", twitter, twitter];
	
	descriptionText.font = [UIFont systemFontOfSize:15];
	descriptionText.html = [NSString stringWithFormat:
							@"<br>Presented by %@<br>%@%@<br>Presented at the %@ Room<br>Saturday %@<br>", 
							speaker, company, twitterDisplay, location, timeDisplay];
	
	
	portraitImg.urlPath = [SessionViewController thumbnailURL:regID];
	
	[dateFormatter release];
	[timeFormatter release];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
	return toInterfaceOrientation == UIInterfaceOrientationPortrait;
}
@end
