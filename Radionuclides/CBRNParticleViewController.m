//
//  CBRNParticleViewController.m
//  Radionuclides
//
//  Created by Chris on 11-11-13.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "CBRNParticleViewController.h"


@implementation CBRNParticleViewController

@synthesize contents = _contents, particleType = _particleType;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.title = self.particleType;
}

-(void)viewDidUnload
{
	self.contents = nil;
	self.particleType = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.contents count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section 
{
	return [NSString stringWithFormat:@"Energy: Probability"];	
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ParticleCellIdentifier = @"ParticleCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ParticleCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ParticleCellIdentifier];
    }
    
    // Configure the cell...
	id thing = [self.contents objectAtIndex:indexPath.row];
	cell.textLabel.text = [thing stringValue];
	cell.detailTextLabel.text = [NSString stringWithFormat:@"%.3f%c", 100*[[thing probability] doubleValue], '%'];

    
    return cell;
}


# pragma mark - Popup menu

- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath
{	
	return YES;		
}

- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    return (action == @selector(copy:));
}

- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    if (action == @selector(copy:)) {		

		NSString *dataString = nil;
		
		// get the cell data into a string		
		id particle = [self.contents objectAtIndex:indexPath.row];
		double prob = 100*[[particle probability] doubleValue];
		dataString = [NSString stringWithFormat:@"%@ %.3f%c", [particle stringValue], prob, '%'];
					   
		// put on the general pasteboard
		UIPasteboard *gpBoard = [UIPasteboard generalPasteboard];
		[gpBoard setString:dataString];
	}
}

@end
