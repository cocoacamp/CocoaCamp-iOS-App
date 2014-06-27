//
//  WordPressApiSessionsJsonParserTests.m
//  CocoaCamp
//
//  Created by Rusty Zarse on 10/19/11.
//  Copyright 2011 LeVous, LLC. All rights reserved.
//

#import "WordPressApiSessionsJsonParserTests.h"
#import "WordPressApiSessionsJsonParser.h"
#import "Session.h"

@implementation WordPressApiSessionsJsonParserTests

#if USE_APPLICATION_UNIT_TEST     // all code under test is in the iPhone Application

- (void)testAppDelegate {
    
    id yourApplicationDelegate = [[UIApplication sharedApplication] delegate];
    STAssertNotNil(yourApplicationDelegate, @"UIApplication failed to find the AppDelegate");
    
}

#else                           // all code under test must be linked into the Unit Test bundle

- (void)testParseScheduleJsonSample {
    NSString *filePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"WordPressScheduleDay" ofType:@"js"];
    NSString *jsonFileContents = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    STAssertNotNil(jsonFileContents, @"File contents expected not nil for path %@", filePath);
    
    CoreDataManager *coreDataManager = [[CoreDataManager alloc] init];
    WordPressApiSessionsJsonParser *parser = [[WordPressApiSessionsJsonParser alloc] initWithManagedObjectContext:[coreDataManager managedObjectContext]];
    
    NSArray *results = [parser parseSessionScheduleJson:jsonFileContents];
    STAssertNotNil(results, @"results contents expected not nil for path %@", filePath);
    
    STAssertEquals((NSUInteger)10, [results count], @"ten sessions expected in sample data");
    
    // find the lunch item
    // this item date was not parsing correctly
    NSPredicate *lunchSessionPredicate = [NSPredicate predicateWithFormat:@"title = 'Luncheon & Plenary Session: Yale Law Professor & Bestselling Author Amy Chua (Co-Sponsored by Allstate & Schiff Hardin, LLP)'"];
    NSArray *filteredResults = [results filteredArrayUsingPredicate:lunchSessionPredicate];
    STAssertEquals((NSUInteger)1, [filteredResults count], @"1 session expected in filtered data");
    
    Session *lunchSession = [filteredResults objectAtIndex:0];
    NSDate *sessionStartDateTime = [lunchSession datetimeStart];
    

}


#endif

@end
