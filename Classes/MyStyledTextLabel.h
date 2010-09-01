//
//  MyStyledTextLabel.h
//  CocoaCamp
//
//  Created by airportyh on 8/30/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MyStyledTextLabel : TTStyledTextLabel {
	NSObject *delegate;
}

@property (assign) NSObject *delegate;

@end
