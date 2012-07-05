//
//  BreakEgg.m
//  FengZi
//
//  Created by a on 12-5-2.
//  Copyright (c) 2012年 ifengzi.cn. All rights reserved.
//

#import "OpenBox.h"
#import <FengZi/Api.h>
#import "EggReward.h"

@implementation OpenBox
@synthesize btn1,btn2,btn3,btn4,btn5,btn6,btn7,btn8,btn9,luckyid,shopguid;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)goBack{
   // [self.navigationController popViewControllerAnimated:YES];
    [self dismissModalViewControllerAnimated:YES];
}

//查看具体中奖信息
-(void)goReward:(GameReward*)rs{
    
    EggReward *nextView = [[EggReward alloc] init];
    //nextView.param = obj;
    //模拟传递数据
    nextView.text = rs.name;
    nextView.imgUrl= rs.luckyimg;
    
    [self.navigationController pushViewController:nextView animated:YES];
    [nextView release];
    
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
    label.text= @"开宝箱";
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
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    [luckyid release];
    [shopguid release];
    [btn1 release];
    [btn2 release];
    [btn3 release];
    [btn4 release];
    [btn5 release];
    [btn6 release];
    [btn7 release];
    [btn8 release];
    [btn9 release];
    luckyid=nil;
    shopguid=nil;
    btn1=nil;
    btn2=nil;
    btn3=nil;
    btn4=nil;
    btn5=nil;
    btn6=nil;
    btn7=nil;
    btn8=nil;
    btn9=nil;
}

- (void)dealloc {
    [luckyid release];
    [shopguid release];
    [btn1 release];
    [btn2 release];
    [btn3 release];
    [btn4 release];
    [btn5 release];
    [btn6 release];
    [btn7 release];
    [btn8 release];
    [btn9 release];
    
    [super dealloc];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)goBreak:(id)sender
{
    
    //设置所有砸鸡蛋不可用
    [btn1 setEnabled:NO];
    [btn2 setEnabled:NO];
    [btn3 setEnabled:NO];
    [btn4 setEnabled:NO];
    [btn5 setEnabled:NO];
    [btn6 setEnabled:NO];
    [btn7 setEnabled:NO];
    [btn8 setEnabled:NO];
    [btn9 setEnabled:NO];
    
    //加载成功，失败图片
    UIImage *yesImg = [UIImage imageNamed:@"bxcg.png"];
    UIImage *noImg = [UIImage imageNamed:@"bxsb.png"];
    //调用接口。获得返回值 判断返回值。
    GameReward *rs = [Api get_reward_info:luckyid shopguid:shopguid];
    if (rs.status == 0 && rs.islucky == 1) 
    {
        UIButton *sbtn = (UIButton*)sender;
        [sbtn setImage:yesImg forState:UIControlStateDisabled];
        [yesImg release];
        [iOSApi Alert:@"系统提示" message:@"恭喜，中奖啦"];
        [self performSelector:@selector(goReward:) withObject:rs afterDelay:0.8];
    } else {        
        UIButton *sbtn = (UIButton*)sender;
        [sbtn setImage:noImg forState:UIControlStateDisabled];
        [noImg release];
        [iOSApi Alert:@"系统提示" message:@"很遗憾，未中奖"];
        //延时执行
        [self performSelector:@selector(goBack) withObject:nil afterDelay:0.8];
    }
}
@end
