//
//  ImageLoader.m
//  CocoaCamp
//
//  Created by airportyh on 8/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PortraitLoader.h"
#import "PortraitLoaderDelegate.h"

@implementation PortraitLoader
@synthesize delegate, regID, data;



- (void)connection:(NSURLConnection *)theConnection didReceiveData:(NSData *)incrementalData {
	if (self.data==nil) {
		self.data = [[NSMutableData alloc] initWithCapacity:2048];
	} 
	[self.data appendData:incrementalData];
}

- (void)connectionDidFinishLoading:(NSURLConnection*)connection {
	[connection release];
	//NSLog(@"download finished for %@", self.regID);
	[self.delegate imageForReg: self.regID finishedLoading: self.data];
	[self.data release];
}

- (void) loadImage: (NSString *)_regID delegate: (id<PortraitLoaderDelegate>)_delegate{
	self.delegate = _delegate;
	self.regID = _regID;
	NSString *urlString = [NSString stringWithFormat: @"http://cocoa:camp@cocoacamp.org/thumbnail/show?id=%@&w=50&h=50", self.regID];
	NSURL *url = [NSURL URLWithString: urlString];	
	NSURLRequest* request = [NSURLRequest requestWithURL:url 
											 cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
	[[NSURLConnection alloc] initWithRequest:request delegate:self];
}

@end
