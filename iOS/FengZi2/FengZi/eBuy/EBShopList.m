//
//  EBShopList.m
//  FengZi
//
//  Created by wangfeng on 12-3-23.
//  Copyright (c) 2012年 iTotemStudio. All rights reserved.
//

#import "EBShopList.h"
#import "EBProductList.h"
#import "EBShopInfo.h"
#import "EBProductDetail.h"
#import <iOSApi/iOSStar.h>
#import <iOSApi/UIImageView+Utils.h>

@interface EBShopList ()

@end

@implementation EBShopList
@synthesize tableView=_tableView;

#define kTAG_BASE (10000)
#define kTAG_STAR (kTAG_BASE + 1)

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //self.proxy = self;
        _page = 0;
    }
    return self;
}

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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
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
    label.text= @"商铺";
    self.navigationItem.titleView = label;
    [label release];
    
    UIButton *backbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backbtn.frame =CGRectMake(0, 0, 60, 32);
    
    [backbtn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backbtn setImage:[UIImage imageNamed:@"back_tap.png"] forState:UIControlStateHighlighted];
    [backbtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backitem = [[UIBarButtonItem alloc] initWithCustomView:backbtn];
    self.navigationItem.leftBarButtonItem = backitem;
    [backitem release];
        
    _borderStyle = UITextBorderStyleNone;
    //font = [UIFont systemFontOfSize:13.0];
    if ([_items count] == 0) {
        // 预加载项
        _items = [[NSMutableArray alloc] initWithCapacity:0];
        _page = 1;
    }
    if (_items != nil) {
        NSArray *list = [[Api ebuy_shoplist:_page] retain];
        [_items addObjectsFromArray:list];
        [list release];
    }
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //return 0;
    return [_items count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 50.f;
	return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    int pos = [indexPath row];
    EBShop *obj = [_items objectAtIndex:pos];
    cell.imageView.image = [[UIImage imageNamed:@"unknown.png"] toSize:CGSizeMake(50, 50)];
    [cell.imageView imageWithURL:[iOSApi urlDecode:obj.picUrl]];
    cell.imageView.frame = CGRectMake(0, 0, 50, 50);
    cell.textLabel.text = [iOSApi urlDecode:obj.name];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellAccessoryDetailDisclosureButton;
    //return UITableViewCellAccessoryDisclosureIndicator;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    EBShop *obj = [_items objectAtIndex:indexPath.row];
    EBProductList *nextView = [[EBProductList alloc] init];
    nextView.way = 0;
    nextView.typeId = [NSString valueOf:obj.id];
    [self.navigationController pushViewController:nextView animated:YES];
    [nextView release];
}

@end
