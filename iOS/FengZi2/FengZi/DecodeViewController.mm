//
//  DecodeViewController.m
//  QRCode
//
//  Copyright (c) 2011 iTotemStudio. All rights reserved.
//

#import "DecodeViewController.h"
#import "TabBarController.h"
#import "QRCodeReader.h"
#import "TwoDDecoderResult.h"
#import "MultiFormatOneDReader.h"
#import "WebScanViewController.h"
#import "DecodeCardViewControlle.h"
#import "BusDecoder.h"
#import "BusCategory.h"
#import "DecodeBusinessViewController.h"
#import "HelpView.h"
#import "ScanAboutViewController.h"
#import "ImageDecodeViewController.h"
#import "QREncoder.h"
#import "DataMatrix.h"

#define AniInterval 0.3f
@implementation DecodeViewController

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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    _imageScanImageVew.image = [UIImage imageNamed:@"image_scan1.png"];
//    _camecaScanImagevView.image = [UIImage imageNamed:@"camera_scan1.png"];
//    _webSiteScanImageView.image = [UIImage imageNamed:@"website_scan1.png"];
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if(!_isHideNavi){
        self.navigationController.navigationBarHidden = NO;
    }
}

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
    BusCategory *category = [BusDecoder classify:input];
    if ([category.type isEqualToString:CATEGORY_CARD]) {
        DecodeCardViewControlle *cardView = [[DecodeCardViewControlle alloc] initWithNibName:@"DecodeCardViewControlle" category:category result:input withImage:_curImage withType:HistoryTypeFavAndHistory withSaveImage:[self generateImageWithInput:input]];
        [self.navigationController pushViewController:cardView animated:YES];
        RELEASE_SAFELY(cardView);
    }else{
        DecodeBusinessViewController *businessView = [[DecodeBusinessViewController alloc] initWithNibName:@"DecodeBusinessViewController" category:category result:input image:_curImage withType:HistoryTypeFavAndHistory withSaveImage:[self generateImageWithInput:input]];
        [self.navigationController pushViewController:businessView animated:YES];
        RELEASE_SAFELY(businessView);
    }
}

-(void)decoderWithImage:(UIImage*)image{
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
    [self chooseShowController:twoDResult.text];
    decoder.delegate = nil;
}

-(void)decoder:(Decoder *)decoder failedToDecodeImage:(UIImage *)image usingSubset:(UIImage *)subset reason:(NSString *)reason{
    ImageDecodeViewController *imageViewController = [[ImageDecodeViewController alloc] initWithNibName:@"ImageDecodeViewController" bundle:nil];
    imageViewController.curImage = image;
    [self.navigationController pushViewController:imageViewController animated:YES];
    [imageViewController release];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (![USER_DEFAULT boolForKey:HELPSHOW]) {
        HelpView *helpView = (HelpView*)[[[NSBundle mainBundle] loadNibNamed:@"HelpView" owner:self options:nil] objectAtIndex:0];
        [helpView startHelp];
    }
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    UIImage *image = [UIImage imageNamed:@"navigation_bg.png"];
    Class ios5Class = (NSClassFromString(@"CIImage"));
    if (nil != ios5Class) {
        [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    }else
    {
        self.navigationController.navigationBar.layer.contents = (id)image.CGImage;
    }
}

- (void)viewDidUnload
{
    [_camecaScanImagevView release];
    _camecaScanImagevView = nil;
    [_imageScanImageVew release];
    _imageScanImageVew = nil;
    [_webSiteScanImageView release];
    _webSiteScanImageView = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)imageAnimationEnd:(NSTimer *) timer{
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

-(void)cameraAnimationEnd:(NSTimer *) timer{
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
    [self.navigationController pushViewController:widController animated:YES];
    [widController release];
    [readers release];
    [oneDReader release];
    [qrcodeReader release];
}

-(void)webSiteAnimationEnd:(NSTimer *) timer{
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
    WebScanViewController *scanView = [[WebScanViewController alloc] initWithNibName:@"WebScanViewController" bundle:nil];
    [TabBarController hide:YES animated:NO];
    [self.navigationController pushViewController:scanView animated:YES];
    [scanView release];
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
        [self chooseShowController:result];
    }
}

- (void)zxingControllerDidCancel:(ZXingWidgetController*)controller {
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
