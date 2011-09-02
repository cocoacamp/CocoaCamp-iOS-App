    //
//  CCBranding.m
//  CocoaCamp
//
//  Created by Rusty Zarse on 9/1/11.
//  Copyright 2011 LeVous, LLC. All rights reserved.
//

#import "CCBranding.h"
#import "CocoaCampConstants.h"

@implementation CCBranding

@synthesize brandedConfig;
- (id)init
{
    self = [super init];
    if (self) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"branded" ofType:@"plist"];
        [self setBrandedConfig:[NSDictionary dictionaryWithContentsOfFile:path]];
        fileNamePrefix = [[self brandedConfig] objectForKey:kBrandedPListKeyFileNamePrefix];
        if (!fileNamePrefix) fileNamePrefix = @"";
    }
    
    return self;
}

- (NSString *)fileNamePrefix{
    return fileNamePrefix;
}

- (UIImage *)logoImage{
    NSString *imageName = [NSString stringWithFormat:@"%@logo.png", fileNamePrefix];
    return [UIImage imageNamed:imageName];
}

- (UIView *)headerView{
    NSString *headerViewXibName = [[self brandedConfig] objectForKey:kBrandedPListKeyHeaderNibName];
    if (headerViewXibName) {
        
       /* NSArray *nibViews = [[NSBundle mainBundle] loadNibNamed:headerViewXibName
                                                          owner:nil
                                                        options:nil];
        
        UIView *headerView = [nibViews objectAtIndex:1];
    */
        UIViewController *tempController = [[UIViewController alloc] initWithNibName:headerViewXibName bundle:nil];
        UIView *headerView = [tempController view];
        [tempController release];
         
        return headerView;
    }
    return nil;
}

- (void)applyConfiguredBrandingToTableView:(UITableView *)tableView {
    UIView *headerView = [self headerView];
    if (headerView) {
        [tableView setTableHeaderView:headerView];
    }
}

@end
