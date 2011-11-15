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

@interface CBRNViewController : UITableViewController <UISearchDisplayDelegate, UISearchBarDelegate> {
	NSMutableArray *_radionuclides;
	NSMutableArray *_filteredRadionuclides;
}

@property (nonatomic, strong) CBRNDataController *dataController;
@property (nonatomic, strong) NSMutableArray *radionuclides;
@property (nonatomic, strong) NSMutableArray *filteredRadionuclides;

@end
