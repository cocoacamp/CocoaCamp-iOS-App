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
	NSDictionary *schedule;
	TTImageView *portraitImg;
	UITextView *titleText;
	TTStyledTextLabel *descriptionText;
}
@property (nonatomic, retain) NSDictionary *talk;
@property (nonatomic, retain) NSDictionary *schedule;
@property (nonatomic, retain) IBOutlet TTImageView *portraitImg;
@property (nonatomic, retain) IBOutlet UITextView *titleText;
@property (nonatomic, retain) IBOutlet TTStyledTextLabel *descriptionText;


@end
