//
//  DetailsViewController.m
//  ARSSReader
//
//  Created by Marin Todorov on 5/25/10.
//  Copyright 2010 Marin Todorov. All rights reserved.
//

#import "RssDetailsViewController.h"


@implementation RssDetailsViewController

@synthesize item;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	webView.delegate = self;
	webView.scalesPageToFit = YES;
	NSURL* url = [NSURL URLWithString:[item objectForKey:@"link"]];
	[webView loadRequest:[NSURLRequest requestWithURL:url]];
	NSLog(@"loading url...");
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}


- (void)dealloc {
	//very important, otherwise unfinished requests will cause exc_badaccess
	webView.delegate = nil;
    [super dealloc];
}

#pragma mark -
#pragma mark UIWebViewDelegate messages
- (void)webViewDidStartLoad:(UIWebView *)webView
{
	loader.hidden = NO;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	loader.hidden = YES;
}


@end