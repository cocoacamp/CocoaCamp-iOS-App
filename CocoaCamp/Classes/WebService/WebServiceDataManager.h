//
//  WebServiceDataManager.h
//  CocoaCamp
//
//  Created by Rusty Zarse on 10/19/11.
//  Copyright 2011 LeVous, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebServiceDataManager : NSObject
@property (assign, nonatomic) id delegate;

- (int)refreshSessionSchedule;

@end
