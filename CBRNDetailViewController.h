//
//  CBRNDetailViewController.h
//  Radionuclides
//
//  Created by Chris on 11-11-12.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RadData.h"
#import "CBRNParticleViewController.h"

@interface CBRNDetailViewController : UITableViewController {
	Radioisotope *_radioisotope;
	NSArray *_sections;
}

@property (nonatomic, strong) Radioisotope *radioisotope;
@property (nonatomic, strong) NSArray *sections;

-(NSArray*)sections;

@end
