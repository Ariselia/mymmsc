//
//  EWallView.m
//  FengZi
//
//  Created by wangfeng on 12-5-14.
//  Copyright (c) 2012年 ifengzi.cn. All rights reserved.
//

#import "EWallView.h"

@interface EWallView ()

@end

@implementation EWallView
@synthesize param;
@synthesize webView = _webView;

#define kTagActivity (10000 + 1)

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
    label.text= @"墙贴";
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
    IOSAPI_RELEASE(activity);
    _webView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    NSString *sUrl = [NSString stringWithFormat:@"http://devp.ifengzi.cn:38090/misc/checktokenlist.action?doorid=%@&num=%@&factoryid=%@&userid=%d",param.doorid,param.num,param.factoryid,[Api userId]];
    
    // NSString *url = @"http://devp.ifengzi.cn:38090/misc/checktokenlist.action?doorid=70&num=&factoryid=68&userid=100046";    
    
    // iOSLog(@"url = %@", url);        
    
    NSURL *url = [NSURL URLWithString:sUrl];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [_webView loadRequest:request];
    [request release];
    
    activity = [[UIActivityIndicatorView alloc] 
                             initWithFrame : CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)];
    activity.tag = kTagHintView;
    [activity setCenter: self.view.center];
    //[activityIndicatorView setActivityIndicatorViewStyle: UIActivityIndicatorViewStyleWhite];
	[activity setActivityIndicatorViewStyle: UIActivityIndicatorViewStyleGray];
    [self.view addSubview: activity];
    [activity release];
}

/*
 UIWebView主要有下面几个委托方法：
 
 1、- (void)webViewDidStartLoad:(UIWebView *)webView;开始加载的时候执行该方法。
 2、- (void)webViewDidFinishLoad:(UIWebView *)webView;加载完成的时候执行该方法。
 3、- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error;加载出错的时候执行该方法。
 
 我们可以将activityIndicatorView放置到前面两个委托方法中。
 */
- (void)webViewDidStartLoad:(UIWebView *)webView
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    //UIActivityIndicatorView *activity = (UIActivityIndicatorView *)[self.view viewWithTag:kTagActivity];
    [activity startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //UIActivityIndicatorView *activity = (UIActivityIndicatorView *)[self.view viewWithTag:kTagActivity];
    [activity stopAnimating];
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

/*
 buttonPress方法很简单，调用我们开始定义好的loadWebPageWithString方法就行了：
 
 - (IBAction)buttonPress:(id) sender
 {
 [textField resignFirstResponder]; 
 [self loadWebPageWithString:textField.text];
 
 }
 */

//当请求页面出现错误的时候，我们给予提示：

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    UIAlertView *alterview = [[UIAlertView alloc] initWithTitle:@""
														message: [error localizedDescription]
													   delegate: nil
											  cancelButtonTitle: @"确定" 
											  otherButtonTitles: nil];
    [alterview show];
    [alterview release];
}


@end
