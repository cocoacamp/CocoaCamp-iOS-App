//
//  RegistrantDetailViewController.h
//  CocoaCamp
//
//  Created by Alondo Brewington on 8/22/10.
//  Copyright 2010 DT Squared Software, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Registrant.h"

@class Registrant;

extern NSString *AppUserRegistrantIDKey;

@interface RegistrantDetailViewController : UIViewController {
	Registrant *currRegistrant;
	IBOutlet UILabel *nameLabel;
}

@property (nonatomic, retain) Registrant *currRegistrant;
@property (nonatomic, retain) UILabel *nameLabel;

- (IBAction)storeCurrentProfileAsIdentity;
- (IBAction)initiateContactExchange:(id)sender;
- (void)performContactExchange;
@end
