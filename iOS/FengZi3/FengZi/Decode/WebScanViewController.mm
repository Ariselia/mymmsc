//
//  WebScanViewController.m
//  FengZi
//

//  Copyright (c) 2011年 iTotemStudio. All rights reserved.
//

#import "WebScanViewController.h"
#import <ZXing/QRCodeReader.h>
#import <ZXing/TwoDDecoderResult.h>
#import "DecodeCardViewControlle.h"
#import "BusDecoder.h"
#import "BusCategory.h"
#import "DecodeBusinessViewController.h"
#import "TabBarController.h"
#import <QRCode/QREncoder.h>
#import <QRCode/DataMatrix.h>

// 二期加入
#import "UCKmaViewController.h"
#import "UCRichMedia.h"
#import "UCCreateCode.h"

#import "UCUpdateNikename.h"

@implementation WebScanViewController
@synthesize scanWebView = _scanWebView;

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

- (void)decoder:(Decoder *)decoder didDecodeImage:(UIImage *)image usingSubset:(UIImage *)subset withResult:(TwoDDecoderResult *)twoDResult {
    [self chooseShowController:twoDResult.text isSave:YES];

    decoder.delegate = nil;
}

- (void)decoder:(Decoder *)decoder failedToDecodeImage:(UIImage *)image usingSubset:(UIImage *)subset reason:(NSString *)reason{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:DECODE_FAIL delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alertView show];
    RELEASE_SAFELY(alertView);
    return;
}

-(void)createImageWithWeb{
    UIGraphicsBeginImageContext(_scanWebView.bounds.size);
    [_scanWebView.layer renderInContext:UIGraphicsGetCurrentContext()];
    _webImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    Decoder *decoder = [[Decoder alloc] init];
    QRCodeReader* qrcodeReader = [[QRCodeReader alloc] init];
    NSSet *readers = [[NSSet alloc ] initWithObjects:qrcodeReader,nil];
    decoder.readers = readers;
    decoder.delegate = self;
    [decoder decodeImage:_webImage];
    [readers release];
    [qrcodeReader release];
    [decoder release];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [_activityIndicatorView stopAnimating];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [_activityIndicatorView stopAnimating];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    NSLog(@"error-----%@",error);
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络连接失败！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alertView show];
    RELEASE_SAFELY(alertView);
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
    [_activityIndicatorView startAnimating];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

-(void)goBack{
    [TabBarController hide:NO animated:NO];
    //[self.navigationController popViewControllerAnimated:YES];
    [self dismissModalViewControllerAnimated:YES];
}

-(void)decodeWeb{
    [self createImageWithWeb];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImage *image = [UIImage imageNamed:@"navigation_bg.png"];
    Class ios5Class = (NSClassFromString(@"CIImage"));
    if (nil != ios5Class) {
        [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    } else {
        self.navigationController.navigationBar.layer.contents = (id)[UIImage imageNamed:@"navigation_bg.png"].CGImage;
    }

    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320,44)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = UITextAlignmentCenter;
    label.font = [UIFont fontWithName:@"黑体" size:60];
    label.textColor = [UIColor blackColor];
    label.text= @"网站解码";
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
    [btn setImage:[UIImage imageNamed:@"decode_code_btn.png"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"decode_code_btn_tap.png"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(decodeWeb) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = item;
    [item release];

    
    _webSeachBar.text = @"http://www.fengxiafei.com";
    _activityIndicatorView = [[UIActivityIndicatorView alloc] 
                             initWithFrame : CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)] ;
    [_activityIndicatorView setCenter: self.view.center] ;
    [_activityIndicatorView setActivityIndicatorViewStyle: UIActivityIndicatorViewStyleWhite] ; 
    [self.view addSubview : _activityIndicatorView] ;
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [_searchField resignFirstResponder];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    NSString *url = textField.text;
    if ([url rangeOfString:@"://"].location == NSNotFound) {
        url = [NSString stringWithFormat:@"http://%@",url];
    }
    [_scanWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    return YES;
}
- (void)viewDidUnload
{
    [self setScanWebView:nil];
    [_searchField release];
    _searchField = nil;
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
    [_activityIndicatorView release];
    [_webSeachBar release];
    [_scanWebView release];
    [_searchField release];
    [super dealloc];
}
@end
