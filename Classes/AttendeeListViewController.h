//
//  AttendeeListViewController.h
//  CocoaCamp
//
//  Created by Alondo Brewington on 8/22/10.
//  Copyright 2010 DT Squared Software. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *AppUserRegistrantIDKey;

@interface AttendeeListViewController : UITableViewController <UISearchBarDelegate> {
	NSMutableArray *attendees;
	NSDictionary *dictRegistrant;
	NSMutableData *responseData;
	UIImage *presenterIcon;
	UIActivityIndicatorView *progressInd;
	IBOutlet UISearchBar *searchBar;
	BOOL searching;
	NSMutableArray *lstGroupedAttendees;
	NSMutableArray *attendeeIndex;
}

@property (nonatomic, retain) NSDictionary *dictRegistrant;
@property (nonatomic, retain) UIActivityIndicatorView *progressInd;
@property (nonatomic, retain) NSMutableData *responseData;
@property (nonatomic, retain) NSMutableArray *attendees;
@property (nonatomic, retain) NSMutableArray *lstGroupedAttendees;
@property (nonatomic, retain) NSMutableArray *attendeeIndex;

- (void)drillDown: (NSDictionary *)reg animated: (BOOL)animated;
@end
