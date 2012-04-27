//
//  UCStoreTable.m
//  FengZi
//
//  Created by WangFeng on 11-12-15.
//  Copyright (c) 2012年 mymmsc.org. All rights reserved.
//

#import "UCStoreTable.h"
#import "Api+eShop.h"
#import "UCStoreInfo.h"
#import "UCStoreSubscribe.h"
#import "UCStorePerson.h"
#import <iOSApi/iOSAsyncImageView.h>

@implementation UCStoreTable

@synthesize seg = _seg;
@synthesize person = _person;
@synthesize page = _page;
@synthesize bPerson;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.proxy = self;
        
        _type = 0;
        _sorttype = 0;
        _pricetype = 0;
        _person = 0;
        _page = 1;
        bPerson = NO;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)goBack{
    if(!bPerson) {
        [self dismissModalViewControllerAnimated:YES];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)goSpecial {
    UCStorePerson *nextView = [UCStorePerson new];
    [self.navigationController pushViewController:nextView animated:YES];
    [nextView release];
}

static int nClickTimes = 0;

- (void)setDDListHidden:(BOOL)hidden {
    //int index = [self.seg selectedSegmentIndex];
    //nClickTimes = index;
	NSInteger height = hidden ? 0 : 90;
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:.2];
	//[ddTypes.view setFrame:CGRectMake(30, 36, 200, height)];
    CGRect frame = self.seg.frame;
    frame.size.width /= 3;
    frame.origin.y += frame.size.height;
    frame.size.height = height;
    frame.origin.x = frame.size.width * nClickTimes;
    [ddTypes.view setFrame: frame];
	[UIView commitAnimations];
}

- (IBAction)doSelectType:(id)sender {
    int index = [self.seg selectedSegmentIndex];
    nClickTimes = index < 0 ? nClickTimes : index;
    [ddTypes updateData: [listIType objectAtIndex:index]];
    [self setDDListHidden:NO];
}

// 转向 订购
- (IBAction)gotoSubscribe:(id)sender {
    UCStoreSubscribe *nextView = [UCStoreSubscribe new];
    [self.navigationController pushViewController:nextView animated:YES];
    [nextView release];
}

#pragma mark -
#pragma mark DropDownList protocol

- (void)passValue:(NSString *)value{
	if (value) {
        //itype.text = value;
        [self.seg setTitle:value forSegmentAtIndex:nClickTimes];
        [self setDDListHidden:YES];
        //[itype resignFirstResponder];
		//[self searchBarSearchButtonClicked:_searchBar];
	}
	else {
		
	}
}

- (void)dropDown:(DropDownList *)dropDown index:(int)index{
    _page = 1;
    switch (nClickTimes) {
        case 1:
            _sorttype = index;
            break;
        case 2:
            _pricetype = index;
            break;
        default:
            _type = index;
            break;
    }
    [self reloadData];
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
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewWillAppear:(BOOL)animated {
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
    label.text= @"数字商城";
    self.navigationItem.titleView = label;
    [label release];
    
    UIButton *backbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backbtn.frame =CGRectMake(0, 0, 60, 32);
    if (bPerson) {
        [backbtn setImage:[UIImage imageNamed:@"as_back.png"] forState:UIControlStateNormal];
        [backbtn setImage:[UIImage imageNamed:@"as_back_tap.png"] forState:UIControlStateHighlighted];
    } else {
        [backbtn setImage:[UIImage imageNamed:@"as_nav_home.png"] forState:UIControlStateNormal];
        [backbtn setImage:[UIImage imageNamed:@"as_nav_home.png"] forState:UIControlStateHighlighted];
    }
    [backbtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backitem = [[UIBarButtonItem alloc] initWithCustomView:backbtn];
    self.navigationItem.leftBarButtonItem = backitem;
    [backitem release];
    
    _btnRight = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnRight.frame = CGRectMake(0, 0, 60, 32);
    [_btnRight setImage:[UIImage imageNamed:@"as_nav_special.png"] forState:UIControlStateNormal];
    [_btnRight setImage:[UIImage imageNamed:@"as_nav_special.png"] forState:UIControlStateHighlighted];
    [_btnRight addTarget:self action:@selector(goSpecial) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:_btnRight];
    self.navigationItem.rightBarButtonItem = rightItem;
    [rightItem release];
    
    // type 媒体文件的类型
    NSArray *list1 = [[NSArray alloc] initWithObjects:@"全部", @"电子书", @"音乐", @"游戏", @"美图", @"视频", @"漫画", @"其它", nil];
    // sorttype	订购排行的类型
    NSArray *list2 = [[NSArray alloc] initWithObjects:@"全部", @"最新", @"热门", nil];
    // pricetype
    NSArray *list3 = [[NSArray alloc] initWithObjects:@"全部", @"免费", @"收费", nil];
    //person	品牌专区的归属
    //0 全部
    //xxx 专区的ID
    //page	当前请求的页数
    
    listIType = [[NSArray alloc] initWithObjects:list1,list2,list3, nil];
    [list1 release];
    [list2 release];
    [list3 release];
    ddTypes = [[DropDownList alloc] initWithStyle:UITableViewStylePlain];
	ddTypes.delegate = self;
    [ddTypes._resultList removeAllObjects];
    [ddTypes._resultList addObjectsFromArray: listIType];
	[self.view addSubview:ddTypes.view];
    [ddTypes.view setFrame:CGRectMake(0, 0, 0, 0)];
    
    _borderStyle = UITextBorderStyleNone;
    font = [UIFont systemFontOfSize:13.0];
    if ([items count] == 0) {
        // 预加载项
        items = [[NSMutableArray alloc] initWithCapacity:0];
    }
}

- (UITableViewCell *)configure:(UITableViewCell *)cell withObject:(id)object {
    ProductInfo *obj = object;
    // 设置字体
    UIFont *textFont = [UIFont systemFontOfSize:17.0];
    UIFont *detailFont = [UIFont systemFontOfSize:12.0];
    int imageHeight = 36;
    
    //cell.imageView.image = [[iOSApi imageNamed:[Api typeIcon:obj.type]] scaleToSize:CGSizeMake(36, 36)];
    // 占位
    cell.imageView.image = [[UIImage imageNamed:@"unknown.png"] toSize:CGSizeMake(imageHeight, imageHeight)];
    NSString *tmpUrl = [iOSApi urlDecode:obj.productLogo];
    //UIImage *im = [[[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:tmpUrl]]] autorelease];
    //cell.imageView.image = im;
    CGRect frame;
    frame.size.width = imageHeight;
    frame.size.height = imageHeight;
    frame.origin.x = 0;
    frame.origin.y = 0;
    iOSAsyncImageView *ai = nil; //[info aimage];
    if (ai == nil)
    {
        // 默认图片
        cell.imageView.image = [[UIImage imageNamed:@"unknown.png"] toSize:CGSizeMake(imageHeight, imageHeight)];
        ai = [[[iOSAsyncImageView alloc] initWithFrame:frame] autorelease];
        //ai.tag = tagImage;
        //NSString *tmpUrl;
        
        NSURL *url = [NSURL URLWithString: tmpUrl];
        [ai loadImageFromURL:url];
    }
    [cell.imageView addSubview:ai];
    //[cell.imageView setImage:ai.image];
    
    cell.textLabel.text = [Api eshop_typename:obj.type];
    cell.textLabel.font = textFont;
    cell.detailTextLabel.textColor = [UIColor blueColor];
    NSString *tmpPrice = [NSString stringWithFormat:@"%.02f元", obj.price];
    if (obj.price < 0.01) {
        tmpPrice = @"免费";
    }
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@　%@", obj.name, obj.writer];
    cell.detailTextLabel.font = detailFont;
    
    frame.origin.x = 240;
    frame.origin.y = 15;
    frame.size.width = 100;
    frame.size.height = 18;
    UILabel *price = [[UILabel alloc] initWithFrame:frame];
    price.textColor = [UIColor blueColor];
    price.text = tmpPrice;
    [cell.contentView addSubview:price];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableViewCell *)cell onCustomAccessoryTapped:(id)object {
    ProductInfo *obj = object;
    UCStoreInfo *nextView = [[UCStoreInfo alloc] init];
    nextView.productId = obj.id;
    [self.navigationController pushViewController:nextView animated:YES];
    [nextView release];
}

- (NSArray *)reloadData:(iOSTableViewController *)tableView {
    [iOSApi showAlert:@"正在获取商品信息"];
    NSArray *data = [Api storeList:_type sorttype:_sorttype pricetype:_pricetype person:_person page:_page];
    if (data == nil || data.count < 1) {
        [iOSApi showCompleted:@"没有要查询的商品信息"];
    }
    [iOSApi closeAlert];
    return data;
}

- (NSArray *)arrayOfHeader:(iOSTableViewController *)tableView {
    return nil;
}

- (NSArray *)arrayOfFooter:(iOSTableViewController *)tableView {
    NSArray *list = [Api storeList:_type sorttype:_sorttype pricetype:_pricetype person:_person page:_page + 1];
    if (list.count > 0) {
        _page += 1;
    }
    return list;
}

@end
