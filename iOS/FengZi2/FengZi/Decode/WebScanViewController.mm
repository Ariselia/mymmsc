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
/*
-(UIImage*)generateImageWithInput:(NSString*)input{
    int qrcodeImageDimension = 250;
    //the string can be very long
    NSString* aVeryLongURL = input;
    //first encode the string into a matrix of bools, TRUE for black dot and FALSE for white. Let the encoder decide the error correction level and version
    int qr_level = QR_ECLEVEL_L;
    DataMatrix* qrMatrix = [QREncoder encodeWithECLevel:qr_level version:QR_VERSION_AUTO string:aVeryLongURL];
    //then render the matrix
    UIImage* qrcodeImage = [QREncoder renderDataMatrix:qrMatrix imageDimension:qrcodeImageDimension];
    return qrcodeImage;
}

-(void) chooseShowController:(NSString*)input{
    if (input != nil && [input hasPrefix:API_URL_SHOW]) {
        NSDictionary *dict = [Api parseUrl:input];
        NSString *userId = [dict objectForKey:@"id"];
        UCUpdateNikename *nextView = [[UCUpdateNikename alloc] init];
        nextView.idDest = [userId intValue];
        [self.navigationController pushViewController:nextView animated:YES];
        [nextView release];
        return;
    }
    BusCategory *category = [BusDecoder classify:input];
    [TabBarController hide:NO animated:NO];
    if ([category.type isEqualToString:CATEGORY_CARD]) {
        DecodeCardViewControlle *cardView = [[DecodeCardViewControlle alloc] initWithNibName:@"DecodeCardViewControlle" category:category result:input withImage:_webImage withType:HistoryTypeFavAndHistory withSaveImage:[self generateImageWithInput:input]];
        [self.navigationController pushViewController:cardView animated:YES];
        [cardView release];
    } else if([category.type isEqualToString:CATEGORY_MEDIA]) {
        // 富媒体业务
        UCRichMedia *nextView = [[UCRichMedia alloc] init];
        nextView.urlMedia = input;
        [self.navigationController pushViewController:nextView animated:YES];
        [nextView release];  
    } else if([category.type isEqualToString:CATEGORY_KMA]) {
        // 空码, 可以调到空码赋值页面, 默认为富媒体
        UCKmaViewController *nextView = [[UCKmaViewController alloc] init];
        //nextView.bKma = YES; // 标记为空码赋值富媒体
        nextView.code = input;
        [self.navigationController pushViewController:nextView animated:YES];
        [nextView release];
    } else{
        DecodeBusinessViewController *businessView = [[DecodeBusinessViewController alloc] initWithNibName:@"DecodeBusinessViewController" category:category result:input image:_webImage withType:HistoryTypeFavAndHistory withSaveImage:[self generateImageWithInput:input]];
        [self.navigationController pushViewController:businessView animated:YES];
        [businessView release];
    }
}
*/
- (void)decoder:(Decoder *)decoder didDecodeImage:(UIImage *)image usingSubset:(UIImage *)subset withResult:(TwoDDecoderResult *)twoDResult {
    [self chooseShowController:twoDResult.text];
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
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)decodeWeb{
    [self createImageWithWeb];
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
