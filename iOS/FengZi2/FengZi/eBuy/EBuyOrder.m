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
#import "EBuyOrderInfo.h"

@interface EBuyOrder ()

@end

@implementation EBuyOrder
@synthesize tableView = _tableView;
@synthesize param;
@synthesize addrId;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        addrId = 0; // 默认取第一个地址
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
        [_tableView reloadData];
    }
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_items count] + 3;
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
        cell.textLabel.font = [UIFont systemFontOfSize:20.0];
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        cell.textLabel.lineBreakMode = UILineBreakModeTailTruncation;
        cell.textLabel.numberOfLines = 0;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        // 下面加按钮
        return cell;
    }
    
    EBProductInfo *obj = nil;
    // 地址簿非空
    if (pos == 0) {
        EBAddress *obj = [al objectAtIndex:addrId];
        NSString *str = nil;
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                       reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        cell.textLabel.textColor = [UIColor grayColor];
        cell.textLabel.highlightedTextColor = [UIColor blackColor];
        cell.textLabel.font = [UIFont systemFontOfSize:15.0];
        str = [NSString stringWithFormat:@"收货地址 省:%@ 市:%@",obj.sheng, obj.chengshi];
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
            yj += obj.price * obj.carCount;
        }
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle                                       reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //cell.textLabel.textAlignment = UITextAlignmentRight;
        cell.textLabel.textColor = [UIColor grayColor];
        cell.textLabel.highlightedTextColor = [UIColor blackColor];
        cell.textLabel.font = [UIFont systemFontOfSize:15.0];
        //cell.textLabel.text = [NSString stringWithFormat:@"原始价格:¥%.2f -- 返现:¥%.2f", yj, 0.00f];
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
    if (pos == _items.count + 2) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.frame = CGRectMake(0, 0, 320, 50);
        CGRect frame = CGRectMake(2, 2, 316, 46);
        //kPayWayAlipay = 0x0, // 支付宝客户端支付
        //kPayWayAliWap = 0x1, // 支付宝wap支付
        //kPayWayMobile = 0x2, // 移动支付
        //kPayWayQuick  = 0x3  // 快钱支付
        UISegmentedControl *seg = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"货到付款", @"支付宝"/*, @"支付宝wap", @"移动支付", @"快钱"*/, nil]];
        seg.frame = frame;
        
        NSArray *na = [seg subviews];
        NSEnumerator *ne = [na objectEnumerator];
        UIView *subView;
        while (subView = [ne nextObject]) {
            if ([subView isKindOfClass:[UILabel class]]) {
                UILabel *lb = (UILabel *)subView;
                [lb setTextAlignment:UITextAlignmentCenter];
                [lb setFrame:CGRectMake(0, 0, 120, 30)];
                [lb setFont:[UIFont systemFontOfSize:12]];
            }
        }
        [seg addTarget:self action:@selector(doPay:) forControlEvents:UIControlEventValueChanged];
        [cell.contentView addSubview:seg];
        cell.accessoryType = UITableViewCellAccessoryNone;
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
    NSString *tmpTitle = [NSString stringWithFormat:@"编号:%d 数量:%d 价格:%.2f", obj.shopId, obj.carCount, obj.price];
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
    nextView.seqId = addrId;
    [self.navigationController pushViewController:nextView animated:YES];
    [nextView release];
}

// 选择
- (IBAction)doPay:(UISegmentedControl *)segment{
    NSInteger Index = segment.selectedSegmentIndex;
    _xType = Index - 1;
}

// 确认购买
- (void)doClear:(id)sender event:(id)event{
    //_xType = -1;
    EBOrderInfo *info = [[[EBOrderInfo alloc] init] autorelease];
    EBAddress *addr = [[Api ebuy_address_list] objectAtIndex:0];
    EBOrderUser *user = [[[EBOrderUser alloc] init] autorelease];
    user.userId = [Api userId];
    user.type = _xType < 0 ? @"01" : @"02";
    user.state = kPayStatusNo;
    //user.payWay = _xType;
    //user.payStatus = kPayStatusNo;
    user.address = [NSString stringWithFormat:@"%@%@ %@(%@)", addr.sheng, addr.chengshi, addr.dizhi, addr.youbian];
    user.mobile = addr.shouji.longLongValue;
    user.receiver = addr.shouhuoren;
    user.goodsCount = 0;
    user.areaCode = addr.youbian.intValue;
    
    NSMutableArray *array = [NSMutableArray array];
    for (EBProductInfo *obj in _items) {
        EBOrderProduct *product = [[[EBOrderProduct alloc] init] autorelease];
        product.id = obj.id;
        product.name = obj.title;
        product.totalCount = obj.carCount;
        product.price = obj.price;
        [array addObject:product];
        user.orderId = obj.orderId;
        user.goodsCount += obj.carCount;
    }
    info.userInfo = user;
    info.products = array;
    [iOSApi showAlert:@"订购操作中..."];
    BOOL bBuy = NO;
    ApiResult *iRet = [[Api ebuy_order:info] retain];
    [iOSApi showCompleted:iRet.message];
    [iOSApi closeAlert];
    if (iRet.status == 0) {
        bBuy = YES;
    }
    
    if (bBuy) {
        if (_xType < 0) {
            for (EBProductInfo *obj in _items) {
                [Api ebuy_car_delete:obj];
            }
            [self.navigationController popToRootViewControllerAnimated:YES];
        } else {
            EBuyOrderInfo *nextView = [[EBuyOrderInfo alloc] init];
            nextView.bPay = YES;
            nextView.xType = _xType;
            nextView.orderId = iRet.data;
            [self.navigationController pushViewController:nextView animated:YES];
            [nextView release];
        }
    }
    [iRet release];
}

@end
