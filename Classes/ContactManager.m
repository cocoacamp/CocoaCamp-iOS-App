//
//  ContactManager.m
//  CocoaCamp
//
//  Created by Warren Moore on 7/22/10.
//  Copyright 2010 Auerhaus Development, LLC. All rights reserved.
//

#import "ContactManager.h"
#import "BumpContact.h"

static ContactManager *sharedInstance;

@implementation ContactManager

+ (ContactManager *)sharedInstance {
	if(!sharedInstance)
		sharedInstance = [[ContactManager alloc] init];
	return sharedInstance;
}

- (id)init {
	if((self = [super init]))
	{
		addressBook = ABAddressBookCreate();
		NSAssert(addressBook, @"Unable to get an address book instance.");
	}
	
	return self;
}

- (NSError *)addContactForBumpContact:(BumpContact *)contact {
	CFErrorRef error = NULL;
	ABRecordRef record = [contact addressBookContact];
	ABAddressBookAddRecord(addressBook, record, &error);
	if(!error && ABAddressBookHasUnsavedChanges(addressBook))
		ABAddressBookSave(addressBook, &error);
	return (NSError *)error;
}

@end

@implementation BumpContact (AddressBook)
- (ABRecordRef)addressBookContact {
	CFErrorRef error = NULL;
	ABRecordRef personRecord = ABPersonCreate();
	
	ABRecordSetValue(personRecord, kABPersonFirstNameProperty, self.firstName, &error);
	ABRecordSetValue(personRecord, kABPersonMiddleNameProperty, self.middleName, &error);
	ABRecordSetValue(personRecord, kABPersonLastNameProperty, self.lastName, &error);
	ABRecordSetValue(personRecord, kABPersonPrefixProperty, self.prefix, &error);
	ABRecordSetValue(personRecord, kABPersonSuffixProperty, self.suffix, &error);
	ABRecordSetValue(personRecord, kABPersonFirstNamePhoneticProperty, self.phoneticFirstName, &error);
	ABRecordSetValue(personRecord, kABPersonMiddleNamePhoneticProperty, self.phoneticMiddleName, &error);
	ABRecordSetValue(personRecord, kABPersonLastNamePhoneticProperty, self.phoneticLastName, &error);
	ABRecordSetValue(personRecord, kABPersonNicknameProperty, self.nickname, &error);
	ABRecordSetValue(personRecord, kABPersonOrganizationProperty, self.companyName, &error);
	ABRecordSetValue(personRecord, kABPersonDepartmentProperty, self.department, &error);
	ABRecordSetValue(personRecord, kABPersonJobTitleProperty, self.jobTitle, &error);
	
	CFDateRef birthdayValue = (CFDateRef)self.birthDay;
	ABRecordSetValue(personRecord, kABPersonBirthdayProperty, birthdayValue, &error);

	ABMutableMultiValueRef emailValue = ABMultiValueCreateMutable(kABMultiStringPropertyType);
	for(NSDictionary *bumpEmail in self.emailAddresses)
	{
		if([bumpEmail valueForKey:BUMP_EMAIL_ADDRESS])
		{
			CFStringRef emailLabel = kABOtherLabel;
			if([bumpEmail valueForKey:BUMP_FIELD_TYPE] == BUMP_FIELD_TYPE_HOME)
				emailLabel = kABHomeLabel;
			else if([bumpEmail valueForKey:BUMP_FIELD_TYPE] == BUMP_FIELD_TYPE_WORK)
				emailLabel = kABWorkLabel;
			ABMultiValueIdentifier identifier;
			ABMultiValueAddValueAndLabel(emailValue, [bumpEmail valueForKey:BUMP_EMAIL_ADDRESS], emailLabel, &identifier);
		}
	}
	
	ABRecordSetValue(personRecord, kABPersonEmailProperty, emailValue, &error);
	CFRelease(emailValue);
	
	ABMutableMultiValueRef websiteValue = ABMultiValueCreateMutable(kABMultiStringPropertyType);
	for(NSDictionary *bumpWebsite in self.webUrls)
	{
		if([bumpWebsite valueForKey:BUMP_URL])
		{
			CFStringRef websiteLabel = kABOtherLabel;
			if([bumpWebsite valueForKey:BUMP_FIELD_TYPE] == BUMP_FIELD_TYPE_HOME)
				websiteLabel = kABHomeLabel;
			else if([bumpWebsite valueForKey:BUMP_FIELD_TYPE] == BUMP_FIELD_TYPE_WORK)
				websiteLabel = kABWorkLabel;
			ABMultiValueIdentifier identifier;
			ABMultiValueAddValueAndLabel(websiteValue, [bumpWebsite valueForKey:BUMP_URL], websiteLabel, &identifier);
		}
	}
	
	ABRecordSetValue(personRecord, kABPersonURLProperty, websiteValue, &error);
	CFRelease(websiteValue);

	ABMutableMultiValueRef phoneValue = ABMultiValueCreateMutable(kABMultiStringPropertyType);
	for(NSDictionary *bumpPhoneNumber in self.phoneNumbers)
	{
		if([bumpPhoneNumber valueForKey:BUMP_PHONE_NUMBER])
		{
			CFStringRef phoneLabel = kABOtherLabel;
			if([bumpPhoneNumber valueForKey:BUMP_FIELD_TYPE] == BUMP_FIELD_TYPE_HOME)
				phoneLabel = kABHomeLabel;
			else if([bumpPhoneNumber valueForKey:BUMP_FIELD_TYPE] == BUMP_FIELD_TYPE_WORK)
				phoneLabel = kABWorkLabel;
			else if([bumpPhoneNumber valueForKey:BUMP_FIELD_TYPE] == BUMP_FIELD_TYPE_MOBILE)
				phoneLabel = kABPersonPhoneMobileLabel;
			else if([bumpPhoneNumber valueForKey:BUMP_FIELD_TYPE] == BUMP_FIELD_TYPE_HOME_FAX)
				phoneLabel = kABPersonPhoneHomeFAXLabel;
			else if([bumpPhoneNumber valueForKey:BUMP_FIELD_TYPE] == BUMP_FIELD_TYPE_WORK_FAX)
				phoneLabel = kABPersonPhoneWorkFAXLabel;
			else if([bumpPhoneNumber valueForKey:BUMP_FIELD_TYPE] == BUMP_FIELD_TYPE_PAGER)
				phoneLabel = kABPersonPhonePagerLabel;

			ABMultiValueIdentifier identifier;
			ABMultiValueAddValueAndLabel(phoneValue, [bumpPhoneNumber valueForKey:BUMP_PHONE_NUMBER], phoneLabel, &identifier);
		}
	}
	
	ABRecordSetValue(personRecord, kABPersonPhoneProperty, phoneValue, &error);
	CFRelease(phoneValue);
	
	ABMutableMultiValueRef imValue = ABMultiValueCreateMutable(kABDictionaryPropertyType);
	for(NSDictionary *bumpIM in self.imUserNames)
	{
		CFStringRef network = NULL;
		if([bumpIM valueForKey:BUMP_IM_SERVICE] == BUMP_IM_SERVICE_AIM)
			network = kABPersonInstantMessageServiceAIM;
		else if([bumpIM valueForKey:BUMP_IM_SERVICE] == BUMP_IM_SERVICE_MSN)
			network = kABPersonInstantMessageServiceMSN;
		else if([bumpIM valueForKey:BUMP_IM_SERVICE] == BUMP_IM_SERVICE_YAHOO)
			network = kABPersonInstantMessageServiceYahoo;
		else if([bumpIM valueForKey:BUMP_IM_SERVICE] == BUMP_IM_SERVICE_ICQ)
			network = kABPersonInstantMessageServiceICQ;
		else if([bumpIM valueForKey:BUMP_IM_SERVICE] == BUMP_IM_SERVICE_JABBER)
			network = kABPersonInstantMessageServiceJabber;
		
		if(network && [bumpIM valueForKey:BUMP_IM_NAME])
		{
			NSMutableDictionary *im = [NSMutableDictionary dictionaryWithCapacity:2];
			[im setValue:(NSString *)network forKey:(NSString *)kABPersonInstantMessageServiceKey];
			[im setValue:[bumpIM valueForKey:BUMP_IM_NAME] forKey:(NSString *)kABPersonInstantMessageUsernameKey];
			ABMultiValueIdentifier identifier;
			ABMultiValueAddValueAndLabel(imValue, im, kABWorkLabel, &identifier); // assume all IM usernames are for work
		}
	}
	
	ABRecordSetValue(personRecord, kABPersonInstantMessageProperty, imValue, &error);
	CFRelease(imValue);
	
	ABMutableMultiValueRef addressValue = ABMultiValueCreateMutable(kABDictionaryPropertyType);
	for(NSDictionary *bumpAddress in self.streetAddresses)
	{
		CFStringRef addressType = kABOtherLabel;
		if([bumpAddress valueForKey:BUMP_FIELD_TYPE] == BUMP_FIELD_TYPE_HOME)
			addressType = kABHomeLabel;
		else if([bumpAddress valueForKey:BUMP_FIELD_TYPE] == BUMP_FIELD_TYPE_WORK)
			addressType = kABWorkLabel;
		
		NSMutableDictionary *contactAddress = [NSMutableDictionary dictionaryWithCapacity:5];
		if([bumpAddress objectForKey:BUMP_ADDRESS_STREET])
			[contactAddress setObject:[bumpAddress objectForKey:BUMP_ADDRESS_STREET] forKey:(NSString *)kABPersonAddressStreetKey];
		if([bumpAddress objectForKey:BUMP_ADDRESS_CITY])
			[contactAddress setObject:[bumpAddress objectForKey:BUMP_ADDRESS_CITY] forKey:(NSString *)kABPersonAddressCityKey];
		if([bumpAddress objectForKey:BUMP_ADDRESS_STATE])
			[contactAddress setObject:[bumpAddress objectForKey:BUMP_ADDRESS_STATE] forKey:(NSString *)kABPersonAddressStateKey];
		if([bumpAddress objectForKey:BUMP_ADDRESS_ZIP])
			[contactAddress setObject:[bumpAddress objectForKey:BUMP_ADDRESS_ZIP] forKey:(NSString *)kABPersonAddressZIPKey];
		if([bumpAddress objectForKey:BUMP_ADDRESS_COUNTRY])
			[contactAddress setObject:[bumpAddress objectForKey:BUMP_ADDRESS_COUNTRY] forKey:(NSString *)kABPersonAddressCountryKey];
		ABMultiValueIdentifier identifier;
		ABMultiValueAddValueAndLabel(addressValue, contactAddress, addressType, &identifier);
	}
	
	ABRecordSetValue(personRecord, kABPersonAddressProperty, addressValue, &error);
	CFRelease(addressValue);

	return personRecord;
}
@end

BumpContact *BumpContactForAddressBookRecord(ABRecordRef record)
{
	return nil;
}
