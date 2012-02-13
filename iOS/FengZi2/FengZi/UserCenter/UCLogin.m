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

#define TAG_LOGIN_BASE   (200000)
#define TAG_LOGIN_NAME   (TAG_LOGIN_BASE + 1)
#define TAG_LOGIN_PASSWD (TAG_LOGIN_BASE + 2)
#define TAG_LOGIN_VAILED (TAG_LOGIN_BASE + 3)
#define TAG_LOGIN_SAVE   (TAG_LOGIN_BASE + 4)

#define ALERT_TITLE @"登录 提示"

@implementation UCLogin

@synthesize tableView=_tableView;
@synthesize bDownload;

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

// 返回上一个界面
- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

// 转向注册页面
- (void)doReg:(id)sender{
    UCRegister *nextView = [[UCRegister alloc] init];
    [self.navigationController pushViewController:nextView animated:YES];
    [nextView release];
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
    
    _btnRight = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnRight.frame = CGRectMake(0, 0, 60, 32);
    [_btnRight setImage:[UIImage imageNamed:@"uc-reg2.png"] forState:UIControlStateNormal];
    [_btnRight setImage:[UIImage imageNamed:@"uc-reg2.png"] forState:UIControlStateHighlighted];
    [_btnRight addTarget:self action:@selector(doReg:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:_btnRight];
    self.navigationItem.rightBarButtonItem = rightItem;
    [rightItem release];
    
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
- (void)textUpdate:(id)sender {
	if ([sender isKindOfClass: [UITextField class]]) {
        UITextField *field = sender;
        
        NSString *msg = [field.text trim];
        int tag = [field tag];
        if (tag == TAG_LOGIN_NAME && ![iOSApi regexpMatch:msg withPattern:@"[0-9]+"]) {
            //
        }
        if (tag == TAG_LOGIN_NAME && msg.length >= ISP_PHONE_MAXLENGTH) {
            if ([iOSApi regexpMatch:msg withPattern:@"[0-9]{11}"]) {
                [field resignFirstResponder];
#if UC_AUTHCODE_FROM_USERNAME
                [NSThread detachNewThreadSelector:@selector(authWaiting:) toTarget:self withObject:field];
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

- (void)testDataInit{
    UserInfo *info = [Api user];
    info.userId = 1;
    info.userName = @"iOS测试者";
    info.nikeName = @"测试者1";
    info.phoneNumber = @"18632523200";
    info.password = @"123456";
}


// 登录
- (IBAction)doLogin:(id)sender {
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
        [iOSApi showAlert:iRet.message];
        [iOSApi closeAlert];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    if ([items count] == 0) {
        // 预加载项
        CGRect frame = CGRectMake(90.f, 8.0f, 120, 25);
        iOSInput *input = nil;
        items = [[NSMutableArray alloc] initWithCapacity:0];
        
        input = [[iOSInput new] autorelease];
        [input setName:@"用户名"];
        [input setTag:TAG_LOGIN_NAME];
        userId = [[UITextField alloc] initWithFrame:frame];
        userId.tag = input.tag;
		userId.returnKeyType = UIReturnKeyNext;
		userId.borderStyle = _borderStyle;
        userId.placeholder = @"输入手机号";
        userId.font = font;
		// 绑定事件
		//[userId addTarget:self action:@selector(textRestore:) forControlEvents:UIControlEventEditingDidEndOnExit];
		[userId addTarget:self action:@selector(textRestore:) forControlEvents:UIControlEventEditingDidEnd];
		[userId addTarget:self action:@selector(textUpdate:) forControlEvents:UIControlEventEditingChanged];
        [input setObject: userId];
        [items addObject: input];
        
        input = [[iOSInput new] autorelease];
        [input setName:@"密码"];
        [input setTag:TAG_LOGIN_PASSWD];
        passwd = [[UITextField alloc] initWithFrame:frame];
        [passwd setSecureTextEntry:YES];
        passwd.tag = input.tag;
		passwd.returnKeyType = UIReturnKeyDone;
		//userId.delegate = self;
		passwd.borderStyle = _borderStyle;
        passwd.placeholder = @"输入密码";
        passwd.font = font;
		// 绑定事件
		[passwd addTarget:self action:@selector(textRestore:) forControlEvents:UIControlEventEditingDidEndOnExit];
		//[passwd addTarget:self action:@selector(textUpdate:) forControlEvents:UIControlEventEditingChanged];
        [input setObject: passwd];
        [items addObject: input];
        
        /*
        input = [[iOSInput new] autorelease];
        [input setName:@"验证码"];
        [input setTag:TAG_LOGIN_VAILED];
        vailed = [[UITextField alloc] initWithFrame:frame];
        //[vailed setSecureTextEntry:YES];
        vailed.tag = input.tag;
		vailed.returnKeyType = UIReturnKeyDone;
		//userId.delegate = self;
        vailed.placeholder = @"输入验证码";
		vailed.borderStyle = _borderStyle;
        vailed.font = font;
		// 绑定事件
		[vailed addTarget:self action:@selector(textRestore:) forControlEvents:UIControlEventEditingDidEndOnExit];
		//[vailed addTarget:self action:@selector(textUpdate:) forControlEvents:UIControlEventEditingChanged];
        
        [input setObject: vailed];
        [items addObject: input];
        */
        input = [[iOSInput new] autorelease];
        [input setName:@"记住密码"];
        [input setTag:TAG_LOGIN_SAVE];
        CGRect swFrame = frame;
        swFrame.origin.y = 3;
        isSavePasswd = [[UISwitch alloc] initWithFrame:swFrame];
        //[vailed setSecureTextEntry:YES];
        isSavePasswd.tag = input.tag;
		//isSavePasswd.returnKeyType = UIReturnKeyDone;
		//userId.delegate = self;
		//isSavePasswd.borderStyle = UITextBorderStyleBezel;
        // 绑定事件
		//[isSavePasswd addTarget:self action:@selector(textRestore:) forControlEvents:UIControlEventEditingDidEndOnExit];
		//[isSavePasswd addTarget:self action:@selector(textUpdate:) forControlEvents:UIControlEventEditingChanged];
        
        [input setObject: isSavePasswd];
        [items addObject: input];
    }
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //return 2;
    return [items count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 36;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    // Configure the cell.
    int pos = [indexPath row];
    if (pos >= [items count]) {
        //[cell release];
        return nil;
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    iOSInput *obj = [items objectAtIndex: pos];
    // 设定标题
    cell.textLabel.text = [NSString stringWithFormat:@"%-20@", [obj name]];
    cell.textLabel.font = font;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.accessoryType = UITableViewCellAccessoryNone;
    [cell setBackgroundColor: [UIColor clearColor]];
    // 设定右边按钮
    CGRect frame = CGRectMake(220.f, 5.0f, 70, 25);
    if (obj.tag == TAG_LOGIN_VAILED) {
        // 验证码
        lbCode = [[[UILabel alloc] initWithFrame:frame] autorelease];
        lbCode.text = @"----";
        [cell.contentView addSubview:lbCode];
    } else if (obj.tag == TAG_LOGIN_PASSWD) {
        // 密码区域, 点击忘记密码
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btn.frame = frame;
        NSString *btnText = @"忘记密码";
        [btn setTitle:btnText forState:UIControlStateNormal];
        [btn setTitle:btnText forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(doForget:event:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:btn];
        //[btn release];
    }
    
    [cell.contentView addSubview:[obj object]];
    return cell;
}

- (void)doForget:(id)sender event:(id)event {
    UCForget *nextView = [[UCForget alloc] init];
    [self.navigationController pushViewController:nextView animated:YES];
    [nextView release];
}

@end
