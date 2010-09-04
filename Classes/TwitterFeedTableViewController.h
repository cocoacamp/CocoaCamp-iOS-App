//
//  TwitterFeedTableViewController.h
//  CocoaCamp
//
//  Created by Warren Moore on 9/1/10.
//  Copyright 2010 Auerhaus Development, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TwitterFeedTableViewController : UITableViewController {
	NSMutableData *tweetData;
	NSArray *tweets;
	NSDateFormatter *dateParser;
	NSString *tweetSearchURLSuffix;
	UIActivityIndicatorView *activityIndicator;
}

- (void)refreshTweets;

@end

@interface NSDate(PrettyDate)
- (NSString *)prettyStringRelativeToDate:(NSDate *)priorDate;
@end