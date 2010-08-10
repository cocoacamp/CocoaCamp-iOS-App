
/*
  File: FlickrController.h
 Abstract: View controller to manage a view to display a note's photo.
 
 */


@interface FlickrController : UIViewController  <UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    @private
	IBOutlet UIImageView *imageView;
	UIButton *takePictureButton;
	UIButton *selectFromCameraRollButton;
	IBOutlet UIButton *hideControlsButton;
	UIButton *flickrSendButton;
	UIButton *flickrViewButton;
	UIView *headerView;
}

@property(nonatomic, retain) UIImageView	*imageView;
@property(nonatomic, retain) UIButton		*takePictureButton;
@property(nonatomic, retain) UIButton		*selectFromCameraRollButton;
@property(nonatomic, retain) UIButton		*hideControlsButton;
@property(nonatomic, retain) UIButton		*flickrSendButton;
@property(nonatomic, retain) UIButton		*flickrViewButton;
@property(nonatomic, retain) UIView			*headerView;



- (void)getCameraPicture:(id)sender;
- (void)selectExistingPicture;
- (IBAction)hideControls;
- (void)flickrSend;
- (void)flickrView;
@end
