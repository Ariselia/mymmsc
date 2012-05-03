//
//  EBuyEvaluate.m
//  FengZi
//
//  Created by wangfeng on 12-4-23.
//  Copyright (c) 2012年 ifengzi.cn. All rights reserved.
//

#import "EBuyEvaluate.h"
#import "EBuyEvaluateCell.h"
#import "Api+Ebuy.h"
#import <iOSApi/iOSAsyncImageView.h>

@interface EBuyEvaluate ()

@end

@implementation EBuyEvaluate
@synthesize tableView = _tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.proxy = self;
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
    label.text= @"我的评价";
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

#define IMAGE_VIEW_TAG (9001)

- (UITableViewCell *)configure:(UITableViewCell *)cell withObject:(id)object {
    EBProductComment *obj = object;
    NSString *tmp = [iOSApi urlDecode:obj.picUrl];
    NSArray *arr = [tmp split:@"*"];
    EBuyEvaluateCell *cellView = [(EBuyEvaluateCell *)[[[NSBundle mainBundle] loadNibNamed:@"EBuyEvaluateCell" owner:self options:nil] objectAtIndex:0] retain];
    cellView.ownerId = self;
    cellView.productId = obj.id;
    cellView.orderId = obj.orderId;
    cellView.content.text = [iOSApi urlDecode:obj.content];
    [cellView.imageView imageWithURL:[arr objectAtIndex:0]];
    cellView.selectionStyle = UITableViewCellSelectionStyleNone;
    return cellView;
}

- (NSArray *)reloadData:(iOSTableViewController *)tableView {
    [iOSApi showAlert:@"获取评论列表..."];
    NSArray *data = [Api ebuy_sdandcomentlist:_page];
    if (data == nil || data.count < 1) {
        [iOSApi showCompleted:@"没有评论信息"];
    }
    [iOSApi closeAlert];
    return data;
}

- (NSArray *)arrayOfHeader:(iOSTableViewController *)tableView {
    return nil;
}

- (NSArray *)arrayOfFooter:(iOSTableViewController *)tableView {
    NSArray *list = [Api ebuy_sdandcomentlist:_page + 1];
    if (list.count > 0) {
        _page += 1;
    }
    return list;
}

@end
