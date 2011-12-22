//
//  HeaderSponsorView.m
//  CocoaCamp
//
//  Created by Rusty Zarse on 9/1/11.
//  Copyright 2011 LeVous, LLC. All rights reserved.
//

#import "HeaderSponsorView.h"
#import "WebServiceDataManager.h"

@implementation HeaderSponsorView
@synthesize sponsorView;

- (void)changeCurrentSponsor{
    if(!sponsorLogos){
        
        // this should be moved to the/a plist
        sponsorLogos = [[NSArray arrayWithObjects:
                         @"Allstate_Platinum.jpg",
                         @"AlstonBird_Platinum.jpg",
                         @"Microsoft.jpg",
                        @"Prudential_Platinum.jpg",
                        @"SchiffHardin_Platinum.jpg",
                        @"Seyfarth_Platinum.jpg",
                        @"Walmart_Premier.jpg",
                        nil] retain];
        nextLogoIdx = 0;
        
         
        
        
    }
    
    [UIView animateWithDuration:1.5 delay:5.0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        for(UIView *subView in [[self sponsorView] subviews]){
            [subView setAlpha:0.0];
        }
    } completion:^(BOOL complete){
        for(UIView *subView in [[self sponsorView] subviews]){
            [subView removeFromSuperview];
        }
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, sponsorView.frame.size.width, sponsorView.frame.size.height)];
        [imageView setAlpha:0.0];
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        NSString *logoName = [sponsorLogos objectAtIndex:nextLogoIdx];
        if (++nextLogoIdx >= [sponsorLogos count]) {
            nextLogoIdx = 0;
        }
        [imageView setImage:[UIImage imageNamed:logoName]];
        [[self sponsorView] addSubview:imageView];
        [imageView release];
        
        [UIView animateWithDuration:1.5 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                            [imageView setAlpha:1.0];
                        } 
                         completion:^(BOOL finished) {
                             [self changeCurrentSponsor];
                        }];
    }];
    
}

- (void)dealloc{
    [sponsorLogos release], sponsorLogos = nil;
    [super dealloc];
}

- (void)awakeFromNib{
    [self changeCurrentSponsor];

}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self changeCurrentSponsor];
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
