//
//  Registrant.h
//  CocoaCamp
//
//  Created by Alondo Brewington on 8/22/10.
//  Copyright 2010 DT Squared Software. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Registrant : NSObject {
	 NSNumber* rid;
	 NSString* firstName;
	 NSString* lastName;
	 NSString* company;
	 NSString* email;
	 NSString* industry;
	 NSString* twitter;
	 NSString* present;
}

@property (nonatomic, retain) NSNumber* rid;
@property (nonatomic, retain) NSString* firstName;
@property (nonatomic, retain) NSString* lastName;
@property (nonatomic, retain) NSString* company;
@property (nonatomic, retain) NSString* email;
@property (nonatomic, retain) NSString* industry;
@property (nonatomic, retain) NSString* twitter;
@property (nonatomic, retain) NSString* present;

@end
