//
//  WebServiceDataManager.m
//  CocoaCamp
//
//  Created by Rusty Zarse on 10/19/11.
//  Copyright 2011 LeVous, LLC. All rights reserved.
//

#import "WebServiceDataManager.h"
#import "CoreDataManager.h"
#import "WordPressApiSessionsJsonParser.h"
#import "WebServiceUrlManager.h"

@implementation WebServiceDataManager
@synthesize delegate;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (int)refreshSessionSchedule{
    
    WebServiceUrlManager *webServiceUrlManager = [[WebServiceUrlManager alloc] init];
    NSArray *scheduleUrls = [[webServiceUrlManager sessionScheduleUrlList] retain];
    [webServiceUrlManager release];
    // this may be on a background thread so get an isolater coredata manager
    CoreDataManager *coreDataManager = [[CoreDataManager alloc] init];
    
    // good place to build a dependency injection if you need something different
    WordPressApiSessionsJsonParser *parser = [[WordPressApiSessionsJsonParser alloc] initWithCoreDataManager:coreDataManager];

    // reusable vars

    NSURLResponse *urlResponse = nil;
    NSError *error = nil;
    
    NSArray *entityResults = [NSArray array];
    
    for( NSURL *url in scheduleUrls){
        // create request
        NSURLRequest *request = [NSURLRequest requestWithURL:url
                                                 cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
        
        // get response
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request 
                                                     returningResponse:&urlResponse 
                                                                 error:&error];
        // convert to string
        NSString *jsonText = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];

        // parse to array of model entities
        entityResults = [parser parseSessionScheduleJson:jsonText];
        
        // clean up for this request
        [jsonText release];
        
        // save
        [coreDataManager save];
    }
    
    // finished with parser
    [parser release];
    
    if( delegate && [delegate respondsToSelector:@selector(scheduleUpdateComplete)]){
        [delegate performSelector:@selector(scheduleUpdateComplete)];
    }
    
    [coreDataManager release];
    [scheduleUrls release];
    
    return [entityResults count];

    
}

@end
