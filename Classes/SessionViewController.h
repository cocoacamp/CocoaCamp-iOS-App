//
//  SessionViewController.h
//  CocoaCamp
//
//  Created by airportyh on 8/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SessionViewController : UITableViewController {
	NSArray *schedules;
	NSMutableDictionary *thumbnails;
	UIActivityIndicatorView *progressInd;
}

@property (nonatomic, retain) NSArray *schedules;
@property (nonatomic, retain) NSMutableDictionary *thumbnails;
@property (nonatomic, retain) UIActivityIndicatorView *progressInd;
<<<<<<< HEAD

- (UIActivityIndicatorView *)progressInd;
+ (NSURL *) schedulesURL;
+ (NSURL *) thumbnailURL: (NSString *)regID;
=======
>>>>>>> 858ddc0ae162adb625b3d5af3635e4992fb0b4ab

- (void) downloadImageFor: (NSString *) regID;
- (UIActivityIndicatorView *)progressInd;
@end
