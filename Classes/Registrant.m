//
//  Registrant.m
//  CocoaCamp
//
//  Created by Alondo Brewington on 8/22/10.
//  Copyright 2010 DT Squared Software. All rights reserved.
//

#import "Registrant.h"


@implementation Registrant
@synthesize  rid, firstName, lastName, company, email, industry, twitter, present;

-(NSString *)twitterUrl{
	return [NSString stringWithFormat: @"http://twitter.com/%@", self.twitter];
}

-(NSString *)fullName{
	return [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
}

-(void) dealloc{
	[rid release];
	[firstName release];
	[lastName release];
	[company release]; 
	[email release];
	[industry release];
	[twitter release];
	[present release];
	[super dealloc];
}

-(void)encodeWithCoder:(NSCoder*)coder
{
    [coder encodeObject: rid];
    [coder encodeObject: firstName];
	[coder encodeObject: lastName];
	[coder encodeObject: company];
	[coder encodeObject: email];
	[coder encodeObject: industry];
	[coder encodeObject: twitter];
	[coder encodeObject: present];
    
}

-(id)initWithCoder:(NSCoder*)coder
{
	if (self=[super init]) {
		self.rid = [coder decodeObject];
		self.firstName = [coder decodeObject];
		self.lastName = [coder decodeObject];
		self.company = [coder decodeObject];
		self.email = [coder decodeObject];
		self.industry = [coder decodeObject];
		self.twitter = [coder decodeObject];
		self.present = [coder decodeObject];
	}
	return self;
}

- (NSError *)saveAddressBookContact {
	CFErrorRef error = NULL;
	ABMultiValueIdentifier identifier;
	ABRecordRef personRecord = ABPersonCreate();
	
	ABRecordSetValue(personRecord, kABPersonFirstNameProperty, self.firstName, &error);
	ABRecordSetValue(personRecord, kABPersonLastNameProperty, self.lastName, &error);
	if (self.company) {
		ABRecordSetValue(personRecord, kABPersonOrganizationProperty, self.company, &error);
	}
	
	if (self.email){
		ABMutableMultiValueRef emailValue = ABMultiValueCreateMutable(kABMultiStringPropertyType);
		CFStringRef emailLabel = kABOtherLabel;
		
		ABMultiValueAddValueAndLabel(emailValue, self.email, emailLabel, &identifier);
		ABRecordSetValue(personRecord, kABPersonEmailProperty, emailValue, &error);
		CFRelease(emailValue);
	}
	
	if (self.twitter){
		ABMutableMultiValueRef websiteValue = ABMultiValueCreateMutable(kABMultiStringPropertyType);
		CFStringRef websiteLabel = kABOtherLabel;
		ABMultiValueAddValueAndLabel(websiteValue, self.twitterUrl, websiteLabel, &identifier);
		ABRecordSetValue(personRecord, kABPersonURLProperty, websiteValue, &error);
		CFRelease(websiteValue);
	}
	
	ABAddressBookRef addressBook = ABAddressBookCreate();
	ABAddressBookAddRecord(addressBook, personRecord, &error);
	if(!error && ABAddressBookHasUnsavedChanges(addressBook)){
		ABAddressBookSave(addressBook, &error);
		return nil;
	}else {
		return (NSError *)error;
	}
}
@end
