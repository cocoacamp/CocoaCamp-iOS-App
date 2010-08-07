
/*
 File: FlickrController.m
 Abstract: View controller to manage picture taking and flickr sharing
 
 */

#import "FlickrController.h"
#import "FlickrPageViewController.h"


@implementation FlickrController

@synthesize imageView;
@synthesize hideControlsButton;
@synthesize takePictureButton,  selectFromCameraRollButton, flickrSendButton, flickrViewButton, headerView;


- (void)viewDidLoad {
		
	[super viewDidLoad] ;
		
	[self.navigationController setNavigationBarHidden:YES animated:NO];
	
	
	// set up custom header view and buttons to get image and share on flickr
	
	headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.view.bounds.size.width,60)];
	headerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;		
	headerView.backgroundColor = [UIColor lightGrayColor];
	
	UIImage *roundrecbuttonnorm = [UIImage imageNamed:@"roundrecbuttonnorm.png"];
	UIImage *roundrecbuttonnormstretch = [roundrecbuttonnorm stretchableImageWithLeftCapWidth:30 topCapHeight:0];		
	UIImage *roundrecbuttonpress = [UIImage imageNamed:@"roundrecbuttonpress.png"];
	UIImage *roundrecbuttonpressstretch = [roundrecbuttonpress stretchableImageWithLeftCapWidth:30 topCapHeight:0];			
	
	takePictureButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
	[takePictureButton setTitle:@"Share Image From Camera" forState:UIControlStateNormal];		
	takePictureButton.frame = CGRectMake(self.view.bounds.size.width - 77, 3, 75, 60);
	[takePictureButton setBackgroundImage:roundrecbuttonnormstretch forState:UIControlStateNormal];
	[takePictureButton setBackgroundImage:roundrecbuttonpressstretch  forState:UIControlStateHighlighted];			
	[takePictureButton setTitleColor:[UIColor whiteColor]  forState:UIControlStateNormal];
	[takePictureButton.titleLabel setFont:[UIFont boldSystemFontOfSize:10]];
	takePictureButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;	
	takePictureButton.titleLabel.textAlignment = UITextAlignmentCenter;	
	takePictureButton.titleLabel.lineBreakMode = UILineBreakModeWordWrap;	
	[takePictureButton addTarget:self action:@selector (getCameraPicture:) forControlEvents:UIControlEventTouchUpInside];
	
	selectFromCameraRollButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
	[selectFromCameraRollButton setTitle:@"Share Image From Album" forState:UIControlStateNormal];		
	selectFromCameraRollButton.frame = CGRectMake(self.view.bounds.size.width - 157, 3, 75, 60);
	[selectFromCameraRollButton setBackgroundImage:roundrecbuttonnormstretch forState:UIControlStateNormal];
	[selectFromCameraRollButton setBackgroundImage:roundrecbuttonpressstretch  forState:UIControlStateHighlighted];			
	[selectFromCameraRollButton setTitleColor:[UIColor whiteColor]  forState:UIControlStateNormal];
	[selectFromCameraRollButton.titleLabel setFont:[UIFont boldSystemFontOfSize:10]];
	selectFromCameraRollButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;	
	selectFromCameraRollButton.titleLabel.textAlignment = UITextAlignmentCenter;	
	selectFromCameraRollButton.titleLabel.lineBreakMode = UILineBreakModeWordWrap;	
	[selectFromCameraRollButton addTarget:self action:@selector (selectExistingPicture) forControlEvents:UIControlEventTouchUpInside];
	
	flickrSendButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
	[flickrSendButton setTitle:@"Send to CocoaCamp Flickr Page" forState:UIControlStateNormal];		
	flickrSendButton.frame = CGRectMake(self.view.bounds.size.width - 237, 3, 75, 60);
	[flickrSendButton setBackgroundImage:roundrecbuttonnormstretch forState:UIControlStateNormal];
	[flickrSendButton setBackgroundImage:roundrecbuttonpressstretch  forState:UIControlStateHighlighted];			
	[flickrSendButton setTitleColor:[UIColor whiteColor]  forState:UIControlStateNormal];
	[flickrSendButton.titleLabel setFont:[UIFont boldSystemFontOfSize:10]];
	flickrSendButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;	
	flickrSendButton.titleLabel.textAlignment = UITextAlignmentCenter;	
	flickrSendButton.titleLabel.lineBreakMode = UILineBreakModeWordWrap;	
	[flickrSendButton addTarget:self action:@selector (flickrSend) forControlEvents:UIControlEventTouchUpInside];
	flickrSendButton.hidden = YES;
	
	flickrViewButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
	[flickrViewButton setTitle:@"View CocoaCamp Flickr Page" forState:UIControlStateNormal];		
	flickrViewButton.frame = CGRectMake(self.view.bounds.size.width - 317, 3, 75, 60);
	[flickrViewButton setBackgroundImage:roundrecbuttonnormstretch forState:UIControlStateNormal];
	[flickrViewButton setBackgroundImage:roundrecbuttonpressstretch  forState:UIControlStateHighlighted];			
	[flickrViewButton setTitleColor:[UIColor whiteColor]  forState:UIControlStateNormal];
	[flickrViewButton.titleLabel setFont:[UIFont boldSystemFontOfSize:10]];
	flickrViewButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;	
	flickrViewButton.titleLabel.textAlignment = UITextAlignmentCenter;	
	flickrViewButton.titleLabel.lineBreakMode = UILineBreakModeWordWrap;	
	[flickrViewButton addTarget:self action:@selector (flickrView) forControlEvents:UIControlEventTouchUpInside];
	
	
	
	
	UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,self.view.bounds.size.width,65)];
	whiteView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"headerBackground.png"]];	
	whiteView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	whiteView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"headerBackground.png"]];	
	
	
	[headerView addSubview:whiteView];
	[headerView addSubview:takePictureButton];
	[headerView addSubview:selectFromCameraRollButton];
	[headerView addSubview:flickrSendButton];
	[headerView addSubview:flickrViewButton];
		
	[whiteView release];
	[takePictureButton release];
	[selectFromCameraRollButton release];
	[flickrSendButton release];
	[flickrViewButton release];
	
	[self.view bringSubviewToFront:imageView];
	[self.view bringSubviewToFront:headerView];
	
	[self.view addSubview: headerView];	
	[headerView release];
		
}
	
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];	
		
}	


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);

}

- (void)dealloc {
   [imageView release];
	[super dealloc];
}

#pragma mark -
	
	- (void)getCameraPicture:(id)sender {
		if ([UIImagePickerController isSourceTypeAvailable:
			 UIImagePickerControllerSourceTypeCamera]) {
			
		UIImagePickerController *picker = [[UIImagePickerController alloc] init];
		picker.delegate = self;
		picker.allowsEditing = NO;
		picker.sourceType = UIImagePickerControllerSourceTypeCamera; 
		[self presentModalViewController:picker animated:YES];
		[picker release];
		}
		else {
			UIAlertView *alert = [[UIAlertView alloc] 
								  initWithTitle:@"Error accessing camera" 
								  message:@"Device does not support a camera" 
								  delegate:nil 
								  cancelButtonTitle:@"Cancel" 
								  otherButtonTitles:nil];
			[alert show];
			[alert release];
		}
		
	}
	
	- (void)selectExistingPicture {
		if ([UIImagePickerController isSourceTypeAvailable:
			 UIImagePickerControllerSourceTypePhotoLibrary]) {
			UIImagePickerController *picker = [[UIImagePickerController alloc] init];
			picker.delegate = self;
			picker.allowsEditing = NO;
			picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
			[self presentModalViewController:picker animated:YES];
			[picker release];
		}
		else {
			UIAlertView *alert = [[UIAlertView alloc] 
								  initWithTitle:@"Error accessing photo library" 
								  message:@"Device does not support a photo library" 
								  delegate:nil 
								  cancelButtonTitle:@"Cancel" 
								  otherButtonTitles:nil];
			[alert show];
			[alert release];
		}
	}


- (IBAction)hideControls  {
	
	// tapping the screen will hide/restore the header and buttons so you can see the full image
	
	if (takePictureButton.hidden) {
		takePictureButton.hidden = NO ;
		selectFromCameraRollButton.hidden = NO;
		if (imageView.image != nil) {
			flickrSendButton.hidden = NO;
		}
		headerView.hidden = NO;
		//self.tabBarController.tabBar.hidden = NO; 		
	
	} else {
	
		takePictureButton.hidden = YES;
		selectFromCameraRollButton.hidden = YES;
		flickrSendButton.hidden = YES;
		headerView.hidden = YES;
		//self.tabBarController.tabBar.hidden = YES; 	
	}
}

- (void)flickrSend  {
	
	if (imageView.image == nil) {
		UIAlertView *flickAlert = [[UIAlertView alloc] 
							  initWithTitle:@"No Image to Share" 
							  message:@"Please choose a picture to upload" 
							  delegate:nil 
							  cancelButtonTitle:@"Cancel" 
							  otherButtonTitles:nil];
		[flickAlert show];
		[flickAlert release];
	}	else {
		UIAlertView *flickAlert = [[UIAlertView alloc] 
				initWithTitle:@"Flickr Upload" 
					message:@"This feature is not active yet" 
					delegate:nil 
					cancelButtonTitle:@"Cancel" 
					otherButtonTitles:nil];
		[flickAlert show];
		[flickAlert release];	}

	
	}

- (void)flickrView  {
	
	FlickrPageViewController *flickController = [[FlickrPageViewController alloc] initWithNibName:@"FlickrPageView" bundle:nil];
	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:flickController];
	[self presentModalViewController:navigationController animated:YES];
	
	[navigationController release];
	[flickController release];
	
	}

#pragma mark  -

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	
	
	UIImage *selectedImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];	
	imageView.image = selectedImage;
	
	[picker dismissModalViewControllerAnimated:YES];
	flickrSendButton.hidden = NO;
}	

	- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
		
		[picker dismissModalViewControllerAnimated:YES];
		}
	

@end
	