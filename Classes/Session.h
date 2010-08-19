//
//  Session.h
//  CocoaCamp
//
//  Created by Warren Moore on 7/22/10.
//  Copyright 2010 Auerhaus Development, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Session : NSObject {
}

@property(nonatomic, retain) NSString *title;
@property(nonatomic, retain) NSString *speaker;
@property(nonatomic, retain) NSString *details;
@property(nonatomic, retain) NSString *location;
@property(nonatomic, retain) NSDate *startTime;
@property(nonatomic, retain) NSDate *endTime;

@end
