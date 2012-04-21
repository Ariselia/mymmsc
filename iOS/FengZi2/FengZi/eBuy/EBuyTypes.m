//
//  EBuyTypes.m
//  FengZi
//
//  Created by wangfeng on 12-4-20.
//  Copyright (c) 2012年 ifengzi.cn. All rights reserved.
//

#import "EBuyTypes.h"
#import "Api+Ebuy.h"
#import "EBProductList.h"

@interface EBuyTypes ()

@end

@implementation EBuyTypes
@synthesize tableView = _tableView;
@synthesize subject, frontId, typeId;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.proxy = self;
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
    _curSubject = subject != nil? subject:@"全部分类";
    label.text= _curSubject;
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
}

#pragma mark -
#pragma mark UITableViewDataSource

- (BOOL)configure:(UITableViewCell *)cell withObject:(id)object {
    EBProductType *obj = object;
    // 设置字体
    UIFont *textFont = [UIFont systemFontOfSize:17.0];
    //UIFont *detailFont = [UIFont systemFontOfSize:12.0];
    //int imageHeight = 36;
    
    //[cell.imageView setImage:ai.image];
    
    cell.textLabel.text = [iOSApi urlDecode:obj.typeName];
    cell.textLabel.font = textFont;
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return YES;
}

- (void)tableView:(UITableViewCell *)cell onCustomAccessoryTapped:(id)object {
    EBProductType *obj = object;
    if (obj.child > 0) {
        // 有子分类
        EBuyTypes *nextView = [[EBuyTypes alloc] init];
        nextView.frontId = typeId;
        nextView.typeId = obj.typeId;
        nextView.subject = [NSString stringWithFormat:@"%@>>%@",_curSubject, obj.typeName];
        [self.navigationController pushViewController:nextView animated:YES];
        [nextView release];
    } else {
        // 无子分类, 跳转产品
        EBProductList *nextView = [[EBProductList alloc] init];
        nextView.way = 1;
        nextView.typeId = obj.typeId;
        [self.navigationController pushViewController:nextView animated:YES];
        [nextView release];
    }
}

- (NSArray *)reloadData:(iOSTableViewController *)tableView {
    [iOSApi showAlert:@"正在获取商品信息"];
    NSArray *data = [Api ebuy_type:_page typeId:typeId];
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
    NSArray *list = [Api ebuy_type:_page + 1 typeId:typeId];
    if (list.count > 0) {
        _page += 1;
    }
    return list;
}

@end
