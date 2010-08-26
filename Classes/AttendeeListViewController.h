//
//  AttendeeListViewController.h
//  CocoaCamp
//
//  Created by Alondo Brewington on 8/22/10.
//  Copyright 2010 DT Squared Software. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AttendeeListViewController : UITableViewController {
	NSMutableArray *attendees;
	NSDictionary *dictRegistrant;
	NSMutableData *responseData;
}

@property (nonatomic, retain) NSDictionary *dictRegistrant;
@property (nonatomic, retain) NSMutableData *responseData;
@property (nonatomic, retain) NSMutableArray *attendees;
@end
