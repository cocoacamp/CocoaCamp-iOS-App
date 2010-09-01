//
//  MyStyledTextLabel.m
//  CocoaCamp
//
//  Created by airportyh on 8/30/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MyStyledTextLabel.h"


@implementation MyStyledTextLabel
@synthesize delegate;

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event {
	if (_highlightedNode){
		if ([self.delegate respondsToSelector:@selector(didEndTouchOnANode)])
			[self.delegate didEndTouchOnANode];
	}
	[super touchesEnded:touches withEvent:event];
}

@end
