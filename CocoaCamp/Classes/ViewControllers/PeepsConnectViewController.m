//
//  PeepsConnectViewController.m
//  CocoaCamp
//
//  Created by Rusty Zarse on 12/22/11.
//  Copyright (c) 2011 LeVous, LLC. All rights reserved.
//

#import "PeepsConnectViewController.h"


@implementation PeepsConnectViewController
@synthesize myInfoBarButtonItem;
@synthesize myInfoQRCodeImage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    
        self.title = @"Connect";
		UIImage* image = [UIImage imageNamed:@"connect-icon.png"];
		self.tabBarItem = [[[UITabBarItem alloc] initWithTitle:@"Connect" image:image tag:0] autorelease];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[self navigationItem] setRightBarButtonItem:[self myInfoBarButtonItem]];
}

- (void)viewDidUnload
{
    [self setMyInfoQRCodeImage:nil];
    [self setMyInfoBarButtonItem:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)scanPressed:(id)sender {
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    [self presentModalViewController: reader
                            animated: YES];
    [reader release];
    
}

- (IBAction)myInfoButtonPressed:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Not Implemented"
                                                    message:@"Need ViewController to gather user info"
                                                   delegate:nil
                                          cancelButtonTitle:@"Yaderhey" 
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
                          
                          }

- (void) imagePickerController: (UIImagePickerController*) reader didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    id<NSFastEnumeration> results = [info objectForKey: ZBarReaderControllerResults];
    UIImage *image = [info objectForKey: UIImagePickerControllerOriginalImage];
    [reader dismissModalViewControllerAnimated: YES];
    
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        // EXAMPLE: just grab the first barcode
        break;
    
    // TODO: do something useful with the barcode data
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Not Implemented"
                                                    message:symbol.data                                                   delegate:nil
                                          cancelButtonTitle:@"Yaderhey" 
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
    
}

- (void)dealloc {
    [myInfoQRCodeImage release];
    [myInfoBarButtonItem release];
    [super dealloc];
}
@end
