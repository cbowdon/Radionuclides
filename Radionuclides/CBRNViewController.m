//
//  CBRNViewController.m
//  Radionuclides
//
//  Created by Chris on 11-11-12.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "CBRNViewController.h"

@implementation CBRNViewController

@synthesize dataController = _dataController, radionuclides = _radionuclides;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	self.title = NSLocalizedString(@"Radionuclides", @"Master view navigation title");
	
	// final arrays
	UILocalizedIndexedCollation *theCollation = [UILocalizedIndexedCollation currentCollation];
	self.radionuclides = [NSMutableArray arrayWithCapacity:1];
	
	// enumerate array and get section number
	// add section number to item in array
	for (Radioisotope *ri in self.dataController.isotopes) {
		NSInteger sect = [theCollation sectionForObject:ri collationStringSelector:@selector(name)];
		ri.sectionNumber = sect;
	}
	
	// create temporary outer array, add empty sub-arrays to it as per section
	NSInteger nSections = [[theCollation sectionTitles] count];
	NSMutableArray *sectionArrays = [NSMutableArray arrayWithCapacity:nSections];
	for (int i = 0; i <= nSections; i++) {
		NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1];
		[sectionArrays addObject:sectionArray];
	}
	
	// load from original flat array into the section arrays
	for (Radioisotope *ri in self.dataController.isotopes) {
		[(NSMutableArray*)[sectionArrays objectAtIndex:ri.sectionNumber] addObject:ri];
	}	
	
	// sort and make a final nested array
	for (NSMutableArray *sectionArray in sectionArrays) {
		NSArray *sortedSection = [theCollation sortedArrayFromArray:sectionArray collationStringSelector:@selector(name)];
		[self.radionuclides addObject:sortedSection];
	}

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Table view 

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.radionuclides count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	return [[self.radionuclides objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *CellIdentifier = @"NameCell";
	
	// Dequeue or create a cell of the appropriate type.
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    // Get the object to display and set the value in the cell.
	Radioisotope *radioisotope = [[self.radionuclides objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
	cell.textLabel.text = [NSString stringWithFormat:@"%@", radioisotope.name];
	cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", radioisotope.halfLifeString];
	return cell;
}

#pragma mark Section header titles

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section 
{   
 	if ([[self.radionuclides objectAtIndex:section] count] > 0) {
		return [[[UILocalizedIndexedCollation currentCollation] sectionIndexTitles] objectAtIndex:section];
	} else {
		return nil;
	}
}

-(NSArray*)sectionIndexTitlesForTableView:(UITableView *)tableView
{
	return [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles];
}

-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
	return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index];
}

#pragma mark - Table view selection

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    
    // When a row is selected, the segue creates the detail view controller as the destination.
	// Set the detail view controller's detail item to the item associated with the selected row.    
    if ([[segue identifier] isEqualToString:@"ShowSelectedRadioisotope"]) {
		
        NSIndexPath *selectedRowIndex = [self.tableView indexPathForSelectedRow];
        CBRNDetailViewController *detailViewController = [segue destinationViewController];		
        detailViewController.radioisotope = 
		[[self.radionuclides objectAtIndex:selectedRowIndex.section] objectAtIndex:selectedRowIndex.row];
    }
}


@end
