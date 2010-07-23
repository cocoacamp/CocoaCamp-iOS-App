//
//  Session.m
//  CocoaCamp
//
//  Created by Warren Moore on 7/22/10.
//  Copyright 2010 Auerhaus Development, LLC. All rights reserved.
//

#import "Session.h"

@implementation Session

@synthesize title;
@synthesize speaker;
@synthesize details;
@synthesize location;
@synthesize startTime;
@synthesize endTime;

- (id)init {
	if((self = [super init]))
	{
		title = @"Example Session with a Long Title";
		location = @"Presentation Room A";
		startTime = [NSDate date];
		endTime = [NSDate date];
	}
	
	return self;
}

@end
