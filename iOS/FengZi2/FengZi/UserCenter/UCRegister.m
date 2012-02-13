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
    NSString *pwd2 = [passwd2.text trim];
    NSString *acd = [[authcode text] trim];
    NSString *nicname = [nikename.text trim];
    BOOL bRet = [iOSApi regexpMatch:uid withPattern:@"[0-9]{11}"];
    if (!bRet) {
        [iOSApi Alert:ALERT_TITLE message:@"手机号码格式有误，请重新输入。"];
        [userId becomeFirstResponder];
        return;
    }
    if (![pwd isEqualToString:pwd2]) {
        [iOSApi Alert:ALERT_TITLE message:@"两次输入密码不相同，请重新输入。"];
        [passwd becomeFirstResponder];
        return;
    }
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
    if (![confirmProto isOn]) {
        [iOSApi Alert:ALERT_TITLE message:@"注册账号请先确定注册协议。"];
        return;
    }
    [iOSApi showAlert:@"正在注册..."];
    ucResult *iRet = [Api createId:uid passwd:pwd authcode:acd nikename:nicname];
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
#if API_INTERFACE_TEST
        srvAuthcode = API_TEST_AUTHCODE;
#endif
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
    if ([items count] == 0) {
        // 预加载项
        CGRect frame = CGRectMake(90.f, 8.0f, 120, 25);
        iOSInput *input = nil;
        items = [[NSMutableArray alloc] initWithCapacity:0];
                
        // 手机号
        input = [[iOSInput new] autorelease];
        [input setName:@"手机号"];
        [input setTag:TAG_REG_NAME];
        userId = [[UITextField alloc] initWithFrame:frame];
        userId.tag = input.tag;
		userId.returnKeyType = UIReturnKeyNext;
		userId.borderStyle = _borderStyle;
        userId.placeholder = @"输入手机号";
		userId.font = font;
        // 绑定事件
		[userId addTarget:self action:@selector(textRestore:) forControlEvents:UIControlEventEditingDidEndOnExit];
		[userId addTarget:self action:@selector(textUpdate:) forControlEvents:UIControlEventEditingChanged];
        [input setObject: userId];
        [items addObject: input];
        
        // 密码
        input = [[iOSInput new] autorelease];
        [input setName:@"密码"];
        [input setTag:TAG_REG_PASSWD];
        passwd = [[UITextField alloc] initWithFrame:frame];
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
        [items addObject: input];
        
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
        
        input = [[iOSInput new] autorelease];
        [input setName:@"短信验证码"];
        [input setTag:TAG_REG_AUTHCODE];
        authcode = [[UITextField alloc] initWithFrame:frame];
        authcode.tag = input.tag;
		authcode.returnKeyType = UIReturnKeyDone;
		authcode.borderStyle = _borderStyle;
        authcode.placeholder = @"输入短信验证码";
		authcode.font = font;
        // 绑定事件
		[authcode addTarget:self action:@selector(textRestore:) forControlEvents:UIControlEventEditingDidEndOnExit];
		[authcode addTarget:self action:@selector(textUpdate:) forControlEvents:UIControlEventEditingChanged];
        [input setObject: authcode];
        [items addObject: input];
        
        // 昵称
        input = [[iOSInput new] autorelease];
        [input setName:@"昵称"];
        [input setTag:TAG_REG_NKNAME];
        nikename = [[UITextField alloc] initWithFrame:frame];
        nikename.tag = input.tag;
		nikename.returnKeyType = UIReturnKeyDone;
		nikename.borderStyle = _borderStyle;
        nikename.placeholder = @"输入昵称";
		nikename.font = font;
        // 绑定事件
		[nikename addTarget:self action:@selector(textRestore:) forControlEvents:UIControlEventEditingDidEndOnExit];
		[nikename addTarget:self action:@selector(textUpdate:) forControlEvents:UIControlEventEditingChanged];
        [input setObject: nikename];
        [items addObject: input];
        
        // 注册协议
        input = [[iOSInput new] autorelease];
        [input setName:@"注册协议"];
        [input setTag:TAG_REG_PROTO];
        CGRect swFrame = frame;
        swFrame.origin.y = 3;
        confirmProto = [[UISwitch alloc] initWithFrame:swFrame];
        confirmProto.tag = input.tag;
		// 绑定事件
		[confirmProto addTarget:self action:@selector(textRestore:) forControlEvents:UIControlEventEditingDidEndOnExit];
		[confirmProto addTarget:self action:@selector(textUpdate:) forControlEvents:UIControlEventEditingChanged];
        
        [input setObject: confirmProto];
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
	return 30;
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
    CGRect frame = CGRectMake(200.f, 5.0f, 90, 25);
    if (obj.tag == TAG_REG_AUTHCODE) {
        // 密码区域, 点击忘记密码
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btn.frame = frame;
        NSString *btnText = @"获取验证码";
        [btn setTitle:btnText forState:UIControlStateNormal];
        [btn setTitle:btnText forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(getCheckCode:event:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:btn];
    } else if(obj.tag == TAG_REG_PROTO) {
        // 密码区域, 点击忘记密码
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btn.frame = frame;
        NSString *btnText = @"查看协议";
        [btn setTitle:btnText forState:UIControlStateNormal];
        [btn setTitle:btnText forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(readProto:event:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:btn];
    }
    [cell.contentView addSubview:[obj object]];
    return cell;
}

static int iTimes = -1;

// 阅读协议
- (void)readProto:(id)sender event:(id)event {
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
                [confirmProto setOn:YES];
			}
				break;
			default:
                [confirmProto setOn:NO];
				break;
		}
	} else if (iTimes == 1) {
        //
	}
}
- (void)getCheckCode:(id)sender event:(id)event {
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
#if API_INTERFACE_TEST
        srvAuthcode = API_TEST_AUTHCODE;
#endif
    }
    //[pool release];
}

@end
