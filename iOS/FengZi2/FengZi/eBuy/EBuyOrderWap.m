//
//  EBuyOrderWap.m
//  FengZi
//
//  Created by wangfeng on 12-5-20.
//  Copyright (c) 2012年 ifengzi.cn. All rights reserved.
//

#import "EBuyOrderWap.h"
#import "EBuyOrderInfo.h"

@interface EBuyOrderWap ()

@end

@implementation EBuyOrderWap
@synthesize webView = _webView;
@synthesize payUrl, totalFee;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)goBack{
    if (_webView.canGoBack) {
        [_webView goBack];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
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
    label.text= @"在线支付";
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
    [super viewWillAppear:animated];
    NSURL *url = [NSURL URLWithString:payUrl];
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

#pragma mark -
#pragma mark UIWebViewDelegate

/*
 UIWebView主要有下面几个委托方法：
 
 1、- (void)webViewDidStartLoad:(UIWebView *)webView;开始加载的时候执行该方法。
 2、- (void)webViewDidFinishLoad:(UIWebView *)webView;加载完成的时候执行该方法。
 3、- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error;加载出错的时候执行该方法。
 
 我们可以将activityIndicatorView放置到前面两个委托方法中。
 */
#pragma mark -
#pragma mark UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSString *sUrl = [[request URL] absoluteString];
    iOSLog(@"WebView-url = [%@]", sUrl);
    //http://220.231.48.34:38090/WapPayChannel/servlet/CallBack?out_trade_no=OD1205201245000002&request_token=requestToken&result=success&trade_no=2012052076462009&sign=03d6d62a71df2630535348752431d264
    // 如果URL, 首先判断是否富媒体
    static NSString *kCallBack_Alipay = @"WapPayChannel/servlet/CallBack";
    NSRange range = [sUrl rangeOfString:kCallBack_Alipay];
    if (range.length > 0) {
        // 支付宝wap支付
        NSDictionary *params = [sUrl uriParams];
        NSString *temp = nil;
        temp = [params objectForKey:@"out_trade_no"];
        NSString *orderId = [temp replace:@"\"" withString:@""];
        temp = [params objectForKey:@"result"];
        NSString *result = [temp replace:@"\"" withString:@""];
        temp = [params objectForKey:@"trade_no"];
        NSString *trade_no = [temp replace:@"\"" withString:@""];
        float payAmount = totalFee;
        int payStatus = 0x01;
        if ([result isSame:@"success"]) {
            payStatus = 0x11;
        }
        ApiResult *iRet = [[Api ebuy_order_change:orderId payId:trade_no payWay:1 payStatus:payStatus payAmount:payAmount serviceFee:0.00f] retain];
        [EBuyOrderInfo changeState:0];
        
        NSString *msg = [NSString stringWithFormat:@"%@:[%@]", iRet.message, result];
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" 
                                                             message:msg
                                                            delegate:self 
                                                   cancelButtonTitle:@"确定" 
                                                   otherButtonTitles:nil];
        [alertView show];
        [alertView release];
        [iRet release];
        //[self.navigationController popViewControllerAnimated:YES];
    }
    return YES;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger) buttonIndex {
    [self.navigationController popViewControllerAnimated:YES];
}

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
