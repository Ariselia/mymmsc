//
//  Roulette.m
//  FengZi
//
//  Created by a on 12-5-2.
//  Copyright (c) 2012年 ifengzi.cn. All rights reserved.
//

#import "Roulette.h"
#import "EggReward.h"
#import <FengZi/Api.h>

@interface Roulette ()
{
    NSTimer *timer;
}
@end

@implementation Roulette
@synthesize imgView,btn1,num,time,jstime,isJs,luckyid,shopguid;


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
    label.text= @"转轮盘";
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
    jstime = 1;
    isJs = NO;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    luckyid=nil;
    shopguid=nil;
    btn1=nil;
    imgView = nil;
    
    [luckyid release];
    [shopguid release];
    [btn1 release];
    [imgView release];
   
}

- (void)dealloc {
    [luckyid release];
    [shopguid release];
    [btn1 release];
    [imgView release];

    
    [super dealloc];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)goBreak:(id)sender
{
    self.navigationItem.leftBarButtonItem = nil;
    [btn1 setEnabled:NO];
    [btn1 setHidden:YES];
    num  = 1;
    time = 1;
    timer =[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(xuanzhuan) userInfo:nil repeats:YES]; 
}

-(void)goJianSu
{
    
    isJs = YES;
    timer =[NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(xuanzhuan) userInfo:nil repeats:YES]; 
}

-(void)xuanzhuan
{
    //用切换图片得形式
    time++;
    
    if (time>30) {
        time=1;
        [timer invalidate];
        //goto 减速
        [self goJianSu];
        
    } else {
        jstime++;
        if (jstime>35&&isJs) {
            //
            [timer invalidate];
            timer = nil;
            //加载成功，失败图片
            UIImage *yesImg = [UIImage imageNamed:@"lp10.png"];            
            UIImage *noImg = [UIImage imageNamed:@"lp9.png"];            
            
            //调用接口。获得返回值 判断返回值。
            
            GameReward *rs = [Api get_reward_info:luckyid shopguid:shopguid];
            if (rs.status==0&&rs.islucky==1)
            {                
                [imgView setImage:yesImg];
                [yesImg release];
                [iOSApi Alert:@"系统提示" message:@"恭喜，中奖啦"];
                [self performSelector:@selector(goReward:) withObject:rs afterDelay:0.8];
            } else {
                [imgView setImage:noImg];
                [yesImg release];
                [noImg release];
                [iOSApi Alert:@"系统提示" message:@"很遗憾，未中奖"];
                //延时执行            
                [self performSelector:@selector(goBack) withObject:nil afterDelay:0.8];
            }
        } else {
            NSString *imgUrl = [NSString stringWithFormat:@"lp%d.png", num];
            UIImage *image = [UIImage imageNamed:imgUrl];
            [imgView setImage:image];
            //[imgUrl release];
            num++;
            if(num == 10) {
                num=1;
            }
        }
    }
}

@end
