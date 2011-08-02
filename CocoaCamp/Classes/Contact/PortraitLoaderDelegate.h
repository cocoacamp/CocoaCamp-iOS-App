//
//  ImageLoaderDelegate.h
//  CocoaCamp
//
//  Created by airportyh on 8/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PortraitLoader;

@protocol PortraitLoaderDelegate

@required
- (void) imageForReg: (NSString *)regID finishedLoading: (NSData *)imageData;

@end
