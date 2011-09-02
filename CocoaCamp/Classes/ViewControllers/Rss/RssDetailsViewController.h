//
//  DetailsViewController.h
//  ARSSReader
//
//  Created by Marin Todorov on 5/25/10.
//  Copyright 2010 Marin Todorov. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RssDetailsViewController : UIViewController <UIWebViewDelegate> {
	NSDictionary* item;
	
	IBOutlet UIWebView* webView;
	IBOutlet UIActivityIndicatorView* loader;
}

@property (retain, nonatomic) NSDictionary* item;

@end
