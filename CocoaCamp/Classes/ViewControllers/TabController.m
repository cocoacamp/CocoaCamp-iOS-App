    //
//  TabController.m
//  CocoaCamp
//
//  Created by airportyh on 9/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TabController.h"
#import <Three20/Three20.h>
#import <Three20/Three20+Additions.h>

@implementation TabController

- (void)viewDidLoad {
	[self setTabURLs:[NSArray arrayWithObjects:
					 
					  @"tt://schedule",
                      @"tt://connect",
					  @"tt://flickr",
					  @"tt://twitter",
					  @"tt://news",
                      
					  nil]];
}


@end
