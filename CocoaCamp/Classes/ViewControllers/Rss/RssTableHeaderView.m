//
//  TableHeaderView.m
//  ARSSReader
//
//  Created by Marin Todorov on 6/2/10.
//  Copyright 2010 Marin Todorov. All rights reserved.
//

#import "RssTableHeaderView.h"
#import "CCBranding.h"

@implementation RssTableHeaderView

- (id)initWithText:(NSString*)text 
{
    
    
	UIImage* img = [UIImage imageNamed:@"arss_header.png"];
    if ((self = [super initWithImage:img])) {
        
        // Initialization code
        label = [[UILabel alloc] initWithFrame:CGRectMake(20,10,200,70)];
        label.textColor = [UIColor whiteColor];
        label.shadowColor = [UIColor grayColor];
        label.shadowOffset = CGSizeMake(1, 1);
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:20];
        label.text = text;
        label.numberOfLines = 2;
        [self addSubview:label];
        [label release];
        
        CCBranding *branding = [[CCBranding alloc] init];
        UIView *brandedHeader = [branding headerView];
        if (brandedHeader) {
            [self addSubview:brandedHeader];
            [label setFrame:CGRectMake(10, 70, 310, 23)];
            [label setNumberOfLines:1];
            [label setFont:[UIFont systemFontOfSize:16]];
            [label setBackgroundColor:[UIColor lightGrayColor]];
        }
        
        
    }
    return self;
}

- (void)setText:(NSString*)text
{
	label.text = text;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc {
    [super dealloc];
}


@end
