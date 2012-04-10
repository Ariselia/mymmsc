//
//  EBMessageList.m
//  FengZi
//
//  Created by wangfeng on 12-4-10.
//  Copyright (c) 2012年 ifengzi.cn. All rights reserved.
//

#import "EBMessageList.h"
#import "Api+Ebuy.h"

@interface EBMessageList ()

@end

@implementation EBMessageList
@synthesize tableView = _tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    label.text= @"商铺查询结果";
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
        //NSArray *list = [[Api ebuy_push:_page++] retain];
        NSArray *list = [[Api ebuy_search:param] retain];
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
    CGFloat height = 60.f;
	return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    int pos = [indexPath row];
    EBSiteMessage *obj = [_items objectAtIndex:pos];
    
    cell.textLabel.text = [iOSApi urlDecode:obj.title];
    NSString *tmpPrice = [NSString stringWithFormat:@"¥ %.02f", obj.price];
    if (obj.price < 0.01) {
        tmpPrice = @"免费";
    }
    cellView.price.text = tmpPrice;
    cellView.desc.text = [NSString stringWithFormat:@"商品简介: %@", [iOSApi urlDecode:obj.content]];
    cell = cellView;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellAccessoryDetailDisclosureButton;
    //return UITableViewCellAccessoryDisclosureIndicator;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    EBProductInfo *obj = [items objectAtIndex:indexPath.row];
    EBProductDetail *nextView = [[EBProductDetail alloc] init];
    nextView.param = obj;
    [self.navigationController pushViewController:nextView animated:YES];
    [nextView release];
}

@end
