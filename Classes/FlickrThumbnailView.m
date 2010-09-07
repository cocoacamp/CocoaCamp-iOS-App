    //
//  FlickrThumbnailView.m
//  CocoaCamp
//
//  Created by airportyh on 9/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
#import "FlickrThumbnailView.h"
#import "SearchResultsPhotoSource.h"
#import "SearchResultsModel.h"
#import "FlickrAddPhotoController.h"

@implementation FlickrThumbnailView

-(id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)bundle {
	if (self = [super initWithNibName:nibName bundle:bundle]){
		self.title = @"Flickr Wall";
		UIImage* image = [UIImage imageNamed:@"photoIcon.png"];
		self.tabBarItem = [[[UITabBarItem alloc] initWithTitle:self.title image:image tag:0] autorelease];
		//self.wantsFullScreenLayout = NO;
		self.hidesBottomBarWhenPushed = NO;
	}
	return self;
}

- (void)viewDidLoad{
	self.view.autoresizesSubviews = YES;
	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	
	UIBarButtonItem *addItem = [[UIBarButtonItem alloc] 
							 initWithTitle:@"Add" style:UIBarButtonItemStylePlain 
							 target:self action:@selector(addPhoto)];
	self.navigationItem.rightBarButtonItem = addItem;
	
	UIBarButtonItem *refreshItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh 
												   target:self 
												   action:@selector(refresh)] autorelease];
	
	
	self.navigationItem.leftBarButtonItem = refreshItem;
	
	if (self.photoSource == nil){
		SearchResultsPhotoSource *ps = [[SearchResultsPhotoSource alloc] initWithModel:CreateSearchModelWithCurrentSettings()];
		realModel = [[ps underlyingModel] retain];
		[self.photoSource load:TTURLRequestCachePolicyNoCache more:NO];
		self.photoSource = ps;
	}
	
}

- (void)addPhoto{
	FlickrAddPhotoController *addController = [[FlickrAddPhotoController alloc] 
											   initWithNibName:@"FlickrAddPhotoController" bundle:nil];
	[self.navigationController pushViewController:addController animated:YES];
	[addController release];
}

- (void)refresh{
	if (self.photoSource.isLoading)
		return;
	[self.photoSource performSelector:@selector(reset)];
	[self.photoSource load:TTURLRequestCachePolicyNoCache more:NO];
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
	return YES;
}

@end
