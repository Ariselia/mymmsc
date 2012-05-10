//
//  EBProductDetail.m
//  FengZi
//
//  Created by wangfeng on 12-3-22.
//  Copyright (c) 2012年 iTotemStudio. All rights reserved.
//

#import "EBProductDetail.h"
#import "EBProductIntro.h"
#import "EBuyComments.h"
#import "EBuyCar.h"

@interface EBProductDetail ()

@end

@implementation EBProductDetail

@synthesize param;
@synthesize proId, proPrice;
@synthesize tableView = _tableView;

#define kTagTitle (10001)

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _product = nil;
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
    label.text= @"商品详情";
    label.tag = kTagTitle;
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

- (void)viewWillAppear:(BOOL)animated {
    [iOSApi showAlert:@"正在读取信息..."];
    _product = [[Api ebuy_goodsinfo:param] retain];
    if (_product != nil) {
        _items = [[NSMutableArray alloc] initWithCapacity:0];
        UILabel *lable = (UILabel *)self.navigationItem.titleView;
        lable.text = [iOSApi urlDecode:_product.shopName];
    }
    [iOSApi closeAlert];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int count = 0;
    if (_product != nil) {
        count = 5;
        if ([Api isOnLine]) {
            // 如果登录了, 增加一行功能按钮.
            count = 6;
        }
    }
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 50;
	//CGSize size = [@"123" sizeWithFont:fontInfo constrainedToSize:CGSizeMake(labelWidth, 20000) lineBreakMode:UILineBreakModeWordWrap];
	//return size.height + 10; // 10即消息上下的空间，可自由调整 
    if (indexPath.row == 0) {
        height = 90.0f;
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
    int row3 = 0;
    if ([Api isOnLine]) {
        row3 = 1;
    }
    if (pos == 0) {
        NSArray *tmpList = [_product.picUrl componentsSeparatedByString:@"*"];
        UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(12, 0, 295, 90)];
        //scroll.backgroundColor = [UIColor grayColor];
        [cell.contentView addSubview:scroll];
        int xWidth = 95;
        int xHeight = 90;
        int num = tmpList.count;
        scroll.contentSize = CGSizeMake(xWidth * (num + 0) , xHeight);
        CGRect bounds = scroll.bounds;
        bounds.size.width = 95;
        //scroll.bounds = bounds;
        
        UIImage *undef = [UIImage imageNamed:@"unknown.png"];
        int i = 0;
        for (NSString *tmpUrl in tmpList) {
            tmpUrl = [tmpUrl trim];
            if (tmpUrl == nil || tmpUrl.length < 7) {
                break;
            }
            iOSImageView *iv = [[[iOSImageView alloc] initWithImage:undef] autorelease];
            [iv imageWithURL:[iOSApi urlDecode:tmpUrl]];
            CGRect frame = iv.frame;
            frame.origin.x = xWidth * i;
            frame.origin.y = 0;
            frame.size.height = 90;
            frame.size.width = 90;
            iv.frame = frame;
            [scroll addSubview:iv];
            i ++;
        }
        scroll.contentSize = CGSizeMake(xWidth * (i + 0) , xHeight);
        [scroll release];
    } else if (pos == 1) {
        cell.textLabel.text = [NSString stringWithFormat:@"商品名称：%@", [iOSApi urlDecode:_product.title]];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"价格：%.2f", _product.price];
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *image = [UIImage imageNamed:@"ebuy_shopping_info.png"];
        [btn setImage:image forState:UIControlStateNormal];
        [btn setImage:image forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(gotoProduct) forControlEvents:UIControlEventTouchUpInside];
        btn.frame = CGRectMake(250, 5, 44, 29);
        [cell.contentView addSubview:btn];
    } else if (pos == 2) {
        cell.textLabel.text = [NSString stringWithFormat:@"库存：%d 现货", _product.storeInfo];
    } else if (row3 > 0 && pos == 3) {
        CGRect frame = CGRectMake(15, 10, 90, 30);
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btn setTitle:@"放入购物车" forState:UIControlStateNormal];
        btn.frame = frame;
        [btn addTarget:self action:@selector(addShop) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:btn];
        
        btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        frame.origin.x += 100;
        [btn setTitle:@"立即购买" forState:UIControlStateNormal];
        btn.frame = frame;
        [btn addTarget:self action:@selector(goBuy) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:btn];
        
        btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        frame.origin.x += 100;
        [btn setTitle:@"添加收藏" forState:UIControlStateNormal];
        btn.frame = frame;
        [btn addTarget:self action:@selector(addShouCang) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:btn];
    } else if (pos == 3 + row3) {
        cell.textLabel.text = [NSString stringWithFormat:@"很喜欢(%d) 喜欢(%d) 不喜欢(%d)", _product.Goodcommentcount, _product.Middlecommentcount, _product.Poorcommentcount];
    } else if (pos == 4 + row3) {
        //cell.textLabel.text = [NSString stringWithFormat:@"评论(%d)", _product.Experiencecount];
        cell.textLabel.text = [NSString stringWithFormat:@"评论(%d)", _product.Goodcommentcount + _product.Middlecommentcount + _product.Poorcommentcount];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    //NSLog(@"module goto...");
    int pos = indexPath.row;
    int row3 = 0;
    if ([Api isOnLine]) {
        row3 = 1;
    }
    if (pos < 4 + row3) {
        return;
    }
    // 跳转 评论页面
    EBuyComments *nextView = [[EBuyComments alloc] init];
    nextView.param = param;
    [self.navigationController pushViewController:nextView animated:YES];
    [nextView release];
    
}

- (void)gotoProduct{
    EBProductIntro *nextView = [[EBProductIntro alloc] init];
    nextView.param = param;
    [self.navigationController pushViewController:nextView animated:YES];
    [nextView release];
}

// 加入购物车
- (void)addShop{
    BOOL bRet = [Api ebuy_car_add:_product];
    NSString *message = @"";
    if (bRet) {
        message = @"商品加入购物车完成";
    } else {
        message = @"商品加入购物车失败";
    }
    [iOSApi Alert:@"购物车 提示" message:message];
}

// 立即购买
- (void)goBuy{
    EBuyCar *nextView = [[EBuyCar alloc] init];
    [self.navigationController pushViewController:nextView animated:YES];
    [nextView release];
}

// 添加收藏
- (void)addShouCang{
    [iOSApi showAlert:@"添加收藏..."];
    ApiResult *iRet = [[Api ebuy_collect_add:_product.id] retain];
    [iOSApi showCompleted:iRet.message];
    [iRet release];
    [iOSApi closeAlert];
}

@end
