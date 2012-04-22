//
//  EBuyOrder.m
//  FengZi
//
//  Created by wangfeng on 12-4-23.
//  Copyright (c) 2012年 ifengzi.cn. All rights reserved.
//

#import "EBuyOrder.h"
#import "Api+Ebuy.h"
#import "EBuyAddress.h"
#import <iOSApi/iOSAsyncImageView.h>

@interface EBuyOrder ()

@end

@implementation EBuyOrder
@synthesize tableView = _tableView;
@synthesize param;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    label.text= @"提交订单";
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
    
    // 处理收货地址
    isEmpty = NO;
    NSArray *data = [[Api ebuy_car_list] objectForKey:param];
    if (data.count < 1) {
        isEmpty = YES;
    } else {
        if (_items != nil) {
            [_items release];
        }
        _items = [[NSMutableArray alloc] initWithArray:data];
    }
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_items count] + 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 70.f;
    
	return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    int pos = [indexPath row];
    [cell.contentView removeSubviews];
    // 地址簿空
    NSArray *al = [Api ebuy_address_list];
    isEmpty = al.count < 1;
    if (pos == 0 && isEmpty) {
        // 下面配文字
        cell.textLabel.text = @"亲，请输入你的地址";
        cell.textLabel.font = [UIFont systemFontOfSize:30.0];
        cell.textLabel.lineBreakMode = UILineBreakModeTailTruncation;
        cell.textLabel.numberOfLines = 0;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        // 下面加按钮
        return cell;
    }
    
    EBProductInfo *obj = nil;
    // 地址簿非空
    if (pos == 0) {
        EBAddress *obj = [al objectAtIndex:0];
        NSString *str = nil;
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                       reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        cell.textLabel.textColor = [UIColor grayColor];
        cell.textLabel.highlightedTextColor = [UIColor blackColor];
        cell.textLabel.font = [UIFont systemFontOfSize:15.0];
        str = [NSString stringWithFormat:@"省:%@ 市:%@",obj.sheng, obj.chengshi];
        cell.textLabel.text = [iOSApi urlDecode:str];
        
        cell.detailTextLabel.textAlignment = UITextAlignmentCenter;
        cell.detailTextLabel.textColor = [UIColor grayColor];
        cell.detailTextLabel.highlightedTextColor = [UIColor blackColor];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:15.0];
        str = [NSString stringWithFormat:@"%@(%@)",obj.dizhi, obj.youbian];
        cell.detailTextLabel.text = [iOSApi urlDecode:str];
        return cell;
    }
    if (pos == _items.count + 1) {
        CGFloat yj = 0.00f;
        for (obj in _items) {
            yj += obj.price;
        }
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle                                       reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //cell.textLabel.textAlignment = UITextAlignmentRight;
        cell.textLabel.textColor = [UIColor grayColor];
        cell.textLabel.highlightedTextColor = [UIColor blackColor];
        cell.textLabel.font = [UIFont systemFontOfSize:15.0];
        cell.textLabel.text = [NSString stringWithFormat:@"原始价格:¥%.2f -- 返现:¥%.2f", yj, 0.00f];
        //cell.detailTextLabel.textAlignment = UITextAlignmentRight;
        cell.detailTextLabel.textColor = [UIColor grayColor];
        cell.detailTextLabel.highlightedTextColor = [UIColor blackColor];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:15.0];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"合计:¥%.2f", yj];
        if (!isEmpty) {
            CGRect frame = CGRectMake(180, 50, 100, 20);
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [btn setTitle:@"确认购买" forState:UIControlStateNormal];
            btn.frame = frame;
            [btn addTarget:self action:@selector(doClear:event:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:btn];
        }
        return cell;
    }
    obj = [_items objectAtIndex:pos - 1];
    cell.imageView.frame = CGRectMake(0, 0, 50, 50);
    iOSAsyncImageView *ai = nil; //[info aimage];
    if (ai == nil)
    {
        // 默认图片
        cell.imageView.image = [[UIImage imageNamed:@"unknown.png"] toSize:CGSizeMake(50, 50)];
        ai = [[[iOSAsyncImageView alloc] initWithFrame:cell.imageView.frame] autorelease];
        NSString *tmp = [iOSApi urlDecode:obj.picUrl];
        NSArray *arr = [tmp split:@"*"];
        //NSString *tmpUrl;
        
        NSURL *url = [NSURL URLWithString: [arr objectAtIndex:0]];
        [ai loadImageFromURL:url];
    }
    [cell.imageView addSubview:ai];
    
    cell.textLabel.text = [iOSApi urlDecode:obj.title];
    NSString *tmpTitle = [NSString stringWithFormat:@"编号:%d 数量:1 价格:%.2f", obj.shopId, obj.price];
    cell.detailTextLabel.text = [iOSApi urlDecode:tmpTitle];
    cell.detailTextLabel.lineBreakMode = UILineBreakModeTailTruncation;
    cell.detailTextLabel.numberOfLines = 0;
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    int pos = indexPath.row;
    if (pos > 0) {
        return;
    }
    // 跳转 地址簿编辑页面
    EBuyAddress *nextView = [[EBuyAddress alloc] init];
    //nextView.param = param;
    [self.navigationController pushViewController:nextView animated:YES];
    [nextView release];
    
}

// 确认购买
- (void)doClear:(id)sender event:(id)event{
    NSSet *touches = [event allTouches];
	UITouch *touch = [touches anyObject];
	CGPoint currentTouchPosition = [touch locationInView: _tableView];
	NSIndexPath *indexPath = [_tableView indexPathForRowAtPoint: currentTouchPosition];
    
}

@end
