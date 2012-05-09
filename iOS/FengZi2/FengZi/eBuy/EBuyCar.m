//
//  EBuyCar.m
//  FengZi
//
//  Created by wangfeng on 12-4-22.
//  Copyright (c) 2012年 ifengzi.cn. All rights reserved.
//

#import "EBuyCar.h"
#import "Api+Ebuy.h"
#import "EBuyOrder.h"
#import "EBuyTypes.h"
#import "EBuyEditAddress.h"
#import "EBProductList.h"
#import <iOSApi/iOSAsyncImageView.h>

@interface EBuyCar ()

@end

@implementation EBuyCar
@synthesize tableView = _tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        isEmpty = NO;
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
    label.text= @"购物车";
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
    isEmpty = NO;
    NSMutableDictionary *data = [[Api ebuy_car_list] retain];
    if (data.count < 1) {
        isEmpty = YES;
    } else {
        if (_items != nil) {
            [_items release];
        }
        _items = [[NSMutableDictionary alloc] initWithDictionary:data];
        [data release];
    }
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (isEmpty) {
        return 1;
    }
    int iCount = [_items count];
    return iCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (isEmpty) {
        return 1;
    }
    NSArray *keys = [_items allKeys];
    NSArray *values = [_items objectForKey:[keys objectAtIndex:section]];
    return [values count] + 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 70.f;
    NSArray *keys = [_items allKeys];
    int iCount = 0;
    if (keys.count > 0) {
        NSString *name = [keys objectAtIndex:indexPath.section];
        if (name != nil) {
            NSArray *values = [_items objectForKey:name];
            iCount = values.count;
        }
    }    
    if (isEmpty) {
        height = 357;
    } else if(indexPath.row == 0){
        height = 30;
    } else if(indexPath.row == iCount + 1){
        height = 50;
    }
	return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    int pos = [indexPath row];
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    [cell.contentView removeSubviews];
    // 购物车空
    if (pos == 0 && isEmpty) {
        // 加载购物车图片
        UIImage *image = [UIImage imageNamed:@"ebuy_shopping_empty.png"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = CGRectMake(80, 0, 160, 160);
        [cell.contentView addSubview:imageView];
        // 下面配文字
        cell.textLabel.text = @"购物车还是空的，快去选购吧～～";
        cell.textLabel.font = [UIFont systemFontOfSize:15.0];
        cell.textLabel.lineBreakMode = UILineBreakModeTailTruncation;
        cell.textLabel.numberOfLines = 0;
        CGRect frame = CGRectMake(100, 300, 120, 30);
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btn setTitle:@"去逛逛" forState:UIControlStateNormal];
        btn.frame = frame;
        [btn addTarget:self action:@selector(doBuyList) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:btn];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        // 下面加按钮
        return cell;
    }
    
    NSArray *keys = [_items allKeys];
    NSArray *values = [_items objectForKey:[keys objectAtIndex:indexPath.section]];
    EBProductInfo *obj = nil;
    // 购物车非空
    if (pos == 0) {
        obj = [values objectAtIndex:0];
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        cell.textLabel.textColor = [UIColor grayColor];
        cell.textLabel.highlightedTextColor = [UIColor blackColor];
        cell.textLabel.font = [UIFont systemFontOfSize:15.0];
        cell.textLabel.text = [iOSApi urlDecode:obj.shopName];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
    if (pos == values.count + 1) {
        CGFloat yj = 0.00f;
        for (obj in values) {
            yj += obj.price * obj.carCount;
        }
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle                                       reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.textAlignment = UITextAlignmentRight;
        cell.textLabel.textColor = [UIColor grayColor];
        cell.textLabel.highlightedTextColor = [UIColor blackColor];
        cell.textLabel.font = [UIFont systemFontOfSize:15.0];
        cell.textLabel.text = [NSString stringWithFormat:@"合计:¥%.2f", yj];/*[NSString stringWithFormat:@"原始价格:¥%.2f -- 返现:¥%.2f", yj, 0.00f];
        cell.detailTextLabel.textAlignment = UITextAlignmentRight;
        cell.detailTextLabel.textColor = [UIColor grayColor];
        cell.detailTextLabel.highlightedTextColor = [UIColor blackColor];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:15.0];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"合计:¥%.2f", yj];
        */
        CGRect frame = CGRectMake(140, 30, 70, 20);
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btn setTitle:@"去结算" forState:UIControlStateNormal];
        btn.frame = frame;
        [btn addTarget:self action:@selector(doClear:event:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:btn];
        
        frame = CGRectMake(220, 30, 70, 20);
        btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btn setTitle:@"继续购物" forState:UIControlStateNormal];
        btn.frame = frame;
        [btn addTarget:self action:@selector(doBuy:event:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:btn];
        return cell;
    }
    obj = [values objectAtIndex:pos - 1];
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
    NSString *tmpTitle = [NSString stringWithFormat:@"编号:%d 数量:%d 价格:%.2f", obj.shopId, obj.carCount, obj.price];
    cell.detailTextLabel.text = [iOSApi urlDecode:tmpTitle];
    cell.detailTextLabel.lineBreakMode = UILineBreakModeTailTruncation;
    cell.detailTextLabel.numberOfLines = 0;
    CGRect frame = CGRectMake(200, 0, 70, 20);
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn setTitle:@"删除" forState:UIControlStateNormal];
    btn.frame = frame;
    [btn addTarget:self action:@selector(doRemove:event:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:btn];
    
    _tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    int pos = indexPath.row;
    if (pos != 0 || isEmpty) {
        return;
    }
    NSArray *keys = [_items allKeys];
    NSArray *values = [_items objectForKey:[keys objectAtIndex:indexPath.section]];
    EBProductInfo *obj = nil;
    obj = [values objectAtIndex:0];
    // 跳转 商户产品列表 页面
    EBProductList *nextView = [[EBProductList alloc] init];
    nextView.way = 0;
    nextView.typeId = [NSString valueOf:obj.shopId];
    [self.navigationController pushViewController:nextView animated:YES];
    [nextView release];
}


- (void)doBuyList{
    EBuyTypes *nextView = [[EBuyTypes alloc] init];
    nextView.typeId = 0;
    [self.navigationController pushViewController:nextView animated:YES];
    [nextView release];
}

- (void)doBuy:(id)sender event:(id)event{
    NSSet *touches = [event allTouches];
	UITouch *touch = [touches anyObject];
	CGPoint currentTouchPosition = [touch locationInView: _tableView];
	NSIndexPath *indexPath = [_tableView indexPathForRowAtPoint: currentTouchPosition];
    NSArray *keys = [_items allKeys];
    NSArray *values = [_items objectForKey:[keys objectAtIndex:indexPath.section]];
    EBProductInfo *obj = [values objectAtIndex:indexPath.row - 2];
    obj = [values objectAtIndex:0];
    // 跳转 商户产品列表 页面
    EBProductList *nextView = [[EBProductList alloc] init];
    nextView.way = 0;
    nextView.typeId = [NSString valueOf:obj.shopId];
    [self.navigationController pushViewController:nextView animated:YES];
    [nextView release];
    /*
    EBuyTypes *nextView = [[EBuyTypes alloc] init];
    nextView.typeId = 0;
    [self.navigationController pushViewController:nextView animated:YES];
    [nextView release];
    */
}

- (void)doClear:(id)sender event:(id)event{
    NSSet *touches = [event allTouches];
	UITouch *touch = [touches anyObject];
	CGPoint currentTouchPosition = [touch locationInView: _tableView];
	NSIndexPath *indexPath = [_tableView indexPathForRowAtPoint: currentTouchPosition];
    NSArray *keys = [_items allKeys];
    NSArray *values = [_items objectForKey:[keys objectAtIndex:indexPath.section]];
    EBProductInfo *obj = [values objectAtIndex:indexPath.row - 2];
    if ([Api ebuy_address_list].count > 0) {
        EBuyEditAddress *nextView = [[EBuyEditAddress alloc] init];
        nextView.shopName = obj.shopName;
        [self.navigationController pushViewController:nextView animated:YES];
        [nextView release];
    } else {
        EBuyOrder *nextView = [[EBuyOrder alloc] init];
        nextView.param = obj.shopName;
        [self.navigationController pushViewController:nextView animated:YES];
        [nextView release];
    }
}

- (void)doRemove:(id)sender event:(id)event{
    NSSet *touches = [event allTouches];
	UITouch *touch = [touches anyObject];
	CGPoint currentTouchPosition = [touch locationInView: _tableView];
	NSIndexPath *indexPath = [_tableView indexPathForRowAtPoint: currentTouchPosition];
    NSArray *keys = [_items allKeys];
    NSArray *values = [_items objectForKey:[keys objectAtIndex:indexPath.section]];
    EBProductInfo *obj = [values objectAtIndex:indexPath.row - 1];
    [Api ebuy_car_delete:obj.shopName index:indexPath.row - 1];
    isEmpty = NO;
    NSMutableDictionary *data = [[Api ebuy_car_list] retain];
    if (data.count < 1) {
        isEmpty = YES;
        [_items removeAllObjects];
    } else {
        if (_items != nil) {
            [_items release];
        }
        _items = [[NSMutableDictionary alloc] initWithDictionary:data];
        [data release];
    }
     [_tableView reloadData];
}
@end
