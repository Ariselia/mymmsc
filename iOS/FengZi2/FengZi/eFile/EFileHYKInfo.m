//
//  EFileHYKInfo.m
//  FengZi
//
//  Created by a on 12-4-19.
//  Copyright (c) 2012年 ifengzi.cn. All rights reserved.
//

#import "EFileHYKInfo.h"
#import "Api+Database.h"
#import "FileUtil.h"

@implementation EFileHYKInfo
@synthesize u_num,u_pic,u_code,u_name,u_codepic,u_content,u_usetime,u_serialNum;
@synthesize param;
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

- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //设置导航图片    
    
    [super viewWillAppear:animated];
    
    UIImage *image = [[UIImage imageNamed:@"fjtitle.png"] toSize: CGSizeMake(320, 44)];
    Class ios5Class = (NSClassFromString(@"CIImage"));
    if (nil != ios5Class) {
        [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    } else {
        self.navigationController.navigationBar.layer.contents = (id)[UIImage imageNamed:@"fjtitle.png"].CGImage;
    }
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320,44)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = UITextAlignmentCenter;
    label.font = [UIFont fontWithName:@"黑体" size:60];
    label.textColor = [UIColor blackColor];
    label.text= param.name;
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
    
    
    EFileMemberInfo *result = [[DataBaseOperate shareData] loadMemberInfo:param.sid];
    
    
    //memberinfocodename,memberinfocodepicurl,memberinfocodecontent,memberinfocodenum,memberinfopicurl,memberinfocodeserialnum,memberinfocodeusetime,userid FROM member where memberlistid
    
    NSString *memberinfocodename= result.memberinfocodename;
    NSString *memberinfocodepicurl=result.memberinfocodepicurl;


    NSString *memberinfocodecontent= result.memberinfocodecontent;


    NSString *memberinfocodenum=result.memberinfocodenum;


    NSString *memberinfopicurl=result.memberinfopicurl;


    NSString *memberinfocodeserialnum= result.memberinfocodeserialnum;


    NSString *memberinfocodeusetime= result.memberinfocodeusetime;


    NSString *userid=result.userid;

    self.u_name.text =memberinfocodename;
    
    self.u_content.text=memberinfocodecontent;
    self.u_num.text = memberinfocodenum;
    self.u_usetime.text=memberinfocodeusetime;
    self.u_code.text = userid;
    self.u_serialNum.text = memberinfocodeserialnum;
    
    NSString *code_path;
    NSString *info_path;
    code_path = [FileUtil filePathInEncode:memberinfocodepicurl];
    info_path = [FileUtil filePathInEncode:memberinfopicurl];
    //NSLog(path);//???路径有～～图片没存到本地？？
    
    //if([Api fileIsExists:code_path])
    //{
        
        self.u_codepic.image=[UIImage imageWithContentsOfFile:code_path];  

    //}
    //else
    //{
        
   //    self.u_pic.image = [[UIImage imageNamed:@"unknown.png"] toSize:CGSizeMake(115, 66)];
        
    //}
    
//    if([Api fileIsExists:info_path])
//    {
        
        self.u_pic.image=[UIImage imageWithContentsOfFile:info_path];  
        
//    }
//    else
//    {
        
   //     self.u_codepic.image = [[UIImage imageNamed:@"unknown.png"] toSize:CGSizeMake(147, 128)];
        
  //  }

    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //加载信息，取出图片和其他信息
    
    
    
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

@end
