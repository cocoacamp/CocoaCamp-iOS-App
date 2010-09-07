//
//  RegistrantDetailViewController.h
//  CocoaCamp
//
//  Created by Alondo Brewington on 8/22/10.
//  Copyright 2010 DT Squared Software, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Registrant.h"
#import "Bump.h"
@class Registrant;

extern NSString *AppUserRegistrantIDKey;

@interface RegistrantDetailViewController : UIViewController <BumpDelegate> {
	Registrant *currRegistrant;
	IBOutlet UILabel *nameLabel;
	IBOutlet UIActivityIndicatorView *loading;
	BOOL isExchanging;
}

@property (nonatomic, retain) Registrant *currRegistrant;
@property (nonatomic, retain) UILabel *nameLabel;
@property (readonly) Bump *bump;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *loading;

- (IBAction)storeCurrentProfileAsIdentity;
- (IBAction)initiateContactExchange:(id)sender;
- (void)performContactExchange;
- (void)bumpFailed;
@end
