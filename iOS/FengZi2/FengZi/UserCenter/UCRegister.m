//
//  UCRegister.m
//  FengZi
//
//  Created by  on 11-12-27.
//  Copyright (c) 2011年 iTotemStudio. All rights reserved.
//

#import "UCRegister.h"
#import "Api+UserCenter.h"

#define TAG_REG_BASE     (200100)
#define TAG_REG_NAME     (TAG_REG_BASE + 1)
#define TAG_REG_PASSWD   (TAG_REG_BASE + 2)
#define TAG_REG_PASSWD2  (TAG_REG_BASE + 3)
#define TAG_REG_AUTHCODE (TAG_REG_BASE + 4)
#define TAG_REG_NKNAME   (TAG_REG_BASE + 5)
#define TAG_REG_PROTO    (TAG_REG_BASE + 6)

#define ALERT_TITLE @"注册 提示"

@implementation UCRegister

@synthesize tableView=_tableView;

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

- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)doRegister:(id)sender {
    NSString *uid = [[userId text] trim];
    NSString *pwd = [[passwd text] trim];
  //  NSString *pwd2 = [passwd2.text trim];
    NSString *acd = [[authcode text] trim];
    NSString *nicname = [nikename.text trim];
    BOOL bRet = [iOSApi regexpMatch:uid withPattern:@"[0-9]{11}"];
    if (!bRet) {
        [iOSApi Alert:ALERT_TITLE message:@"手机号码格式有误，请重新输入。"];
        [userId becomeFirstResponder];
        return;
    }
    /*
    if (![pwd isEqualToString:pwd2]) {
        [iOSApi Alert:ALERT_TITLE message:@"两次输入密码不相同，请重新输入。"];
        [passwd becomeFirstResponder];
        return;
    }
     */
    /*
     if (srvAuthcode == nil || srvAuthcode.length == 0) {
        [iOSApi Alert:ALERT_TITLE message:@"验证码无效，请点击 获取验证码。"];
        return;

    }
    // 判断验证码
    if (![acd isEqualToString:srvAuthcode]) {
        [iOSApi Alert:ALERT_TITLE message:@"验证码不正确"];
        [authcode becomeFirstResponder];
        return;
    }
     */
    // 判断协议
    if (!isCheck) {
        [iOSApi Alert:ALERT_TITLE message:@"注册账号请先确定注册协议。"];
        return;
    }
    [iOSApi showAlert:@"正在注册..."];
    ApiResult *iRet = [Api createId:uid passwd:pwd authcode:acd nikename:nicname];
    [iOSApi closeAlert];
    if (iRet.status == 0) {
        [iOSApi showAlert:@"注册成功"];
        // 返回登录后页面, 用户中心
        [self goBack];
        [iOSApi closeAlert];
    } else {
        [iOSApi showAlert:iRet.message];
        [iOSApi closeAlert];
    }
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    isCheck = YES;
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
    label.text= @"注册";
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
	[textField resignFirstResponder];
	return YES;
}

- (BOOL)switchShouldReturn:(UISwitch *)field
{
	//
	return YES;
}

#if UC_AUTHCODE_FROM_USERNAME
- (void)authWaiting:(UITextField *)field {
    //NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSString *msg = [field.text trim];
    BOOL bRet = [iOSApi regexpMatch:msg withPattern:@"[0-9]{11}"];
    if (!bRet) {
        [iOSApi Alert:ALERT_TITLE message:@"手机号码格式有误，请重新输入。"];
        [userId becomeFirstResponder];
        return;
    }
    [iOSApi showAlert:@"正在发送验证码..."];
    ucAuthCode *ac = [Api authcodeWithName:msg];
    //ucAuthCode *ac = [Api authcode];
    [iOSApi closeAlert];
    if (ac.status == API_USERCENTET_SUCCESS) {
        srvAuthcode = [ac.code retain];
    } else {
        [iOSApi Alert:ALERT_TITLE message:ac.message];
    }
    [iOSApi closeAlert];
    //[pool release];
}
#endif

// 文本框变动的时候
- (void)textUpdate:(id)sender {
	if ([sender isKindOfClass: [UITextField class]]) {
        UITextField *field = sender;
        
        NSString *msg = [field.text trim];
        int tag = [field tag];
        if (tag == TAG_REG_NAME && ![iOSApi regexpMatch:msg withPattern:@"[0-9]+"]) {
            //
        }
        if (tag == TAG_REG_NAME && msg.length >= ISP_PHONE_MAXLENGTH) {
            if ([iOSApi regexpMatch:msg withPattern:@"[0-9]{11}"]) {
                [field resignFirstResponder];
#if UC_AUTHCODE_FROM_USERNAME
                //[NSThread detachNewThreadSelector:@selector(authWaiting:) toTarget:self withObject:field];
                //[self authWaiting:field];
#endif
            } else {
                // 非手机号码
                [iOSApi Alert:@"手机号码输入提示" message:@"非11位手机号码，请重新输入。"];
                [userId becomeFirstResponder];
            }
        }
	} else {
		[self switchShouldReturn: sender];
	}
}


// 恢复数据到文本框
- (void)textRestore:(UITextField *)textField {
    [textField resignFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated {
    isShowPwd = NO;
        CGRect frame = CGRectMake(0, 0, 5, 25);
        UIView *view = [[UIView alloc] initWithFrame:frame];
        UIView *view1 = [[UIView alloc] initWithFrame:frame];
        UIView *view2 = [[UIView alloc] initWithFrame:frame];
        UIView *view3 = [[UIView alloc] initWithFrame:frame];
        iOSInput *input = nil;
        // 手机号
        input = [[iOSInput new] autorelease];
        [input setName:@"手机号"];
        [input setTag:TAG_REG_NAME];
        userId.leftView = view;
        userId.leftViewMode = UITextFieldViewModeAlways;
        userId.tag = input.tag;
		userId.returnKeyType = UIReturnKeyNext;
		userId.borderStyle = _borderStyle;
        userId.placeholder = @"输入手机号";
		userId.font = font;
        // 绑定事件
		[userId addTarget:self action:@selector(textRestore:) forControlEvents:UIControlEventEditingDidEndOnExit];
		[userId addTarget:self action:@selector(textUpdate:) forControlEvents:UIControlEventEditingChanged];
        [input setObject: userId];
               
        // 密码
        input = [[iOSInput new] autorelease];
        [input setName:@"密码"];
        [input setTag:TAG_REG_PASSWD];
        passwd.leftView = view1;
        passwd.leftViewMode = UITextFieldViewModeAlways;

        [passwd setSecureTextEntry:YES];
        passwd.tag = input.tag;
		passwd.returnKeyType = UIReturnKeyDone;
		passwd.borderStyle = _borderStyle;
		passwd.placeholder = @"输入密码";
        passwd.font = font;
        // 绑定事件
		[passwd addTarget:self action:@selector(textRestore:) forControlEvents:UIControlEventEditingDidEndOnExit];
		[passwd addTarget:self action:@selector(textUpdate:) forControlEvents:UIControlEventEditingChanged];
        [input setObject: passwd];
        
        
        /*
        // 确认密码
        input = [[iOSInput new] autorelease];
        [input setName:@"确认密码"];
        [input setTag:TAG_REG_PASSWD2];
        passwd2 = [[UITextField alloc] initWithFrame:frame];
        [passwd2 setSecureTextEntry:YES];
        passwd2.tag = input.tag;
		passwd2.returnKeyType = UIReturnKeyDone;
		passwd2.borderStyle = _borderStyle;
        passwd2.placeholder = @"再输入一遍密码";
        passwd2.font = font;
		// 绑定事件
		[passwd2 addTarget:self action:@selector(textRestore:) forControlEvents:UIControlEventEditingDidEndOnExit];
		[passwd2 addTarget:self action:@selector(textUpdate:) forControlEvents:UIControlEventEditingChanged];
        [input setObject: passwd2];
        [items addObject: input];
        */
        input = [[iOSInput new] autorelease];
        [input setName:@"短信验证码"];
        [input setTag:TAG_REG_AUTHCODE];
       
        authcode.leftView = view2;
        authcode.leftViewMode = UITextFieldViewModeAlways;
        authcode.tag = input.tag;
		authcode.returnKeyType = UIReturnKeyDone;
		authcode.borderStyle = _borderStyle;
        authcode.placeholder = @"输入短信验证码";
		authcode.font = font;
        // 绑定事件
		[authcode addTarget:self action:@selector(textRestore:) forControlEvents:UIControlEventEditingDidEndOnExit];
		[authcode addTarget:self action:@selector(textUpdate:) forControlEvents:UIControlEventEditingChanged];
        [input setObject: authcode];
        
        
        // 昵称
        input = [[iOSInput new] autorelease];
        [input setName:@"昵称"];
        [input setTag:TAG_REG_NKNAME];
        nikename.leftView = view3;
        nikename.leftViewMode = UITextFieldViewModeAlways;
        nikename.tag = input.tag;
		nikename.returnKeyType = UIReturnKeyDone;
		nikename.borderStyle = _borderStyle;
        nikename.placeholder = @"输入昵称";
		nikename.font = font;
        // 绑定事件
		[nikename addTarget:self action:@selector(textRestore:) forControlEvents:UIControlEventEditingDidEndOnExit];
		[nikename addTarget:self action:@selector(textUpdate:) forControlEvents:UIControlEventEditingChanged];
        [input setObject: nikename];
       
        [view release];
        [view1 release];
        [view2 release];
        [view3 release];
    
}


static int iTimes = -1;
- (IBAction)showPwd:(id)sender event:(id)event {
    [passwd resignFirstResponder];
    isShowPwd = (!isShowPwd);
    if (isShowPwd) {
      UIImage *showimg = [UIImage imageNamed:@"uc-hide.png"];
      [showPwdBtn setImage:showimg forState:UIControlStateNormal];
        [passwd setSecureTextEntry:NO];
    }else {
        UIImage *hideimg = [UIImage imageNamed:@"uc-show.png"];
        [showPwdBtn setImage:hideimg forState:UIControlStateNormal];
        [passwd setSecureTextEntry:YES];
    }
     
    
}
// 阅读协议
- (IBAction)readProto:(id)sender event:(id)event {
    iTimes = 0;
    NSString *filename = @"protocol.txt";
    filename = [[NSBundle mainBundle] pathForResource:@"protocol" ofType:@"txt"];
    NSError *error = nil;
    NSString *proto = [[NSString alloc] initWithContentsOfFile:filename encoding:NSUTF8StringEncoding error:&error];
    UIAlertView *alert = [[UIAlertView alloc]
						  initWithTitle:@"蜂子协议"
						  message:[NSString stringWithFormat:proto]
						  delegate:self
						  cancelButtonTitle:@"不同意"
						  otherButtonTitles:@"同意", nil];
    //UITextView *text = [[UITextView alloc] initWithFrame:CGRectMake(5, 50, 280, 120)];
    //[text setText:proto];
    [proto release];
    //[alert addSubview:text];
    [alert show];
    [alert release];
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger) buttonIndex {
	if (iTimes == 0) {
		switch (buttonIndex) {
			case 1:
			{
                // 同意协议
                isCheck = YES;
                UIImage *isOKImg =[UIImage imageNamed:@"check_ok.png"];
                [isCheckBtn setImage:isOKImg forState:UIControlStateNormal];
			}
				break;
			default:
                isCheck= NO;
                UIImage *isNOImg =[UIImage imageNamed:@"check_or.png"];
                [isCheckBtn setImage:isNOImg forState:UIControlStateNormal];

				break;
		}
	} else if (iTimes == 1) {
        //
	}
}
- (IBAction)getCheckCode:(id)sender event:(id)event {
    //NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSString *msg = [userId.text trim];
    BOOL bRet = [iOSApi regexpMatch:msg withPattern:@"[0-9]{11}"];
    if (!bRet) {
        [iOSApi Alert:ALERT_TITLE message:@"手机号码格式有误，请重新输入。"];
        [userId becomeFirstResponder];
        return;
    }
    [iOSApi showAlert:@"正在发送验证码..."];
    ucAuthCode *ac = [Api authcodeWithName:msg];
    //ucAuthCode *ac = [Api authcode];
    [iOSApi closeAlert];
    if (ac.status == API_USERCENTET_SUCCESS) {
        srvAuthcode = ac.code;
    } else {
        [iOSApi Alert:ALERT_TITLE message:ac.message];
    }
    //[pool release];
}
- (IBAction)doOK:(id)sender
{
    isCheck = (!isCheck);
    if (isCheck) {
        UIImage *isOKImg =[UIImage imageNamed:@"check_ok.png"];
        [isCheckBtn setImage:isOKImg forState:UIControlStateNormal];
    }
    else {
        UIImage *isNOImg =[UIImage imageNamed:@"check_or.png"];
        [isCheckBtn setImage:isNOImg forState:UIControlStateNormal];
    }
}
@end
