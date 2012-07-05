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
#import "DecodeBusinessViewController.h"
#import <QRCode/QREncoder.h>
#import <QRCode/DataMatrix.h>

#import "BusDecoder.h"
#import "BusCategory.h"

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

-(void)gotoEditController:(BusinessType)type{
    DATA_ENV.curBusinessType = type;
    UIViewController *viewController;
    switch (type) {
        case kModelAppUrl:
            viewController = [[EncodeAppUrlViewController alloc] initWithNibName:@"EncodeAppUrlViewController" bundle:nil];
            break;
        case kModelGMap:
            viewController = [[EncodeMapViewController alloc] initWithNibName:@"EncodeMapViewController" bundle:nil];
            break;
        case kModelShortMessage:
            viewController = [[EncodeSmsViewController alloc] initWithNibName:@"EncodeSmsViewController" bundle:nil];
            break;
        case kModelCard:
            viewController = [[EncodeCardViewController alloc] initWithNibName:@"EncodeCardViewController" bundle:nil];
            break;
        case kModelEmail:
            viewController = [[EncodeEmailViewController alloc] initWithNibName:@"EncodeEmailViewController" bundle:nil];
            break;
        case kModelText:
            viewController = [[EncodeTextViewController alloc] initWithNibName:@"EncodeTextViewController" bundle:nil];
            break;
        case kModelWiFiText:
            viewController = [[EncodeWifiViewController alloc] initWithNibName:@"EncodeWifiViewController" bundle:nil];
            break;
        case kModelEncText:
            viewController = [[EncodeEncTextViewController alloc] initWithNibName:@"EncodeEncTextViewController" bundle:nil];
            break;
        case kModelWeibo:
            viewController = [[EncodeWeiboViewController alloc] initWithNibName:@"EncodeWeiboViewController" bundle:nil];
            break;
        case kModelBookMark:
            viewController = [[EncodeBookMarkViewController alloc] initWithNibName:@"EncodeBookMarkViewController" bundle:nil];
            break;
        case kModelPhone:
            viewController = [[EncodePhoneViewController alloc] initWithNibName:@"EncodePhoneViewController" bundle:nil];
            break;
        case kModelUrl:
            viewController = [[EncodeUrlViewController alloc] initWithNibName:@"EncodeUrlViewController" bundle:nil];
            break;
        case kModelSchedule:
            viewController = [[EncodeScheduleViewController alloc] initWithNibName:@"EncodeScheduleViewController" bundle:nil];
            break;
        case kModelRichMedia: // WangFeng: 增加生码类
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
    [Api setKma:YES];
    [Api kmaSetId:code];
    if (![Api isOnLine]) {
        [self gotoLogin];
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
