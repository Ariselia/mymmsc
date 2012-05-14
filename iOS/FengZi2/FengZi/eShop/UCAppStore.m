//
//  UCAppStore.m
//  FengZi
//
//  Created by WangFeng on 11-12-15.
//  Copyright (c) 2012年 mymmsc.org. All rights reserved.
//

#import "UCAppStore.h"
#import "Api+eShop.h"
#import "UCStoreTable.h" // 数字商城
#import "EBuyPortal.h"   // 电子商城
#import "EFileMain.h"    // 蜂夹
#import "GamePortal.h"   // 蜂幸运

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

// 转向电子蜂夹
- (IBAction)gotoEFile:(id)sender {
    // 判断是否登录
    if ([Api isOnLine]) {
        // 登录
        EFileMain *theView = [[[EFileMain alloc] init] autorelease];
        UINavigationController *nextView = [[UINavigationController alloc] initWithRootViewController:theView];
        [self presentModalViewController:nextView animated:YES];
        [nextView release];
    } else {
        // 未登录
        [iOSApi toast:@"请先登录"];
        [proxy closeAppStore];
    }
}

// 转向蜂幸运
- (IBAction)gotoLucky:(id)sender{
    // 判断是否登录
    if ([Api isOnLine]) {
        // 登录
        GamePortal *theView = [[[GamePortal alloc] init] autorelease];
        UINavigationController *nextView = [[UINavigationController alloc] initWithRootViewController:theView];
        [self presentModalViewController:nextView animated:YES];
        [nextView release];
    } else {
        // 未登录
        [iOSApi toast:@"请先登录"];
        [proxy closeAppStore];
    }
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
