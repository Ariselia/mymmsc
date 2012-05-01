//
//  UCAppStore.m
//  FengZi
//
//  Created by WangFeng on 11-12-15.
//  Copyright (c) 2012年 mymmsc.org. All rights reserved.
//

#import "UCAppStore.h"
#import "UCStoreTable.h"
#import "EBuyPortal.h"
#import "Api+eShop.h"

@implementation UCAppStore

@synthesize proxy;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //self.navigationController.delegate = self;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (IBAction)hideWindow:(id)sender {
    [Api seTabView:nil];
    [proxy closeAppStore];
}

- (IBAction)gotoStoreTable:(id)sender {
    UCStoreTable *theView = [[[UCStoreTable alloc] init] autorelease];
    UINavigationController *nextView = [[UINavigationController alloc] initWithRootViewController:theView];
    //nextView.delegate = theView;
    //[self.navigationController pushViewController:nextView animated:YES];
    [self presentModalViewController:nextView animated:YES];
    [nextView release];
}

- (IBAction)gotoEBuy:(id)sender {
    EBuyPortal *theView = [[[EBuyPortal alloc] init] autorelease];
    UINavigationController *nextView = [[UINavigationController alloc] initWithRootViewController:theView];
    [self presentModalViewController:nextView animated:YES];
    [nextView release];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
