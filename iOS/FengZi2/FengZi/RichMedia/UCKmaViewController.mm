//
//  UCKmaViewController.m
//  FengZi
//
//  Created by  on 12-1-8.
//  Copyright (c) 2012年 iTotemStudio. All rights reserved.
//

#import "UCKmaViewController.h"
#import "EncodeAppUrlViewController.h"
#import "EncodeBookMarkViewController.h"
#import "EncodeCardViewController.h"
#import "EncodeEmailViewController.h"
#import "EncodeEncTextViewController.h"
#import "EncodeMapViewController.h"
#import "EncodePhoneViewController.h"
#import "EncodeSmsViewController.h"
#import "EncodeScheduleViewController.h"
#import "EncodeTextViewController.h"
#import "EncodeUrlViewController.h"
#import "EncodeWifiViewController.h"
#import "EncodeWeiboViewController.h"

// WangFeng: 增加富媒体生码类
#import "UCCreateCode.h"
#import "UCRichMedia.h"
#import "DecodeCardViewControlle.h"
#import "BusDecoder.h"
#import "BusCategory.h"
#import "DecodeBusinessViewController.h"
#import <QRCode/QREncoder.h>
#import <QRCode/DataMatrix.h>

@implementation UCKmaViewController

@synthesize curImage;
@synthesize code;
@synthesize forceEdit;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        forceEdit = NO;
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
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    UIImage *image = [UIImage imageNamed:@"navigation_bg.png"];
    Class ios5Class = (NSClassFromString(@"CIImage"));
    if (nil != ios5Class) {
        [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    } else {
        self.navigationController.navigationBar.layer.contents = (id)image.CGImage;
    }
    
    
    // Do any additional setup after loading the view from its nib.
    _arcView = [(ArcScrollView*)[[[NSBundle mainBundle] loadNibNamed:@"ArcScrollView" owner:self options:nil] objectAtIndex:0] retain];
    _arcView.delegate = self;
    _arcView.frame = CGRectMake(0, 296, 320, 120);
    [self.view addSubview:_arcView];
    
    DATA_ENV.encodeImageType = EncodeImageTypeCommon;
    _curType = EncodeImageTypeCommon;
}

- (void)viewDidUnload
{
    //[_commonEncodeBtn release];
    //_commonEncodeBtn = nil;
    //[_iconEncodeBtn release];
    //_iconEncodeBtn = nil;
    //[_commonEncodeImageView release];
    //_commonEncodeImageView = nil;
    //[_iconEncodeImageView release];
    //_iconEncodeImageView = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (UIImage*)generateImageWithInput:(NSString*)input{
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

- (void)chooseShowController:(NSString*)input{
    BusCategory *category = [BusDecoder classify:input];
    if ([category.type isEqualToString:CATEGORY_CARD]) {
        DecodeCardViewControlle *cardView = [[DecodeCardViewControlle alloc] initWithNibName:@"DecodeCardViewControlle" category:category result:input withImage:curImage withType:HistoryTypeFavAndHistory withSaveImage:[self generateImageWithInput:input]];
        [self.navigationController pushViewController:cardView animated:YES];
        RELEASE_SAFELY(cardView);
    } else if([category.type isEqualToString:CATEGORY_MEDIA]) {
        // 富媒体业务
        UCRichMedia *nextView = [[UCRichMedia alloc] init];
        nextView.urlMedia = input;
        nextView.curImage = curImage;
        [self.navigationController pushViewController:nextView animated:YES];
        [nextView release];
    } else if([category.type isEqualToString:CATEGORY_KMA]) {
        // 空码, 可以调到空码赋值页面, 默认为富媒体
        UCKmaViewController *nextView = [[UCKmaViewController alloc] init];
        //nextView.bKma = YES; // 标记为空码赋值富媒体
        nextView.code = input;
        nextView.curImage = curImage;
        [self.navigationController pushViewController:nextView animated:YES];
        [nextView release];
    } else{
        DecodeBusinessViewController *businessView = [[DecodeBusinessViewController alloc] initWithNibName:@"DecodeBusinessViewController" category:category result:input image:curImage withType:HistoryTypeFavAndHistory withSaveImage:[self generateImageWithInput:input]];
        [self.navigationController pushViewController:businessView animated:YES];
        RELEASE_SAFELY(businessView);
    }
}

-(void)gotoEditController:(BusinessType)type{
    DATA_ENV.curBusinessType = type;
    UIViewController *viewController;
    switch (type) {
        case BusinessTypeAppUrl:
            viewController = [[EncodeAppUrlViewController alloc] initWithNibName:@"EncodeAppUrlViewController" bundle:nil];
            break;
        case BusinessTypeGmap:
            viewController = [[EncodeMapViewController alloc] initWithNibName:@"EncodeMapViewController" bundle:nil];
            break;
        case BusinessTypeShortMessage:
            viewController = [[EncodeSmsViewController alloc] initWithNibName:@"EncodeSmsViewController" bundle:nil];
            break;
        case BusinessTypeCard:
            viewController = [[EncodeCardViewController alloc] initWithNibName:@"EncodeCardViewController" bundle:nil];
            break;
        case BusinessTypeEmail:
            viewController = [[EncodeEmailViewController alloc] initWithNibName:@"EncodeEmailViewController" bundle:nil];
            break;
        case BusinessTypeText:
            viewController = [[EncodeTextViewController alloc] initWithNibName:@"EncodeTextViewController" bundle:nil];
            break;
        case BusinessTypeWifiText:
            viewController = [[EncodeWifiViewController alloc] initWithNibName:@"EncodeWifiViewController" bundle:nil];
            break;
        case BusinessTypeEncText:
            viewController = [[EncodeEncTextViewController alloc] initWithNibName:@"EncodeEncTextViewController" bundle:nil];
            break;
        case BusinessTypeWeibo:
            viewController = [[EncodeWeiboViewController alloc] initWithNibName:@"EncodeWeiboViewController" bundle:nil];
            break;
        case BusinessTypeBookMark:
            viewController = [[EncodeBookMarkViewController alloc] initWithNibName:@"EncodeBookMarkViewController" bundle:nil];
            break;
        case BusinessTypePhone:
            viewController = [[EncodePhoneViewController alloc] initWithNibName:@"EncodePhoneViewController" bundle:nil];
            break;
        case BusinessTypeUrl:
            viewController = [[EncodeUrlViewController alloc] initWithNibName:@"EncodeUrlViewController" bundle:nil];
            break;
        case BusinessTypeSchedule:
            viewController = [[EncodeScheduleViewController alloc] initWithNibName:@"EncodeScheduleViewController" bundle:nil];
            break;
        case BusinessTypeRichMedia: // WangFeng: 增加生码类
            viewController = [[UCCreateCode alloc] initWithNibName:@"UCCreateCode" bundle:nil];
            break;
        default:
            viewController = [[EncodeCardViewController alloc] initWithNibName:@"EncodeCardViewController" bundle:nil];
            break;
    }
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    [self setKmaContent:nil];
    //if ([Api kma])
    {
        
        iOSLog(@"uuid=[%@]", code);
        //[iOSApi Alert:@"赋值码" message:[NSString stringWithFormat:@"id=%@", xcode]];
        // 扫码
        if (forceEdit) {
            [Api setKma:YES];
            return;
        }
        KmaObject *info = [Api kmaContent:code];
        if (info.isKma == 1) {
            // 是空码, 赋值
            // 设定当前为空码模式
            [Api setKma:YES];
            //[self gotoEditController:(BusinessType)info.type];
            if (![Api isOnLine]) {
                [self gotoLogin];
            }
        } else {
            // 不是空码, 展示
            [self chooseShowController:info.tranditionContent];
        }
    //} else {
       //
    }
}
- (void)dealloc {
    [_arcView release];
    //[_commonEncodeBtn release];
    //[_iconEncodeBtn release];
    //[_commonEncodeImageView release];
    //[_iconEncodeImageView release];
    [super dealloc];
}

@end
