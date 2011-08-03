//
//  WebServiceUrlManager.h
//  CocoaCamp
//
//  Created by Rusty Zarse on 8/2/11.
//  Copyright 2011 LeVous, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebServiceUrlManager : NSObject{
    NSURL *attendeeListUrl;
}

@property(readonly, nonatomic) NSURL *attendeeListUrl;

@end
