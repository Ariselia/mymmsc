//
//  EBuyCollect.m
//  FengZi
//
//  Created by wangfeng on 12-4-22.
//  Copyright (c) 2012年 ifengzi.cn. All rights reserved.
//

#import "EBuyCollect.h"
#import "EBProductDetail.h"
#import "Api+Ebuy.h"
#import <iOSApi/iOSAsyncImageView.h>

@interface EBuyCollect ()

@end

@implementation EBuyCollect
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
    label.text= @"我的收藏";
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

- (UITableViewCell *)configure:(UITableViewCell *)cell withObject:(id)object {
    EBProductInfo *obj = object;
    // 设置字体
    UIFont *textFont = [UIFont systemFontOfSize:17.0];
    UIFont *detailFont = [UIFont systemFontOfSize:12.0];
    cell.imageView.frame = CGRectMake(0, 0, 50, 50);
    iOSAsyncImageView *ai = nil; //[info aimage];
    if (ai == nil)
    {
        // 默认图片
        cell.imageView.image = [[UIImage imageNamed:@"unknown.png"] toSize:CGSizeMake(50, 50)];
        ai = [[[iOSAsyncImageView alloc] initWithFrame:cell.imageView.frame] autorelease];
        //ai.tag = tagImage;
        //NSString *tmpUrl;
        
        NSURL *url = [NSURL URLWithString: [iOSApi urlDecode:obj.picUrl]];
        [ai loadImageFromURL:url];
    }
    [cell.imageView addSubview:ai];
    //cell.imageView.image = [[UIImage imageNamed:@"unknown.png"] toSize:CGSizeMake(50, 50)];
    //[cell.imageView imageWithURL:[iOSApi urlDecode:obj.picUrl]];
    
    cell.textLabel.text = [iOSApi urlDecode:obj.title];
    cell.textLabel.font = textFont;
    NSString *tmpPrice = [NSString stringWithFormat:@"¥ %.02f", obj.price];
    if (obj.price < 0.01) {
        tmpPrice = @"免费";
    }
    cell.detailTextLabel.text = [iOSApi urlDecode:obj.content];
    cell.detailTextLabel.font = detailFont;
    
    CGRect frame = CGRectMake(230, 10, 60, 20);
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn setTitle:@"删除" forState:UIControlStateNormal];
    btn.frame = frame;
    [btn addTarget:self action:@selector(doDelete:event:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:btn];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableViewCell *)cell onCustomAccessoryTapped:(id)object {
    EBProductInfo *obj = object;
    EBProductDetail *nextView = [[EBProductDetail alloc] init];
    nextView.param = obj.id;
    [self.navigationController pushViewController:nextView animated:YES];
    [nextView release];
}

// 按钮点击事件
static int iTimes = -1;
static EBProductInfo *theObj = nil;

- (void)doDelete:(id)sender event:(id)event {
    iTimes = 0;
    theObj = [self objectForEvent:event];
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"提示"
                          message: @"确定删除这条收藏?"
                          delegate:self
                          cancelButtonTitle:@"取消"
                          otherButtonTitles:@"确定", nil];
    [alert show];
    [alert release];        
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger) buttonIndex {
    if (iTimes == 0) {
		switch (buttonIndex) {
			case 1: // 删除
                [Api ebuy_collect_delete:theObj.id];
                [super reloadData];
				break;
			default: // 取消
                theObj = nil;
				break;
		}
	} else if (iTimes == 1) {
        //
	}
}

- (NSArray *)reloadData:(iOSTableViewController *)tableView {
    [iOSApi showAlert:@"正在获取商品信息"];
    NSArray *data = [Api ebuy_collect:_page];
    if (data == nil || data.count < 1) {
        [iOSApi showCompleted:@"没有收藏的产品～～"];
    }
    [iOSApi closeAlert];
    return data;
}

- (NSArray *)arrayOfHeader:(iOSTableViewController *)tableView {
    return nil;
}

- (NSArray *)arrayOfFooter:(iOSTableViewController *)tableView {
    NSArray *list = [Api ebuy_collect:_page + 1];
    if (list.count > 0) {
        _page += 1;
    }
    return list;
}

@end
