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
@synthesize tableView = _tableView;
@synthesize lable1,lable2,lable3,lable4,lable5,lable6;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
         self.proxy = self;
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
   
    [_tableView setHidden:YES];    
}
    //加载动画效果

-(void)animationLable
{

    
    [UIView beginAnimations:@"huishou" context:nil]; 
    //设置动画移动的时间为slider.value滑块的值  
    [UIView setAnimationDuration:2.5]; 
    //设置动画曲线类形为：直线UIViewAnimationCurveLinear  
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    
    int r1 = (arc4random() % 200) + 1;
    int r2 = (arc4random() % 200) + 1;
    int r3 = (arc4random() % 200) + 1;
    int r4 = (arc4random() % 200) + 1;
    int r5 = (arc4random() % 200) + 1;
    int r6 = (arc4random() % 200) + 1;
    CGRect a = CGRectMake(r1, 309, 240,44);
    CGRect b = CGRectMake(r2, 185, 240,44);
    CGRect c = CGRectMake(r3, 232, 240,44);
    CGRect d = CGRectMake(r4,81, 240,44);
    CGRect e = CGRectMake(r5, 143, 240,44);
    CGRect f = CGRectMake(r6, 46, 240,44);
    
    [lable1 setFrame:a];
    [lable2 setFrame:b];
    [lable3 setFrame:c];
    [lable4 setFrame:d];
    [lable5 setFrame:e];
    [lable6 setFrame:f];
    
    //完成动画，必须写，不要忘了  
    [UIView commitAnimations];
    [self performSelector:@selector(showTable) withObject:nil afterDelay:3.5];
}

- (void)showTable
{     
    [lable1 setHidden:YES];
    [lable2 setHidden:YES];
    [lable3 setHidden:YES];
    [lable4 setHidden:YES];
    [lable5 setHidden:YES];
    [lable6 setHidden:YES];
    [_tableView setHidden:NO];
    
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
    _borderStyle = UITextBorderStyleNone;
    //font = [UIFont systemFontOfSize:13.0];
    if ([_items count] == 0) {
        // 预加载项
        _items = [[NSMutableArray alloc] initWithCapacity:0];
        _page = 1;
    } else {
        [_items removeAllObjects];
    }
}

#pragma mark -
#pragma mark UITableViewDataSource

- (UITableViewCell *)configure:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
    }
    cell.textLabel.text =@"蜂子二维码"; 
    GameInfo *obj = [self objectForIndexPath:indexPath];
    // 设置字体
    UIFont *textFont = [UIFont systemFontOfSize:17.0];
    cell.textLabel.text = [iOSApi urlDecode:obj.luckyName];
    cell.textLabel.font = textFont;
    /*
    if (indexPath.row %2 == 0) {
        //cell.backgroundColor = [UIColor grayColor];
        cell.textLabel.textColor = [UIColor blackColor];
    } else {
        //cell.backgroundColor = [UIColor lightGrayColor];
        cell.textLabel.textColor = [UIColor blueColor];
    }
     */
    UIColor *tempColor;
    int tempNum = (arc4random() % 7) + 1;
    
    /*
    
     *)cyanColor;       // 0.0, 1.0, 1.0 RGB 
     + (UIColor *)yellowColor;     // 1.0, 1.0, 0.0 RGB 
     + (UIColor *)magentaColor;    // 1.0, 0.0, 1.0 RGB 
     + (UIColor *)orangeColor;     // 1.0, 0.5, 0.0 RGB 
     + (UIColor *)purpleColor;     // 0.5, 0.0, 0.5 RGB 
     + (UIColor *)brownColor;    
    */
    if(tempNum==1)
    {
        tempColor = [UIColor redColor];
    } else if(tempNum==2) {
        tempColor = [UIColor brownColor];
    } else if(tempNum==3) {
        tempColor = [UIColor blueColor];
    } else if(tempNum==4) {
        tempColor = [UIColor greenColor];
    } else if(tempNum==5) {
        tempColor = [UIColor blackColor];
    } else if(tempNum==6) {
        tempColor = [UIColor orangeColor];
    } else if(tempNum==7) {
        tempColor = [UIColor cyanColor];
    } else {
         tempColor = [UIColor orangeColor];
    }
    
    cell.textLabel.textColor =tempColor;
    [tempColor release];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

/*
- (UITableViewCell *)configure:(UITableViewCell *)cell withObject:(id)object {
    
    
    
    GameInfo *obj = object;
    // 设置字体
    UIFont *textFont = [UIFont systemFontOfSize:17.0];
    cell.textLabel.text = [iOSApi urlDecode:obj.luckyName];
    
    cell.textLabel.font = textFont;
    
    //cell.detailTextLabel.text =obj.luckyName;
    //[cell setLayerEffect:cell.layer];
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
*/
static GameInfo *theObj = nil;

- (void)tableView:(UITableViewCell *)cell onCustomAccessoryTapped:(id)object {
    theObj = object;
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

    /*
    UIAlertView *alert = [[UIAlertView alloc]
						  initWithTitle:nil
						  message:nil
						  delegate:self
						  cancelButtonTitle:@"轮盘"
						  otherButtonTitles:@"打地鼠",@"开箱子",@"砸金蛋",
                          nil];
    [alert show];
	[alert release];
     */
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger) buttonIndex {
    GameInfo *obj = theObj;
    int n = buttonIndex + 1;
    if (n == 1) {
        // 轮盘
        Roulette *theView = [[[Roulette alloc] init] autorelease];
        theView.luckyid = obj.luckyId;
        theView.shopguid = obj.activeId;
        UINavigationController *nextView = [[UINavigationController alloc] initWithRootViewController:theView];
        [self presentModalViewController:nextView animated:YES];
        [nextView release];
    } else if (n == 2) {
        // 打地鼠
        Hamster *theView = [[[Hamster alloc] init] autorelease];
        theView.luckyid = obj.luckyId;
        theView.shopguid = obj.activeId;
        UINavigationController *nextView = [[UINavigationController alloc] initWithRootViewController:theView];
        [self presentModalViewController:nextView animated:YES];
        [nextView release];
    } else if (n == 3) {
        // 开箱子
        OpenBox *theView = [[[OpenBox alloc] init] autorelease];
       theView.luckyid = obj.luckyId;
        theView.shopguid = obj.activeId;
        UINavigationController *nextView = [[UINavigationController alloc] initWithRootViewController:theView];
        [self presentModalViewController:nextView animated:YES];
        [nextView release];
    } else if (n == 4) {
        // 砸蛋
        BreakEgg *theView = [[[BreakEgg alloc] init] autorelease];
        theView.luckyid = obj.luckyId;
        theView.shopguid = obj.activeId;
        
        UINavigationController *nextView = [[UINavigationController alloc] initWithRootViewController:theView];
        [self presentModalViewController:nextView animated:YES];
        [nextView release];
    }
}

- (NSArray *)reloadData:(iOSTableViewController *)tableView {
    [iOSApi showAlert:@"获取活动列表..."];
    NSMutableArray *data = [Api activeList];
    [iOSApi closeAlert];
    if (data == nil || data.count < 1) {
        [iOSApi showCompleted:@"服务器正忙，请稍候"];
    } else {
        [_items addObjectsFromArray:[data retain]];
        for (int i=0; i<_items.count; i++) {
            GameInfo *obj = [_items objectAtIndex:i];
            if(i==0)
            {
               
                [lable1 setText:obj.luckyName];
            }
            if(i==1)
            {
                
                [lable2 setText:obj.luckyName];
            }
            if(i==2)
            {
                
                [lable3 setText:obj.luckyName];
            }
            if(i==3)
            {
                
                [lable4 setText:obj.luckyName];
            }
            if(i==4)
            {
                
                [lable5 setText:obj.luckyName];
            }
            if(i==5)
            {
                
                [lable6 setText:obj.luckyName];
            }

            
        }
    [self animationLable];
        
    }
  
    return data;
}

- (NSArray *)arrayOfHeader:(iOSTableViewController *)tableView {
    return nil;
}

- (NSArray *)arrayOfFooter:(iOSTableViewController *)tableView {
    return nil;
    //NSArray *list = [Api activeList];
    //return list;
}

@end
