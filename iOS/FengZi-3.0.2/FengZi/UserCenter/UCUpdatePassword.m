//
//  UCUpdatePassword.m
//  FengZi
//
//  Created by  on 11-12-31.
//  Copyright (c) 2011年 iTotemStudio. All rights reserved.
//

#import "UCUpdatePassword.h"
#import "Api+UserCenter.h"

#define TAG_FIELD_BASE       (200400)
#define TAG_FIELD_PASSWD     (TAG_FIELD_BASE + 1)
#define TAG_FIELD_NEWPASSWD  (TAG_FIELD_BASE + 2)
#define TAG_FIELD_NEWPASSWD2 (TAG_FIELD_BASE + 3)

#define ALERT_TITLE @"修改密码 提示"

@implementation UCUpdatePassword

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

// 确认, 提交信息
- (IBAction)doAction:(id)sender {
    
    
    NSString *pwd = [passwd.text trim];
    NSLog(@"pwd....%@",pwd);
    NSString *npwd = [newpasswd.text trim];
    //NSString *npwd2 = [newpasswd2.text trim];
    
    // 密码长度判断
    if (pwd.length < 6 || pwd.length > 18) {
        [iOSApi Alert:ALERT_TITLE message:@"密码必须是6～18位的数字字母。"];
        [passwd becomeFirstResponder];
        return;
    }
    
    // 密码长度判断
    if (npwd.length < 6 || npwd.length > 18) {
        [iOSApi Alert:ALERT_TITLE message:@"密码必须是6～18位的数字字母。"];
        [newpasswd becomeFirstResponder];
        return;
    }
    /*
     // 密码长度判断
     if (npwd2.length < 6 || npwd2.length > 18) {
     [iOSApi Alert:ALERT_TITLE message:@"密码必须是6～18位的数字字母。"];
     [newpasswd2 becomeFirstResponder];
     return;
     }
     
     if (![npwd isEqualToString:npwd2]) {
     [iOSApi Alert:ALERT_TITLE message:@"两次输入的新密码不一致。"];
     [newpasswd becomeFirstResponder];
     return;
     }
     */
    [iOSApi showAlert:@"正在提交信息..."];
    ApiResult *iRet = [Api updatePassword:pwd newpasswd:npwd];
    [iOSApi closeAlert];
    NSString *msg = nil;
    if (iRet.status == API_USERCENTET_SUCCESS) {
        msg = @"修改成功";
        [Api setPasswd:npwd];
    } else {
        msg = iRet.message;
    }
    [iOSApi Alert:ALERT_TITLE message:msg];
}

#pragma mark - View lifecycle

-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    isShowPwd =NO;
    
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
    label.text= @"修改密码";
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
    
    // 设定UITableViewCell格式
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

// 文本框变动的时候
- (void)textUpdate:(id)sender {
	if ([sender isKindOfClass: [UITextField class]]) {
        UITextField *field = sender;
        
        NSString *msg = [field.text trim];
        int tag = [field tag];
        if (tag == TAG_FIELD_PASSWD && ![iOSApi regexpMatch:msg withPattern:@"[0-9]+"]) {
            //
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
    
    // 预加载项
    iOSInput *input = nil;
    CGRect frame = CGRectMake(0, 0, 5, 25);
    UIView *view = [[UIView alloc] initWithFrame:frame];
    UIView *view1 = [[UIView alloc] initWithFrame:frame];
    // 密码
    input = [[iOSInput new] autorelease];
    [input setName:@"原密码"];
    [input setTag:TAG_FIELD_PASSWD];
    
    passwd.leftView= view;
    passwd.leftViewMode = UITextFieldViewModeAlways;
    [passwd setSecureTextEntry:YES];
    passwd.tag = input.tag;
    passwd.returnKeyType = UIReturnKeyDone;
    passwd.borderStyle = _borderStyle;
    passwd.placeholder = @"输入原密码";
    passwd.font = font;
    // 绑定事件
    [passwd addTarget:self action:@selector(textRestore:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [passwd addTarget:self action:@selector(textUpdate:) forControlEvents:UIControlEventEditingChanged];
    [input setObject: passwd];
    
    
    // 新密码
    input = [[iOSInput new] autorelease];
    [input setName:@"新密码"];
    [input setTag:TAG_FIELD_NEWPASSWD];
    newpasswd.leftView= view1;
    newpasswd.leftViewMode = UITextFieldViewModeAlways;
    [newpasswd setSecureTextEntry:YES];
    newpasswd.tag = input.tag;
    newpasswd.returnKeyType = UIReturnKeyDone;
    newpasswd.borderStyle = _borderStyle;
    newpasswd.placeholder = @"输入新密码";
    newpasswd.font = font;
    // 绑定事件
    [newpasswd addTarget:self action:@selector(textRestore:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [newpasswd addTarget:self action:@selector(textUpdate:) forControlEvents:UIControlEventEditingChanged];
    [input setObject: newpasswd];
    
    [view release];
    [view1 release];
}


- (IBAction)showPwd:(id)sender event:(id)event {
    [newpasswd resignFirstResponder];
    isShowPwd = (!isShowPwd);
    if (isShowPwd) {
        UIImage *showimg = [UIImage imageNamed:@"uc-hide.png"];
        [showPwdBtn setImage:showimg forState:UIControlStateNormal];
        [newpasswd setSecureTextEntry:NO];
    }else {
        UIImage *hideimg = [UIImage imageNamed:@"uc-show.png"];
        [showPwdBtn setImage:hideimg forState:UIControlStateNormal];
        [newpasswd setSecureTextEntry:YES];
    }
    
    
}
@end
