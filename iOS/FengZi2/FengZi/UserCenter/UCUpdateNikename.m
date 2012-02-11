//
//  UCUpdateNikename.m
//  FengZi
//
//  Created by  on 11-12-31.
//  Copyright (c) 2011年 iTotemStudio. All rights reserved.
//

#import "UCUpdateNikename.h"
#import "Api+UserCenter.h"

#define TAG_FIELD_BASE     (200300)
#define TAG_FIELD_PASSWD   (TAG_FIELD_BASE + 1)
#define TAG_FIELD_NKNAME   (TAG_FIELD_BASE + 2)

#define ALERT_TITLE @"修改昵称 提示"

@implementation UCUpdateNikename

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
    //NSString *uid = [[userId text] trim];
    NSString *pwd = [[passwd text] trim];
    NSString *nkm = [nikename.text trim];
    //NSString *acd = [[authcode text] trim];
    
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
    
    [iOSApi showAlert:@"正在提交信息..."];
    ucResult *iRet = [Api updateNikename:pwd nikename:nkm];
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
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(110, 0, 100,44)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = UITextAlignmentCenter;
    label.font = [UIFont fontWithName:@"黑体" size:60];
    label.textColor = [UIColor blackColor];
    label.text= @"修改昵称";
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
        if (tag == TAG_FIELD_NKNAME && ![iOSApi regexpMatch:msg withPattern:@"[0-9]+"]) {
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
    if ([items count] == 0) {
        // 预加载项
        CGRect frame = CGRectMake(90.f, 8.0f, 120, 25);
        iOSInput *input = nil;
        items = [[NSMutableArray alloc] initWithCapacity:0];
        
        // 密码
        input = [[iOSInput new] autorelease];
        [input setName:@"密码"];
        [input setTag:TAG_FIELD_PASSWD];
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
        
        // 昵称
        input = [[iOSInput new] autorelease];
        [input setName:@"昵称"];
        [input setTag:TAG_FIELD_NKNAME];
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
