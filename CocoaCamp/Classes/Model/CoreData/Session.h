//
//  Session.h
//  CocoaCamp
//
//  Created by Rusty Zarse on 10/19/11.
//  Copyright (c) 2011 LeVous, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Session : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * sessionTimeString;
@property (nonatomic, retain) NSDate * datetimeStart;
@property (nonatomic, retain) NSString * externalId;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * sessionDayTitle;
@property (nonatomic, retain) NSNumber * flagged;

@end
