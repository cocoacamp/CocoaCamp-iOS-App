//
//  BumpContact.h
//	BumpApi
//
//  Copyrights / Disclaimer
//  Copyright 2010, Bump Technologies, Inc. All rights reserved.
//  Use of the software programs described herein is subject to applicable
//  license agreements and nondisclosure agreements. Unless specifically
//  otherwise agreed in writing, all rights, title, and interest to this
//  software and documentation remain with Bump Technologies, Inc. Unless
//  expressly agreed in a signed license agreement, Bump Technologies makes
//  no representations about the suitability of this software for any purpose
//  and it is provided "as is" without express or implied warranty.
//
//  Created by Jake K. on 02/16/10
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define BUMP_FIELD_TYPE			  	@"bump_field_type"
#define BUMP_FIELD_TYPE_HOME	  	@"bump_field_type_home"
#define BUMP_FIELD_TYPE_WORK	  	@"bump_field_type_work"
#define BUMP_FIELD_TYPE_MOBILE  	@"bump_field_type_mobile"
#define BUMP_FIELD_TYPE_HOME_FAX	@"bump_field_type_home_fax"
#define BUMP_FIELD_TYPE_WORK_FAX	@"bump_field_type_work_fax"
#define BUMP_FIELD_TYPE_OTHER		@"bump_field_type_other"
#define BUMP_FIELD_TYPE_PAGER		@"bump_field_type_pager"
#define BUMP_FIELD_TYPE_HOMEPAGE	@"bump_field_type_homepage"

#define BUMP_IM_NAME				@"bump_im_name"
#define BUMP_IM_SERVICE				@"bump_im_service"
#define BUMP_IM_SERVICE_YAHOO		@"Yahoo"
#define BUMP_IM_SERVICE_JABBER		@"Jabber"
#define BUMP_IM_SERVICE_MSN			@"MSN"
#define BUMP_IM_SERVICE_ICQ			@"ICQ"
#define BUMP_IM_SERVICE_AIM			@"AIM"

#define BUMP_EMAIL_ADDRESS			@"bump_email_address"
#define BUMP_PHONE_NUMBER			@"bump_phone_number"
#define BUMP_URL					@"bump_url"
#define BUMP_ADDRESS_STREET			@"bump_address_street"
#define BUMP_ADDRESS_CITY			@"bump_address_city"
#define BUMP_ADDRESS_ZIP	  		@"bump_address_zip"
#define BUMP_ADDRESS_STATE	  		@"bump_address_state"
#define BUMP_ADDRESS_COUNTRY 		@"bump_address_country"
#define BUMP_ADDRESS_COUNTRY_CODE	@"bump_address_country_code"

@interface BumpContact : NSObject
{
	NSString*			_firstName;
	NSString*			_lastName;
	NSString*			_companyName;
	NSString*			_prefix;
	NSString*			_suffix;
	NSString*			_phoneticFirstName;
	NSString*			_phoneticMiddleName;
	NSString*			_phoneticLastName;
	NSString*			_middleName;
	NSString*			_nickname;
	NSString*			_jobTitle;
	NSString*			_department;
	NSDate*				_birthDay;
	NSArray*			_emailAddresses;
	NSArray*			_phoneNumbers;
	NSArray*			_webUrls;
	NSArray*			_streetAddresses;
	NSArray*			_imUserNames;
	UIImage*			_image;
}
@property (nonatomic, copy)	NSString*				firstName;
@property (nonatomic, copy)	NSString*				lastName;
@property (nonatomic, copy)	NSString*				companyName;
@property (nonatomic, copy)	NSString*				prefix;
@property (nonatomic, copy)	NSString*				suffix;
@property (nonatomic, copy)	NSString*				phoneticFirstName;
@property (nonatomic, copy)	NSString*				phoneticMiddleName;
@property (nonatomic, copy)	NSString*				phoneticLastName;
@property (nonatomic, copy)	NSString*				middleName;
@property (nonatomic, copy)	NSString*				nickname;
@property (nonatomic, copy)	NSString*				jobTitle;
@property (nonatomic, copy)	NSString*				department;
@property (nonatomic, retain) NSDate*				birthDay;
@property (nonatomic, retain) UIImage*				image;

/*Email Addresses : An (NSArray *) of (NSDictionary *) objects with key-value pairs:
 {
 BUMP_EMAIL_ADDRESS	==> (NSString*)addr
 BUMP_FIELD_TYPE	==> (NSString *)field_type
 }
 */
@property (nonatomic, retain) NSArray* emailAddresses;

/*Phone Numbers : An (NSArray *) of NSDictionaries with key-value pairs
 {
 BUMP_PHONE_NUMBER	==> (NSString*)number
 BUMP_FIELD_TYPE	==> (NSString *)field_type
 }*/
@property (nonatomic, retain) NSArray* phoneNumbers;

/*Web Urls : An (NSArray *) of NSDictionaries with key-value pairs
 {
 BUMP_URL			==> (NSString*)url
 BUMP_FIELD_TYPE	==> (NSString *)field_type
 }
 */
@property (nonatomic, retain) NSArray* webUrls;

/*Street Addresses : An (NSArray *) of NSDictionaries with key-value pairs
 {
 BUMP_ADDRESS_STREET		==> (NSString*)street
 BUMP_ADDRESS_CITY			==> (NSString*)city
 BUMP_ADDRESS_ZIP			==> (NSString*)zip
 BUMP_ADDRESS_STATE			==> (NSString*)state
 BUMP_ADDRESS_COUNTRY		==> (NSString*)country
 BUMP_ADDRESS_COUNTRY_CODE	==> (NSString*)country_code
 BUMP_FIELD_TYPE			==> (NSString*)field_type
 }
 */
@property (nonatomic, retain) NSArray* streetAddresses;

/*IM User Names: An (NSArray *) of (NSDictionary *) objects with key-value pairs:
 {
 BUMP_IM_NAME		==> (NSString*)usrName
 BUMP_IM_NETWORK	==> (NSString *)imNetwork
 }
 */
@property (nonatomic, retain) NSArray* imUserNames;
@end
