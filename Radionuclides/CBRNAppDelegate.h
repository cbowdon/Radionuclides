//
//  CBRNAppDelegate.h
//  Radionuclides
//
//  Created by Chris on 11-11-12.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBRNDataController.h"
#import "CBRNViewController.h"

@interface CBRNAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) CBRNDataController *dataController;
@property (strong, nonatomic) CBRNViewController *viewController;

@end
