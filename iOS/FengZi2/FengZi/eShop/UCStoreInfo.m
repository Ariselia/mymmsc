//
//  UCStoreInfo.m
//  FengZi
//
//  Created by  on 12-1-3.
//  Copyright (c) 2012年 iTotemStudio. All rights reserved.
//

#import "UCStoreInfo.h"
#import "Api+eShop.h"
#import "SHKItem.h"
#import "ShareView.h"
#import "UCLogin.h"
#import <iOSApi/HttpDownload.h>
#import "UCStoreSubscribe.h"
#import "UCStoreBBS.h"
#import <iOSApi/iOSAsyncImageView.h>

#import <iOSApi/UIImage+Scale.h>
#import <iOSApi/iOSImageView.h>
#import "UCBookReader.h"
#import "UCMoviePlayer.h"
#import "UCMusicPlayer.h"
#import "DetailedInfo.h"
#import "eShopProducerInfo.h"

@implementation UCStoreInfo

@synthesize info;
@synthesize page;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //self.proxy = self;
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
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(110, 0, 150,44)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = UITextAlignmentCenter;
    label.font = [UIFont fontWithName:@"黑体" size:60];
    label.textColor = [UIColor blackColor];
    label.text= info.name;
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
    /*
    DetailedInfo *topView = [[DetailedInfo alloc] initWithNibName:@"DetailedInfo" bundle:nil];
    topView.info = info;
    CGRect frame = topView.view.frame;
    frame.size.height = 270;
    topView.view.frame = frame;
    [self.tableView addSubview:topView.view];
     */
    if ([items count] == 0) {
        // 预加载项
        items = [[NSMutableArray alloc] initWithCapacity:0];
    }
    [iOSApi showAlert:@"正在获取商品信息"];
    NSArray *data = [[Api relation:info.pid page:_page] retain];
    [items addObjectsFromArray: data];
    [data release];
    [iOSApi closeAlert];
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
    [super viewWillAppear:YES];
    
}

static BOOL dLoaded = NO;
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    if (dLoaded && items.count > 1) {
        /*
        NSIndexPath *indexPath = [NSIndexPath indexPathWithIndex:0];
        [super.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];
        */
        [self.tableView reloadData];
    }
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //return 2;
    return [items count] + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 50;
	//CGSize size = [@"123" sizeWithFont:fontInfo constrainedToSize:CGSizeMake(labelWidth, 20000) lineBreakMode:UILineBreakModeWordWrap];
	//return size.height + 10; // 10即消息上下的空间，可自由调整 
    if (indexPath.row == 0) {
        height = 270.0f;
    }
	return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    // Configure the cell.
    int pos = [indexPath row];
    if (pos >= [items count] + 1) {
        return nil;
    }
    if (pos == 0) {
         eShopProducerInfo *topView = [(eShopProducerInfo*)[[[NSBundle mainBundle] loadNibNamed:@"eShopProducerInfo" owner:self options:nil] objectAtIndex:0] retain];
        topView.info = info;
        topView.idInfo = self;
        [topView loadData:info];
        /*
        CGRect frame = topView.frame;
        frame.origin.x = 0;
        frame.origin.y = 0;
        frame.size.height = 270;
        frame.size.width = 320;
        topView.frame = frame;
        [topView awakeFromNib];
        [cell addSubview:topView];
        cell.selectionStyle=UITableViewCellSelectionStyleGray;
        [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];
        //[self.tableView bringSubviewToFront:topView.view];
        */
        cell = topView;
        dLoaded = YES;
    } else {
        ProductInfo *obj = [items objectAtIndex: pos - 1];
        // 设置字体
        UIFont *textFont = [UIFont systemFontOfSize:17.0];
        UIFont *detailFont = [UIFont systemFontOfSize:12.0];
        int imageHeight = 36;
        
        //cell.imageView.image = [[iOSApi imageNamed:[Api typeIcon:obj.type]] scaleToSize:CGSizeMake(36, 36)];
        // 占位
        cell.imageView.image = [[UIImage imageNamed:@"unknown.png"] scaleToSize:CGSizeMake(imageHeight, imageHeight)];
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
            cell.imageView.image = [[UIImage imageNamed:@"unknown.png"] scaleToSize:CGSizeMake(imageHeight, imageHeight)];
            ai = [[[iOSAsyncImageView alloc] initWithFrame:frame] autorelease];
            //ai.tag = tagImage;
            //NSString *tmpUrl;
            
            NSURL *url = [NSURL URLWithString: tmpUrl];
            [ai loadImageFromURL:url];
        }
        [cell.imageView addSubview:ai];
        //[cell.imageView setImage:ai.image];
        
        cell.textLabel.text = [Api typeName:obj.type];
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
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    NSLog(@"module goto...");
    int pos = indexPath.row;
    if (pos == 0) {
        return;
    }
    pos -= 1;
    ProductInfo *object = [items objectAtIndex:pos];
    ProductInfo *obj = object;
    UCStoreInfo *nextView = [[UCStoreInfo alloc] init];
    nextView.info = obj;
    [self.navigationController pushViewController:nextView animated:YES];
    [nextView release];
    
}

@end
