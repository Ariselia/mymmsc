//
//  EncodeWeiboViewController.m
//  FengZi
//

//  Copyright (c) 2011年 iTotemStudio. All rights reserved.
//

#import "EncodeWeiboViewController.h"
#import "EncodeEditViewController.h"
#import "Weibo.h"
#import "BusDecoder.h"
@implementation EncodeWeiboViewController

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
    if ([_titleText.text isEqualToString:@""]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"标题不能为空！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        RELEASE_SAFELY(alertView);
        return;
    }
    if ([_webText.text isEqualToString:@""]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网址不能为空！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        RELEASE_SAFELY(alertView);
        return;
    }
    if (![BusDecoder isUrl:_webText.text]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网址格式不正确！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        RELEASE_SAFELY(alertView);
        return;
    }

    Weibo *wb = [[[Weibo alloc] init]autorelease];
    wb.title =_titleText.text;
    wb.url=_webText.text;
    EncodeEditViewController *editView =[[EncodeEditViewController alloc] initWithNibName:@"EncodeEditViewController" bundle:nil];
    [self.navigationController pushViewController:editView animated:YES];
    [editView loadObject:wb];
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
    label.text= @"微博生码";
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
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [_titleText resignFirstResponder];
    [_webText resignFirstResponder];
}

-(void)viewDidDisappear:(BOOL)animated{
    [_titleText resignFirstResponder];
    [_webText resignFirstResponder];
}

- (void)viewDidUnload
{
    [_titleText release];
    _titleText = nil;
    [_webText release];
    _webText = nil;
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
    [_titleText release];
    [_webText release];
    [super dealloc];
}
@end
