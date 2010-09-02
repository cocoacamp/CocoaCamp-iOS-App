//
//  AttendeeListViewController.h
//  CocoaCamp
//
//  Created by Alondo Brewington on 8/22/10.
//  Copyright 2010 DT Squared Software. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *AppUserRegistrantIDKey;

@interface AttendeeListViewController : UITableViewController {
	NSMutableArray *attendees;
	NSDictionary *dictRegistrant;
	NSMutableData *responseData;
	UIImage *presenterIcon;
}

@property (nonatomic, retain) NSDictionary *dictRegistrant;
@property (nonatomic, retain) NSMutableData *responseData;
@property (nonatomic, retain) NSMutableArray *attendees;

- (IBAction)initiateContactExchange:(id)sender;
- (void)performContactExchange;

@end
