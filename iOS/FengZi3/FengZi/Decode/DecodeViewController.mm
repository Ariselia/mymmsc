//
//  DecodeViewController.m
//  QRCode
//
//  Copyright (c) 2011 iTotemStudio. All rights reserved.
//

#import "DecodeViewController.h"
#import "TabBarController.h"
#import <ZXing/QRCodeReader.h>
#import <ZXing/TwoDDecoderResult.h>
#import <ZXing/MultiFormatOneDReader.h>
#import "WebScanViewController.h"
#import "DecodeCardViewControlle.h"
#import <FengZi/BusDecoder.h>
#import <FengZi/BusCategory.h>
#import "DecodeBusinessViewController.h"
#import "HelpView.h"
#import "ScanAboutViewController.h"
#import "ImageDecodeViewController.h"
#import <QRCode/QREncoder.h>
#import <QRCode/DataMatrix.h>

// 二期加入
#import "UCLogin.h"
#import "UCKmaViewController.h"
#import "UCRichMedia.h"
#import "UCCreateCode.h"

#import "UCUpdateNikename.h" // 个人空间
#import "RMRide.h" // 顺风车

#import "UCStoreTable.h" // 数字商城
#import "EBuyPortal.h"   // 电子商城
#import "EFileMain.h"    // 蜂夹
#import "GamePortal.h"   // 蜂幸运
#import "UCLogin.h"

#define AniInterval 0.3f

static int iTimes = -1;
#define kCODE_NONE (0)
#define kCODE_KMA  (9)


@implementation DecodeViewController
@synthesize btnLogin;

#define VIEW_TAG_APPASTORE (1001)

- (IBAction)doLogin:(id)sender {
    UCLogin *nextView = [[UCLogin alloc] init];
    [self.navigationController pushViewController:nextView animated:YES];
    [nextView release];
}

//拉动幕布
- (IBAction)doCurtain:(id)sender {
   //加载拉动动画和mark显示；
    if (_isHideCurtain) {        
        frameRect = CGRectMake(0, 0, 320, 480);
        maskView = [[UIView alloc]initWithFrame:frameRect];
        maskView.backgroundColor = [UIColor grayColor];
        maskView.alpha=0.7;
        [self.view addSubview:maskView];
        [self.view bringSubviewToFront:_curtainBtn];
        [self.view bringSubviewToFront:_curtainView];
        //加载动画
        [UIView beginAnimations:@"show" context:nil]; 
        //设置动画移动的时间为slider.value滑块的值  
        [UIView setAnimationDuration:0.5]; 
        //设置动画曲线类形为：直线UIViewAnimationCurveLinear  
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        
        CGRect btnFrame = CGRectMake(10, 223, 32,120);
        CGRect viewFrame = CGRectMake(0, 0, 320,227);
        [_curtainBtn setFrame:btnFrame];
        [_curtainView setFrame:viewFrame];        
        //完成动画，必须写，不要忘了  
        [UIView commitAnimations];
        _isHideCurtain = NO;
    } else {        
        //加载动画
        [UIView beginAnimations:@"hide" context:nil]; 
        //设置动画移动的时间为slider.value滑块的值  
        [UIView setAnimationDuration:0.5]; 
        //设置动画曲线类形为：直线UIViewAnimationCurveLinear  
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        
        CGRect btnFrame = CGRectMake(10, -4, 32,120);
        CGRect viewFrame = CGRectMake(0, -227, 320,227);
        [_curtainBtn setFrame:btnFrame];
        [_curtainView setFrame:viewFrame];        
        //完成动画，必须写，不要忘了  
        [UIView commitAnimations];        
        [maskView removeFromSuperview];
        maskView = nil;
        _isHideCurtain = YES;
        
    }
       
}

- (IBAction)gotoStoreTable:(id)sender {
    UCStoreTable *theView = [[[UCStoreTable alloc] init] autorelease];
    UINavigationController *nextView = [[UINavigationController alloc] initWithRootViewController:theView];
    //nextView.delegate = theView;
    //[self.navigationController pushViewController:nextView animated:YES];
    [self presentModalViewController:nextView animated:YES];
    [nextView release];
}

- (IBAction)gotoEBuy:(id)sender {
    EBuyPortal *theView = [[[EBuyPortal alloc] init] autorelease];
    UINavigationController *nextView = [[UINavigationController alloc] initWithRootViewController:theView];
    [self presentModalViewController:nextView animated:YES];
    [nextView release];
}
- (void)goLogin{
    UCLogin *theView = [[[UCLogin alloc] init] autorelease];
    theView.bModel = YES;
    UINavigationController *nextView = [[UINavigationController alloc] initWithRootViewController:theView];
    [self presentModalViewController:nextView animated:YES];
}

// 转向电子蜂夹
- (IBAction)gotoEFile:(id)sender {
    // 登录
    if (![Api isOnLine]) {
        [self goLogin];
        return;
    }
    EFileMain *theView = [[[EFileMain alloc] init] autorelease];
    UINavigationController *nextView = [[UINavigationController alloc] initWithRootViewController:theView];
    [self presentModalViewController:nextView animated:YES];
}

// 转向蜂幸运
- (IBAction)gotoLucky:(id)sender{
    if (![Api isOnLine]) {
        [self goLogin];
        return;
    }
    // 登录
    GamePortal *theView = [[[GamePortal alloc] init] autorelease];
    UINavigationController *nextView = [[UINavigationController alloc] initWithRootViewController:theView];
    [self presentModalViewController:nextView animated:YES];
    [nextView release];
}


- (IBAction)gotoStore:(id)sender {
    UCAppStore *as = [[UCAppStore alloc] init];
    
    as.proxy = self;
    as.view.tag = VIEW_TAG_APPASTORE;
    
    [UIView beginAnimations:nil context:nil];
	//display mode, slow at beginning and end
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	//动画时间
	[UIView setAnimationDuration:1.0f];
	//使用当前正在运行的状态开始下一段动画
	[UIView setAnimationBeginsFromCurrentState:YES];
	//给视图添加过渡效果
	[UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.view cache:YES];
	[UIView commitAnimations];
    [self.view addSubview:as.view];
    //[self presentModalViewController:as animated:YES];
    //[as release];
    //[TabBarController hide:NO animated:YES];
}

- (void)hideAppStor {
    [UIView beginAnimations:nil context:nil];
	//display mode, slow at beginning and end
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	//动画时间
	[UIView setAnimationDuration:1.0f];
	//使用当前正在运行的状态开始下一段动画
	[UIView setAnimationBeginsFromCurrentState:YES];
	//给视图添加过渡效果
	[UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.view cache:YES];
	[UIView commitAnimations];
    UIView *view = [self.view viewWithTag:VIEW_TAG_APPASTORE];
    [view removeFromSuperview];
    //[view release];
}

- (void)closeAppStore{
    [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(hideAppStor) userInfo:nil repeats:NO];
    //[self dismissModalViewControllerAnimated:YES];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        iTimes = kCODE_NONE;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    _imageScanImageVew.image = [UIImage imageNamed:@"image_scan1.png"];
//    _camecaScanImagevView.image = [UIImage imageNamed:@"camera_scan1.png"];
//    _webSiteScanImageView.image = [UIImage imageNamed:@"website_scan1.png"];
    _curtainBtn.hidden = YES;
    self.navigationController.navigationBarHidden = YES;
    if ([Api isOnLine]) {
        btnLogin.hidden = YES;
    } else {
        btnLogin.hidden = NO;
    }
    iTimes = kCODE_NONE;
   
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if(!_isHideNavi){
        self.navigationController.navigationBarHidden = NO;
    }
}

- (void)decoderWithImage:(UIImage *)image{
    Decoder *decoder = [[[Decoder alloc] init] autorelease];
    QRCodeReader* qrcodeReader = [[QRCodeReader alloc] init];
    NSSet *readers = [[NSSet alloc ] initWithObjects:qrcodeReader,nil];
    decoder.readers = readers;
    decoder.delegate = self;
    _curImage = image;
    [decoder decodeImage:image];
    [readers release];
    [qrcodeReader release];
}

- (void)decoder:(Decoder *)decoder didDecodeImage:(UIImage *)image usingSubset:(UIImage *)subset withResult:(TwoDDecoderResult *)twoDResult {
    
    [self chooseShowController:twoDResult.text isSave:YES];

    decoder.delegate = nil;
}

- (void)decoder:(Decoder *)decoder failedToDecodeImage:(UIImage *)image usingSubset:(UIImage *)subset reason:(NSString *)reason{
    ImageDecodeViewController *imageViewController = [[ImageDecodeViewController alloc] initWithNibName:@"ImageDecodeViewController" bundle:nil];
    imageViewController.curImage = image;
    [self.navigationController pushViewController:imageViewController animated:YES];
    [imageViewController release];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    //注册摇晃
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doCurtain:) name:@"shake" object:nil];  
    
    
    if (![USER_DEFAULT boolForKey:HELPSHOW]) {
        HelpView *helpView = (HelpView*)[[[NSBundle mainBundle] loadNibNamed:@"HelpView" owner:self options:nil] objectAtIndex:0];
        [helpView startHelp];
    }
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    UIImage *image = [UIImage imageNamed:@"navigation_bg.png"];
    Class ios5Class = (NSClassFromString(@"CIImage"));
    if (nil != ios5Class) {
        [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    } else {
        self.navigationController.navigationBar.layer.contents = (id)image.CGImage;
    }
    //添加下拉页面；
    //定义幕布为隐藏；
    _isHideCurtain = YES;
    [_curtainView setFrame: CGRectMake(0, -227, 320, 227)];
    [self.view addSubview:_curtainView];
    //[self.view bringSubviewToFront:_curtainView];
}

- (void)viewDidUnload
{
    [_camecaScanImagevView release];
    _camecaScanImagevView = nil;
    [_imageScanImageVew release];
    _imageScanImageVew = nil;
    [_webSiteScanImageView release];
    _webSiteScanImageView = nil;
    [_curtainBtn release];
    _curtainBtn =nil;
    [_curtainView release];
    _curtainView = nil;
    [maskView release];
    maskView = nil;
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)imageAnimationEnd:(NSTimer *)timer{
    if ([UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary]) {
        
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
        imagePickerController.delegate = self;
        [self presentModalViewController:imagePickerController animated:YES];
        _isHideNavi = YES;
    }
    [timer invalidate];
    [_imageScanImageVew stopAnimating];
}


- (IBAction)tapOnSelectImageBtn:(id)sender {
//    [NSTimer scheduledTimerWithTimeInterval: AniInterval target:self selector:@selector(imageAnimationEnd:) userInfo:nil repeats: NO];
//    _imageScanImageVew.image = [UIImage imageNamed:@"image_scan3.png"];
//    _imageScanImageVew.animationImages = [NSArray arrayWithObjects:
//                                             [UIImage imageNamed:@"image_scan1.png"],
//                                             [UIImage imageNamed:@"image_scan2.png"],
//                                             [UIImage imageNamed:@"image_scan3.png"],
//                                             nil ];
//    _imageScanImageVew.animationDuration=AniInterval;
//    _imageScanImageVew.animationRepeatCount=1;
//    [_imageScanImageVew startAnimating];
    if ([UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary]) {
        DATA_ENV.curScanType = ScanCodeTypeImage;
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
        imagePickerController.delegate = self;
        _isHideNavi = YES;
        [self presentModalViewController:imagePickerController animated:YES];
        [imagePickerController release];
    }
}

- (void)cameraAnimationEnd:(NSTimer *) timer{
    ZXingWidgetController *widController = [[ZXingWidgetController alloc] initWithDelegate:self showCancel:YES OneDMode:NO];
    QRCodeReader* qrcodeReader = [[QRCodeReader alloc] init];
    MultiFormatOneDReader *oneDReader = [[MultiFormatOneDReader alloc] init];
    NSSet *readers = [[NSSet alloc ] initWithObjects:qrcodeReader,oneDReader,nil];
    widController.readers = readers;
    if ([DATA_ENV getDecodeMusicStatus]) {
        NSBundle *mainBundle = [NSBundle mainBundle];
        widController.soundToPlay = [NSURL fileURLWithPath:[mainBundle pathForResource:@"scan_tip" ofType:@"mp3"] isDirectory:NO];
    }
    [widController setTorch:[DATA_ENV getFlashLightStatus]];
    [self.navigationController pushViewController:widController animated:YES];
    [widController release];
    [readers release];
    [oneDReader release];
    [qrcodeReader release];
    [timer invalidate];
    [_camecaScanImagevView stopAnimating];
}

- (IBAction)tapOnSelectCameraBtn:(id)sender {
//    [NSTimer scheduledTimerWithTimeInterval: AniInterval target:self selector:@selector(cameraAnimationEnd:) userInfo:nil repeats: NO];
//    _camecaScanImagevView.image = [UIImage imageNamed:@"camera_scan3.png"];
//    _camecaScanImagevView.animationImages = [NSArray arrayWithObjects:
//                                             [UIImage imageNamed:@"camera_scan1.png"],
//                                             [UIImage imageNamed:@"camera_scan2.png"],
//                                             [UIImage imageNamed:@"camera_scan3.png"],
//                                             nil ];
//    _camecaScanImagevView.animationDuration=AniInterval;
//    _camecaScanImagevView.animationRepeatCount=1;
//    [_camecaScanImagevView startAnimating];
    
    if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"设备上没有摄像头！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        [alertView release];
        return;
    }
    DATA_ENV.curScanType = ScanCodeTypeCamera;
    ZXingWidgetController *widController = [[ZXingWidgetController alloc] initWithDelegate:self showCancel:YES OneDMode:NO];
    QRCodeReader* qrcodeReader = [[QRCodeReader alloc] init];
    MultiFormatOneDReader *oneDReader = [[MultiFormatOneDReader alloc] init];
    NSSet *readers = [[NSSet alloc ] initWithObjects:qrcodeReader,oneDReader,nil];
    widController.readers = readers;
    
    if ([DATA_ENV getDecodeMusicStatus]) {
        NSBundle *mainBundle = [NSBundle mainBundle];
        widController.soundToPlay = [NSURL fileURLWithPath:[mainBundle pathForResource:@"scan_tip" ofType:@"mp3"] isDirectory:NO];
    }
    [widController setTorch:[DATA_ENV getFlashLightStatus]];
    // [TabBarController hide:YES animated:NO];
    [self.navigationController pushViewController:widController animated:YES];
    [widController release];
    [readers release];
    [oneDReader release];
    [qrcodeReader release];
}

- (void)webSiteAnimationEnd:(NSTimer *) timer{
    WebScanViewController *scanView = [[WebScanViewController alloc] initWithNibName:@"WebScanViewController" bundle:nil];
    [TabBarController hide:YES animated:NO];
    [self.navigationController pushViewController:scanView animated:YES];
    [scanView release];
    [timer invalidate];
    [_webSiteScanImageView stopAnimating];
}

- (IBAction)tapOnSelectWebSiteBtn:(id)sender {
//    [NSTimer scheduledTimerWithTimeInterval: AniInterval target:self selector:@selector(webSiteAnimationEnd:) userInfo:nil repeats: NO];
//    _webSiteScanImageView.image = [UIImage imageNamed:@"website_scan3.png"];
//    _webSiteScanImageView.animationImages = [NSArray arrayWithObjects:
//                                             [UIImage imageNamed:@"website_scan1.png"],
//                                             [UIImage imageNamed:@"website_scan2.png"],
//                                             [UIImage imageNamed:@"website_scan3.png"],
//                                             nil ];
//    _webSiteScanImageView.animationDuration=AniInterval;
//    _webSiteScanImageView.animationRepeatCount=1;
//    [_webSiteScanImageView startAnimating];
    DATA_ENV.curScanType = ScanCodeTypeWeisite;
  /*
    WebScanViewController *scanView = [[WebScanViewController alloc] initWithNibName:@"WebScanViewController" bundle:nil];
    [TabBarController hide:YES animated:NO];
    [self.navigationController pushViewController:scanView animated:YES];
    [scanView release];
    */
    WebScanViewController *scanView = [[[WebScanViewController alloc] init] autorelease];
    UINavigationController *nextView = [[UINavigationController alloc] initWithRootViewController:scanView];
    [self presentModalViewController:nextView animated:YES];
    [nextView release];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissModalViewControllerAnimated:YES];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self decoderWithImage:image];
    _isHideNavi = NO;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissModalViewControllerAnimated:YES];
    _isHideNavi = NO;
}

#pragma mark -
#pragma mark ZXingDelegateMethods

- (void)zxingController:(ZXingWidgetController*)controller didScanResult:(NSString *)result {
    if (self.isViewLoaded) {
        self.navigationController.navigationBarHidden = NO;
        [self.navigationController popViewControllerAnimated:NO];
        
        _curImage = controller.gimage;
        [self chooseShowController:result isSave:YES];

    }
    else {
        self.view.backgroundColor = [UIColor grayColor];
    }
}

- (void)zxingControllerDidCancel:(ZXingWidgetController*)controller {
     [TabBarController hide:NO animated:NO];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)zxingControllerDidShowInfo:(ZXingWidgetController *)controller{
    ScanAboutViewController *aboutView = [[ScanAboutViewController alloc] initWithNibName:@"ScanAboutViewController" bundle:nil];
    [self.navigationController pushViewController:aboutView animated:YES];
    [aboutView release];
}

- (void)dealloc {
    [_camecaScanImagevView release];
    [_imageScanImageVew release];
    [_webSiteScanImageView release];
    [super dealloc];
}
@end
