//
//  UCUpdateNikename.m
//  FengZi
//
//  Created by  on 11-12-31.
//  Copyright (c) 2011年 iTotemStudio. All rights reserved.
//

#import "UCUpdateNikename.h"
#import "Api+UserCenter.h"
#import "Api+eShop.h"

#define TAG_FIELD_BASE     (200300)
#define TAG_FIELD_PASSWD   (TAG_FIELD_BASE + 1) // 密码
#define TAG_FIELD_NKNAME   (TAG_FIELD_BASE + 2) // 昵称
#define TAG_FIELD_REALNAME (TAG_FIELD_BASE + 3) // 真实姓名
#define TAG_FIELD_SEX      (TAG_FIELD_BASE + 4) // 性别
#define TAG_FIELD_EMAIL    (TAG_FIELD_BASE + 5) // 邮箱地址
#define TAG_FIELD_BIRTHDAY (TAG_FIELD_BASE + 6) // 生日
#define TAG_FIELD_IDNUMBER (TAG_FIELD_BASE + 7) // 身份证号码
#define TAG_FIELD_ADDRESS  (TAG_FIELD_BASE + 8) // 通信地址
#define TAG_FIELD_POSTCODE (TAG_FIELD_BASE + 9) // 邮编
#define TAG_FIELD_ISOPEN   (TAG_FIELD_BASE + 10) // 是否公开
#define TAG_FIELD_WEIBO    (TAG_FIELD_BASE + 11) // 微博
#define TAG_FIELD_QQ       (TAG_FIELD_BASE + 12) // QQ号码
#define TAG_FIELD_CONTACT  (TAG_FIELD_BASE + 13) // 联系方式

#define ALERT_TITLE @"修改个人信息 提示"

@implementation UCUpdateNikename

@synthesize idDest;
@synthesize tableView = _tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.idDest = -1;
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
- (void)doSave {
    //NSString *uid = [[userId text] trim];
    //NSString *pwd = [[passwd text] trim];
    NSString *nkm = [nikename.text trim];
    NSString *sRealName = [realname.text trim];
    NSString *sSex = (sex.isOn == YES ? @"1" : @"0");
    NSString *sEmail = [email.text trim];
    NSString *sBirthday = [birthday.text trim];
    NSString *sIdNumber = [idNumber.text trim];
    NSString *sAddress = [address.text trim];
    NSString *sPostCode = [postCode.text trim];
    NSString *sLikes = [likes.text trim];
    NSString *sIsopen = (isopen.isOn ? @"1":@"0");
    NSString *sWeibo = [weibo.text trim];
    NSString *sQQ = [QQ.text trim];
    NSString *sContact = [contact.text trim];
    /*
    // 密码长度判断
    if (pwd.length < 6 || pwd.length > 18) {
        [iOSApi Alert:ALERT_TITLE message:@"密码必须是6～18位的数字字母。"];
        [passwd becomeFirstResponder];
        return;
    }
    
    // 昵称长度判断
    if (nkm.length < 6 || nkm.length > 18) {
        [iOSApi Alert:ALERT_TITLE message:@"昵称必须是6～18位的文字。"];
        [passwd becomeFirstResponder];
        return;
    }
    */
    [iOSApi showAlert:@"正在提交信息..."];
    //ApiResult *iRet = [Api updateNikename:pwd nikename:nkm];
    ApiResult *iRet = [Api uc_userinfo_set:sRealName sex:sSex email:sEmail birthday:sBirthday idNumber:sIdNumber address:sAddress postCode:sPostCode likes:sLikes isopen:sIsopen weibo:sWeibo QQ:sQQ contact:sContact];
    [iOSApi closeAlert];
    NSString *msg = nil;
    if (iRet.status == API_USERCENTET_SUCCESS) {
        [Api setNikeName:nkm];
        msg = @"修改成功";
    } else {
        msg = iRet.message;
    }
    [iOSApi Alert:ALERT_TITLE message:msg];
}

#pragma mark - View lifecycle

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
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(110, 0, 140, 44)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = UITextAlignmentCenter;
    label.font = [UIFont fontWithName:@"黑体" size:60];
    label.textColor = [UIColor blackColor];
    label.text= @"修改个人信息";
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
    
    UIButton *_btnRight = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnRight.frame = CGRectMake(0, 0, 60, 32);
    [_btnRight setImage:[UIImage imageNamed:@"uc-save.png"] forState:UIControlStateNormal];
    [_btnRight setImage:[UIImage imageNamed:@"uc-save.png"] forState:UIControlStateHighlighted];
    [_btnRight addTarget:self action:@selector(doSave) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:_btnRight];
    self.navigationItem.rightBarButtonItem = rightItem;
    [rightItem release];
    
    // 设定UITableViewCell格式
    _borderStyle = UITextBorderStyleRoundedRect;
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

#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	// the user pressed the "Done" button, so dismiss the keyboard
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
        if (tag == TAG_FIELD_NKNAME && ![iOSApi regexpMatch:msg withPattern:@"[0-9]+"]) {
            //
        }
	} else {
		[self switchShouldReturn: sender];
	}
}


// 恢复数据到文本框
- (void)textRestore:(UITextField *)textField {
    //[textField becomeFirstResponder];
    [textField resignFirstResponder];
    NSTimeInterval animationDuration = 0.3;
    CGRect frame = _tableView.frame;
    frame.size.height = 369;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    _tableView.frame = frame;
    [UIView commitAnimations];
}

- (void)editBegin:(UITextField *)textField event:(UIEvent *)event{
    NSTimeInterval animationDuration = 0.3;
    CGRect frame = _tableView.frame;
    frame.size.height = 160;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    _tableView.frame = frame;
    [UIView commitAnimations];
    int row = textField.tag;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [iOSApi showAlert:@"正在获取用户信息..."];
    int userId = [Api userId];
    BOOL bEdit = YES;
    if (idDest >= 0) {
        bEdit = NO;
        userId = idDest;
    }
    ucUserInfo *ucInfo = [[Api uc_userinfo_get:userId] retain];
    [iOSApi closeAlert];
    if ([items count] == 0) {
        // 预加载项
        CGRect frame = CGRectMake(90.f, 5.0f, 200, 25);
        iOSInput *input = nil;
        items = [[NSMutableArray alloc] initWithCapacity:0];
        
        // 昵称
        input = [[iOSInput new] autorelease];
        [input setName:@"昵称"];
        [input setTag:TAG_FIELD_NKNAME];
        nikename = [[UITextField alloc] initWithFrame:frame];
        nikename.text = [Api nikeName];
        nikename.tag = input.tag;
		nikename.returnKeyType = UIReturnKeyDone;
		nikename.borderStyle = _borderStyle;
        nikename.placeholder = @"输入昵称";
        nikename.font = font;
        [nikename setEnabled:bEdit];
		// 绑定事件
		[nikename addTarget:self action:@selector(textRestore:) forControlEvents:UIControlEventEditingDidEndOnExit];
		[nikename addTarget:self action:@selector(textUpdate:) forControlEvents:UIControlEventEditingChanged];
        [input setObject: nikename];
        [items addObject: input];
        
        // 帐户名
        input = [[iOSInput new] autorelease];
        [input setName:@"账号名"];
        [input setTag:TAG_FIELD_CONTACT];
        UILabel *ac = [[UILabel alloc] initWithFrame:frame];
        ac.text = ucInfo.contact;
        ac.tag = input.tag;
		ac.font = font;
        [ac setEnabled:bEdit];
		[input setObject: ac];
        [items addObject: input];
        
        input = [[iOSInput new] autorelease];
        [input setName:@"是否公开"];
        [input setTag:TAG_FIELD_ISOPEN];
        CGRect swFrame = frame;
        swFrame.origin.y = 3;
        isopen = [[UISwitch alloc] initWithFrame:swFrame];
        isopen.tag = input.tag;
        [isopen setOn:ucInfo.isopen];
        [isopen setEnabled:bEdit];
        [input setObject: isopen];
        [items addObject: input];
        
        // 姓名
        input = [[iOSInput new] autorelease];
        [input setName:@"姓名"];
        [input setTag:TAG_FIELD_REALNAME];
        realname = [[UITextField alloc] initWithFrame:frame];
        realname.text = ucInfo.realname;
        realname.tag = input.tag;
		realname.returnKeyType = UIReturnKeyDone;
		realname.borderStyle = _borderStyle;
        realname.placeholder = @"输入姓名";
        realname.font = font;
        [realname setEnabled:bEdit];
		// 绑定事件
		[realname addTarget:self action:@selector(editBegin:event:) forControlEvents:UIControlEventEditingDidBegin];
		
        [realname addTarget:self action:@selector(textRestore:) forControlEvents:UIControlEventEditingDidEndOnExit];
		[realname addTarget:self action:@selector(textUpdate:) forControlEvents:UIControlEventEditingChanged];
        [input setObject: realname];
        [items addObject: input];
        
        // 性别
        input = [[iOSInput new] autorelease];
        [input setName:@"性别(男)"];
        [input setTag:TAG_FIELD_SEX];
        swFrame = frame;
        swFrame.origin.y = 3;
        sex = [[UISwitch alloc] initWithFrame:swFrame];
        sex.tag = input.tag;
        [sex setOn:ucInfo.sex];
        [sex setEnabled:bEdit];
        [input setObject: sex];
        [items addObject: input];
        
        // 出生日期
        input = [[iOSInput new] autorelease];
        [input setName:@"出生日期"];
        [input setTag:TAG_FIELD_BIRTHDAY];
        birthday = [[UITextField alloc] initWithFrame:frame];
        birthday.text = ucInfo.realname;
        birthday.tag = input.tag;
		birthday.returnKeyType = UIReturnKeyDone;
		birthday.borderStyle = _borderStyle;
        birthday.placeholder = @"输入年月日";
        birthday.font = font;
        [birthday setEnabled:bEdit];
		// 绑定事件
        [birthday addTarget:self action:@selector(editBegin:event:) forControlEvents:UIControlEventEditingDidBegin];
		
		[birthday addTarget:self action:@selector(textRestore:) forControlEvents:UIControlEventEditingDidEndOnExit];
		[birthday addTarget:self action:@selector(textUpdate:) forControlEvents:UIControlEventEditingChanged];
        [input setObject: birthday];
        [items addObject: input];
        
        // 联系方式
        input = [[iOSInput new] autorelease];
        [input setName:@"联系方式"];
        [input setTag:TAG_FIELD_CONTACT];
        contact = [[UITextField alloc] initWithFrame:frame];
        contact.text = ucInfo.contact;
        contact.tag = input.tag;
		contact.returnKeyType = UIReturnKeyDone;
		contact.borderStyle = _borderStyle;
        contact.placeholder = @"输入联系方式";
        contact.font = font;
        [contact setEnabled:bEdit];
		// 绑定事件
        [contact addTarget:self action:@selector(editBegin:event:) forControlEvents:UIControlEventEditingDidBegin];
		
		[contact addTarget:self action:@selector(textRestore:) forControlEvents:UIControlEventEditingDidEndOnExit];
		[contact addTarget:self action:@selector(textUpdate:) forControlEvents:UIControlEventEditingChanged];
        [input setObject: contact];
        [items addObject: input];
        
        // 联系地址
        input = [[iOSInput new] autorelease];
        [input setName:@"联系地址"];
        [input setTag:TAG_FIELD_ADDRESS];
        address = [[UITextField alloc] initWithFrame:frame];
        address.text = ucInfo.address;
        address.tag = input.tag;
		address.returnKeyType = UIReturnKeyDone;
		address.borderStyle = _borderStyle;
        address.placeholder = @"输入联系地址";
        address.font = font;
        [address setEnabled:bEdit];
		// 绑定事件
        [address addTarget:self action:@selector(editBegin:event:) forControlEvents:UIControlEventEditingDidBegin];
		
		[address addTarget:self action:@selector(textRestore:) forControlEvents:UIControlEventEditingDidEndOnExit];
		[address addTarget:self action:@selector(textUpdate:) forControlEvents:UIControlEventEditingChanged];
        [input setObject: address];
        [items addObject: input];
        
        // 身份证号码
        input = [[iOSInput new] autorelease];
        [input setName:@"身份证号码"];
        [input setTag:TAG_FIELD_IDNUMBER];
        idNumber = [[UITextField alloc] initWithFrame:frame];
        idNumber.text = ucInfo.idNumber;
        idNumber.tag = input.tag;
		idNumber.returnKeyType = UIReturnKeyDone;
		idNumber.borderStyle = _borderStyle;
        idNumber.placeholder = @"输入身份证号码";
        idNumber.font = font;
        [idNumber setEnabled:bEdit];
		// 绑定事件
		[idNumber addTarget:self action:@selector(editBegin:event:) forControlEvents:UIControlEventEditingDidBegin];
		[idNumber addTarget:self action:@selector(textRestore:) forControlEvents:UIControlEventEditingDidEndOnExit];
		[idNumber addTarget:self action:@selector(textUpdate:) forControlEvents:UIControlEventEditingChanged];
        [input setObject: idNumber];
        [items addObject: input];
        
        // QQ
        input = [[iOSInput new] autorelease];
        [input setName:@"QQ号码"];
        [input setTag:TAG_FIELD_QQ];
        QQ = [[UITextField alloc] initWithFrame:frame];
        QQ.text = [NSString valueOf:ucInfo.QQ];
        QQ.tag = input.tag;
		QQ.returnKeyType = UIReturnKeyDone;
		QQ.borderStyle = _borderStyle;
        QQ.placeholder = @"输入身份证号码";
        QQ.font = font;
        [QQ setEnabled:bEdit];
        [QQ addTarget:self action:@selector(editBegin:event:) forControlEvents:UIControlEventEditingDidBegin];
		// 绑定事件
		[QQ addTarget:self action:@selector(textRestore:) forControlEvents:UIControlEventEditingDidEndOnExit];
		[QQ addTarget:self action:@selector(textUpdate:) forControlEvents:UIControlEventEditingChanged];
        /*
        QQ.keyboardType = UIKeyboardTypeDefault;
		QQ.returnKeyType = UIReturnKeyDone;	
		
		QQ.clearButtonMode = UITextFieldViewModeWhileEditing;	// has a clear 'x' button to the right
		
		// Add an accessibility label that describes the text field.
		[QQ setAccessibilityLabel:NSLocalizedString(@"CheckMarkIcon", @"")];
		
		//QQ.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"segment_check.png"]];
		QQ.leftViewMode = UITextFieldViewModeAlways;
		
		QQ.delegate = self;	// let us be the delegate so we know when the keyboard's "Done" button is pressed
         */
        [input setObject: QQ];
        [items addObject: input];
        
        // 处理所有文本输入框的被键盘挡住问题
        //[super unregisterForKeyboardNotifications];
    }
    [ucInfo release];
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
    for (UIView *view in [cell.contentView subviews]) {
        [view removeFromSuperview];
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
    //cell.textLabel.backgroundColor = [UIColor blueColor];
    //cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.accessoryType = UITableViewCellAccessoryNone;
    //[cell setBackgroundColor: [UIColor clearColor]];
    /*
    // 设定右边按钮
    CGRect frame = CGRectMake(200.f, 5.0f, 90, 25);
    if (obj.tag == TAG_FIELD_AUTHCODE) {
        // 密码区域, 点击忘记密码
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btn.frame = frame;
        NSString *btnText = @"获取验证码";
        [btn setTitle:btnText forState:UIControlStateNormal];
        [btn setTitle:btnText forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(getCheckCode:event:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:btn];
    }
     */
    [obj.object setTag:pos];
    [cell.contentView addSubview:[obj object]];
    return cell;
}
/*
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
    ucAuthCode *ac = [Api authcode];
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
*/
@end
