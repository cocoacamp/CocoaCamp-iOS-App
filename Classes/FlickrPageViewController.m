//
//  FlickrPageViewController.m
//  CocoaCamp
//
//  Created by Ken  Icklan on 8/6/10.
//

#import "FlickrPageViewController.h"

@implementation FlickrPageViewController


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	
	UIBarButtonItem * doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
	target:self
	action:@selector(done)];
	self.navigationItem.leftBarButtonItem = doneButton ; 
	[doneButton release] ;
}



- (void)viewWillAppear:(BOOL)animated {
    
	[super viewWillAppear:animated];
	
	NSURL *cocoaFlickr = [[NSURL alloc] initWithString:@"http://m.flickr.com/#/photos/52319257@N06/"];

	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:cocoaFlickr];
	
	[aWebView loadRequest: request];
	aWebView.delegate = self;
	
	[request release];
	[cocoaFlickr release];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {	
    // starting the load, show the activity indicator in the status bar
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
    // finished loading, hide the activity indicator in the status bar
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	
    // load error, hide the activity indicator in the status bar
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    // report the error inside the webview
	
    NSString* errorString = [NSString stringWithFormat:
                             @"<html><center><font size=+5 color='red'>An error occurred:<br>%@</font></center></html>",
                             error.localizedDescription];
							[aWebView loadHTMLString:errorString baseURL:nil];
	
}

- (void)viewWillDisappear:(BOOL)animated {
    aWebView.delegate = nil;    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
}

- (void)done {
	 [[self parentViewController] dismissModalViewControllerAnimated:YES];	
 }



/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/

/*
- (void)viewDidDisappear:(BOOL)animated {

 	[super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/



#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    }

- (void)viewDidUnload {
    aWebView = nil;
	[aWebView release];
}


- (void)dealloc {
	aWebView = nil;
	[aWebView release];
	[super dealloc];
}


@end

