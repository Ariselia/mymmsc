//
//  UCForget.m
//  FengZi
//
//  Created by  on 11-12-30.
//  Copyright (c) 2011年 iTotemStudio. All rights reserved.
//

#import "UCForget.h"
#import "Api+UserCenter.h"
#import "UCRegister.h"
#import "UITableViewCellExt.h"

#define TAG_FIELD_BASE     (200200)
#define TAG_FIELD_NAME     (TAG_FIELD_BASE + 1)
#define TAG_FIELD_PASSWD   (TAG_FIELD_BASE + 2)
#define TAG_FIELD_PASSWD2  (TAG_FIELD_BASE + 3)
#define TAG_FIELD_AUTHCODE (TAG_FIELD_BASE + 4)
#define TAG_FIELD_NKNAME   (TAG_FIELD_BASE + 5)
#define TAG_FIELD_PROTO    (TAG_FIELD_BASE + 6)

#define ALERT_TITLE @"忘记密码 提示"

@implementation UCForget

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

-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)doReg:(id)sender{
    UCRegister *nextView = [[UCRegister alloc] init];
    [self.navigationController pushViewController:nextView animated:YES];
    [nextView release];
}

// 确认, 提交信息
- (IBAction)doAction:(id)sender {
    NSString *uid = [[userId text] trim];
    NSString *pwd = [[passwd text] trim];
    NSString *pwd2 = [passwd2.text trim];
    NSString *acd = [[authcode text] trim];
   
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
    [iOSApi showAlert:@"正在提交信息..."];
    [Api forget:uid passwd:pwd newpasswd:pwd authcode:acd];
    if ([Api forget:uid passwd:pwd newpasswd:pwd authcode:acd].status != API_USERCENTET_SUCCESS) {
        [iOSApi closeAlert];
        [iOSApi Alert:@"提交信息" message:@"失败"];
        return;
        
    }else {
        [iOSApi closeAlert];        
        [iOSApi Alert:@"提交信息" message:@"成功"];
        [self goBack];
        
    }
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIImageView * bg = [[UIImageView alloc]initWithImage:[[UIImage imageNamed:@"uc_backg.png"]toSize:CGSizeMake(320, 480)]];
    [self.view bringSubviewToFront:bg];
    [bg release];
    
    
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
    label.text= @"忘记密码";
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
    
    // 设定UITableViewCell格式
    _borderStyle = UITextBorderStyleNone;
    font = [UIFont systemFontOfSize:15.0];
    
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
    //NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSString *msg = [field.text trim];
    BOOL bRet = [iOSApi regexpMatch:msg withPattern:@"[0-9]{11}"];
    if (!bRet) {
        [iOSApi Alert:ALERT_TITLE message:@"手机号码格式有误，请重新输入。"];
        [userId becomeFirstResponder];
        return;
    }
    [iOSApi showAlert:@"正在发送验证码..."];
    //ucAuthCode *ac = [Api authcodeWithName:msg];
    ucAuthCode *ac = [Api authcode:msg];
    [iOSApi closeAlert];
    if (ac.status == API_USERCENTET_SUCCESS) {
        srvAuthcode = [ac.code retain];
        [authcode setText:srvAuthcode];
    } else {
        //[iOSApi Alert:@"提示" message:ac.message];
    }
    [iOSApi closeAlert];
    //[pool release];
}

// 文本框变动的时候
- (void)textUpdate:(id)sender {
	if ([sender isKindOfClass: [UITextField class]]) {
        UITextField *field = sender;
        
        NSString *msg = [field.text trim];
        int tag = [field tag];
        if (tag == TAG_FIELD_NAME && ![iOSApi regexpMatch:msg withPattern:@"[0-9]+"]) {
            //
        }
        if (tag == TAG_FIELD_NAME && msg.length >= ISP_PHONE_MAXLENGTH) {
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
        CGRect frame = CGRectMake(87.f, 10.0f, 155, 31);
        iOSInput *input = nil;
        
        UIImage * image = [[UIImage imageNamed:@"uc-text-f.png"]toSize:CGSizeMake(155, 31)];
        items = [[NSMutableArray alloc] initWithCapacity:0];
        
        // 手机号
        input = [[iOSInput new] autorelease];
        [input setName:@"手机号"];
        [input setTag:TAG_FIELD_NAME];
        
        userId = [[UITextField alloc] initWithFrame:frame];
        userId.background =image;
        userId.tag = input.tag;
        userId.returnKeyType = UIReturnKeyNext;
		userId.borderStyle = _borderStyle;
        userId.placeholder = @"输入手机号";
        userId.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		userId.font = font;
        // 绑定事件
		[userId addTarget:self action:@selector(textRestore:) forControlEvents:UIControlEventEditingDidEndOnExit];
		[userId addTarget:self action:@selector(textUpdate:) forControlEvents:UIControlEventEditingChanged];
        [input setObject: userId];
        [items addObject: input];
        
        input = [[iOSInput new] autorelease];
        [input setName:@"短信验证码"];
        [input setTag:TAG_FIELD_AUTHCODE];
        authcode = [[UITextField alloc] initWithFrame:frame];
        authcode.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        authcode.background = image;
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
        
        // 密码
        input = [[iOSInput new] autorelease];
        [input setName:@"新密码"];
        [input setTag:TAG_FIELD_PASSWD];
        passwd = [[UITextField alloc] initWithFrame:frame];
        passwd.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        passwd.background = image;
        [passwd setSecureTextEntry:YES];
        passwd.tag = input.tag;
		passwd.returnKeyType = UIReturnKeyDone;
		passwd.borderStyle = _borderStyle;
		passwd.placeholder = @"输入新密码";
        passwd.font = font;
        // 绑定事件
		[passwd addTarget:self action:@selector(textRestore:) forControlEvents:UIControlEventEditingDidEndOnExit];
		[passwd addTarget:self action:@selector(textUpdate:) forControlEvents:UIControlEventEditingChanged];
        [input setObject: passwd];
        [items addObject: input];
        
        // 确认密码
        input = [[iOSInput new] autorelease];
        [input setName:@"确认密码"];
        [input setTag:TAG_FIELD_PASSWD2];
        passwd2 = [[UITextField alloc] initWithFrame:frame];
        passwd2.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        passwd2.background = image;
        [passwd2 setSecureTextEntry:YES];
        passwd2.tag = input.tag;
		passwd2.returnKeyType = UIReturnKeyDone;
		passwd2.borderStyle = _borderStyle;
        passwd2.placeholder = @"再输入一遍新密码";
        passwd2.font = font;
		// 绑定事件
		[passwd2 addTarget:self action:@selector(textRestore:) forControlEvents:UIControlEventEditingDidEndOnExit];
		[passwd2 addTarget:self action:@selector(textUpdate:) forControlEvents:UIControlEventEditingChanged];
        [input setObject: passwd2];
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
	return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIImage *image = [[UIImage imageNamed:@"uc-cell.png"] toSize: CGSizeMake(320, 50)];
    
    [cell setBackgroundImage:image];

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
    
    cell.textLabel.backgroundColor=[UIColor clearColor];
    cell.textLabel.font = font;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    // 设定右边按钮
    CGRect frame = CGRectMake(250.f, 13.0f, 64, 25);
    if (obj.tag == TAG_FIELD_AUTHCODE) {
        // 密码区域, 点击忘记密码
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = frame;
        [btn setImage:[UIImage imageNamed:@"uc_checkBtn_tap.png"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"uc_checkBtn.png"] forState:UIControlStateHighlighted];
        NSString *btnText = @"获取验证码";
        [btn setTitle:btnText forState:UIControlStateNormal];
        [btn setTitle:btnText forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(getCheckCode:event:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:btn];
    }
    [cell.contentView addSubview:[obj object]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [userId resignFirstResponder];
    [passwd resignFirstResponder];
    [passwd2 resignFirstResponder];
    [authcode resignFirstResponder];
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
    //ucAuthCode *ac = [Api authcodeWithName:msg];
    ucAuthCode *ac = [Api authcode:msg];
    [iOSApi closeAlert];
    if (ac.status == API_USERCENTET_SUCCESS) {
        srvAuthcode = ac.code;
    } else {
        [iOSApi Alert:@"提示" message:ac.message];
    }
    //[pool release];
}


@end
