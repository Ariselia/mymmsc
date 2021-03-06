//
//  UCLogin.m
//  FengZi
//
//  Created by  on 11-12-27.
//  Copyright (c) 2011年 iTotemStudio. All rights reserved.
//

#import "UCLogin.h"
#import "Api+UserCenter.h"
#import <iOSApi/iOSActivityIndicator.h>
#import "UCRegister.h"
#import "UCForget.h"
#import "UCWebView.h"
#define TAG_LOGIN_BASE   (200000)
#define TAG_LOGIN_NAME   (TAG_LOGIN_BASE + 1)
#define TAG_LOGIN_PASSWD (TAG_LOGIN_BASE + 2)
#define TAG_LOGIN_VAILED (TAG_LOGIN_BASE + 3)
#define TAG_LOGIN_SAVE   (TAG_LOGIN_BASE + 4)

#define ALERT_TITLE @"登录 提示"

@implementation UCLogin

@synthesize tableView=_tableView;
@synthesize bDownload;
@synthesize bModel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        bDownload = NO;
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

- (IBAction)btnSelectIsSavePasswd:(id)sender {
    if (toSave) {
      
        [isSaveBtn setImage:[UIImage imageNamed:@"check_or.png"] forState:UIControlStateNormal];   
    }
    else {
      
        [isSaveBtn setImage:[UIImage imageNamed:@"check_ok.png"] forState:UIControlStateNormal]; 
    }

    
    toSave = (!toSave);
   
    NSString *value = nil;
    if (toSave) {
        value = @"1";
        
    } else {
        value = @"0";
        [iOSApi cacheSetObject: API_CACHE_USERID value: @""];
        //[iOSApi cacheSetObject: API_CACHE_PASSWD value: @""];
    }
    NSLog(@"%@",value);
    [iOSApi cacheSetObject: API_CACHE_ISSAVE value: value];
}

// 返回上一个界面
- (void)goBack{
    if (!bModel) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        [self dismissModalViewControllerAnimated:YES];
    }
    
    //[self.navigationController popViewControllerAnimated:YES];
}

// 转向注册页面
- (IBAction)doReg:(id)sender{
    [regBtn setImage:[UIImage imageNamed:@"uc_reg_h.png"] forState:UIControlStateHighlighted]; 
    UCRegister *nextView = [[UCRegister alloc] init];
    [self.navigationController pushViewController:nextView animated:YES];
    [nextView release];
}
//写文本
- (IBAction)doWriteZH:(id)sender{
    [passwd resignFirstResponder];
    [userId becomeFirstResponder];
    userId.textColor = [UIColor blackColor];
    if([userId.text isEqualToString:@"账号"])
    {
     userId.text = @"";
    }
}
- (IBAction)doWriteMM:(id)sender{
    [passwd setSecureTextEntry:YES];
    [userId resignFirstResponder];
    [passwd becomeFirstResponder];
    passwd.textColor = [UIColor blackColor];
    if([passwd.text isEqualToString:@"密码"])
    {
        passwd.text = @"";
    }
    
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
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(110, 0, 100,44)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = UITextAlignmentCenter;
    label.font = [UIFont fontWithName:@"黑体" size:60];
    label.textColor = [UIColor blackColor];
    label.text= @"登录";
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
    /*
    _btnRight = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnRight.frame = CGRectMake(0, 0, 60, 32);
    [_btnRight setImage:[UIImage imageNamed:@"uc-reg2.png"] forState:UIControlStateNormal];
    [_btnRight setImage:[UIImage imageNamed:@"uc-reg2.png"] forState:UIControlStateHighlighted];
    [_btnRight addTarget:self action:@selector(doReg:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:_btnRight];
    self.navigationItem.rightBarButtonItem = rightItem;
    [rightItem release];
    */
    _borderStyle = UITextBorderStyleNone;
    font = [UIFont systemFontOfSize:13.0];
    
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [passwd setSecureTextEntry:YES];
    [userId resignFirstResponder];
    [passwd becomeFirstResponder];
	
	return YES;
}

- (BOOL)switchShouldReturn:(UISwitch *)field
{
	
    [passwd resignFirstResponder];
    [userId becomeFirstResponder];

	return YES;
}

- (void)authWaiting:(UITextField *)field {
#if 0
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSString *msg = [field.text trim];
    //[iOSApi showAlert:@"正在发送验证码..."];
    ucAuthCode *ac = [Api authcodeWithName:msg];
    //ucAuthCode *ac = [Api authcode];
    //[iOSApi closeAlert];
    
    if (ac.status == API_USERCENTET_SUCCESS) {
        srvAuthcode = ac.code;
        lbCode.text = srvAuthcode;
    } else {
        [iOSApi Alert:ALERT_TITLE message:ac.message];
    }
    [pool release];
#endif
}

// 文本框变动的时候
- (IBAction)textUpdate:(id)sender {
    UITextField *field = sender;        
    NSString *msg = [field.text trim];
    if (![iOSApi regexpMatch:msg withPattern:@"[0-9]{11}"]){
        // 非手机号码
        [iOSApi Alert:@"手机号码输入提示" message:@"非11位手机号码，请重新输入。"];
        [self switchShouldReturn:sender];
	} else {
		[self textFieldShouldReturn: sender];
	}
    
}

// 恢复数据到文本框
- (void)textRestore:(UITextField *)field {
    [field resignFirstResponder];
	/*
     int tag = [field tag];
    NSString *msg = [field.text trim];
    if (tag == TAG_LOGIN_NAME && msg.length >= ISP_PHONE_MAXLENGTH) {
        if ([iOSApi regexpMatch:msg withPattern:@"[0-9]{11}"]) {
            [NSThread detachNewThreadSelector:@selector(authWaiting:) toTarget:self withObject:field];
        } else {
            // 非手机号码
            [iOSApi Alert:@"手机号码输入提示" message:@"非11位手机号码，请重新输入。"];
            [userId becomeFirstResponder];
        }
	}
     */
}

- (void)testDataInit123{
    UserInfo *info = [Api user];
    info.userId = 1;
    info.userName = @"iOS测试者";
    info.nikeName = @"测试者1";
    info.phoneNumber = @"18632523200";
    info.password = @"123456";
}


// 登录
- (IBAction)doLogin:(id)sender {
    
    /*
    UCWebView *nextView = [[UCWebView alloc] init];
    nextView.webtitle = @"标题";
    nextView.weburl = @"http://baidu.com";
    [self.navigationController pushViewController:nextView animated:YES];
    [nextView release];
    */
   
    

    
     [loginBtn setImage:[UIImage imageNamed:@"uc_login_h.png"] forState:UIControlStateHighlighted];
    [userId resignFirstResponder];
    [passwd resignFirstResponder];
    BOOL bTestor = YES;
    NSString *uid = [[userId text] trim];
    NSString *pwd = [[passwd text] trim];
    NSString *authcode = [[vailed text] trim];
    if (!bTestor) {
        BOOL bRet = [iOSApi regexpMatch:uid withPattern:@"[0-9]{11}"];
        if (!bRet) {
            [iOSApi Alert:ALERT_TITLE message:@"手机号码格式有误，请重新输入。"];
            [userId becomeFirstResponder];
            return;
        }
        // 判断验证码
        if (![authcode isEqualToString:srvAuthcode]) {
            [iOSApi Alert:ALERT_TITLE message:@"验证码不正确"];
            [vailed becomeFirstResponder];
            return;
        }
        
    }
    [iOSApi showAlert:@"正在登录..."];
    ucLoginResult *iRet = [Api login:uid passwd:pwd authcode:authcode];
    [iOSApi closeAlert];
    if (iRet.status == 0) {
        if (isSavePasswd.isOn) {
            [[iOSApi cache] setObject:@"1" forKey:API_CACHE_ISSAVE];
        }
        [Api setPasswd:pwd];
        if (bDownload) {
            [iOSApi showAlert:@"登录成功, 返回商城"];
            //[self testDataInit];
            [self.navigationController popViewControllerAnimated:YES];
            bDownload = NO;
        } else {
            //[self testDataInit];
            [iOSApi showAlert:@"登录成功"];
            // 返回登录后页面, 用户中心
            [self goBack];
        }
        [iOSApi closeAlert];
    } else {
        if(iRet.status == 113)
        {
        [iOSApi showAlert:@"帐号密码错误"];
        [iOSApi closeAlert];
        }
        else {
            [iOSApi showAlert:iRet.message];
            [iOSApi closeAlert];
        }
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
        //清除高亮
     //   [forgetPwdBtn setImage:[UIImage imageNamed:@"forgetpwd.png"] forState:UIControlStateHighlighted];
        toSave = NO;
        NSString *sUserId = [Api userPhone];//[iOSApi objectForCache: API_CACHE_USERID];
        NSString *sPasswd = [Api passwd];//[iOSApi objectForCache: API_CACHE_PASSWD];
        NSString *flag = [iOSApi objectForCache: API_CACHE_ISSAVE];
        iOSInput *input = nil;
        input = [[iOSInput new] autorelease];
        [input setName:@"用户名"];
        [input setTag:TAG_LOGIN_NAME];
       
        userId.tag = input.tag;
        userId.text = sUserId;
        userId.returnKeyType = UIReturnKeyNext;
        userId.borderStyle = _borderStyle;
        userId.placeholder = @"输入手机号";
        userId.font = font;
        [input setObject: userId];
    
        input = [[iOSInput new] autorelease];
        [input setName:@"密码"];
        [input setTag:TAG_LOGIN_PASSWD];
   
        [passwd setSecureTextEntry:YES];
        passwd.tag = input.tag;
       // passwd.text = sPasswd;
        passwd.returnKeyType = UIReturnKeyDone;
    //userId.delegate = self;
        passwd.borderStyle = _borderStyle;
        passwd.placeholder = @"输入密码";
        passwd.font = font;
    
        [input setObject: passwd];
        
        if(sUserId != nil && ![sUserId isEqualToString:@""])
        {
            [userId setText:sUserId];
            userId.textColor = [UIColor blackColor];
        }
    
        if ([flag isEqualToString: @"1"]) {
            toSave = YES;
            if(sPasswd != nil && ![sPasswd isEqualToString:@""])
            {
            [passwd setSecureTextEntry:YES];
            passwd.textColor = [UIColor blackColor];
            [passwd setText: sPasswd];
            }
        } else {
            toSave = NO;
        }
    
    
    
    if (toSave) {
      
    [isSaveBtn setImage:[UIImage imageNamed:@"check_ok.png"] forState:UIControlStateNormal];   
    } else {
    [isSaveBtn setImage:[UIImage imageNamed:@"check_or.png"] forState:UIControlStateNormal]; 
    }
    
    //userId.keyboardType = UIKeyboardTypeNumberPad;
    userId.returnKeyType = UIReturnKeyNext;
    passwd.returnKeyType = UIReturnKeyDone;
        
}


- (IBAction)doForget:(id)sender{
   // [forgetPwdBtn setImage:[UIImage imageNamed:@"forgetpwd.png"] forState:UIControlStateHighlighted];   
    UCForget *nextView = [[UCForget alloc] init];
    [self.navigationController pushViewController:nextView animated:YES];
    [nextView release];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [userId resignFirstResponder];
    [passwd resignFirstResponder];
}

@end
