//
//  EBProductList.m
//  FengZi
//
//  Created by wangfeng on 12-4-11.
//  Copyright (c) 2012年 ifengzi.cn. All rights reserved.
//

#import "EBProductList.h"
#import "EBShopInfo.h"
#import "EBProductDetail.h"
#import <iOSApi/iOSStar.h>
#import <iOSApi/UIImageView+Utils.h>

@interface EBProductList ()

@end

@implementation EBProductList
@synthesize tableView=_tableView;
@synthesize way, typeId;
@synthesize pClass, subject, btnWrite;
@synthesize param;

#define kTAG_BASE (10000)
#define kTAG_STAR (kTAG_BASE + 1)
#define ALERT_TITLE @"系统 提示"

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //self.proxy = self;
        _page = 0;
        way = 0;
    }
    return self;
}

- (IBAction)doWriteMsg:(id)sender{
    UIAlertView *alert = [[UIAlertView alloc]
						  initWithTitle: [NSString stringWithFormat:@"对\"%@\"说点什么吧", shopName]
						  message:[NSString stringWithFormat:@"\n\n"]
						  delegate:self
						  cancelButtonTitle:@"取消"
						  otherButtonTitles:@"发表", nil];
    content = [[UITextField alloc] initWithFrame:CGRectMake(12, 60, 260, 25)];
	[content setTag:1001];
	CGAffineTransform mytrans = CGAffineTransformMakeTranslation(-0, -150);
	[alert setTransform:mytrans];
	[content setBackgroundColor:[UIColor whiteColor]];
	[alert addSubview:content];
	[alert show];
	[alert release];
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
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100,44)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = UITextAlignmentCenter;
    label.font = [UIFont fontWithName:@"黑体" size:60];
    label.textColor = [UIColor blackColor];
    label.text= @"商品列表";
    self.navigationItem.titleView = label;
    [label release];
    
    UIButton *btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    btnLeft.frame = CGRectMake(0, 0, 60, 32);
    
    [btnLeft setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [btnLeft setImage:[UIImage imageNamed:@"back_tap.png"] forState:UIControlStateHighlighted];
    [btnLeft addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *itemLeft = [[UIBarButtonItem alloc] initWithCustomView:btnLeft];
    self.navigationItem.leftBarButtonItem = itemLeft;
    [itemLeft release];
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

- (void)setStarClass:(int)n {
    UIView *view = [self.view viewWithTag:kTAG_STAR];
    if (view != nil) {
        [view removeFromSuperview];
    }
    iOSStar *star2 = [[iOSStar alloc] initWithFrame:CGRectMake(60.0f, 23.0f, 150.0f, 21.0f)];
    star2.show_star = 20 * n;
    star2.font_size = 17;
    star2.empty_color = [UIColor whiteColor];
    star2.full_color = [UIColor orangeColor];
    star2.tag = kTAG_STAR;
    [self.view addSubview:star2];
    [star2 release];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Bug #519, 如果找到商户商品列表, 在导航条右侧增加一个按钮 [WangFeng fixed at 2012/05/16 06:48]
    if (param == nil) {
        /*
        UIImage *tmpImg = [[UIImage imageNamed:@"nav-at.png"] toSize:CGSizeMake(32, 32)];
        UIButton *btnRight = [UIButton buttonWithType:UIButtonTypeCustom];
        btnRight.frame = CGRectMake(0, 0, 60, 32);
        [btnRight setImage:tmpImg forState:UIControlStateNormal];
        [btnRight setImage:tmpImg forState:UIControlStateHighlighted];
        [btnRight addTarget:self action:@selector(doWriteMsg:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *itemRight = [[UIBarButtonItem alloc] initWithCustomView:btnRight];
        self.navigationItem.rightBarButtonItem = itemRight;
        [itemRight release];
        */
        btnWrite.hidden = NO;
    }
    _borderStyle = UITextBorderStyleNone;
    //font = [UIFont systemFontOfSize:13.0];
    if ([_items count] == 0) {
        // 预加载项
        _items = [[NSMutableArray alloc] initWithCapacity:0];
        _page = 1;
    }
    if (_items != nil) {
        NSArray *list = nil;
        if (param != nil) {
            list = [[Api ebuy_search:param] retain];
        } else { 
            list = [[Api ebuy_goodslist:_page way:way typeId:typeId] retain];
        }
        [_items addObjectsFromArray:list];
        [list release];
        if (_items.count > 0) {
            NSString *tmpTitle = param;
            if (tmpTitle == nil) {
                EBProductInfo *obj = [_items objectAtIndex:0];
                tmpTitle = [iOSApi urlDecode:obj.shopName];
            }
            subject.text = tmpTitle;
            //[self setStarClass:3];
            shopName = subject.text;
        }
    }
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //return 0;
    return [_items count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 96.f;
	return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    int pos = [indexPath row];
    EBProductInfo *obj = [_items objectAtIndex:pos];
    CGRect frame = cell.frame;
    frame.size.width = 290;
    frame.size.height = 96;
    EBShopInfo *cellView = [(EBShopInfo *)[[[NSBundle mainBundle] loadNibNamed:@"EBShopInfo" owner:self options:nil] objectAtIndex:0] retain];
    cell.frame = frame;
    [cellView.pic imageWithURL:[iOSApi urlDecode:obj.picUrl]];
    cellView.subject.text = [iOSApi urlDecode:obj.title];
    NSString *tmpPrice = [NSString stringWithFormat:@"¥ %.02f", obj.price];
    if (obj.price < 0.00001) {
        tmpPrice = @"免费";
    }
    cellView.price.text = tmpPrice;
    cellView.desc.text = [NSString stringWithFormat:@"商品简介: %@", [iOSApi urlDecode:obj.content]];
    cell = cellView;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    return cell;
}
/*
- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellAccessoryDetailDisclosureButton;
}
*/
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    EBProductInfo *obj = [_items objectAtIndex:indexPath.row];
    EBProductDetail *nextView = [[EBProductDetail alloc] init];
    nextView.param = obj.id;
    [self.navigationController pushViewController:nextView animated:YES];
    [nextView release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger) buttonIndex{
    if (buttonIndex == 1) {
        NSString *msg = [content.text trim];
        if (msg.length < 1) {
            [iOSApi Alert:ALERT_TITLE message:@"内容不能为空"];
            return;
        } else {
            EBProductInfo *obj = [_items objectAtIndex:0];
            NSString *recvId = [NSString valueOf:obj.shopId];
            ApiResult *iRet = [[Api ebuy_message_new:recvId baseId:recvId content:msg ] retain];
            [iOSApi Alert:ALERT_TITLE message:iRet.message];
            [iRet release];
        }
    }
}

@end
