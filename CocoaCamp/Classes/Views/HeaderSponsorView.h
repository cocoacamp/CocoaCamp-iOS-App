//
//  HeaderSponsorView.h
//  CocoaCamp
//
//  Created by Rusty Zarse on 9/1/11.
//  Copyright 2011 LeVous, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeaderSponsorView : UIView{
    NSArray *sponsorLogos;
    NSUInteger nextLogoIdx;
}
@property(retain, nonatomic) IBOutlet UIView *sponsorView;
@end
