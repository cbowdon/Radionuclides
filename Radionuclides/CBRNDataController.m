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

@synthesize data = _data, sectionData = _sectionData;

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

-(NSArray*)sectionData
{
	if (!_sectionData) {
		
		NSMutableArray *mut = [[NSMutableArray alloc] initWithCapacity:26];
		
		NSUInteger i;
		for (i = 0; i < 26; i++) {
			NSString *letter = [NSString stringWithFormat:@"%c", (char)(i+65)];
			NSArray *topesForLetter = [self.data findIsotopeWithName:letter];
			[mut addObject:topesForLetter];
		}	
		
		_sectionData = [[NSArray alloc] initWithArray:mut];
		
	}
	
	return _sectionData;
	
}

@end
