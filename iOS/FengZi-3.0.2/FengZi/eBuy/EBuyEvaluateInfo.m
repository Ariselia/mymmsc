//
//  EBuyEvaluateInfo.m
//  FengZi
//
//  Created by wangfeng on 12-5-15.
//  Copyright (c) 2012年 ifengzi.cn. All rights reserved.
//

#import "EBuyEvaluateInfo.h"
#import "Api+eBuy.h"

@interface EBuyEvaluateInfo ()

@end

@implementation EBuyEvaluateInfo
@synthesize id, orderId, xState, xContent, xTime, xPic;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

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
    label.text= @"评论内容";
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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    EBProductComment *comm = [[Api ebuy_comment_get:id orderId:orderId] retain];
    int starNum = comm.grade;
    NSString *temp = @"一般";
    if (comm.love == 0) {
        temp = @"很喜欢";
        starNum = 5;
    } else if (comm.love == 1) {
        temp = @"一般";
    } else if (comm.love == 2) {
        temp = @"不喜欢";
    }
    xState.text = temp;
    temp = @"东东很不错，我很喜欢。";
    if (comm.content != nil) {
        temp = [iOSApi urlDecode:comm.content];
    }
    xContent.text = temp;
    if (starNum < 0) {
        starNum = 0;
    }
    if (starNum > 5) {
        starNum = 5;
    }
    _star = [[iOSStar alloc] initWithFrame:CGRectMake(90.0f, 4.0f, 150.0f, 21.0f)];
    _star.show_star = 20 * starNum;
    _star.font_size = 17;
    _star.isSelect = YES;
    _star.empty_color = [UIColor grayColor];
    _star.full_color = [UIColor redColor];
    //_star.tag = kTAG_STAR;
    [self.view addSubview:_star];
    _star.delegate = self;
    [_star release];
    xTime.text = comm.realizeTime;
    [xPic imageWithURL:[iOSApi urlDecode:comm.picUrl]];
}

@end
