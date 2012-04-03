//
//  UCMyComments.m
//  FengZi
//
//  Created by wangfeng on 12-3-31.
//  Copyright (c) 2012年 iTotemStudio. All rights reserved.
//

#import "UCMyComments.h"
#import "Api+UserCenter.h"
#import "UCUpdateNikename.h"

@interface UCMyComments ()

@end

@implementation UCMyComments
@synthesize tableView = _tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.proxy = self;
        _page = 0;
        _size = 8;
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
    // Do any additional setup after loading the view from its nib.
    UIImage *image = [UIImage imageNamed:@"navigation_bg.png"];
    Class ios5Class = (NSClassFromString(@"CIImage"));
    if (nil != ios5Class) {
        [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    } else {
        self.navigationController.navigationBar.layer.contents = (id)[UIImage imageNamed:@"navigation_bg.png"].CGImage;
    }
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(110, 0, 140, 44)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = UITextAlignmentCenter;
    label.font = [UIFont fontWithName:@"黑体" size:60];
    label.textColor = [UIColor blackColor];
    label.text= @"蜂巢留言板";
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
    
    /*
    UIButton *_btnRight = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnRight.frame = CGRectMake(0, 0, 60, 32);
    [_btnRight setImage:[UIImage imageNamed:@"uc-save.png"] forState:UIControlStateNormal];
    [_btnRight setImage:[UIImage imageNamed:@"uc-save.png"] forState:UIControlStateHighlighted];
    [_btnRight addTarget:self action:@selector(doSave) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:_btnRight];
    self.navigationItem.rightBarButtonItem = rightItem;
    [rightItem release];
     */
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
    if ([_items count] == 0) {
        // 预加载项
        _items = [[NSMutableArray alloc] initWithCapacity:0];
    }
    //[iOSApi showAlert:@"正在获取用户信息..."];
    //[iOSApi closeAlert];
}

- (BOOL)configure:(UITableViewCell *)cell withObject:(id)object {
    ucComment *obj = object;
    // 设置字体
    UIFont *textFont = [UIFont systemFontOfSize:15.0];
    UIFont *detailFont = [UIFont systemFontOfSize:10.0];
    //cell.imageView.image = [[iOSApi imageNamed:[Api typeIcon:obj.type]] scaleToSize:CGSizeMake(36, 36)];
    //cell.textLabel.text = [NSString stringWithFormat:@"%@ 的评论", obj.username];
    cell.textLabel.text = obj.commentName;
    cell.textLabel.font = textFont;
    
    UILabel *dt = [[UILabel alloc] initWithFrame:CGRectMake(170, 0, 105, 20)];
    dt.font = detailFont;
    dt.text = obj.commentDate;
    dt.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:dt];
    [dt release];
    cell.detailTextLabel.text = obj.commentContent;
    cell.detailTextLabel.font = detailFont;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    // 突出效果
    UIView *effectView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    effectView.backgroundColor = [UIColor whiteColor]; // 把背景設成白色
    //effectView.backgroundColor = [UIColor clearColor]; // 透明背景
    
    effectView.layer.cornerRadius = 4.0f; // 圓角的弧度
    effectView.layer.masksToBounds = NO;
    
    effectView.layer.shadowColor = [[UIColor blackColor] CGColor];
    effectView.layer.shadowOffset = CGSizeMake(1.0f, 1.0f); // [水平偏移, 垂直偏移]
    effectView.layer.shadowOpacity = 0.5f; // 0.0 ~ 1.0 的值
    effectView.layer.shadowRadius = 1.0f; // 陰影發散的程度
    
    effectView.layer.borderWidth = 2.0;
    effectView.layer.borderColor = [[UIColor lightTextColor] CGColor];
    
    /*CAGradientLayer *gradient = [CAGradientLayer layer];
     gradient.frame = sampleView.bounds;
     gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor whiteColor] CGColor], (id)[[UIColor grayColor] CGColor], nil]; // 由上到下的漸層顏色
     [effectView.layer insertSublayer:gradient atIndex:0];
     */
    [cell setBackgroundView:effectView];
    return YES;
}

- (NSArray *)reloadData:(iOSTableViewController *)tableView {
    NSArray *list = [Api uc_comments_get:_page size:_size];
    return list;
}

- (NSArray *)arrayOfHeader:(iOSTableViewController *)tableView {
    return nil;
}

- (NSArray *)arrayOfFooter:(iOSTableViewController *)tableView {
    NSArray *list = [Api uc_comments_get:_page + 1 size:_size];
    if (list.count > 0) {
        _page += 1;
    }
    return list;
}


- (void)tableView:(UITableViewCell *)cell onCustomAccessoryTapped:(id)object {
    ucComment *obj = object;
    UCUpdateNikename *nextView = [[UCUpdateNikename alloc] init];
    nextView.idDest = obj.commentUserId;
    [self.navigationController pushViewController:nextView animated:YES];
    [nextView release];
}

@end
