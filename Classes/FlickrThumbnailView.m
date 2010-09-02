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


- (void)viewDidLoad{
	UIBarButtonItem *addItem = [[UIBarButtonItem alloc] 
							 initWithTitle:@"Add" style:UIBarButtonItemStylePlain 
							 target:self action:@selector(addPhoto)];
	self.navigationItem.rightBarButtonItem = addItem;
	
	UIBarButtonItem *refreshItem = [[UIBarButtonItem alloc] 
							 initWithTitle:@"Refresh" style:UIBarButtonItemStylePlain 
							 target:self action:@selector(refresh)];
	
	self.navigationItem.leftBarButtonItem = refreshItem;
	
	 
	SearchResultsPhotoSource *ps = [[SearchResultsPhotoSource alloc] initWithModel:CreateSearchModelWithCurrentSettings()];
	realModel = [[ps underlyingModel] retain];
	[self.photoSource load:TTURLRequestCachePolicyNoCache more:NO];
	self.photoSource = ps;
	
}

- (void)addPhoto{
	FlickrAddPhotoController *addController = [[FlickrAddPhotoController alloc] 
											   initWithNibName:@"FlickrAddPhotoController" bundle:nil];
	[self.navigationController pushViewController:addController animated:YES];
	[addController release];
}

- (void)refresh{
	[self.photoSource performSelector:@selector(reset)];
	[self.photoSource load:TTURLRequestCachePolicyNoCache more:NO];
}

@end
