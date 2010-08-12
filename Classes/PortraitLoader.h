//
//  ImageLoader.h
//  CocoaCamp
//
//  Created by airportyh on 8/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PortraitLoaderDelegate.h"

@interface PortraitLoader : NSObject {
	id<PortraitLoaderDelegate> delegate;
	NSString *regID;
	NSMutableData *data;
}

@property (nonatomic, retain) id<PortraitLoaderDelegate> delegate;
@property (nonatomic, retain) NSString *regID;
@property (nonatomic, retain) NSMutableData *data;

- (void) loadImage:(NSString *)regID delegate:(id<PortraitLoaderDelegate>)delegate;

@end
