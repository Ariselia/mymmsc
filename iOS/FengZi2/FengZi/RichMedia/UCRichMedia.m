//
//  UCRichMedia.m
//  FengZi
//
//  Created by  on 12-1-8.
//  Copyright (c) 2012年 iTotemStudio. All rights reserved.
//

#import "UCRichMedia.h"
#import "Api+RichMedia.h"
#import "UCMediaPage.h"
#import "SHKItem.h"
#import "ShareView.h"

@implementation UCRichMedia
@synthesize urlMedia, scrollViewX;
@synthesize picView1,picView2,picView3;

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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)shareCode{
    SHKItem *item = [SHKItem text:@"快来扫码，即有惊喜！"];
    //item.image = _image;
    item.shareType = SHKShareTypeImage;
    item.title = @"快来扫码，即有惊喜！\n来自蜂子客户端";
    ShareView *actionSheet = [[ShareView alloc] initWithItem:item];
    [actionSheet showInView:self.view];
    [actionSheet release];
}

- (void)viewWillAppear:(BOOL)animated{
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
    label.text= @"富媒体 内容";
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
    
    _btnRight = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnRight.frame = CGRectMake(0, 0, 60, 32);
    [_btnRight setImage:[UIImage imageNamed:@"share.png"] forState:UIControlStateNormal];
    [_btnRight setImage:[UIImage imageNamed:@"share_tap.png"] forState:UIControlStateHighlighted];
    [_btnRight addTarget:self action:@selector(shareCode) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:_btnRight];
    self.navigationItem.rightBarButtonItem = rightItem;
    [rightItem release];
    
    // bebe13af-287d-424d-b817-be0504a0850b
    NSDictionary *dict = [Api parseUrl:urlMedia];
    NSString *code = [dict objectForKey:@"id"];
    [Api kmaSetId:code];
    iOSLog(@"uuid1=[%@]", code);
    iOSLog(@"uuid2=[%@]", [Api kmaId]);
    
    // 获取媒体美容
    MediaContent *mc = [Api getContent:code];
    if (mc.status == 0) {
        [iOSApi Alert:@"提示" message:@"获取内容正确"];
    } else {
        [iOSApi Alert:@"提示" message:mc.message];
        [iOSApi Alert:@"提示" message:@"获取内容正确"];
    }
    int xHeight = 411;
    int num = [mc.pageList count];
    scrollViewX.contentSize = CGSizeMake(320 * num, xHeight);
    for (int i = 0; i < mc.pageList.count; i++) {
        MediaObject *info = [mc.pageList objectAtIndex:i];
        UCMediaPage *page = [[UCMediaPage alloc] init];
        CGRect frame = page.view.frame;
        frame.origin.x = 320 * i;
        frame.origin.y = 0;
        frame.size.height = 411;
        page.view.frame = frame;
        [self.scrollViewX addSubview:page.view];
        page.subject.text = mc.title;
        page.content.text = info.textContent;
        page.info = info;
    }
    picView1.image = [UIImage imageNamed:@"diandian.png"];
    picView2.image = [UIImage imageNamed:@"dian.png"];
    picView3.image = [UIImage imageNamed:@"dian.png"];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGPoint currentOffset = [scrollView contentOffset];
    if (currentOffset.x >= 0 && currentOffset.x < 320) {
        // 第一页
        picView1.image = [UIImage imageNamed:@"diandian.png"];
        picView2.image = [UIImage imageNamed:@"dian.png"];
        picView3.image = [UIImage imageNamed:@"dian.png"];
    } else if(currentOffset.x >= 320 && currentOffset.x < 640) {
        // 第二页
        picView1.image = [UIImage imageNamed:@"dian.png"];
        picView2.image = [UIImage imageNamed:@"diandian.png"];
        picView3.image = [UIImage imageNamed:@"dian.png"];
    } else {
        // 第三页
        picView1.image = [UIImage imageNamed:@"dian.png"];
        picView2.image = [UIImage imageNamed:@"dian.png"];
        picView3.image = [UIImage imageNamed:@"diandian.png"];
    }
}
@end
