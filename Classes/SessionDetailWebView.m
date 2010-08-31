//
//  SessionDetailWebView.m
//  CocoaCamp
//
//  Created by airportyh on 8/30/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SessionDetailWebView.h"


@implementation SessionDetailWebView
@synthesize webView, progressInd;

- (void)loadURL: (NSURL *)url{
	NSURLRequest *req = [NSURLRequest requestWithURL:url];
	[self.webView loadRequest:req];
}

- (UIActivityIndicatorView *)progressInd {
	if (progressInd == nil)
	{
		CGRect frame = CGRectMake(self.view.frame.size.width/2-15, self.view.frame.size.height/2-15, 30, 30);
		progressInd = [[UIActivityIndicatorView alloc] initWithFrame:frame];
		[progressInd startAnimating];
		progressInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
		[progressInd sizeToFit];
		progressInd.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin |
										UIViewAutoresizingFlexibleRightMargin |
										UIViewAutoresizingFlexibleTopMargin |
										UIViewAutoresizingFlexibleBottomMargin);
		
		progressInd.tag = 1;    // tag this view for later so we can remove it from recycled table cells
	}
	return progressInd;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
	[self.view addSubview: self.progressInd];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
	[self.progressInd removeFromSuperview];
}

- (void)dealloc {
    [super dealloc];
	[self.webView release];
	if (progressInd)
		[progressInd release];
}


@end
