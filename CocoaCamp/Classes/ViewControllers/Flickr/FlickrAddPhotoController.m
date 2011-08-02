//
//  FlickrAddPhotoController.m
//  CocoaCamp
//
//  Created by airportyh on 9/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FlickrAddPhotoController.h"


@implementation FlickrAddPhotoController

@synthesize selectedImage;

- (void)getCameraPicture {
	if ([UIImagePickerController isSourceTypeAvailable:
		 UIImagePickerControllerSourceTypeCamera]) {
		
		UIImagePickerController *picker = [[UIImagePickerController alloc] init];
		picker.delegate = self;
		picker.allowsEditing = YES;
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
		picker.allowsEditing = YES;
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


- (void)flickrSend  {
	
	MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
	mail.mailComposeDelegate = self;
	
	if ([MFMailComposeViewController canSendMail]) {
		
		[mail setSubject:@"Cocoa Camp 2010"];
		[mail setToRecipients:  [NSArray arrayWithObject:@"cases90values@photos.flickr.com"]];
		
		NSData *imageData = UIImagePNGRepresentation(selectedImage);		
		[mail addAttachmentData:imageData mimeType:@"image/png" fileName:@"CocoaCamp"];
		
		[self presentModalViewController:mail animated:YES]; 
		
	} else {
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message Failed" message:@"This device is not configured to send email" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
		
	}
	[mail release];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	[self dismissModalViewControllerAnimated:YES];
	
	if (result == MFMailComposeResultFailed) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upload Failed" message:@"Your email has failed to send" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
		[alert show];
		[alert release];
	} 
	
	if (result == MFMailComposeResultSent) {
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Flickr Upload Sent. It may take a couple of minutes for it to show up on the wall." message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
		
		[self.navigationController popViewControllerAnimated:NO];
	}
	
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	self.selectedImage = [info objectForKey:@"UIImagePickerControllerEditedImage"];	
	
	[picker dismissModalViewControllerAnimated:NO];
	[self flickrSend];
}	

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	[picker dismissModalViewControllerAnimated:YES];
}

- (void)viewDidLoad{
	[super viewDidLoad];
}

- (void)dealloc {
    [super dealloc];
	if (selectedImage)
		[selectedImage release];
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
	return YES;
}

@end
