//
//  EBuyPortal.m
//  FengZi
//
//  Created by wangfeng on 12-3-5.
//  Copyright (c) 2012年 iTotemStudio. All rights reserved.
//

#import "EBuyPortal.h"
#import "Api+Ebuy.h"
#import "EBuyRecommend.h"
#import "EBExpressDetail.h"
#import "EBProductList.h"
#import "EBAdBar.h"
#import "EBuyPanel.h"

@implementation EBuyPortal

@synthesize tableView = _tableView;
@synthesize searchBar = _searchBar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        isOnline = NO;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

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
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)hiddenKetboard{
    [self.searchBar resignFirstResponder];
}

- (void)goBack{
    [self dismissModalViewControllerAnimated:YES];
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
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(110, 0, 210, 60)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = UITextAlignmentCenter;
    label.font = [UIFont fontWithName:@"黑体" size:44];
    label.textColor = [UIColor blackColor];
    label.text= @"电子商城";
    self.navigationItem.titleView = label;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = label.frame;
    [btn addTarget:self action:@selector(hiddenKetboard) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.view addSubview:btn];
    [label release];
    
    
    UIButton *backbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backbtn.frame = CGRectMake(0, 0, 60, 32);
    
    [backbtn setImage:[UIImage imageNamed:@"as_nav_home.png"] forState:UIControlStateNormal];
    [backbtn setImage:[UIImage imageNamed:@"as_nav_home.png"] forState:UIControlStateHighlighted];
    [backbtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backitem = [[UIBarButtonItem alloc] initWithCustomView:backbtn];
    self.navigationItem.leftBarButtonItem = backitem;
    [backitem release];
        
    _borderStyle = UITextBorderStyleNone;
    _font = [UIFont systemFontOfSize:13.0];
    
    _borderStyle = UITextBorderStyleNone;
    _font = [UIFont systemFontOfSize:13.0];
    [iOSApi showAlert:@"正在加载信息..."];
    // 列表头部
    if (_headers.count == 0) {
        _headers = [[NSMutableArray alloc] initWithCapacity:0];
    } else {
        [_headers removeAllObjects];
    }
    isOnline = [Api isOnLine];
    // 广告视图
    EBAdBar *view = [(EBAdBar*)[[[NSBundle mainBundle] loadNibNamed:@"EBAdBar" owner:self options:nil] objectAtIndex:0] retain];
    [_headers addObject:view];
    EBuyRecommend *topView = [(EBuyRecommend*)[[[NSBundle mainBundle] loadNibNamed:@"EBuyRecommend" owner:self options:nil] objectAtIndex:0] retain];
    topView.ownerId = self;
    [_headers addObject:topView];
    // 判断是否登录
    if (isOnline) {
        // 登录
    } else {
        // 未登录
    }
    if ([_items count] == 0) {
        // 预加载项
        _items = [[NSMutableArray alloc] initWithCapacity:0];
        _page = 1;
        NSArray *list = [[Api ebuy_new:_page++] retain];
        [_items addObjectsFromArray:list];
        [list release];
    }
    //[iOSApi showCompleted:@"加载完毕"];
    [iOSApi closeAlert];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //return 0;
    return [_headers count]+[_items count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 36;
	
    if (indexPath.row < _headers.count) {
        UITableViewCell *cell = [_headers objectAtIndex:indexPath.row];
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
    if (pos >= _headers.count + _items.count) {
        return nil;
    }
    if (pos < _headers.count) {
        cell = [_headers objectAtIndex:pos];
    } else {
        EBExpressType *obj = [_items objectAtIndex:(pos - _headers.count)];
        cell.textLabel.text = [iOSApi urlDecode:[obj title]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //NSLog(@"module goto...");
    int pos = indexPath.row;
    if (pos < _headers.count) {
        return;
    }
    // 跳转 快讯详情页面
    pos -= _headers.count;
    EBExpressType *obj = [_items objectAtIndex:pos];
    EBExpressDetail *nextView = [[EBExpressDetail alloc] init];
    nextView.param = obj;
    [self.navigationController pushViewController:nextView animated:YES];
    [nextView release];
}

#pragma mark -
#pragma mark UISearchBar

-(void)handleSearchForTerm:(NSString *)searchTerm
{
    //能过待删除的key数组删除数组
    EBProductList *nextView = [EBProductList new];
    nextView.param = searchTerm;
    [self.navigationController pushViewController:nextView animated:YES];
    [nextView release];
    //[_tableView reloadData];
    //重载数据    
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    //按软键盘右下角的搜索按钮时触发
    NSString *searchTerm = [searchBar text];
    //读取被输入的关键字
    [self handleSearchForTerm:searchTerm];
    //根据关键字，进行处理
    [searchBar resignFirstResponder];
    //隐藏软键盘
}

// 搜索条输入文字修改时触发
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if([searchText length] == 0) {
        //如果无文字输入
        [self.searchBar resignFirstResponder];
        self.searchBar.showsCancelButton = NO;
        return; 
    } else {
        self.searchBar.showsCancelButton = YES;
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    //取消按钮被按下时触发
    //[self resetSearch];
    //重置
    searchBar.text = @"";
    //输入框清空
    [_tableView reloadData];
    [searchBar resignFirstResponder];
    //重新载入数据，隐藏软键盘
}

// 界面下方列表切换
- (void)doSwitch:(int)index{
    //
}

@end
