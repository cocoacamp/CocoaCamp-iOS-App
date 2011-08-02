    //
//  TabController.m
//  CocoaCamp
//
//  Created by airportyh on 9/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TabController.h"

@implementation TabController

- (void)viewDidLoad {
	[self setTabURLs:[NSArray arrayWithObjects:
					  @"tt://people",
					  @"tt://schedule",
					  @"tt://flickr",
					  @"tt://twitter",
					  nil]];
}


@end
