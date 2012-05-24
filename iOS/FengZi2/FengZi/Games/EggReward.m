//
//  EggReward.m
//  FengZi
//
//  Created by a on 12-5-2.
//  Copyright (c) 2012年 ifengzi.cn. All rights reserved.
//

#import "EggReward.h"
#import "Api.h"

@interface EggReward ()

@end

@implementation EggReward
@synthesize content,imgView,text,imgUrl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)goBack{
    [self.navigationController popToRootViewControllerAnimated:YES];
    //[self.navigationController popViewControllerAnimated:YES];
    //[self dismissModalViewControllerAnimated:YES];
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
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(110, 0, 100,44)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = UITextAlignmentCenter;
    label.font = [UIFont fontWithName:@"黑体" size:60];
    label.textColor = [UIColor blackColor];
    label.text= @"获奖信息";
    self.navigationItem.titleView = label;
    [label release];
    
    UIButton *backbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backbtn.frame = CGRectMake(0, 0, 60, 32);
    
    [backbtn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backbtn setImage:[UIImage imageNamed:@"back_tap.png"] forState:UIControlStateHighlighted];
    [backbtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backitem = [[UIBarButtonItem alloc] initWithCustomView:backbtn];
    self.navigationItem.leftBarButtonItem = backitem;
    [backitem release];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    content.text = text;
    
    NSString * aImageName=[[NSString alloc]initWithFormat:@"logo.png"];
    UIImage *img = [UIImage imageNamed:aImageName];
    UIImage *simg = [img toSize:CGSizeMake(240, 240)];
    
    NSString *tempUrl = imgUrl;
    
    iOSImageView *iv = [[iOSImageView alloc] initWithImage:simg];
    [iv imageWithURL: tempUrl];
    
    [imgView addSubview:iv];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    imgUrl=nil;
    text = nil;
    content =nil;
    imgView =nil;
    [imgUrl release];
    [text release];
    [content release];
    [imgView release];
}

- (void)dealloc {
    [imgUrl release];
    [text release];
    [content release];
    [imgView release];
 
    [super dealloc];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
