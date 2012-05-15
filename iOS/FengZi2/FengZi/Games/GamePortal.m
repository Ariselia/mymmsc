//
//  GamePortal.m
//  FengZi
//
//  Created by wangfeng on 12-5-14.
//  Copyright (c) 2012年 ifengzi.cn. All rights reserved.
//

#import "GamePortal.h"
#import "UIView+Effect.h"

#import "Roulette.h" // 轮盘
#import "Hamster.h"  // 打地鼠
#import "BreakEgg.h" // 砸蛋
#import "OpenBox.h"  // 开箱子

@interface GamePortal ()

@end

@implementation GamePortal
@synthesize tableView = _tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
         self.proxy = self;
    }
    return self;
}

- (void)goBack{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIImage *image = [UIImage imageNamed:@"navigation_bg.png"];
    Class ios5Class = (NSClassFromString(@"CIImage"));
    if (nil != ios5Class) {
        [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    } else {
        self.navigationController.navigationBar.layer.contents = (id)[UIImage imageNamed:@"navigation_bg.png"].CGImage;
    }
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(110, 0, 150,44)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = UITextAlignmentCenter;
    label.font = [UIFont fontWithName:@"黑体" size:60];
    label.textColor = [UIColor blackColor];
    label.text= @"蜂幸运";
    self.navigationItem.titleView = label;
    [label release];
    
    UIButton *backbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backbtn.frame = CGRectMake(0, 0, 60, 32);
    
    [backbtn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backbtn setImage:[UIImage imageNamed:@"back_tap.png"] forState:UIControlStateHighlighted];
    [backbtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backitem = [[UIBarButtonItem alloc] initWithCustomView:backbtn];
    self.navigationItem.leftBarButtonItem = backitem;
    [backitem release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _borderStyle = UITextBorderStyleNone;
    //font = [UIFont systemFontOfSize:13.0];
    if ([_items count] == 0) {
        // 预加载项
        _items = [[NSMutableArray alloc] initWithCapacity:0];
        _page = 1;
    }
}

#pragma mark -
#pragma mark UITableViewDataSource

- (UITableViewCell *)configure:(UITableViewCell *)cell withObject:(id)object {
    GameInfo *obj = object;
    // 设置字体
    UIFont *textFont = [UIFont systemFontOfSize:17.0];
    cell.textLabel.text = [iOSApi urlDecode:obj.caseName];
    cell.textLabel.font = textFont;
    
    cell.detailTextLabel.text = [iOSApi urlDecode:obj.activeName];
    //[cell setLayerEffect:cell.layer];
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

static GameInfo *theObj = nil;

- (void)tableView:(UITableViewCell *)cell onCustomAccessoryTapped:(id)object {
    theObj = object;
    UIAlertView *alert = [[UIAlertView alloc]
						  initWithTitle:nil
						  message:nil
						  delegate:self
						  cancelButtonTitle:@"轮盘"
						  otherButtonTitles:@"打地鼠",@"开箱子",@"砸金蛋",
                          nil];
    [alert show];
	[alert release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger) buttonIndex {
    GameInfo *obj = theObj;
    int n = buttonIndex + 1;
    if (n == 1) {
        // 轮盘
        Roulette *theView = [[[Roulette alloc] init] autorelease];
        theView.luckyid = obj.caseId;
        theView.shopguid = obj.activeId;
        UINavigationController *nextView = [[UINavigationController alloc] initWithRootViewController:theView];
        [self presentModalViewController:nextView animated:YES];
        [nextView release];
    } else if (n == 2) {
        // 打地鼠
        Hamster *theView = [[[Hamster alloc] init] autorelease];
        theView.luckyid = obj.caseId;
        theView.shopguid = obj.activeId;
        UINavigationController *nextView = [[UINavigationController alloc] initWithRootViewController:theView];
        [self presentModalViewController:nextView animated:YES];
        [nextView release];
    } else if (n == 3) {
        // 开箱子
        OpenBox *theView = [[[OpenBox alloc] init] autorelease];
       theView.luckyid = obj.caseId;
        theView.shopguid = obj.activeId;
        UINavigationController *nextView = [[UINavigationController alloc] initWithRootViewController:theView];
        [self presentModalViewController:nextView animated:YES];
        [nextView release];
    } else if (n == 4) {
        // 砸蛋
        BreakEgg *theView = [[[BreakEgg alloc] init] autorelease];
        theView.luckyid = obj.caseId;
        theView.shopguid = obj.activeId;
        
        UINavigationController *nextView = [[UINavigationController alloc] initWithRootViewController:theView];
        [self presentModalViewController:nextView animated:YES];
        [nextView release];
    }
}

- (NSArray *)reloadData:(iOSTableViewController *)tableView {
    [iOSApi showAlert:@"获取活动列表..."];
    NSArray *data = [Api activeList];
    if (data == nil || data.count < 1) {
        [iOSApi showCompleted:@"服务器正忙，请稍候"];
    }
    [iOSApi closeAlert];
    return data;
}

- (NSArray *)arrayOfHeader:(iOSTableViewController *)tableView {
    return nil;
}

- (NSArray *)arrayOfFooter:(iOSTableViewController *)tableView {
    return nil;
    //NSArray *list = [Api activeList];
    //return list;
}

@end
