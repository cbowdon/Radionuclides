//
//  CBRNViewController.m
//  Radionuclides
//
//  Created by Chris on 11-11-12.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "CBRNViewController.h"

@implementation CBRNViewController

@synthesize dataController = _dataController;
@synthesize radionuclides = _radionuclides, filteredRadionuclides = _filteredRadionuclides;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	self.title = NSLocalizedString(@"Radionuclides", @"Master view navigation title");
	
	// final arrays
	UILocalizedIndexedCollation *theCollation = [UILocalizedIndexedCollation currentCollation];
	self.radionuclides = [NSMutableArray arrayWithCapacity:1];
	self.filteredRadionuclides = [NSMutableArray arrayWithCapacity:[self.dataController.isotopes count]];
	
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
	
	NSIndexPath *startPath = [NSIndexPath indexPathForRow:0 inSection:0];

	[self.tableView reloadData];
	[self.tableView scrollToRowAtIndexPath:startPath atScrollPosition:UITableViewScrollPositionTop animated:NO];

}

-(void)viewDidUnload
{
	self.radionuclides = nil;
	self.filteredRadionuclides = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Table view 

#pragma mark - Table view number of sections and rows
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
 	if (tableView == self.searchDisplayController.searchResultsTableView) {
		return 1;
	} else {
		return [self.radionuclides count];
	}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	if (tableView == self.searchDisplayController.searchResultsTableView) {
		return [self.filteredRadionuclides count];
	} else {
		return [[self.radionuclides objectAtIndex:section] count];
	}
}

#pragma mark - Table view cells

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *NameCellIdentifier = @"NameCell";
	static NSString *SearchResultIdentifier = @"SearchResult";	
	
	// Dequeue or create a cell of the appropriate type.
	UITableViewCell *cell;
	
	// Get the object to display and set the value in the cell.
	Radioisotope *radioisotope;
	if (tableView == self.searchDisplayController.searchResultsTableView) {
		
		cell = [tableView dequeueReusableCellWithIdentifier:SearchResultIdentifier];
		
		if (cell == nil) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SearchResultIdentifier];
			cell.accessoryType = UITableViewCellAccessoryNone;
		}
		
        radioisotope = [self.filteredRadionuclides objectAtIndex:indexPath.row];		
    } else {			
		
		cell = [tableView dequeueReusableCellWithIdentifier:NameCellIdentifier];
		if (cell == nil) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:NameCellIdentifier];
			cell.accessoryType = UITableViewCellAccessoryNone;
		}
		
		radioisotope = [[self.radionuclides objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
	}
	
	cell.textLabel.text = [NSString stringWithFormat:@"%@", radioisotope.name];
	cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", radioisotope.halfLifeString];
	return cell;	
}

#pragma mark - Table view section header titles

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section 
{   
	if (tableView == self.searchDisplayController.searchResultsTableView) {
		return nil;
	} else {
		if ([[self.radionuclides objectAtIndex:section] count] > 0) {
			return [[[UILocalizedIndexedCollation currentCollation] sectionIndexTitles] objectAtIndex:section];
		} else {
			return nil;
		}
	}
}

-(NSArray*)sectionIndexTitlesForTableView:(UITableView *)tableView
{
	if (tableView == self.searchDisplayController.searchResultsTableView) {
		return nil;
	} else {		
		return [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles];
	}
}

-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
	if (tableView == self.searchDisplayController.searchResultsTableView) {
		return 0;
	} else {
		return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index];
	}
}

#pragma mark - Search 

// update filteredRadionuclides
- (void)filterContentForSearchText:(NSString*)searchText
{
	[self.filteredRadionuclides removeAllObjects]; // First clear the filtered array.
	
	// Search the flat list for products whose name matches searchText; add items that match to the filtered array.
	//	self.filteredRadionuclides = 
	//	[NSMutableArray arrayWithArray:[self.dataController.data findIsotopeWithName:searchText]];	
	
	for (Radioisotope *radi in self.dataController.isotopes)
	{		
		NSComparisonResult result = 
		[radi.name compare:searchText 
				   options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) 
					 range:NSMakeRange(0, [searchText length])];		
		if (result == NSOrderedSame)
		{
			[self.filteredRadionuclides addObject:radi];
		}
	}
	
	
	
}


#pragma mark - UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}


#pragma mark - Table view selection segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    // When a row is selected, the segue creates the detail view controller as the destination.
	// Set the detail view controller's detail item to the item associated with the selected row.    	
	
	NSIndexPath *selectedRowIndex = [self.tableView indexPathForSelectedRow];
	CBRNDetailViewController *detailViewController = [segue destinationViewController];		
	
	
	if ([[segue identifier] isEqualToString:@"ShowSelectedRadioisotope"]) {
		
		detailViewController.radioisotope = 
		[[self.radionuclides objectAtIndex:selectedRowIndex.section] objectAtIndex:selectedRowIndex.row];
		
    }
	if ([[segue identifier] isEqualToString:@"ShowSearchResult"]) {
		
		detailViewController.radioisotope = [self.filteredRadionuclides objectAtIndex:selectedRowIndex.row];
		
    }
	
}


@end
