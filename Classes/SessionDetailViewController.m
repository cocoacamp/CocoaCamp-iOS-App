//
//  SessionDetailViewController.m
//  CocoaCamp
//
//  Created by airportyh on 8/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SessionDetailViewController.h"
#import "AsyncImageView.h"
#import "SessionViewController.h"

@implementation SessionDetailViewController
@synthesize talk, portraitImg, titleLbl, descriptionLbl;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = @"Session Detail";
	
	NSString *regID = [talk objectForKey:@"register_id"];
	NSDictionary *reg = [talk objectForKey: @"Register"];
	
	NSString *title = [talk objectForKey:@"title"];
	
	NSString *speaker = [NSString stringWithFormat: @"%@ %@", 
						 [reg objectForKey: @"first_name"], 
						 [reg objectForKey: @"last_name"]];
	NSString *location = [talk objectForKey: @"location"];
	
	titleLbl.text = title;
	
	descriptionLbl.text = [NSString stringWithFormat:@"%@\n%@", speaker, location];
	
	NSString *thumbURL = [SessionViewController thumbnailURL:regID];
	NSData *imageData = [AsyncImageView cachedImageDataFor: thumbURL];
	NSLog(@"thumbURL: %@", thumbURL);
	if (imageData != NULL){
		NSLog(@"Image data retrieved from cache!");
	}
	portraitImg.image = [UIImage imageWithData:imageData];
	portraitImg.autoresizingMask = ( UIViewAutoresizingFlexibleWidth || UIViewAutoresizingFlexibleHeight );
	
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
