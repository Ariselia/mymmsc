//
//  EBuyOrderInfo.m
//  FengZi
//
//  Created by wangfeng on 12-4-23.
//  Copyright (c) 2012年 ifengzi.cn. All rights reserved.
//

#import "EBuyOrderInfo.h"
#import "Api+Ebuy.h"
#import <iOSApi/iOSAsyncImageView.h>
#import "EBuyOrderUserCell.h"
#import "EBuyOrderAddressCell.h"
#import "EBProductList.h"

@interface EBuyOrderInfo ()

@end

@implementation EBuyOrderInfo
@synthesize tableView = _tableView;
@synthesize orderId, bPay, xType;//

static int xState = -1;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _shopId = 0;
        xState = -1;
    }
    return self;
}

- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
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
    label.text= @"查看订单";
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
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    if (_timer != nil) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewWillAppear:(BOOL)animated{
    IOSAPI_RELEASE(_orderInfo);
    _orderInfo = [[Api ebuy_order_get:orderId] retain];
    IOSAPI_RELEASE(_items);
    _items = [[NSMutableArray alloc] initWithCapacity:0];
    isEmpty = YES;
    if (_orderInfo.userInfo != nil) {
        isEmpty = NO;
        // 表格顶部用户信息
        EBOrderUser *user = _orderInfo.userInfo;
        _shopId = user.shopId;
        NSArray *list = _orderInfo.products;
        EBuyOrderUserCell *cell1 = [(EBuyOrderUserCell *)[[[NSBundle mainBundle] loadNibNamed:@"EBuyOrderUserCell" owner:self options:nil] objectAtIndex:0] retain];
        
        cell1.orderId.text = [iOSApi urlDecode:user.orderId];
        // 支付方式
        cell1.orderId.text = user.orderId;
        cell1.orderState.text = [Api ebuy_state_order:user.state];
        cell1.orderPayStatus.text = user.payStatus == 0x01 ? @"未支付" : @"已支付";//[Api ebuy_state_order:user.payStatus];
        cell1.orderModel.text = [Api ebuy_pay_type:user.payWay];
        cell1.orderNumber.text = [NSString stringWithFormat:@"%d", user.goodsCount];
        float hj = 0.00f;
        for (EBOrderProduct *obj in list) {
            hj += (obj.price * obj.totalCount);
        }
        cell1.orderPrice.text = [NSString stringWithFormat:@"%.2f", hj];
        cell1.backgroundColor = [UIColor lightGrayColor];
        [_items addObject:cell1];
        
        // 店名
        UITableViewCell *cell3 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell3.frame = CGRectMake(0, 0, 320, 50);
        cell3.textLabel.text= [iOSApi urlDecode:user.shopName];
        cell3.textLabel.textAlignment = UITextAlignmentCenter;
        cell3.textLabel.backgroundColor = [UIColor lightGrayColor];
        cell3.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [_items addObject:cell3];
        // 商品信息 循环
        for (EBOrderProduct *op in list) {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
            cell.frame = CGRectMake(0, 0, 320, 60);
            cell.textLabel.text= [iOSApi urlDecode:op.name];
            cell.textLabel.textAlignment = UITextAlignmentCenter;
            cell.backgroundColor = [UIColor grayColor];
            cell.imageView.frame = CGRectMake(0, 0, 50, 50);
            NSString *tmp = [iOSApi urlDecode:op.picUrl];
            NSArray *arr = [tmp split:@"*"];
            //NSURL *url = [NSURL URLWithString: [arr objectAtIndex:0]];
            cell.imageView.image = [[UIImage imageNamed:@"unknown.png"] toSize:CGSizeMake(50, 50)];
            [cell.imageView imageWithURL:[arr objectAtIndex:0]];
            /*
            iOSAsyncImageView *ai = nil; //[info aimage];
            if (ai == nil)
            {
                // 默认图片
                cell.imageView.image = [[UIImage imageNamed:@"unknown.png"] toSize:CGSizeMake(50, 50)];
                ai = [[[iOSAsyncImageView alloc] initWithFrame:cell.imageView.frame] autorelease];
                NSString *tmp = [iOSApi urlDecode:op.picUrl];
                NSArray *arr = [tmp split:@"*"];
                NSURL *url = [NSURL URLWithString: [arr objectAtIndex:0]];
                [ai loadImageFromURL:url];
            }
            [cell.imageView addSubview:ai];
            */
            NSString *tmpTitle = [NSString stringWithFormat:@"数量:%d, 价格:%.2f", op.totalCount, op.price];
            cell.detailTextLabel.text = [iOSApi urlDecode:tmpTitle];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:12.0f];
            cell.detailTextLabel.width = 270;
            //cell.detailTextLabel.lineBreakMode = UILineBreakModeTailTruncation;
            //cell.detailTextLabel.numberOfLines = 0;
            _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            [_items addObject:cell];
        }
        
        // 收货地址信息
        EBuyOrderAddressCell *cell2 = [(EBuyOrderAddressCell*)[[[NSBundle mainBundle] loadNibNamed:@"EBuyOrderAddressCell" owner:self options:nil] objectAtIndex:0] retain];
        cell2.addrAddress.text = [iOSApi urlDecode:user.address];
        cell2.addrCode.text = [[NSNumber numberWithInt:user.areaCode] stringValue];
        cell2.addrName.text = [iOSApi urlDecode:user.receiver];
        cell2.addrPhone.text = [[NSNumber numberWithLongLong:user.mobile] stringValue];
        cell2.logicId.text = [iOSApi urlDecode:user.logicId];
        cell2.logicName.text = [iOSApi urlDecode:user.logicName];
        cell2.logicDate.text = [iOSApi urlDecode:user.logicDt];
        cell2.logicPhone.text = [iOSApi urlDecode:user.servicNo];
        cell2.backgroundColor = [UIColor lightGrayColor];
        [_items addObject:cell2];
        
        // 支付
        if (bPay) {
            UITableViewCell *cellPay = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            cellPay.frame = CGRectMake(0, 0, 320, 50);
            CGRect frame = CGRectMake(2, 2, 316, 46);
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [btn setTitle:[Api ebuy_pay_type:xType] forState:UIControlStateNormal];
            btn.frame = frame;
            [btn addTarget:self action:@selector(doPay:event:) forControlEvents:UIControlEventTouchUpInside];
            [cellPay addSubview:btn];
            cellPay.accessoryType = UITableViewCellAccessoryNone;
            [_items addObject:cellPay];
        }
    }
    //[_orderInfo release];
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (isEmpty) {
        return 1;
    }
    return [_items count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isEmpty) {
        return 357;
    }
    CGFloat height = 30;
	id obj = [_items objectAtIndex:indexPath.row];
    if ([obj isKindOfClass:UITableViewCell.class]) {
        UITableViewCell *cell =(UITableViewCell *)obj;
        height = cell.frame.size.height;
    }
	return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    int pos = [indexPath row];
    if (isEmpty && pos == 0) {
        cell.textLabel.text = @"没有相关记录";
        cell.textLabel.font = [UIFont systemFontOfSize:20.0];
        cell.textLabel.textAlignment = UITextAlignmentCenter;
    } else {
        UITableViewCell *obj = [_items objectAtIndex:pos];
        cell = obj;
        _tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
        cell.backgroundColor = obj.backgroundColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    int pos = indexPath.row;
    if (pos != 1 || _shopId < 1) {
        return;
    }
    // 跳转 商户产品列表 页面
    EBProductList *nextView = [[EBProductList alloc] init];
    nextView.way = 0;
    nextView.typeId = [NSString valueOf:_shopId];
    [self.navigationController pushViewController:nextView animated:YES];
    [nextView release];
}

- (void)doPay:(id)sender event:(id)event{
    [Api ebuy_alipay:_orderInfo];
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(handleTimer:) userInfo:nil repeats:YES];
}

- (void)handleTimer:(NSTimer *)theTimer{
    if (xState > -1) {
        bPay = NO;
        [_timer invalidate];
        _timer = nil;
        
        [self viewWillAppear:YES];
        [self.tableView reloadData];
    }
}

+ (void)changeState:(int)state{
    xState = state;
}
@end
