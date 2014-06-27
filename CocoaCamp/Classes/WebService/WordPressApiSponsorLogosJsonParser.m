//
//  WordPressApiSponsorLogosJsonParser.m
//  CocoaCamp
//
//  Created by Rusty Zarse on 11/8/11.
//  Copyright (c) 2011 LeVous, LLC. All rights reserved.
//

#import "WordPressApiSponsorLogosJsonParser.h"

#import "JSON.h"
#import "GTMNSString+HTML.h"


@implementation WordPressApiSponsorLogosJsonParser

- (NSArray *)parseUrlsFromJson:(NSString *)json{
      
    NSMutableArray *imageUrls = [NSMutableArray array];
    
    NSError *error = nil;
    SBJSON *jsonParser = [[SBJSON alloc] init];
    NSDictionary *jsonData = [jsonParser objectWithString:json error:&error];
    [jsonParser release];
    NSDictionary *page = [jsonData objectForKey:@"page"];
    NSArray *attachments = [page objectForKey:@"attachments"];
    
    for( NSDictionary *attachment in attachments){
        NSDictionary *imageSet = [attachment objectForKey:@"images"];
        NSDictionary *mediumImage = [imageSet objectForKey:@"medium"];
        NSString *imageUrl = [mediumImage objectForKey:@"url"];
        if( imageUrl ) [imageUrls addObject:[NSURL URLWithString:imageUrl]];
    }
    
    
    return [NSArray arrayWithArray:imageUrls];
    
}

@end
