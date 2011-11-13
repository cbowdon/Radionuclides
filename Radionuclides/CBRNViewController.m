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

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	self.title = NSLocalizedString(@"Radionuclides", @"Master view navigation title");

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Table view 

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Only one section.
    return 26;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Only one section, so return the number of items in the list.
	NSString *letter = [NSString stringWithFormat:@"%c", (char)(section+65)];
	NSInteger rows = [[self.dataController.data findIsotopeWithName:letter] count];
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *CellIdentifier = @"NameCell";
	
	// Dequeue or create a cell of the appropriate type.
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    // Get the object to display and set the value in the cell.
	NSArray * isotopesInSection = [self.dataController.sectionData objectAtIndex:indexPath.section];
    Radioisotope *radioisotope = [isotopesInSection objectAtIndex:indexPath.row];
	cell.textLabel.text = [NSString stringWithFormat:@"%@", radioisotope.name];
	cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", radioisotope.halfLifeString];
	return cell;
}

#pragma mark Section header titles

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section 
{    
	NSString *letter = [NSString stringWithFormat:@"%c", (char)(section+65)];
	return letter;
}

-(NSArray*)sectionIndexTitlesForTableView:(UITableView *)tableView
{
	NSUInteger i;
	NSMutableArray *mut = [[NSMutableArray alloc] init];
	for (i = 0; i < 26; i++) {
		[mut addObject:[NSString stringWithFormat:@"%c", (char)(65+i)]];
	}
	return [[NSArray alloc] initWithArray:mut];	
}


#pragma mark - Table view selection

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    /*
     When a row is selected, the segue creates the detail view controller as the destination.
     Set the detail view controller's detail item to the item associated with the selected row.
     */
    if ([[segue identifier] isEqualToString:@"ShowSelectedRadioisotope"]) {
		
        NSIndexPath *selectedRowIndex = [self.tableView indexPathForSelectedRow];
        CBRNDetailViewController *detailViewController = [segue destinationViewController];
		NSArray * isotopesInSection = [self.dataController.sectionData objectAtIndex:selectedRowIndex.section];		
        detailViewController.radioisotope = [isotopesInSection objectAtIndex:selectedRowIndex.row];
    }
}


@end
