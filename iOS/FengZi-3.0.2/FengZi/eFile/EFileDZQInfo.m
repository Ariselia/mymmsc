//
//  EFileHYKInfo.m
//  FengZi
//
//  Created by a on 12-4-19.
//  Copyright (c) 2012年 ifengzi.cn. All rights reserved.
//

#import "EFileDZQInfo.h"
#import <FengZi/Api+Category.h>
#import "Api+Database.h"
#import "FileUtil.h"

@implementation EFileDZQInfo
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
    
    
    EFileCardInfo *result = [[DataBaseOperate shareData] loadCardInfo:param.sid];
    
    
    //cardinfocode,cardinfocodepicurl,cardinfocontent,cardinfoname,cardinfodiscount,cardinfopicurl,cardinfoserialnum,cardinfousetime,cardinfousestate,cardlistarealist,cardlisttypelist,cardinfoshoplist,userid
    /*
    NSString *cardinfousestate= result.cardinfousestate;
    NSString *cardlistarealist=result.cardlistarealist;
    
    
    NSString *cardlisttypelist= result.cardlisttypelist;
    
    NSString *cardinfoshoplist= result.cardinfoshoplist;
    */
    NSString *cardinfocode= result.cardinfocode;
    NSString *cardinfocodepicurl=result.cardinfocodepicurl;


    NSString *cardinfocontent= result.cardinfocontent;


    NSString *cardinfoname=result.cardinfoname;


    NSString *cardinfodiscount=result.cardinfodiscount;


    NSString *cardinfopicurl= result.cardinfopicurl;


    NSString *cardinfoserialnum= result.cardinfoserialnum;

    NSString *cardinfousetime=result.cardinfousetime;
   // NSString *userid=result.userid;
    
    self.u_name.text =cardinfoname;
    
    self.u_content.text=cardinfocontent;
    self.u_num.text = cardinfodiscount;
    self.u_usetime.text=cardinfousetime;
    self.u_code.text = cardinfocode;
    self.u_serialNum.text = cardinfoserialnum;
    
    NSString *code_path;
    NSString *info_path;
    code_path = [FileUtil filePathInEncode:cardinfocodepicurl];
    info_path = [FileUtil filePathInEncode:cardinfopicurl];
    self.u_codepic.image=[UIImage imageWithContentsOfFile:code_path];  
    self.u_pic.image=[UIImage imageWithContentsOfFile:info_path];  
    
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
    u_name=nil;
    u_serialNum=nil;
    u_num=nil;
    u_usetime=nil;
    u_pic=nil;
    u_codepic=nil;
    u_content=nil;
    u_code=nil;
    param=nil;
    [u_name release];
    [u_serialNum release];
    [u_num release];
    [u_usetime release];
    [u_pic release];
    [u_codepic release];
    [u_content release];
    [u_code release];
    
    [param release];
      
}

- (void)dealloc {
    [u_name release];
    [u_serialNum release];
    [u_num release];
    [u_usetime release];
    [u_pic release];
    [u_codepic release];
    [u_content release];
    [u_code release];
    
    [param release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
