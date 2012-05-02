//
//  EBuyEvaluatePage.m
//  FengZi
//
//  Created by wangfeng on 12-5-2.
//  Copyright (c) 2012年 ifengzi.cn. All rights reserved.
//

#import "EBuyEvaluatePage.h"
#import "Api+Ebuy.h"

@interface EBuyEvaluatePage ()

@end

@implementation EBuyEvaluatePage
@synthesize xType, xContent, xState;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

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
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(110, 0, 150,44)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = UITextAlignmentCenter;
    label.font = [UIFont fontWithName:@"黑体" size:60];
    label.textColor = [UIColor blackColor];
    label.text= @"发表评价";
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
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

// 选择图片
- (IBAction)selectPic:(id)sender{
    //
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];
    CGRect frame = self.view.frame;
    frame.origin.y = -135;
    self.view.frame = frame;
    [UIView commitAnimations];
    
    return YES;
}

// 文本框变动的时候
- (void)textViewDidChange:(UITextView *)textView{
    //
}

/*
- (void)textViewDidBeginEditing:(UITextView *)textView {  
    UIBarButtonItem *done = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(leaveEditMode)] autorelease];
    self.navigationItem.rightBarButtonItem = done;
}*/

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    BOOL bRet = NO;
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationDelegate:self];
        CGRect frame = self.view.frame;
        frame.origin.y = 0;
        self.view.frame = frame;
        [UIView commitAnimations];
    } else {
        static int text_maxlength = 140;
        NSString *str = textView.text;
        int length = str.length + text.length - range.length;
        if (length <= text_maxlength) {
            xState.text = [NSString stringWithFormat:@"剩余文字 %d.", text_maxlength - length];
            bRet = YES;
        } else {
            [iOSApi toast:[NSString stringWithFormat:@"文字最长%d", text_maxlength]];
        }
    }
    return bRet;    
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    //self.navigationItem.rightBarButtonItem = nil;
}

/*
- (void)leaveEditMode {
    [self.xContent resignFirstResponder];  
}
*/
// 选择
- (IBAction)segmentAction:(UISegmentedControl *)segment{
    //
}

@end
