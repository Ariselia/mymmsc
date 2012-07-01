//
//  EncodeTextViewController.m
//  FengZi
//

//  Copyright (c) 2011年 iTotemStudio. All rights reserved.
//

#import "EncodeTextViewController.h"
#import "EncodeEditViewController.h"
#import <FengZi/Api+Category.h>

@implementation EncodeTextViewController

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

- (void)generateCode{
    if (_contentText.text.length>110) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"文本不能大于110字！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        RELEASE_SAFELY(alertView);
        return;
    }
    if ([_contentText.text isEqualToString:@""]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"文本不能为空！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        RELEASE_SAFELY(alertView);
        return;
    }
    Text *t  = [[[Text alloc]init]autorelease];
    t.content =_contentText.text;
    EncodeEditViewController *editView =[[EncodeEditViewController alloc] initWithNibName:@"EncodeEditViewController" bundle:nil];
    if (![Api kma]) {
        [self.navigationController pushViewController:editView animated:YES];
        [editView loadObject:t];
    } else {
        [editView viewDidLoad];
        [editView loadObject:t];
        NSString *ss = editView.content;
        [Api uploadKma:ss];
        //[editView tapOnSaveBtn:nil];
    }
    RELEASE_SAFELY(editView);
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
    label.text= @"文本生码";
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
    if ([self kmaContent] != nil) {
        _discribLabel.text = [self kmaContent];
    }
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
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [_contentText resignFirstResponder];
}

-(void)viewDidDisappear:(BOOL)animated{
    [_contentText resignFirstResponder];
}

- (void)viewDidUnload
{
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
    [_contentText release];
    [super dealloc];
}
@end
