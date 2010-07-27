//
//  FirstViewController.h
//  CocoaCamp
//
//  Created by Jonathan Freeman on 7/12/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBookUI/AddressBookUI.h>

@interface FirstViewController : UIViewController<ABPeoplePickerNavigationControllerDelegate> {
	ABRecordRef ownerContact;
}

- (IBAction)initiateContactExchange:(id)sender;
- (void)performContactExchange;

@end
