//
//  FlickrAddPhotoController.h
//  CocoaCamp
//
//  Created by airportyh on 9/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
#import <MessageUI/MessageUI.h>
#import <UIKit/UIKit.h>


@interface FlickrAddPhotoController : UIViewController
<UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
MFMailComposeViewControllerDelegate>{
	
	UIImage *selectedImage;

}
@property (nonatomic, retain) UIImage *selectedImage;
- (IBAction)getCameraPicture;
- (IBAction)selectExistingPicture;

@end
