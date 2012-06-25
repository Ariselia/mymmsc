//
//  Hamster.m
//  FengZi
//
//  Created by a on 12-5-3.
//  Copyright (c) 2012年 ifengzi.cn. All rights reserved.
//

#import "Hamster.h"

#import "Api.h"
#import "EggReward.h"

@implementation Hamster
@synthesize btn1,btn2,btn3,btn4,btn5,btn6,btn7,btn8,btn9,num,luckyid,shopguid;


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
    label.text= @"打地鼠";
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
    btnArray= [[NSMutableArray alloc] init];
    [btnArray addObject:btn1];
    [btnArray addObject:btn2];
    [btnArray addObject:btn3];
    [btnArray addObject:btn4];
    [btnArray addObject:btn5];
    [btnArray addObject:btn6];
    [btnArray addObject:btn7];
    [btnArray addObject:btn8];
    [btnArray addObject:btn9];

    [self goPlay];
    
}

-(void)goPlay
{
    num=1;
    int value = (arc4random() % 8) + 1; 
    temBtn = [btnArray objectAtIndex:value];
    
    [temBtn addTarget:self action:@selector(goOver) forControlEvents:UIControlEventTouchUpInside];

    timer =[NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(showHamster) userInfo:nil repeats:YES]; 
    
       
}

-(void)showHamster
{
    NSString *imgUrl;
     num++;
    if (num>7) {
        //取消tembtn的监听；
       [temBtn removeTarget:self action:@selector(goOver) forControlEvents:UIControlEventTouchUpInside];
        [timer invalidate];
            
        [self goPlay];
    }  
    else {
        
        imgUrl = [NSString stringWithFormat:@"ds%d.png",num];
        
        
        UIImage *image = [UIImage imageNamed:imgUrl];
        
        [temBtn setImage:image forState:0];
    }

    //[imgUrl release];
    
}

-(void)goOver
{
    [temBtn removeTarget:self action:@selector(goOver) forControlEvents:UIControlEventTouchUpInside];
    [timer invalidate];
    if (num>2&&num<6) {
        //加载成功，失败图片
        UIImage *yesImg = [UIImage imageNamed:@"dsok.png"];
        UIImage *noImg = [UIImage imageNamed:@"dsok.png"];
        //调用接口。获得返回值 判断返回值。
        GameReward *rs = [Api get_reward_info:luckyid shopguid:shopguid];
        if (rs.status == 0 && rs.islucky == 1) 
        {
            [temBtn setImage:yesImg forState:0];
            [yesImg release];
            [iOSApi Alert:@"系统提示" message:@"恭喜，中奖啦"];
            [self performSelector:@selector(goReward:) withObject:rs afterDelay:0.8];
        } else {
            [temBtn setImage:noImg forState:0];
            [noImg release];
            [iOSApi Alert:@"系统提示" message:@"很遗憾，未中奖"];
            //延时执行
            [self performSelector:@selector(goBack) withObject:nil afterDelay:0.8];
        }
    } else {
        UIImage *startImg = [UIImage imageNamed:@"ds1.png"];
        [temBtn setImage:startImg forState:0];
        [self goPlay];
    }
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


@end
