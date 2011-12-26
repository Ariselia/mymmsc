//
//  RootTableViewController.m
//  PullDemo
//
//  Created by  on 11-11-24.
//  Copyright (c) 2011年 watsy. All rights reserved.
//

#import "RootTableViewController.h"


@implementation RootTableViewController
@synthesize array = _array;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    _refreshView = [[iOSRefreshTableView alloc] initWithTableView:self.tableView pullDirection:iOSRefreshTableViewDirectionAll];
    _refreshView.delegate = self;
    self.array = [NSMutableArray arrayWithObjects:@"1",@"2", nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.array = nil;
    [_refreshView release];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [self.array count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    NSLog(@"|%@|",[self.array objectAtIndex:indexPath.row]);
    cell.textLabel.text = [self.array objectAtIndex:indexPath.row];
    
    return cell;
}


#pragma mark scroll view delegate
- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_refreshView scrollViewDidScroll:scrollView];
}

- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_refreshView scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}

#pragma mark scroll view delegate
- (BOOL)iOSRefreshTableViewReloadTableViewDataSource:(iOSRefreshTableViewPullType)refreshType
{   
    NSString *strIndex;
    switch (refreshType) {
        case iOSRefreshTableViewPullTypeReload:
            self.array = nil;
            self.array = [NSMutableArray arrayWithObjects:@"1",@"2", nil];
            break;
            
        case iOSRefreshTableViewPullTypeLoadMore:
            strIndex = [NSString stringWithFormat:@"%d",[self.array count] + 1];
            [self.array addObject:strIndex];
            break;
    }
    [self performSelector:@selector(reloadOk) withObject:nil afterDelay:0.5];
    return YES;
}

- (void) reloadOk
{
    [self.tableView reloadData];
    [_refreshView  DataSourceDidFinishedLoading];
}
@end
