//
//  CocoaCampAppDelegate.h
//  CocoaCamp
//
//  Created by Jonathan Freeman on 7/12/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Bump.h"

@interface CocoaCampAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate, BumpDelegate> {
    UIWindow *window;
    UITabBarController *tabBarController;
	Bump *bump;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, retain) Bump *bump;

- (void)initializeBump;

@end
