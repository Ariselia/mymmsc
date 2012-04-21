//
//  EncodeSmsViewController.m
//  FengZi
//

//  Copyright (c) 2011年 iTotemStudio. All rights reserved.
//

#import "EncodeSmsViewController.h"
#import "EncodeEditViewController.h"
#import "Api+Category.h"

@implementation EncodeSmsViewController

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
-(void)generateCode{
    if (_contentText.text.length>110) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"文本不能大于110字！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        RELEASE_SAFELY(alertView);
        return;
    }
    if ([_receiverText.text isEqualToString:@""]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"接收人不能为空！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        RELEASE_SAFELY(alertView);
        return;
    }
    if (![CommonUtils validateCellPhone:_receiverText.text]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"电话格式不正确！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        RELEASE_SAFELY(alertView);
        return;
    }
    Shortmessage *sm = [[[Shortmessage alloc]init]autorelease];
    sm.cellphone = _receiverText.text;
    sm.contente = _contentText.text;
    EncodeEditViewController *editView =[[EncodeEditViewController alloc] initWithNibName:@"EncodeEditViewController" bundle:nil];
    if (![Api kma]) {
        [self.navigationController pushViewController:editView animated:YES];
        [editView loadObject:sm];
    } else {
        [editView viewDidLoad];
        [editView loadObject:sm];
        NSString *ss = editView.content;
        [Api uploadKma:ss];
        //[editView tapOnSaveBtn:nil];
    }
    [editView release];
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320,44)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = UITextAlignmentCenter;
    label.font = [UIFont fontWithName:@"黑体" size:60];
    label.textColor = [UIColor blackColor];
    label.text= @"短信生码";
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
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 60, 32);
    if ([Api kma]) {
        [btn setImage:[UIImage imageNamed:@"uc-save.png"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"uc-save.png"] forState:UIControlStateHighlighted];
    } else {
        [btn setImage:[UIImage imageNamed:@"generate_code.png"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"generate_code_tap.png"] forState:UIControlStateHighlighted];
    }
    [btn addTarget:self action:@selector(generateCode) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = item;
    [item release];
    
    _discribLabel = [[UILabel alloc] initWithFrame:CGRectMake(9, 7, 120, 20)];
    _discribLabel.font = [UIFont systemFontOfSize:14];
    _discribLabel.text = @"内容小于110字";
    _discribLabel.backgroundColor = [UIColor clearColor];
    _discribLabel.textColor = [UIColor colorWithWhite:0.8 alpha:1];
    [_contentText addSubview:_discribLabel];
    [_discribLabel release];
}

-(void)textViewDidChange:(UITextView *)textView{
    if ([_contentText hasText]) {
        _discribLabel.hidden =YES;
    }else{
        _discribLabel.hidden =NO;
    }
}
#pragma mark -
#pragma mark keyboardEvent

- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:) name:@"UIKeyboardWillHideNotification" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"UIKeyboardWillHideNotification" object:nil];
}

//隐藏键盘是屏幕动画
- (void)keyboardWillHide:(NSNotification*)notification {
    NSTimeInterval animationDuration = 0.3;
    CGRect frame = self.view.frame;
    frame.origin.y = 0;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = frame;
    [UIView commitAnimations];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [_receiverText resignFirstResponder];
    [_contentText resignFirstResponder];
}

-(void)viewDidDisappear:(BOOL)animated{
    [_receiverText resignFirstResponder];
    [_contentText resignFirstResponder];
}

- (IBAction)receiveEditBegin:(id)sender {
    NSTimeInterval animationDuration = 0.3;
    CGRect frame = self.view.frame;
    frame.origin.y = 0;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = frame;
    [UIView commitAnimations];
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    NSTimeInterval animationDuration = 0.3;
    CGRect frame = self.view.frame;
    frame.origin.y = -48;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = frame;
    [UIView commitAnimations];
    return YES;
}

- (void)viewDidUnload
{
    [_receiverText release];
    _receiverText = nil;
    [_contentText release];
    _contentText = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [_receiverText release];
    [_contentText release];
    [super dealloc];
}
@end
