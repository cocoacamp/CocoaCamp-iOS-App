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

@interface RegistrantDetailViewController : UIViewController {
	Registrant *currRegistrant;	
	IBOutlet UILabel *industryLabel;
	IBOutlet UILabel *emailLabel;
	IBOutlet UILabel *twitterLabel;
	IBOutlet UILabel *nameLabel;
	IBOutlet UILabel *companyLabel;
}

@property (nonatomic, retain) Registrant *currRegistrant;
@property (nonatomic, retain) UILabel *companyLabel;
@property (nonatomic, retain) UILabel *industryLabel;
@property (nonatomic, retain) UILabel *emailLabel;
@property (nonatomic, retain) UILabel *twitterLabel;
@property (nonatomic, retain) UILabel *nameLabel;


@end
