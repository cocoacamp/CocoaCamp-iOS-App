//
//  SessionDetailViewController.h
//  CocoaCamp
//
//  Created by airportyh on 8/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SessionDetailViewController : UIViewController {
	NSDictionary *talk;
	UIImageView *portraitImg;
	UILabel *titleLbl;
	UILabel *descriptionLbl;
}
@property (nonatomic, retain) NSDictionary *talk;
@property (nonatomic, retain) IBOutlet UIImageView *portraitImg;
@property (nonatomic, retain) IBOutlet UILabel *titleLbl;
@property (nonatomic, retain) IBOutlet UILabel *descriptionLbl;


@end
