//
//  WebServiceUrlManager.m
//  CocoaCamp
//
//  Created by Rusty Zarse on 8/2/11.
//  Copyright 2011 LeVous, LLC. All rights reserved.
//

#import "WebServiceUrlManager.h"

@implementation WebServiceUrlManager

- (void)dealloc{
    [attendeeListUrl release], attendeeListUrl = nil;
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        // attendeeListUrl = [NSURL URLWithString:@"http://cocoa:camp@cocoacamp.org/registers/json?user_name=cocoa&password=camp"];
        NSString *filePathToSample = [[NSBundle mainBundle] pathForResource:@"AttendeeListJson" ofType:@"js"];
        attendeeListUrl = [NSURL fileURLWithPath:filePathToSample];
        // hang on to that url for reuse
        [attendeeListUrl retain];
    }
    
    
    
    return self;
}


- (NSString *)attendeeListUrl{
    return [attendeeListUrl copy];
}

@end
