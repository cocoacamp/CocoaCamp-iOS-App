//
//  WebServiceUrlManager.h
//  CocoaCamp
//
//  Created by Rusty Zarse on 8/2/11.
//  Copyright 2011 LeVous, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebServiceUrlManager : NSObject{
    NSURL *attendeeListUrl, *twitterSearchUrl, *rssNewsUrl, *newsWebUrl, *sessionSchedulePdfUrl, *logoLinksUrl;
    NSString *twitterFallSearchString;
    NSArray *sessionScheduleUrlList;
}

@property(readonly, nonatomic, copy) NSURL *attendeeListUrl, *twitterSearchUrl, *rssNewsUrl, *newsWebUrl, *sessionSchedulePdfUrl, *logoLinksUrl;
@property(readonly, nonatomic, copy) NSString *twitterFallSearchString;
@property(readonly, nonatomic, retain) NSArray *sessionScheduleUrlList;


@end
