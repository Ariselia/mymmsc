//
//  UCStoreTable.m
//  FengZi
//
//  Created by WangFeng on 11-12-15.
//  Copyright (c) 2012年 mymmsc.org. All rights reserved.
//

#import "UCStoreTable.h"
#import "Api+AppStore.h"
#import <iOSApi/UIImage+Scale.h>
#import "UCStoreInfo.h"
#import "UCStoreSubscribe.h"
#import "UCStorePerson.h"

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
    NSArray *list1 = [[NSArray alloc] initWithObjects:@"全部", @"电子书", @"音乐", @"游戏", @"图片", @"视频", @"漫画", @"其它", nil];
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

- (BOOL)configure:(UITableViewCell *)cell withObject:(id)object {
    ProductInfo *obj = object;
    // 设置字体
    UIFont *textFont = [UIFont systemFontOfSize:15.0];
    UIFont *detailFont = [UIFont systemFontOfSize:10.0];
    cell.imageView.image = [[iOSApi imageNamed:[Api typeIcon:obj.type]] scaleToSize:CGSizeMake(36, 36)];
    cell.textLabel.text = [Api typeName:obj.type];
    cell.textLabel.font = textFont;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@  %@  %.02f", obj.name, obj.writer, obj.price];
    cell.detailTextLabel.font = detailFont;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return YES;
}

- (void)tableView:(UITableViewCell *)cell onCustomAccessoryTapped:(id)object {
    ProductInfo *obj = object;
    UCStoreInfo *nextView = [[UCStoreInfo alloc] init];
    nextView.info = obj;
    [self.navigationController pushViewController:nextView animated:YES];
    [nextView release];
}

- (NSArray *)reloadData:(iOSTableViewController *)tableView {
    return [Api storeList:_type sorttype:_sorttype pricetype:_pricetype person:_person page:_page];
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
