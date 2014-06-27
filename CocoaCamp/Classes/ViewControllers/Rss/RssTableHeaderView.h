//
//  TableHeaderView.h
//  ARSSReader
//
//  Created by Marin Todorov on 6/2/10.
//  Copyright 2010 Marin Todorov. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RssTableHeaderView : UIImageView {
	UILabel* label;
}

- (id)initWithText:(NSString*)text;
- (void)setText:(NSString*)text;

@end
