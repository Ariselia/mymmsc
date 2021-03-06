//
//  RMRide.m
//  FengZi
//
//  Created by wangfeng on 12-4-15.
//  Copyright (c) 2012年 ifengzi.cn. All rights reserved.
//

#import "RMRide.h"
#import "RMRidePath.h"
#import "RMRideReal.h"
#import "RMRideGuest.h"
// 共享
#import "SHK.h"
#import "ShareView.h"
@interface RMRide ()

@end

@implementation RMRide
@synthesize maId, maUrl;
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

- (void)shareCode{
    [[SHK currentHelper] setRootViewController:self];
    SHKItem *item = [SHKItem text:@"我制做一个超炫的二维码，大家快来扫扫看！\n来自蜂子客户端"];
    item.image = [Api generateImageWithInput:maUrl];
    item.shareType = SHKShareTypeImage;
    item.title = @"我制做一个超炫的二维码，大家快来扫扫看！";
    SHKActionSheet *actionSheet = [SHKActionSheet actionSheetForItem:item];
    [actionSheet showInView:self.view];
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
    label.text= @"顺风车";
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
    
    UIButton *_btnRight = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnRight.frame = CGRectMake(0, 0, 60, 32);
    [_btnRight setImage:[UIImage imageNamed:@"share.png"] forState:UIControlStateNormal];
    [_btnRight setImage:[UIImage imageNamed:@"share_tap.png"] forState:UIControlStateHighlighted];
    [_btnRight addTarget:self action:@selector(shareCode) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:_btnRight];
    self.navigationItem.rightBarButtonItem = rightItem;
    [rightItem release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    _items = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [iOSApi showAlert:@"正在加载信息..."];
    _ride = [Api sfc_info:maId];
    if (_items == nil) {
        _items = [[NSMutableArray alloc] initWithCapacity:0];
    }
    if (_ride != nil) {
        RideReal *real = _ride.real;
        BOOL bC2P = NO;
        // 根据车龄字段大于0类判断页面类型
        if (real.drvage > 0) {
            bC2P = YES;
        }
        RMRidePath *cellView = [(RMRidePath *)[[[NSBundle mainBundle] loadNibNamed:@"RMRidePath" owner:self options:nil] objectAtIndex:0] retain];
        [_items addObject:cellView];
#if 0
        
        NSArray *drvList = _ride.drvList;
        NSArray *psgList = _ride.psgList;
        if (bC2P) {
            CGRect frame =  CGRectMake(0, 0, 320, 120);
            CGFloat lHeight = 50;
            CGFloat lWidth = 100;
            UILabel *label = nil;
            // 车找人
            UITableViewCell *cellView = [[UITableViewCell alloc] initWithFrame:frame];
            
            // 发车时间
            frame.origin.x = 0;
            frame.origin.y = 0;
            frame.size.width = 100;
            frame.size.height = 44;
            label = [[[UILabel alloc] initWithFrame:frame] autorelease];
            label.backgroundColor = [UIColor clearColor];
            //label.textAlignment = UITextAlignmentCenter;
            label.font = [UIFont fontWithName:@"黑体" size:44];
            label.textColor = [UIColor blackColor];
            label.text= @"发布时间：";
            [cellView.contentView addSubview:label];
            frame.origin.x += lWidth;
            frame.origin.y = 0;
            frame.size.width = 200;
            frame.size.height = 44;
            label = [[[UILabel alloc] initWithFrame:frame] autorelease];
            label.backgroundColor = [UIColor clearColor];
            //label.textAlignment = UITextAlignmentCenter;
            label.font = [UIFont fontWithName:@"黑体" size:44];
            label.textColor = [UIColor blackColor];
            label.text= @"7:30";
            [cellView.contentView addSubview:label];
            
            //NSString *destaddr;//目的地(encode)
            frame.origin.x = 0;
            frame.origin.y += lHeight;
            frame.size.width = 100;
            frame.size.height = 44;
            label = [[[UILabel alloc] initWithFrame:frame] autorelease];
            label.backgroundColor = [UIColor clearColor];
            //label.textAlignment = UITextAlignmentCenter;
            label.font = [UIFont fontWithName:@"黑体" size:44];
            label.textColor = [UIColor blackColor];
            label.text= @"发布时间：";
            [cellView.contentView addSubview:label];
            frame.origin.x += lWidth;
            frame.origin.y = 0;
            frame.size.width = 200;
            frame.size.height = 44;
            label = [[[UILabel alloc] initWithFrame:frame] autorelease];
            label.backgroundColor = [UIColor clearColor];
            //label.textAlignment = UITextAlignmentCenter;
            label.font = [UIFont fontWithName:@"黑体" size:44];
            label.textColor = [UIColor blackColor];
            label.text= @"7:30";
            [cellView.contentView addSubview:label];
            //NSString *drvpath;//驾驶路线(encode)
            //NSString *startaddr;//起始地址(encode)
            //int shour;//出发开始小时
            //int sminut;//出发开始分钟
            
        } else if (psgList != nil && psgList.count > 0) {
            // 人找车
        }
#endif
        if (real != nil) {
            if (bC2P) {
                // 车找人
                RMRideReal *cellView = [(RMRideReal *)[[[NSBundle mainBundle] loadNibNamed:@"RMRideReal" owner:self options:nil] objectAtIndex:0] retain];
                cellView.photo.image = [UIImage imageNamed:@"unknown.png"];
                [cellView.photo imageWithURL:[iOSApi urlDecode:real.headimg]];
                cellView.carPhoto.image = [UIImage imageNamed:@"unknown.png"];
                [cellView.carPhoto imageWithURL:[iOSApi urlDecode:real.carimg]];
                cellView.name.text = [iOSApi urlDecode:real.realname];
                cellView.sex.text = real.gender == 1 ? @"男" : @"女";
                cellView.jiLing.text = [NSString valueOf:real.drvage];
                cellView.carType.text = [NSString stringWithFormat:@"%@%@%@", [iOSApi urlDecode:real.carseries], [iOSApi urlDecode:real.cartype], [iOSApi urlDecode:real.carcolor]];
                cellView.carNumber.text = [iOSApi urlDecode:real.carplate];
                [_items addObject:cellView];
            } else {
                // 人找车
                RMRideGuest *cellView = [(RMRideGuest *)[[[NSBundle mainBundle] loadNibNamed:@"RMRideGuest" owner:self options:nil] objectAtIndex:0] retain];
                cellView.photo.image = [UIImage imageNamed:@"unknown.png"];
                [cellView.photo imageWithURL:[iOSApi urlDecode:real.headimg]];
                cellView.name.text = [iOSApi urlDecode:real.realname];
                cellView.sex.text = real.gender == 1 ? @"男" : @"女";
                [_items addObject:cellView];
            }
            
            UITableViewCell *cell = nil;
            NSString *s = nil;
            CGFloat h = 0.00f;
            CGRect frame;
#if 0
            // 顺风车历史
            s = [iOSApi urlDecode:real.his];
            h = [iOSApi heightForString:s width:300 fontSize:12];
            frame = CGRectMake(0, 0, 320, 50+h);
            // 车找人
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
            cell.frame = frame;
            cell.contentMode = UITableViewCellStyleSubtitle;
            cell.textLabel.text= @"顺风车经历：";
            cell.detailTextLabel.text = [iOSApi urlDecode:real.his];
            cell.detailTextLabel.lineBreakMode = 0;
            cell.backgroundColor = [UIColor grayColor];
            //UIImage *image = [UIImage imageWithNinePatch:@"sfc-block.png" size:frame.size];
            //UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
            //[cell.contentView addSubview:imageView];
            //imageView.frame = frame;
            //[imageView release];
            [_items addObject:cell];
#endif       
            // 顺风车 宣言
            s = [iOSApi urlDecode:real.decl];
            h = [iOSApi heightForString:s width:300 fontSize:12];
            frame = CGRectMake(0, 0, 320, 50+h);
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
            cell.frame = frame;
            cell.contentMode = UITableViewCellStyleSubtitle;
            cell.textLabel.text= @"顺风车宣言：";
            cell.detailTextLabel.text = s;
            cell.detailTextLabel.lineBreakMode = 0;
            cell.backgroundColor = [UIColor grayColor];
            //UIImage *image = [UIImage imageWithNinePatch:@"sfc-block.png" size:frame.size];
            //UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
            //[cell.contentView addSubview:imageView];
            //imageView.frame = frame;
            //[imageView release];
            [_items addObject:cell];
        }
    }
    
    [iOSApi closeAlert];
    [_tableView reloadData];
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int count = 0;
    if (maId != nil) {
        count = [_items count];
    }
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 50;
	//CGSize size = [@"123" sizeWithFont:fontInfo constrainedToSize:CGSizeMake(labelWidth, 20000) lineBreakMode:UILineBreakModeWordWrap];
	//return size.height + 10; // 10即消息上下的空间，可自由调整 
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
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    int pos = [indexPath row];
    UITableViewCell *obj = [_items objectAtIndex:pos];
    cell = obj;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    //NSLog(@"module goto...");
    int pos = indexPath.row;
    if (pos < 4) {
        return;
    }
    // 跳转 评论页面
    //EBuyComments *nextView = [[EBuyComments alloc] init];
    //nextView.param = param;
    //[self.navigationController pushViewController:nextView animated:YES];
    //[nextView release];
}

@end
