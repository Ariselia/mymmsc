//
//  EBuyEditAddress.m
//  FengZi
//
//  Created by wangfeng on 12-4-23.
//  Copyright (c) 2012年 ifengzi.cn. All rights reserved.
//

#import "EBuyEditAddress.h"
#import "EBuyAddress.h"
#import "Api+Ebuy.h"

@interface EBuyEditAddress ()

@end

@implementation EBuyEditAddress
@synthesize tableView = _tableView;
@synthesize shopName;
@synthesize param;

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
    label.text= @"收货地址";
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
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewWillAppear:(BOOL)animated{
    NSArray *data = [Api ebuy_address_list];
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
    return [_items count] + 1;
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
    
    if (pos == _items.count) {
        // 下面配文字
        cell.textLabel.text = @"新增收货地址";
        cell.textLabel.font = [UIFont systemFontOfSize:30.0];
        cell.textLabel.lineBreakMode = UILineBreakModeTailTruncation;
        cell.textLabel.numberOfLines = 0;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        // 下面加按钮
        return cell;
    } else if (pos == _items.count + 1) {
        // 表格下方 三个按钮
        if (!isEmpty) {
            CGRect frame = CGRectMake(180, 50, 100, 20);
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [btn setTitle:@"确认购买" forState:UIControlStateNormal];
            btn.frame = frame;
            [btn addTarget:self action:@selector(doClear:event:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:btn];
        }
        return cell;
    } else {
        EBAddress *obj = [_items objectAtIndex:pos];
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        cell.textLabel.textColor = [UIColor grayColor];
        cell.textLabel.highlightedTextColor = [UIColor blackColor];
        cell.textLabel.font = [UIFont systemFontOfSize:15.0];
        cell.textLabel.text = [iOSApi urlDecode:obj.dizhi];
    }
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

@end
