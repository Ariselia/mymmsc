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

#import "SHK.h"
#import "ShareView.h"

@implementation UCRichMedia
@synthesize urlMedia, scrollViewX;
@synthesize picView1,picView2,picView3,picView4,picView5,picView6;
@synthesize curImage=_curImage;
@synthesize code;
@synthesize maObject;

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
    self.maObject = nil;
}

- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)shareCode{
    [[SHK currentHelper] setRootViewController:self];
    SHKItem *item = [SHKItem text:@"我制做一个超炫的二维码，大家快来扫扫看！\n来自蜂子客户端"];
    item.image = _curImage;
    item.shareType = SHKShareTypeImage;
    item.title = @"我制做一个超炫的二维码，大家快来扫扫看！";
    SHKActionSheet *actionSheet = [SHKActionSheet actionSheetForItem:item];
    [actionSheet showInView:self.view];
}

- (void)changePage:(int)pos {
    picView1.hidden = YES;
    picView2.hidden = YES;
    picView3.hidden = YES;
    picView4.hidden = YES;
    picView5.hidden = YES;
    picView6.hidden = YES;
    picView1.image = [UIImage imageNamed:@"dian.png"];
    picView2.image = [UIImage imageNamed:@"dian.png"];
    picView3.image = [UIImage imageNamed:@"dian.png"];
    picView4.image = [UIImage imageNamed:@"dian.png"];
    picView5.image = [UIImage imageNamed:@"dian.png"];
    picView6.image = [UIImage imageNamed:@"dian.png"];
    if (xCount == 1) {
        return;
    }
    for (int i = 0; i < xCount; i++) {
        if (i == 0) {
            picView1.hidden = NO;
        } else if (i == 1) {
            picView2.hidden = NO;
        } else if (i == 2) {
            picView3.hidden = NO;
        } else if (i == 3) {
            picView4.hidden = NO;
        } else if (i == 4) {
            picView5.hidden = NO;
        } else if (i == 5) {
            picView6.hidden = NO;
        }
        if (i == pos) {
            if (i == 0) {
                picView1.image = [UIImage imageNamed:@"diandian.png"];
            } else if (i == 1) {
                picView2.image = [UIImage imageNamed:@"diandian.png"];
            } else if (i == 2) {
                picView3.image = [UIImage imageNamed:@"diandian.png"];
            } else if (i == 3) {
                picView4.image = [UIImage imageNamed:@"diandian.png"];
            } else if (i == 4) {
                picView5.image = [UIImage imageNamed:@"diandian.png"];
            } else if (i == 5) {
                picView6.image = [UIImage imageNamed:@"diandian.png"];
            }
        }
    }
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
    [iOSApi showAlert:@"Loading..."];
    if (maObject == nil) {
        if (urlMedia != nil) {
            NSDictionary *dict = [urlMedia uriParams];
            code = [dict objectForKey:@"id"];
            
        }
        
        [Api kmaSetId:code];
        iOSLog(@"uuid1=[%@]", code);
        iOSLog(@"uuid2=[%@]", [Api kmaId]);
        
        if (urlMedia != nil) {
            maObject = [[Api getContent:code] retain];
        } else {
            KmaObject *ko = [[Api kmaContent:code] retain];
            maObject = ko.mediaObj;
        }
    }
    xCount = 0;
    if (maObject.status == 0) {
        xCount = maObject.pageList.count;
        [iOSApi showCompleted:@"媒体加载完成"];
    } else {
        [iOSApi Alert:@"提示" message:maObject.message];
        //[iOSApi Alert:@"提示" message:@"获取内容正确"];
    }
    if (xCount >= 6) {
        xCount = 6;
    }
    int xHeight = 411;
    int num = [maObject.pageList count];
    scrollViewX.contentSize = CGSizeMake(320 * num, xHeight);
    for (int i = 0; i < xCount; i++) {
        MediaObject *info = [maObject.pageList objectAtIndex:i];
        UCMediaPage *page = [[UCMediaPage alloc] init];
        CGRect frame = page.view.frame;
        frame.origin.x = 320 * i;
        frame.origin.y = 0;
        frame.size.height = 411;
        page.view.frame = frame;
        
        page.subject.text = maObject.title;
        page.content.text = info.textContent;
        page.maContent = maObject;
        page.info = info;
        page.idMedia = self;
        [page loadData];
        [self.scrollViewX addSubview:page.view];
    }
    [self changePage:0];
    [iOSApi closeAlert];
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
    int offset = currentOffset.x;
    int pos = offset / 320;
    int min = pos * 320;
    int max = min + 320;
    if (currentOffset.x >= min && currentOffset.x < max) {
        [self changePage:pos];
    }
}
@end
