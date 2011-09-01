//
//  CCBranding.h
//  CocoaCamp
//
//  Created by Rusty Zarse on 9/1/11.
//  Copyright 2011 LeVous, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCBranding : NSObject{
    NSString *fileNamePrefix;
}
@property(retain, nonatomic) NSDictionary *brandedConfig;
- (NSString *)fileNamePrefix;
- (UIImage *)logoImage;
- (UIView *)headerView;
- (void)applyConfiguredBrandingToTableView:(UITableView *)tableView;

@end
