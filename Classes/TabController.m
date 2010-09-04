    //
//  TabController.m
//  CocoaCamp
//
//  Created by airportyh on 9/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TabController.h"
#import "SessionViewController.h"
#import "FlickrThumbnailView.h"
#import "ContactExchangeViewController.h"

@implementation TabController

- (void)viewDidLoad {
	[self setTabURLs:[NSArray arrayWithObjects:
					  @"tt://schedule",
					  @"tt://flickr",
					  @"tt://people",
					  nil]];
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
	NSLog(@"tabbar rotate");
	return YES;
}

@end
