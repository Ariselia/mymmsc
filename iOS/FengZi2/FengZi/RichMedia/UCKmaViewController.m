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

@implementation UCKmaViewController
@synthesize code;


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
    
    // 设定当前为空码模式
    [Api setKma:YES];
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

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    if ([Api kma]) {
        // 344bb558-bf6e-48b0-8659-5459956956d8
        NSDictionary *dict = [Api parseUrl:code];
        NSString *xcode = [dict objectForKey:@"id"];
        [Api kmaSetId:xcode];
        iOSLog(@"uuid=[%@]", xcode);
        [iOSApi Alert:@"赋值码" message:[NSString stringWithFormat:@"id=%@", xcode]];
    } else {
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
