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
@synthesize pClass, subject;

#define kTAG_BASE (10000)
#define kTAG_STAR (kTAG_BASE + 1)

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
    label.text= @"商品列表";
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
    if (_items != nil) {
        
        NSArray *list = [[Api ebuy_goodslist:_page way:way typeId:typeId] retain];
        [_items addObjectsFromArray:list];
        [list release];
        if (_items.count > 0) {
            EBProductInfo *obj = [_items objectAtIndex:0];
            subject.text = [iOSApi urlDecode:obj.title];
            [self setStarClass:3];
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
    if (obj.price < 0.01) {
        tmpPrice = @"免费";
    }
    cellView.price.text = tmpPrice;
    cellView.desc.text = [NSString stringWithFormat:@"商品简介: %@", [iOSApi urlDecode:obj.content]];
    cell = cellView;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellAccessoryDetailDisclosureButton;
    //return UITableViewCellAccessoryDisclosureIndicator;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    EBProductInfo *obj = [_items objectAtIndex:indexPath.row];
    EBProductDetail *nextView = [[EBProductDetail alloc] init];
    nextView.param = obj;
    [self.navigationController pushViewController:nextView animated:YES];
    [nextView release];
}

@end
