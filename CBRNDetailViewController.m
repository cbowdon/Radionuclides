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
	return 1;
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
	} else if ([sectionName isEqualToString:@"Progeny"]) {
		Progeny *prog = [self.radioisotope.progeny objectAtIndex:indexPath.row];
		NSString *line = [NSString stringWithFormat:@"%.3f%c\t %@", 100*[prog.probability doubleValue], '%', prog.name];	
		cell.textLabel.text = line;
	} else if ([sectionName isEqualToString:@"Alphas"]) {
		DiscreteParticle *alpha = [self.radioisotope.alphas objectAtIndex:indexPath.row];
		double energy = [alpha.energy doubleValue];
		double probability = 100*[alpha.probability doubleValue];
		NSString *line = [NSString stringWithFormat:@"%.3f%c\t %.3f MeV", probability, '%', energy];	
		cell.textLabel.text = line;
	} else if ([sectionName isEqualToString:@"Betas"]) {
		ContinuousParticle *beta = [self.radioisotope.betas objectAtIndex:indexPath.row];
		double energy = [beta.energy doubleValue];
		double maxEnergy = [beta.maxEnergy doubleValue];
		double probability = 100*[beta.probability doubleValue];
		NSString *line = [NSString stringWithFormat:@"%.3f%c\t %.3f MeV (max)\t [%.3f MeV (avg)]", probability, '%', maxEnergy, energy];	
		cell.textLabel.text = line;
	} else {
		cell.textLabel.text = @"Unknown";
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
