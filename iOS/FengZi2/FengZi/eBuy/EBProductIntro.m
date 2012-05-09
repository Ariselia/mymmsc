//
//  EBProductIntro.m
//  FengZi
//
//  Created by wangfeng on 12-4-8.
//  Copyright (c) 2012年 iTotemStudio. All rights reserved.
//

#import "EBProductIntro.h"

@interface EBProductIntro ()

@end

@implementation EBProductIntro

@synthesize param;
@synthesize proId, proPrice;
@synthesize tableView = _tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    _product = nil;
    _product = [[Api ebuy_goodsinfo:param] retain];
    if (_product != nil) {
        _items = [[NSMutableArray alloc] initWithCapacity:0];
        [_items addObject:[iOSApi urlDecode:_product.info]];
        proId.text = [NSString stringWithFormat:@"编号: %@", _product.orderId];
        proPrice.text = [NSString stringWithFormat:@"%.2f 元", _product.price];
    }
    [iOSApi closeAlert];
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //return 2;
    return [_items count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 36;
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
    if (pos >= [_items count]) {
        return nil;
    }
    cell.textLabel.text = [_items objectAtIndex:pos];
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

- (IBAction)optionAction:(UISegmentedControl *)segment{
    if (_items != nil) {
        [_items removeAllObjects];
        NSInteger Index = segment.selectedSegmentIndex;
        NSString *content = @"";
        switch (Index) {
            case 0: // 商品介绍
                content = [NSString stringWithString:[iOSApi urlDecode:_product.info]];
                break;
            case 1: // 规格参数
                content = [iOSApi urlDecode:_product.parameters];
                break;
            case 2: // 包装清单
                content = [NSString stringWithString:[iOSApi urlDecode:_product.listInfo]];
                break;
            default: // 售后服务
            {
                NSString *s = [iOSApi urlDecode:_product.service];
                content = [NSString stringWithString:s];
            }
                break;
        }
        [_items addObject:content];
        [_tableView reloadData];
    }
}

@end
