//
//  GamePortal.m
//  FengZi
//
//  Created by wangfeng on 12-5-14.
//  Copyright (c) 2012年 ifengzi.cn. All rights reserved.
//

#import "GamePortal.h"
#import "UIView+Effect.h"

#import "Roulette.h" // 轮盘
#import "Hamster.h"  // 打地鼠
#import "BreakEgg.h" // 砸蛋
#import "OpenBox.h"  // 开箱子

@interface GamePortal ()

@end

@implementation GamePortal

@synthesize scrollView=_sview;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
       //  self.proxy = self;
    }
    return self;
}

- (void)goBack{
    [self dismissModalViewControllerAnimated:YES];
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
    label.text= @"蜂幸运";
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
    
    [iOSApi showAlert:@"获取活动列表..."];
    _items = [[NSMutableArray alloc] initWithCapacity:0];

    _items = [[Api activeList] retain];
    

    [iOSApi closeAlert];
    if (_items == nil || _items.count < 1) {
        [iOSApi showCompleted:@"服务器正忙，请稍候"];
    } else {
        [_sview removeSubviews];
        int xWidth = 320;
        int xHeight = 80;
        int num = _items.count;
        _sview.contentSize = CGSizeMake(xWidth,xHeight*num);
        
        CGRect bounds = _sview.bounds;
        bounds.size.width = 320;
        //_sview.contentOffset = CGPointMake(90, 60);
        
        for (int i=0; i<_items.count; i++) {
            GameInfo *obj = [_items objectAtIndex:i];
            int rx;
            int ry;
            CGRect labelCGRect;
            rx = (arc4random() % 320) + 1;
            
            if(i%2 == 0)
            {
                rx = rx+100;   
                ry = (arc4random() % 100) + 1; 
                labelCGRect = CGRectMake(rx, -ry, 240,60);   
            }
            else {
                rx = rx-100;
                ry = (arc4random() % 100) + 320;   
                labelCGRect = CGRectMake(rx, ry, 240,60);     
            }
            
            
            UILabel *tempLabel = [[UILabel alloc]initWithFrame:(labelCGRect)];
            
            UIButton *tempBtn = [[UIButton alloc]initWithFrame:(labelCGRect)];
           // [tempBtn setBackgroundColor:[UIColor blueColor]];
            [tempBtn addTarget:self action:@selector(goGame:) forControlEvents:UIControlEventTouchUpInside];
            [tempBtn setTag:i];
            UIColor *tempColor;
            
            int tempNum = (arc4random() % 7) + 1;
            
            if(tempNum==1)
            {
                tempColor = [UIColor redColor];
            }
            else if(tempNum==2) {
                tempColor =[UIColor colorWithRed:30.0/255 green:144.0/255 blue:255.0/255 alpha:1];
            }
            else if(tempNum==3) {
                tempColor = [UIColor blueColor];
            }
            
            else if(tempNum==4) {
                tempColor = [UIColor greenColor];
            }
            
            else if(tempNum==5) {
                tempColor =[UIColor colorWithRed:255.0/255 green:0 blue:255.0/255 alpha:1];
            }
            else if(tempNum==6) {
                tempColor = [UIColor orangeColor];
            }
            else if(tempNum==7) {
                tempColor = [UIColor yellowColor];
            }
            
            else {
                tempColor = [UIColor orangeColor];
            }
            
            int tempSize = (arc4random() % 20) + 22;
            
            
            
            
            [tempLabel setShadowColor:tempColor];  
            [tempLabel setShadowOffset:CGSizeMake(-1, 1)];  
            
            
            //设置是否能与用户进行交互       
            tempLabel.userInteractionEnabled = YES;  
            //设置点击事件
            
            
            
            [tempLabel setText:@"蜂子二维码"];
            [tempLabel setFont:[UIFont boldSystemFontOfSize:tempSize]];
            [tempLabel setBackgroundColor:[UIColor clearColor]];
            [tempLabel setTextColor:tempColor];
            [tempLabel setText:obj.luckyName];
            [_sview addSubview:tempLabel];
            [_sview addSubview:tempBtn];
            //执行动画
            
            [UIView beginAnimations:@"huishou" context:nil]; 
            //设置动画移动的时间为slider.value滑块的值  
            [UIView setAnimationDuration:2.5]; 
            //设置动画曲线类形为：直线UIViewAnimationCurveLinear  
            [UIView setAnimationCurve:UIViewAnimationCurveLinear];
            
            int rxn = (arc4random() % 100) + 1;
            
            int ryn = (i+1)*60;
            
            CGRect a = CGRectMake(rxn, ryn, 240,44);
            
            
            [tempBtn setFrame:a];
            [tempLabel setFrame:a];        
            //完成动画，必须写，不要忘了  
            [UIView commitAnimations];
            [tempLabel release];
            [tempBtn release];
        }
        
        //[_sview flashScrollIndicators];

        
    }

      
}

-(void)goGame:(id) sender{
    
    //NSLog(@"%d",[sender tag]);
    int i= [sender tag];
    
    GameInfo *theObj = [_items objectAtIndex:i];
    
    
    int n;
    @try {
        n =  [theObj.activeId integerValue];
    }
    @catch (NSException *exception) {
        n = 1;
    }
    @finally {
        //
    }
    
    if (n == 1) {
        // 轮盘
        Roulette *theView = [[[Roulette alloc] init] autorelease];
        theView.luckyid = theObj.luckyId;
        theView.shopguid = theObj.activeId;
        UINavigationController *nextView = [[UINavigationController alloc] initWithRootViewController:theView];
        [self presentModalViewController:nextView animated:YES];
        [nextView release];
    } else if (n == 2) {
        // 打地鼠
        Hamster *theView = [[[Hamster alloc] init] autorelease];
        theView.luckyid = theObj.luckyId;
        theView.shopguid = theObj.activeId;
        UINavigationController *nextView = [[UINavigationController alloc] initWithRootViewController:theView];
        [self presentModalViewController:nextView animated:YES];
        [nextView release];
    } else if (n == 3) {
        // 开箱子
        OpenBox *theView = [[[OpenBox alloc] init] autorelease];
        theView.luckyid = theObj.luckyId;
        theView.shopguid = theObj.activeId;
        UINavigationController *nextView = [[UINavigationController alloc] initWithRootViewController:theView];
        [self presentModalViewController:nextView animated:YES];
        [nextView release];
    } else if (n == 4) {
        // 砸蛋
        BreakEgg *theView = [[[BreakEgg alloc] init] autorelease];
        theView.luckyid = theObj.luckyId;
        theView.shopguid = theObj.activeId;
        
        UINavigationController *nextView = [[UINavigationController alloc] initWithRootViewController:theView];
        [self presentModalViewController:nextView animated:YES];
        [nextView release];
    }

}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [_items release];
    _items=nil;
    [_font release];
    _font = nil;
    [_curSubject release];
    _curSubject = nil;
    _sview = nil;
    [_sview release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}

- (void)dealloc {
    [_items release];
    [_font release];
    [_curSubject release];
    [_sview release];
    [super dealloc];
}


@end
