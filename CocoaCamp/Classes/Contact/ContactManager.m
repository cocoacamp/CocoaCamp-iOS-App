//
//  ContactManager.m
//  CocoaCamp
//
//  Created by Warren Moore on 7/22/10.
//  Copyright 2010 Auerhaus Development, LLC. All rights reserved.
//

#import "ContactManager.h"
#import "BumpContact.h"
#import "Registrant.h"

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
		//addressBook = ABAddressBookCreate();
		//NSAssert(addressBook, @"Unable to get an address book instance.");
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

- (BumpContact *)bumpContactForRegistrant:(Registrant *)registrant
{
	if(!registrant)
	{
		NSLog(@"Received nil registration in bumpContactForRegistrant - for shame!");
		return nil;
	}
	
	BumpContact *contact = [[BumpContact alloc] init];
	contact.firstName = registrant.firstName;
	contact.lastName = registrant.lastName;
	contact.companyName = registrant.company;
	NSMutableDictionary *twitterEntry = [[NSMutableDictionary alloc] init];
	NSString *twitterURL = [NSString stringWithFormat: @"http://twitter.com/%@", registrant.twitter];
	[twitterEntry setObject:twitterURL forKey:BUMP_URL];
	[twitterEntry setObject:BUMP_FIELD_TYPE_HOME forKey:BUMP_FIELD_TYPE];
	NSArray *webURLs = [NSArray arrayWithObjects: twitterEntry, nil];
	contact.webUrls = webURLs;
	NSMutableDictionary *emailEntry = [[NSMutableDictionary alloc] init];
	[emailEntry setObject:registrant.email forKey:BUMP_EMAIL_ADDRESS];
	[emailEntry setObject:BUMP_FIELD_TYPE_HOME forKey:BUMP_FIELD_TYPE];
	NSArray *emailAddresses = [NSArray arrayWithObjects:emailEntry, nil];
	contact.emailAddresses = emailAddresses;
	return contact;
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
	BumpContact *contact = [[BumpContact alloc] init];
	
	contact.firstName = (NSString *)ABRecordCopyValue(record, kABPersonFirstNameProperty);
	[contact.firstName release];
	contact.middleName = (NSString *)ABRecordCopyValue(record, kABPersonMiddleNameProperty);
	[contact.middleName release];
	contact.lastName = (NSString *)ABRecordCopyValue(record, kABPersonLastNameProperty);
	[contact.lastName release];
	contact.prefix = (NSString *)ABRecordCopyValue(record, kABPersonPrefixProperty);
	[contact.prefix release];
	contact.suffix = (NSString *)ABRecordCopyValue(record, kABPersonSuffixProperty);
	[contact.suffix release];
	contact.phoneticFirstName = (NSString *)ABRecordCopyValue(record, kABPersonFirstNamePhoneticProperty);
	[contact.phoneticFirstName release];
	contact.phoneticMiddleName = (NSString *)ABRecordCopyValue(record, kABPersonMiddleNamePhoneticProperty);
	[contact.phoneticMiddleName release];
	contact.phoneticLastName = (NSString *)ABRecordCopyValue(record, kABPersonLastNamePhoneticProperty);
	[contact.phoneticLastName release];
	contact.nickname = (NSString *)ABRecordCopyValue(record, kABPersonNicknameProperty);
	[contact.nickname release];
	contact.companyName = (NSString *)ABRecordCopyValue(record, kABPersonOrganizationProperty);
	[contact.companyName release];
	contact.department = (NSString *)ABRecordCopyValue(record, kABPersonDepartmentProperty);
	[contact.department release];
	contact.jobTitle = (NSString *)ABRecordCopyValue(record, kABPersonJobTitleProperty);
	[contact.jobTitle release];
	
	contact.birthDay = (NSDate *)ABRecordCopyValue(record, kABPersonBirthdayProperty);
	[contact.birthDay release];
	
	ABMultiValueRef emailValue = ABRecordCopyValue(record, kABPersonEmailProperty);
	CFIndex emailCount = ABMultiValueGetCount(emailValue);
	NSMutableArray *bumpEmails = [NSMutableArray arrayWithCapacity:emailCount];
	for(CFIndex i = 0; i < emailCount; i++)
	{
		NSString *emailLabel = (NSString*)ABMultiValueCopyLabelAtIndex(emailValue, i);
		NSString *bumpLabel = BUMP_FIELD_TYPE_OTHER;
		if([emailLabel isEqual:(NSString *)kABHomeLabel])
			bumpLabel = BUMP_FIELD_TYPE_HOME;
		else if([emailLabel isEqual:(NSString *)kABWorkLabel])
			bumpLabel = BUMP_FIELD_TYPE_WORK;
		
		NSString *emailAddress = (NSString*)ABMultiValueCopyValueAtIndex(emailValue, i);
		NSDictionary *bumpEmail = [NSDictionary dictionaryWithObjectsAndKeys:bumpLabel, BUMP_FIELD_TYPE,
																			 emailAddress, BUMP_EMAIL_ADDRESS,
																			 nil];
		[bumpEmails addObject:bumpEmail];

		[emailLabel release];
		[emailAddress release];
	}
	contact.emailAddresses = bumpEmails;
	
	// TODO: transfer websites
	
	// TODO: transfer phone numbers
	
	// TODO: transfer IM names
	
	return contact;
}


