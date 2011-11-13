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
    static NSString *MetaCellIdentifier = @"MetaCell";
	static NSString *ContentCellIdentifier = @"ContentCell";

    
	NSString *sectionName = [self.sections objectAtIndex:indexPath.section];
	
	UITableViewCell *cell;
	
    // Configure the cell...		
	if ([sectionName isEqualToString:@"Atomic number"]) {	
		
		cell = [tableView dequeueReusableCellWithIdentifier:MetaCellIdentifier];
		if (cell == nil) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MetaCellIdentifier];
		}

		
		cell.textLabel.text = [NSString stringWithFormat:@"%i", self.radioisotope.atomicNumber];	
		cell.detailTextLabel.text = nil;
		cell.accessoryType = UITableViewCellAccessoryNone;
		
	} else if ([sectionName isEqualToString:@"Half life"]){	
		
		cell = [tableView dequeueReusableCellWithIdentifier:MetaCellIdentifier];
		if (cell == nil) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MetaCellIdentifier];
		}

		
		cell.textLabel.text = self.radioisotope.halfLifeString;
		cell.detailTextLabel.text = nil;
		cell.accessoryType = UITableViewCellAccessoryNone;

	} else {		
		
		cell = [tableView dequeueReusableCellWithIdentifier:ContentCellIdentifier];
		if (cell == nil) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ContentCellIdentifier];
		}

		
		id thing = [self.radioisotope.contents objectForKey:sectionName];
		NSString *line = [[thing objectAtIndex:indexPath.row] stringValue];		
		cell.textLabel.text = line;
		double prob = 100*[[[thing objectAtIndex:indexPath.row] probability] doubleValue];
		cell.detailTextLabel.text = [NSString stringWithFormat:@"%.3f%c", prob, '%'];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

	}

	return cell;

}

#pragma mark Section header titles

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section 
{    
    // to do: make this "Alphas (13)"
	return [self.sections objectAtIndex:section];
}

#pragma mark - Table view selection

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    /*
     When a row is selected, the segue creates the detail view controller as the destination.
     Set the detail view controller's detail item to the item associated with the selected row.
     */
	
	
    if ([[segue identifier] isEqualToString:@"ShowSelectedParticles"]) {
    
		NSIndexPath *selectedRowIndex = [self.tableView indexPathForSelectedRow];
		
        CBRNParticleViewController *particleViewController = [segue destinationViewController];		
		

		particleViewController.contents = nil;

    }
}




@end
