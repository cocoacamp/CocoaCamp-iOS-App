//
//  WordPressApiSponsorLogosJsonParser.h
//  CocoaCamp
//
//  Created by Rusty Zarse on 11/8/11.
//  Copyright (c) 2011 LeVous, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WordPressApiSponsorLogosJsonParser : NSObject
- (NSArray *)parseUrlsFromJson:(NSString *)json;
@end
