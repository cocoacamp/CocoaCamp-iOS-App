//
//  WordPressApiSessionsJsonParser.h
//  CocoaCamp
//
//  Created by Rusty Zarse on 10/19/11.
//  Copyright 2011 LeVous, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WordPressApiSessionsJsonParser : NSObject{
    CoreDataManager *coreDataManager;
    NSCalendar *gregorianCalendar;
    NSDictionary *scheduleDays;
    NSNumberFormatter *numberFormatter;
}

- (id)initWithCoreDataManager:(CoreDataManager *)aCoreDataManager;

- (NSArray *)parseSessionScheduleJson:(NSString *)json;
@end
