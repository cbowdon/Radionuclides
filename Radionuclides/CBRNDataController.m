//
//  CBRNDataController.m
//  Radionuclides
//
//  Created by Chris on 11-11-12.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "CBRNDataController.h"
#import "RadData.h"

@implementation CBRNDataController

@synthesize data = _data;

-(id)init {
	if ([super init]) {
		_data = [[RadData alloc] init];		
	}		
	
	return self;
}

-(NSUInteger)isotopesCount {
	return [self.data.isotopes count];
}

-(NSArray*)isotopes {
	return self.data.isotopes;
}

@end
