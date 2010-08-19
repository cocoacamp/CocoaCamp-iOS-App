    //
//  SecondViewController.m
//  CocoaCamp
//
//  Created by Rusty Zarse on 8/6/10.
//  Copyright 2010 LeVous, LLC. All rights reserved.
//

#import "SecondViewController.h"


@implementation SecondViewController

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self.navigationController setNavigationBarHidden:NO animated:YES];
	
	self.title = @"Second View";
	TTStyledTextLabel *styledLabel = [[TTStyledTextLabel alloc] initWithFrame:CGRectMake(10.0, 80.0, 300.0, 400.0)];
	[styledLabel setHtml:@"It's really pretty cool, no <b>way freakin' cool</b><img src=\"bundle://iPhoneAppIcon.png\"/> that this <i>library does so damn much!</i><br/><br/>rock http://scope.three20.info/"];
	[[self view] addSubview:styledLabel];
	[styledLabel release];
	
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
