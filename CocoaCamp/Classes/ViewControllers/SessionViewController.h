//
//  SessionViewController.h
//  CocoaCamp
//
//  Created by Rusty Zarse on 10/19/11.
//  Copyright 2011 LeVous, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WebServiceDataManager;

@interface SessionViewController : UITableViewController<NSFetchedResultsControllerDelegate>{
    NSFetchedResultsController *fetchedResultsController;
    NSDate *lastSessionsUpdate;
    WebServiceDataManager *wsMgr;
}
@property (retain, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (retain, nonatomic) CoreDataManager *coreDataManager;
@end
