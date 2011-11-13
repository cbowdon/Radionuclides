//
//  CBRNDataController.h
//  Radionuclides
//
//  Created by Chris on 11-11-12.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RadData.h"

@interface CBRNDataController : NSObject {
	RadData *_data;
}

@property (readonly, strong) RadData *data;
@property (readonly, strong) NSArray *isotopes;

-(NSUInteger)isotopesCount;

@end
