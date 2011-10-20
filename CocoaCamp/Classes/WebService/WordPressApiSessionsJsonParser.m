//
//  WordPressApiSessionsJsonParser.m
//  CocoaCamp
//
//  Created by Rusty Zarse on 10/19/11.
//  Copyright 2011 LeVous, LLC. All rights reserved.
//

#import "WordPressApiSessionsJsonParser.h"
#import "JSON.h"
#import "Session.h"
#import "GTMNSString+HTML.h"



@implementation WordPressApiSessionsJsonParser
- (void)dealloc{
    [gregorianCalendar release];
    [scheduleDays release];
    [numberFormatter release];
    [super dealloc];
}


- (void)initializeScheduleDateArray{
    NSDateComponents *scheduleDate = [[NSDateComponents alloc] init];
    [scheduleDate setYear:2011];
    [scheduleDate setMonth:11];
    [scheduleDate setDay:17];
    
    NSDate *nov17 = [gregorianCalendar dateFromComponents:scheduleDate];
    
    [scheduleDate setDay:18];
    NSDate *nov18 = [gregorianCalendar dateFromComponents:scheduleDate];
    
    [scheduleDate setDay:19];
    NSDate *nov19 = [gregorianCalendar dateFromComponents:scheduleDate];
    
    [scheduleDate setDay:20];
    NSDate *nov20 = [gregorianCalendar dateFromComponents:scheduleDate];
    
    [scheduleDate release];
    
    scheduleDays = [[NSDictionary alloc] initWithObjectsAndKeys:nov17, @"November 17th", nov18, @"November 18th", nov19, @"November 19th", nov20, @"November 20th", nil];
}

- (id)initWithCoreDataManager:(CoreDataManager *)aCoreDataManager{
    self = [super init];
    if (self) {
        coreDataManager = aCoreDataManager;
        gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        [gregorianCalendar setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"EST"]]; // sorry, we're in Atlanta
        numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setFormatterBehavior:[NSNumberFormatter defaultFormatterBehavior]]; 
        [self initializeScheduleDateArray];
    }
    
    return self;
}

- (Session *)applyEntryDictionary:(NSDictionary *)entryDictionary forSessionDateString:(NSString *)sessionDateString toNewOrExistingSessionUsingCurrentSessionsSet:(NSSet *)currentSessions{
    
    NSDate *sessionDate = [scheduleDays objectForKey:sessionDateString];
    
    NSString *sourceId = [[entryDictionary objectForKey:@"id"] stringValue];
    NSString *title = [[entryDictionary objectForKey:@"title"] gtm_stringByUnescapingFromHTML];
    NSDictionary *customFieldsDictionary = [entryDictionary objectForKey:@"custom_fields"];
    NSString *eventTime = [[customFieldsDictionary objectForKey:@"event_time"] objectAtIndex:0];
    
    NSDate *sessionDateTime = sessionDate;
    
    // parse the time string ex: "3:30PM-5:00PM"
    NSRange rangeOfDash = [eventTime rangeOfString:@"-"];
    if(rangeOfDash.location != NSNotFound){
        NSString *startTime = [eventTime substringToIndex:rangeOfDash.location];
        NSString *amPm = [startTime substringFromIndex:[startTime length] - 2];
        BOOL isAM = ([amPm isEqualToString:@"AM"]);
        // strip the AM/PM
        NSString *hourAndMinute = [startTime substringToIndex:[startTime length] - 2];
        NSRange rangeOfColon = [hourAndMinute rangeOfString:@":"];
        if (rangeOfColon.location != NSNotFound) {
            NSString *hour = [hourAndMinute substringToIndex:rangeOfColon.location];
            // substring from colon
            NSString *minute = [hourAndMinute substringFromIndex:rangeOfColon.location+1];
            
            unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
            NSDateComponents *dateComponents = [gregorianCalendar components:unitFlags fromDate:sessionDate];
            @try {
                int hourInteger = [[numberFormatter numberFromString:hour] intValue];
                if(!isAM) hourInteger += 12;
                [dateComponents setHour:hourInteger];
                [dateComponents setMinute:[[numberFormatter numberFromString:minute] intValue]];
            }
            @catch (NSException *exception) {
                // just move on
                NSLog( @"ERROR: [WordPressApiSessionsJsonParser applyEntryDictionary:forSessionDate:toNewOrExistingSessionUsingCurrentSessionsSet:] Parsing of event failed.  Skipping and moving on.");
            }
            @finally {
                sessionDateTime = [gregorianCalendar dateFromComponents:dateComponents];
            }
        
        }
        
    }
    
    
    
    
    
    Session *session = nil;
    // look for existing session
    NSPredicate *idPredicate = [NSPredicate predicateWithFormat:@"externalId = %@", sourceId];
    NSSet *filteredSet = [currentSessions filteredSetUsingPredicate:idPredicate];
    // if filtered set matches
    if ([filteredSet count]) {
        // assuming only one in this set 
        session = [filteredSet anyObject];
    }else{
        // not found so insert
        session = (Session *)[NSEntityDescription insertNewObjectForEntityForName:@"Session"
                                                           inManagedObjectContext:[coreDataManager managedObjectContext]];
    }
    
    [session setTitle:title];
    [session setSessionTimeString:eventTime];
    [session setDatetimeStart:sessionDateTime];
    [session setSessionDayTitle:sessionDateString];
    [session setExternalId:sourceId];
    return session;
}

- (NSArray *)parseSessionScheduleJson:(NSString *)json{
    
    NSError *error = nil;
    SBJSON *jsonParser = [[SBJSON alloc] init];
	NSDictionary *jsonData = [jsonParser objectWithString:json error:&error];
    [jsonParser release];
    NSDictionary *categories = [jsonData objectForKey:@"category"];
    NSString *sessionDateString = [categories objectForKey:@"title"];
    NSArray *posts = [jsonData objectForKey:@"posts"];
    
    NSArray *allCurrentSessions = [coreDataManager resultsForRequest:[coreDataManager fetchRequestForEntityNamed:@"Session"]];

    NSSet *currentSessionsSet = [NSSet setWithArray:allCurrentSessions];
    
    NSMutableArray *entryModels = [NSMutableArray array];
    for (NSDictionary *entryDictionary in posts) {
        Session *session = [self applyEntryDictionary:entryDictionary forSessionDateString:sessionDateString toNewOrExistingSessionUsingCurrentSessionsSet:currentSessionsSet];
        [entryModels addObject:session];
    }
    return [NSArray arrayWithArray:entryModels];
}

@end
