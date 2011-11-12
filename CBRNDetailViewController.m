//
//  CBRNDetailViewController.m
//  Radionuclides
//
//  Created by Chris on 11-11-12.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "CBRNDetailViewController.h"


@implementation CBRNDetailViewController

@synthesize radioisotope = _radioisotope, sections = _sections;

-(NSArray*)sections
{
	if (_sections != nil) {
		return _sections;
	}
	NSMutableArray *mut = [[NSMutableArray alloc] init];
	[mut addObject:[NSString stringWithFormat:@"Radionuclide"]];
	[mut addObject:[NSString stringWithFormat:@"Mass and atomic number"]];
	
	if (self.radioisotope.nProgeny > 0) {
	[mut addObject:[NSString stringWithFormat:@"Progeny"]];
	}
	if (self.radioisotope.nAlphas > 0) {
	[mut addObject:[NSString stringWithFormat:@"Alphas"]];
	}
	if (self.radioisotope.nBetas > 0) {
	[mut addObject:[NSString stringWithFormat:@"Betas"]];
	}
	if (self.radioisotope.nPositrons > 0) {
	[mut addObject:[NSString stringWithFormat:@"Positrons"]];
	}
	if (self.radioisotope.nNegatrons > 0) {
	[mut addObject:[NSString stringWithFormat:@"Negatrons"]];
	}
	if (self.radioisotope.nPhotons > 0) {
	[mut addObject:[NSString stringWithFormat:@"Photons"]];
	}
	
	_sections = [[NSArray alloc] initWithArray:mut];
	return _sections;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

	self.title = self.radioisotope.name;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{	
    return [self.sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    
	cell.textLabel.text = @"Hello";
	
    return cell;
}

#pragma mark Section header titles

/*
 HIG note: In this case, since the content of each section is obvious, there's probably no need to provide a title, but the code is useful for illustration.
 */
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section 
{    
    return [self.sections objectAtIndex:section];
}


@end
