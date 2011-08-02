//
//  CocoaCampAppDelegate.h
//  CocoaCamp
//
//  Created by Rusty Zarse on 8/2/11.
//  Copyright 2011 LeVous, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Bump.h"

@interface CocoaCampAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) Bump *bump;

@end
