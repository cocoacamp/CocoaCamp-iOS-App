//
//  PeepsConnectViewController.h
//  CocoaCamp
//
//  Created by Rusty Zarse on 12/22/11.
//  Copyright (c) 2011 LeVous, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"

@interface PeepsConnectViewController : UIViewController<ZBarReaderDelegate>
- (IBAction)scanPressed:(id)sender;
- (IBAction)myInfoButtonPressed:(id)sender;

@property (retain, nonatomic) IBOutlet UIBarButtonItem *myInfoBarButtonItem;
@property (retain, nonatomic) IBOutlet UIImageView *myInfoQRCodeImage;
@end
