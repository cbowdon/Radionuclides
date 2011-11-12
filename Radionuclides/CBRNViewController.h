//
//  CBRNViewController.h
//  Radionuclides
//
//  Created by Chris on 11-11-12.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBRNDataController.h"
#import "CBRNDetailViewController.h"

@interface CBRNViewController : UITableViewController

@property (nonatomic, strong) CBRNDataController *dataController;

@end
