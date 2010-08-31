//
//  SessionDetailWebView.h
//  CocoaCamp
//
//  Created by airportyh on 8/30/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SessionDetailWebView : UIViewController <UIWebViewDelegate> {
	UIWebView *webView;
	UIActivityIndicatorView *progressInd;
}

@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) UIActivityIndicatorView *progressInd;

- (void)loadURL: (NSURL *)url;

@end
