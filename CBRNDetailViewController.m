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
	if (_sections == nil) {		
		NSMutableArray *mut = [[NSMutableArray alloc] init];
		
		[mut addObject:[NSString stringWithFormat:@"Half life"]];
		[mut addObject:[NSString stringWithFormat:@"Atomic number"]];
		
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
	}
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
	if (section > 1) {
		NSString *sectionName = [self.sections objectAtIndex:section];
		return [[self.radioisotope.contents objectForKey:sectionName] count];
	} else {
		return 1;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"RadioisotopeCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
	
	NSString *sectionName = [self.sections objectAtIndex:indexPath.section];
	
	if ([sectionName isEqualToString:@"Atomic number"]) {		
		cell.textLabel.text = [NSString stringWithFormat:@"%i", self.radioisotope.atomicNumber];		
	} else if ([sectionName isEqualToString:@"Half life"]){			
		cell.textLabel.text = [NSString stringWithFormat:@"%.3f %@", [self.radioisotope.halfLifeNumber doubleValue], self.radioisotope.halfLifeUnit];;
	} else {		
		id thing = [self.radioisotope.contents objectForKey:sectionName];
		NSString *line = [[thing objectAtIndex:indexPath.row] stringValue];		
		cell.textLabel.text = line;
	}
    return cell;
}

#pragma mark Section header titles

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section 
{    
    // to do: make this "Alphas (13)"
	return [self.sections objectAtIndex:section];
}


@end
