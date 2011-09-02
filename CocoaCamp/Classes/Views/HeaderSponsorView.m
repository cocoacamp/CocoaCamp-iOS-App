//
//  HeaderSponsorView.m
//  CocoaCamp
//
//  Created by Rusty Zarse on 9/1/11.
//  Copyright 2011 LeVous, LLC. All rights reserved.
//

#import "HeaderSponsorView.h"

@implementation HeaderSponsorView
@synthesize sponsorView;

- (void)fadeCurrentSponsor{
    [UIView beginAnimations:@"sponsorFade" context:nil];
    [UIView setAnimationDuration:1.5];
    for(UIView *subView in [[self sponsorView] subviews]){
        [subView setAlpha:0.0];
    }
    [UIView commitAnimations];
}

- (void)awakeFromNib{
    [self fadeCurrentSponsor];

}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self fadeCurrentSponsor];
    }
    return self;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
