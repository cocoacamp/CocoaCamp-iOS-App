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
    [twitterSearchUrl release], twitterSearchUrl = nil;
    [twitterFallSearchString release], twitterFallSearchString = nil;
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        
        
        // Load config plist
        NSString *filePathToPList = [[NSBundle mainBundle] pathForResource:@"webServiceConfig" ofType:@"plist"];
        NSMutableDictionary* configDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:filePathToPList];
        
        twitterSearchUrl            = [[NSURL alloc] initWithString:[configDictionary objectForKey:@"twitterSearchUrl"]];
        twitterFallSearchString     = [[NSString alloc] initWithString:[configDictionary objectForKey:@"twitterFallSearchString"]];
        attendeeListUrl             = [[NSURL alloc] initWithString:[configDictionary objectForKey:@"attendeeListUrl"]];

        // ***********************
        // replace with development file urls
        
        NSString *filePathToSample = [[NSBundle mainBundle] pathForResource:@"AttendeeListJson" ofType:@"js"];
        attendeeListUrl = [NSURL fileURLWithPath:filePathToSample];
        // hang on to that url for reuse
        [attendeeListUrl retain];
    }
    
    
    
    return self;
}


- (NSURL *)attendeeListUrl{
    return [attendeeListUrl copy];
}

- (NSURL *)twitterSearchUrl{
    return [twitterSearchUrl copy];
}

- (NSString *)twitterFallSearchString{
    return [twitterFallSearchString copy];
}

@end
