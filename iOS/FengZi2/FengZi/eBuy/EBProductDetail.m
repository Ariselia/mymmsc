//
//  EBProductDetail.m
//  FengZi
//
//  Created by wangfeng on 12-3-22.
//  Copyright (c) 2012年 iTotemStudio. All rights reserved.
//

#import "EBProductDetail.h"

@interface EBProductDetail ()

@end

@implementation EBProductDetail

@synthesize param;
@synthesize proId, proPrice;
@synthesize tableView = _tableView;

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
    EBProductInfo *tmp = [[Api ebuy_goodsinfo:param.id] retain];
    if (tmp != nil) {
        _product = tmp;
        [tmp release];
    }
    if (_product != nil) {
        _items = [[NSMutableArray alloc] initWithCapacity:0];
    }
    [iOSApi closeAlert];
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
    //return [_items count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 50;
	//CGSize size = [@"123" sizeWithFont:fontInfo constrainedToSize:CGSizeMake(labelWidth, 20000) lineBreakMode:UILineBreakModeWordWrap];
	//return size.height + 10; // 10即消息上下的空间，可自由调整 
    if (indexPath.row == 0) {
        //height = 180.0f;
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
    /*
    if (pos >= [_items count] + 1) {
        return nil;
    }*/
    if (pos == 0) {
        cell.textLabel.text = [NSString stringWithFormat:@"商品名称：%@",  _product.title];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"价格：%.2f", _product.price];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *image = [UIImage imageNamed:@"ebug_commodity_info.png"];
        [btn setImage:image forState:UIControlStateNormal];
        [btn setImage:image forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(gotoProduct) forControlEvents:UIControlEventTouchUpInside];
    } else if (pos == 1) {
        cell.textLabel.text = [NSString stringWithFormat:@"库存：%d 现货", _product.storeInfo];
    } else if (pos == 2) {
        cell.textLabel.text = [NSString stringWithFormat:@"很喜欢(%d) 喜欢(%d) 不喜欢(%d)", _product.Goodcommentcount, _product.Middlecommentcount, _product.Poorcommentcount];
    } else if (pos == 3) {
        cell.textLabel.text = [NSString stringWithFormat:@"评论(%d)", _product.Experiencecount];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    //NSLog(@"module goto...");
    int pos = indexPath.row;
    if (pos == 0) {
        return;
    }
    // 跳转 快讯详情页面
    pos -= 1;
    
}

- (void)gotoProduct{
    
}

@end
