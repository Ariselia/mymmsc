//
//  FeedbackViewController.m
//  FengZi
//
//  Created by lt ji on 11-12-19.
//  Copyright (c) 2011年 iTotemStudio. All rights reserved.
//

#import "FeedbackViewController.h"

@implementation FeedbackViewController

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

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)submitFeedBack:(id)sender {
    if ([_contentTextView.text isEqualToString:@""]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请填写内容！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        RELEASE_SAFELY(alertView);
        return;
    }
    [FeedBackDataRequest requestWithDelegate:self withParameters:[NSDictionary dictionaryWithObjectsAndKeys:_titleField.text,@"type",_telField.text,@"connection",_contentTextView.text,@"content", nil] withIndicatorView:_mainView];
    [self.view bringSubviewToFront:_mainView];
}

-(void)requestDidFinishLoad:(ITTBaseDataRequest *)request{
    if ([request isKindOfClass:[FeedBackDataRequest class]]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"发送成功！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        RELEASE_SAFELY(alertView);
    }
    [self.view sendSubviewToBack:_mainView];
}

-(void)request:(ITTBaseDataRequest *)request didFailLoadWithError:(NSError *)error{
    NSLog(@"%@",error);
    [self.view sendSubviewToBack:_mainView];
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    _discribLabel = [[UILabel alloc] initWithFrame:CGRectMake(9, 7, 120, 20)];
    _discribLabel.font = [UIFont systemFontOfSize:14];
    _discribLabel.text = @"输入反馈内容吧";
    _discribLabel.backgroundColor = [UIColor clearColor];
    _discribLabel.textColor = [UIColor colorWithWhite:0.8 alpha:1];
    [_contentTextView addSubview:_discribLabel];
    [_discribLabel release];
//    if (!DATA_ENV.hasNetWork) {
//        _submitBtn.enabled = NO;
//    }
}
-(void)textViewDidChange:(UITextView *)textView{
    if ([_contentTextView hasText]) {
        _discribLabel.hidden =YES;
    }else{
        _discribLabel.hidden =NO;
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [_contentTextView resignFirstResponder];
}
- (void)viewDidUnload
{
    [_titleField release];
    _titleField = nil;
    [_telField release];
    _telField = nil;
    [_contentTextView release];
    _contentTextView = nil;
    [_mainView release];
    _mainView = nil;
    [_submitBtn release];
    _submitBtn = nil;
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
    [_titleField release];
    [_telField release];
    [_contentTextView release];
    [_mainView release];
    [_submitBtn release];
    [super dealloc];
}
@end
