//
//  EBuyPortal.m
//  FengZi
//
//  Created by wangfeng on 12-3-5.
//  Copyright (c) 2012年 iTotemStudio. All rights reserved.
//

#import "EBuyPortal.h"
#import "Api+Ebuy.h"
#import "Api+UserCenter.h"
#import "EBAdBar.h"
#import "EBuyPanel.h"
#import "EBuyRecommend.h"
#import "EBExpressDetail.h"
#import "EBProductList.h"
#import "EBProductDetail.h"

@implementation EBuyPortal

@synthesize tableView = _tableView;
@synthesize searchBar = _searchBar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        isOnline = NO;
        _segIndex = -1;
        topIndex = 0;
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
    [Api seTabView:self];
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
    BOOL bFresh = NO;
    if (isOnline != [Api isOnLine]) {
        bFresh = YES;
    }
    isOnline = [Api isOnLine];
    topIndex = 0;
    // 广告视图, 登录不登录都是必须的
    EBAdBar *view = [(EBAdBar*)[[[NSBundle mainBundle] loadNibNamed:@"EBAdBar" owner:self options:nil] objectAtIndex:0] retain];
    [_headers addObject:view];
    // 判断是否登录
    if (isOnline) {
        // 登录, 显示功能面板
        EBuyPanel *buyPanel = [(EBuyPanel*)[[[NSBundle mainBundle] loadNibNamed:@"EBuyPanel" owner:self options:nil] objectAtIndex:0] retain];
        buyPanel.ownerId = self;
        buyPanel.name.text = [Api nikeName];
        // 加载照片
        NSString *photoName = [Api uc_photo_name:[Api userId]];
        if (![Api fileIsExists:photoName]) {
            // 如果照片不存在, 进行下载
            [Api uc_photo_down:[Api userId]];
        }
        UIImage *im = nil;
        if ([Api fileIsExists:photoName]) {
            NSString *filePath = [iOSFile path:[Api filePath:photoName]];
            im = [UIImage imageWithData:[NSData dataWithContentsOfFile:filePath]];
        }
        [buyPanel.photo loadImage:im];
        [_headers addObject:buyPanel];
        topIndex ++;
    }
    topIndex ++;
    // 未登录, 显示推荐自定义Cell
    topView = [(EBuyRecommend *)[[[NSBundle mainBundle] loadNibNamed:@"EBuyRecommend" owner:self options:nil] objectAtIndex:0] retain];
    topView.ownerId = self;
    [_headers addObject:topView];
    if ([_items count] == 0 || bFresh) {
        if (bFresh) {
            _segIndex = 0;
        }
        if (_items.count > 0) {
            [_items release];
        }
        // 预加载项
        _items = [[NSMutableArray alloc] initWithCapacity:0];
        _page = 1;
        NSArray *list = nil;
        if (!isOnline) {
            // 未登录, 下放列表是推荐产品
            list = [[Api ebuy_new:_page++] retain];
        } else {
#if 0
            // 登录后
            if (_segIndex == 0) {
                // 疯狂抢购:push接口
                list = [[Api ebuy_push:1] retain];
            } else {
                // 金牌店铺:shoplist接口
                list = [[Api ebuy_shoplist:1] retain];
            }
#endif
        }
        [_items addObjectsFromArray:list];
        [list release];
    }
    //[iOSApi showCompleted:@"加载完毕"];
    [iOSApi closeAlert];
    if(bFresh) {
        [_tableView reloadData];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //
}

// 登录后选择疯狂抢购或者金牌店铺
- (void)doSelect_old:(int)index{
    _segIndex = index;
    [_items removeAllObjects];
    NSArray *list = nil;
    if (_segIndex == 0) {
        // 疯狂抢购:push接口
        list = [[Api ebuy_push:1] retain];
    } else {
        // 金牌店铺:shoplist接口
        list = [[Api ebuy_shoplist:1] retain];
    }
    [_items addObjectsFromArray:list];
    [list release];
    [_tableView reloadData];
}

- (void)doSelect:(int)index{
    [iOSApi showAlert:@"正在加载信息..."];
    _segIndex = index;
    [EBuyRecommend setType:index];
    //topView = [(EBuyRecommend *)[[[NSBundle mainBundle] loadNibNamed:@"EBuyRecommend" owner:self options:nil] objectAtIndex:0] retain];
    //topView.ownerId = self;
    //[_headers replaceObjectAtIndex:topIndex withObject:topView];
    [topView awakeFromNib];
    topView.scrollView.contentOffset = CGPointMake(90, 180);
    [_tableView reloadData];
    [iOSApi closeAlert];
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
        pos -= _headers.count;
        id obj = [_items objectAtIndex:pos];
        NSString *title = @"没有商品或商铺信息";
        if ([obj isKindOfClass:EBExpressType.class]) {
            EBExpressType *info = (EBExpressType *)obj;
            title = [iOSApi urlDecode:[info title]];
        } else if ([obj isKindOfClass:EBShop.class]) {
            EBShop *info = (EBShop *)obj;
            title = [iOSApi urlDecode:info.name];
        } else if ([obj isKindOfClass:EBProductInfo.class]) {
            EBProductInfo *info = (EBProductInfo *)obj;
            title = [iOSApi urlDecode:info.title];
        }
        cell.textLabel.text = title;
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
    id obj = [_items objectAtIndex:pos];
    if ([obj isKindOfClass:EBExpressType.class]) {
        EBExpressType *info = (EBExpressType *)obj;
        EBExpressDetail *nextView = [[EBExpressDetail alloc] init];
        nextView.param = info;
        [self.navigationController pushViewController:nextView animated:YES];
        [nextView release];
    } else if ([obj isKindOfClass:EBShop.class]) {
        EBShop *info = (EBShop *)obj;
        EBProductList *nextView = [[EBProductList alloc] init];
        nextView.way = 0;
        nextView.typeId = [NSString valueOf:info.id];
        [self.navigationController pushViewController:nextView animated:YES];
        [nextView release];
    } else if ([obj isKindOfClass:EBProductInfo.class]) {
        EBProductInfo *info = (EBProductInfo *)obj;
        EBProductDetail *nextView = [[EBProductDetail alloc] init];
        nextView.param = info.id;
        [self.navigationController pushViewController:nextView animated:YES];
        [nextView release];
    }
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

@end
