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

-(void)viewDidUnload
{
	_sections = nil;
	self.radioisotope = nil;
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
	NSString *sectionName = [self.sections objectAtIndex:section];
	if ([sectionName isEqualToString:@"Progeny"]) {
		return [[self.radioisotope.contents objectForKey:sectionName] count];
	} else {
		return 1;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
	// types of cell
	static NSString *MetaCellIdentifier = @"MetaCell";
	static NSString *ProgenyCellIdentifier = @"ProgenyCell";
	static NSString *ContentCellIdentifier = @"ContentCell";
    
	
    // Configure the cells...		
	NSString *sectionName = [self.sections objectAtIndex:indexPath.section];	
	UITableViewCell *cell;
	
	if ([sectionName isEqualToString:@"Atomic number"]) {	
		// the Z cell links nowhere and contains just an int
		
		cell = [tableView dequeueReusableCellWithIdentifier:MetaCellIdentifier];
		if (cell == nil) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MetaCellIdentifier];
		}
		
		cell.textLabel.text = [NSString stringWithFormat:@"%i", self.radioisotope.atomicNumber];	
		cell.detailTextLabel.text = nil;
		cell.accessoryType = UITableViewCellAccessoryNone;
		
	} else if ([sectionName isEqualToString:@"Half life"]){	
		// the HL cell links nowhere and contains a string
		
		cell = [tableView dequeueReusableCellWithIdentifier:MetaCellIdentifier];
		if (cell == nil) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MetaCellIdentifier];
		}

		
		cell.textLabel.text = self.radioisotope.halfLifeString;
		cell.detailTextLabel.text = nil;
		cell.accessoryType = UITableViewCellAccessoryNone;

	} else if ([sectionName isEqualToString:@"Progeny"]) {
		// the progeny cell contains the progeny and their probability
		
		cell = [tableView dequeueReusableCellWithIdentifier:ProgenyCellIdentifier];
		if (cell == nil) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ProgenyCellIdentifier];
		}
		
		id thing = [self.radioisotope.contents objectForKey:sectionName];
		NSString *line = [[thing objectAtIndex:indexPath.row] stringValue];		
		cell.textLabel.text = line;
		double prob = 100*[[[thing objectAtIndex:indexPath.row] probability] doubleValue];	
		cell.detailTextLabel.text = [NSString stringWithFormat:@"%.3f%c", prob, '%'];
		cell.accessoryType = UITableViewCellAccessoryNone;
		
	} else {		
		// if present, particle cells contain a count of emissions
		// link to a detail view
		
		cell = [tableView dequeueReusableCellWithIdentifier:ContentCellIdentifier];
		if (cell == nil) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ContentCellIdentifier];
		}
		
		id thing = [self.radioisotope.contents objectForKey:sectionName];
		NSString *word = [thing count] != 1? @"emissions" : @"emission";
		NSString *line = [NSString stringWithFormat:@"%i %@", [thing count], word];
		cell.textLabel.text = line;
		cell.detailTextLabel.text = nil;
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

	}
	
	return cell;

}

#pragma mark Section header titles

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section 
{    
	return [self.sections objectAtIndex:section];
}

#pragma mark - Table view selection

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
	NSIndexPath *selectedRowIndex = [self.tableView indexPathForSelectedRow];	
	NSString *sectionName = [self.sections objectAtIndex:selectedRowIndex.section];
	
	if ([[segue identifier] isEqualToString:@"ShowSelectedParticles"]) {
    
		NSArray *particles = [self.radioisotope.contents objectForKey:sectionName];
		NSString *pType = [self.sections objectAtIndex:selectedRowIndex.section];
		
        CBRNParticleViewController *particleViewController = [segue destinationViewController];		
		particleViewController.contents = particles;
		particleViewController.particleType = pType;
    } else if ([[segue identifier] isEqualToString:@"ShowProgeny"]) {
		
		Radioisotope *radi = [[self.radioisotope.progeny objectAtIndex:0] isotope];

		CBRNDetailViewController *detailViewController = [segue destinationViewController];		
		detailViewController.radioisotope = radi;
	}
}




@end
