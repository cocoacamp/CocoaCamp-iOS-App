//
//  SessionListTableViewController.h
//  CocoaCamp
//
//  Created by Warren Moore on 7/22/10.
//  Copyright 2010 Auerhaus Development, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SessionListTableViewController : UIViewController<UITableViewDelegate, UITableViewDataSource> {
	NSArray *sessions;
}



@end
