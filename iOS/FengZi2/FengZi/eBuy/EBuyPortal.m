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
#import "EBShopList.h"

@implementation EBuyPortal

@synthesize tableView = _tableView;
@synthesize searchBar = _searchBar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    backbtn.frame =CGRectMake(0, 0, 60, 32);
    
    [backbtn setImage:[UIImage imageNamed:@"as_nav_home.png"] forState:UIControlStateNormal];
    [backbtn setImage:[UIImage imageNamed:@"as_nav_home.png"] forState:UIControlStateHighlighted];
    [backbtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backitem = [[UIBarButtonItem alloc] initWithCustomView:backbtn];
    self.navigationItem.leftBarButtonItem = backitem;
    [backitem release];
        
    _borderStyle = UITextBorderStyleNone;
    font = [UIFont systemFontOfSize:13.0];
    if ([items count] == 0) {
        // 预加载项
        items = [[NSMutableArray alloc] initWithCapacity:0];
        _page = 1;
    }
    if (items != nil) {
        NSArray *list = [[Api ebuy_new:_page++] retain];
        [items addObjectsFromArray:list];
        [list release];
    }
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //return 0;
    return 1+[items count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 36;
	//CGSize size = [@"123" sizeWithFont:fontInfo constrainedToSize:CGSizeMake(labelWidth, 20000) lineBreakMode:UILineBreakModeWordWrap];
	//return size.height + 10; // 10即消息上下的空间，可自由调整 
    if (indexPath.row == 0) {
        height = 211.0f;
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
    if (pos >= [items count] + 1) {
        return nil;
    }
    if (pos == 0) {
        EBuyRecommend *topView = [(EBuyRecommend*)[[[NSBundle mainBundle] loadNibNamed:@"EBuyRecommend" owner:self options:nil] objectAtIndex:0] retain];
        topView.idInfo = self;
        //topView.scrollView.delegate = self;
        cell = topView;
    } else {
        EBExpressType *obj = [items objectAtIndex:(pos - 1)];
        cell.textLabel.text = [iOSApi urlDecode:[obj title]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    //NSLog(@"module goto...");
    int pos = indexPath.row;
    if (pos == 0) {
        return;
    }
    // 跳转 快讯详情页面
    pos -= 1;
    EBExpressType *obj = [items objectAtIndex:pos];
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
    EBShopList *nextView = [EBShopList new];
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
    if([searchText length]==0)
    {
        //如果无文字输入
        [self.searchBar resignFirstResponder];
        return; 
    } else {
        //
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

@end
