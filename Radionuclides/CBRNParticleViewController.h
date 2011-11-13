//
//  CBRNParticleViewController.h
//  Radionuclides
//
//  Created by Chris on 11-11-13.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Radioisotope.h"

@interface CBRNParticleViewController : UITableViewController {
	NSArray *_contents;
	NSString *_particleType;
}

@property (nonatomic, strong) NSArray *contents;
@property (nonatomic, strong) NSString *particleType;

@end
