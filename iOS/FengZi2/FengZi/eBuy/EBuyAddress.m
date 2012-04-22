//
//  EBuyAddress.m
//  FengZi
//
//  Created by wangfeng on 12-4-23.
//  Copyright (c) 2012年 ifengzi.cn. All rights reserved.
//

#import "EBuyAddress.h"
#import "Api+Ebuy.h"

@interface EBuyAddress ()

@end

@implementation EBuyAddress
@synthesize sheng, chengshi,dizhi,shouhuoren,youbian,shouji;
@synthesize seqId;

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
    label.text= @"编辑收货地址";
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
    [self registerForKeyboardNotifications];
    
    
    ddShengs = [[DropDownList alloc] initWithStyle:UITableViewStylePlain];
	ddShengs.delegate = self;
    [ddShengs._resultList removeAllObjects];
    [ddShengs._resultList addObjectsFromArray: nil];
	[self.view addSubview:ddShengs.view];
    [ddShengs.view setFrame:CGRectMake(0, 0, 0, 0)];
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

- (void)setDDListHidden:(BOOL)hidden {
    //int index = [self.seg selectedSegmentIndex];
    //nClickTimes = index;
	NSInteger height = hidden ? 0 : 90;
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:.2];
	//[ddTypes.view setFrame:CGRectMake(30, 36, 200, height)];
    CGRect frame = sheng.frame;
    frame.size.height = height;
    [ddShengs.view setFrame: frame];
	[UIView commitAnimations];
}

#pragma mark -
#pragma mark DropDownList protocol

- (void)passValue:(NSString *)value{
	if (value) {
        [sheng setText:value];
        [self setDDListHidden:YES];
	} else {		
	}
}

// 保存地址
- (IBAction)doSave:(id)sender{
    EBAddress *addr = [[[EBAddress alloc] init] autorelease];
    addr.sheng = sheng.text;
    addr.chengshi = chengshi.text;
    addr.dizhi = dizhi.text;
    addr.shouhuoren = shouhuoren.text;
    addr.youbian = youbian.text;
    addr.shouji = shouji.text;
    
    if (addr.sheng.length < 1) {
        [iOSApi toast:@"请选择省市"];
        [sheng becomeFirstResponder];
        return;
    }
    if (addr.chengshi.length < 1) {
        [iOSApi toast:chengshi.placeholder];
        [chengshi becomeFirstResponder];
        return;
    }
    if (addr.dizhi.length < 1) {
        [iOSApi toast:dizhi.placeholder];
        [dizhi becomeFirstResponder];
        return;
    }
    if (addr.shouhuoren.length < 1) {
        [iOSApi toast:shouhuoren.placeholder];
        [shouhuoren becomeFirstResponder];
        return;
    }
    if (addr.youbian.length < 1) {
        [iOSApi toast:youbian.placeholder];
        [youbian becomeFirstResponder];
        return;
    }
    if (addr.shouji.length < 1) {
        [iOSApi toast:shouji.placeholder];
        [shouji becomeFirstResponder];
        return;
    }
    BOOL bRet = [iOSApi regexpMatch:addr.youbian withPattern:@"[0-9]{6}"];
    if (!bRet) {
        [iOSApi Alert:@"提示" message:@"手机号码格式有误，请重新输入。"];
        [youbian becomeFirstResponder];
        return;
    }
    bRet = [iOSApi regexpMatch:addr.shouji withPattern:@"[0-9]{11}"];
    if (!bRet) {
        [iOSApi Alert:@"提示" message:@"手机号码格式有误，请重新输入。"];
        [shouji becomeFirstResponder];
        return;
    }
    [Api ebuy_address_add:addr];
}

- (IBAction)doCancel:(id)sender{
    //
}

- (IBAction)doShowList:(id)sender{
    NSArray *list = [NSArray arrayWithObjects:@"北京", @"上海", @"天津", @"广州", @"深圳", @"西安", nil];
    [ddShengs updateData: list];
    [self setDDListHidden:NO];
}
@end
