//
//  SessionViewController.h
//  CocoaCamp
//
//  Created by airportyh on 8/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PortraitLoaderDelegate.h"

@interface SessionViewController : UITableViewController <PortraitLoaderDelegate> {
	NSArray *schedules;
	NSMutableDictionary *thumbnails;
	UIActivityIndicatorView *progressInd;
}

@property (nonatomic, retain) NSArray *schedules;
@property (nonatomic, retain) NSMutableDictionary *thumbnails;
@property (nonatomic, retain) UIActivityIndicatorView *progressInd;

- (void) downloadImageFor: (NSString *) regID;
- (UIActivityIndicatorView *)progressInd;
@end
