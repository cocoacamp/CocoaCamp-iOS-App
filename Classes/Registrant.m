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

@end
