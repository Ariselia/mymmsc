//
//  AppDelegate.m
//  FengZi
//
//  Copyright (c) 2011 iTotemStudio. All rights reserved.
//

#import "AppDelegate.h"
#import "TabBarController.h"
#import "EncryptTools.h"
#import <iOSApi/iOSApi.h>

//支付宝加入
#import "AlixPay.h"
#import "AlixPayResult.h"
#import "DataVerifier.h"
#import <sys/utsname.h>
#import "EBuyOrderInfo.h"

@implementation AppDelegate

@synthesize window = _window;

- (void)dealloc
{
    if (_locationManager) {
        RELEASE_SAFELY(_locationManager);
    }
    RELEASE_SAFELY(_acivityIndicatorView);
    RELEASE_SAFELY(_defaultImageView);
    [_window release];
    [super dealloc];
}

-(void)loadAnimationEnd:(NSTimer *) timer{
    [_acivityIndicatorView stopAnimating];
    [_acivityIndicatorView removeFromSuperview];
    [_defaultImageView removeFromSuperview];
    [timer invalidate];
    timer = nil;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    TabBarController *tabbarController = [[TabBarController alloc] init];
    self.window.rootViewController = tabbarController;
    [tabbarController release];
    
    [NSTimer scheduledTimerWithTimeInterval: 3.0f target:self selector:@selector(loadAnimationEnd:) userInfo:nil repeats: NO];
    
    _defaultImageView = [[UIImageView alloc] initWithFrame:self.window.bounds];
    _defaultImageView.image = [UIImage imageNamed:@"Default@2x.png"];
    [self.window addSubview:_defaultImageView];
    [self.window bringSubviewToFront:_defaultImageView];
    
    _acivityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(135, 360, 50, 50)];
    [self.window addSubview:_acivityIndicatorView];
    [self.window bringSubviewToFront:_acivityIndicatorView];
    [_acivityIndicatorView startAnimating];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name: kReachabilityChangedNotification
                                               object: nil];
    hostReach = [[Reachability reachabilityWithHostName:REQUEST_DOMAIN] retain];
    [hostReach startNotifier];
    [LastVersionDataRequest silentRequestWithDelegate:self];
    [self setLocationStatus];
    return YES;
}

- (void)reachabilityChanged:(NSNotification *)note{
	Reachability* curReach = [note object];
	if( curReach!=hostReach ){
		DATA_ENV.hasNetWork = NO;
        return;
    }
	NetworkStatus status = [curReach currentReachabilityStatus];
	if (status != NotReachable) {
        DATA_ENV.hasNetWork = YES;
        if(![USER_DEFAULT boolForKey:@"MobileInfoSended"]){
            NSString *netName;
            if ([hostReach isReachableViaWWAN] == kReachableViaWWAN) {
                netName = @"2G/3G";
            }else{
                netName = @"WIFI";
            }
            
            CGSize size  = [[UIScreen mainScreen] currentMode].size;
            NSMutableString *buffer = [[[NSMutableString alloc] initWithCapacity:0] autorelease];
            
            [buffer appendFormat:@"r=%.f*%.f",size.height,size.width];// 分辨率
            size = [[UIScreen mainScreen] bounds].size;
            
            [buffer appendFormat:@"&s=%.f*%.f",size.height,size.width];// 屏幕大小
            
            [buffer appendFormat:@"&iv=%@",[[UIDevice currentDevice] systemVersion]];// 版本
            
            NSString *system = [[UIDevice currentDevice] systemName];
            [buffer appendFormat:@"&o=%@",system];// 系统
            
            [buffer appendFormat:@"&eqn=%@",[[UIDevice currentDevice] uniqueIdentifier]];// 型号
            
            [buffer appendFormat:@"&version=%@",[iOSApi version]];// 版本
            
            [buffer appendFormat:@"&ch=%@",CHANNEL_NUMBER];// 渠道
            
            [buffer appendFormat:@"&simng=%@",netName];// 网络
            
            NSString *info = [EncryptTools Base64EncryptString:buffer];
            [MobileInfoDataRequest silentRequestWithDelegate:self withParameters:[NSDictionary dictionaryWithObjectsAndKeys:info,@"t", nil]];
            [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
        }
    }else{
        DATA_ENV.hasNetWork = NO;
    }
}

-(void)requestDidFinishLoad:(ITTBaseDataRequest *)request{
    if ([request isKindOfClass:[MobileInfoDataRequest class]]) {
        if ([[request.resultDic objectForKey:@"status"] intValue]==0) {
            [USER_DEFAULT setBool:YES forKey:@"MobileInfoSended"];
        }
    }else if([request isKindOfClass:[LastVersionDataRequest class]]){
        if ([[request.resultDic objectForKey:@"status"] intValue]==0) {
            NSDictionary *dic = [request.resultDic objectForKey:@"data"];
            if (dic && [iOSApi isNeedUpload:[dic objectForKey:@"version"]]) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"当前有新版本，是否要更新？" message:nil delegate:self cancelButtonTitle:@"确认" otherButtonTitles: @"取消", nil];
                [alertView show];
                [alertView release];
            }
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:APPSTORE_URL]];
    }
}

- (void)request:(ITTBaseDataRequest *)request didFailLoadWithError:(NSError *)error{
    NSLog(@"%@",error);
}

- (void)setLocationStatus{
    if ([DATA_ENV getLocationStatus]) {
        if (!_locationManager) {
            _locationManager = [[CLLocationManager alloc] init];//创建位置管理器
            _locationManager.delegate=self;//设置代理
            _locationManager.desiredAccuracy=kCLLocationAccuracyBest;//指定需要的精度级别
            _locationManager.distanceFilter=1000.0f;//设置距离筛选器
        }
        [_locationManager startUpdatingLocation];
    }else{
        [_locationManager stopUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    DATA_ENV.curLocation = [NSString stringWithFormat:@"%f,%f",newLocation.coordinate.latitude,newLocation.coordinate.longitude];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Error: %@", [error description]);
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)parseURL:(NSURL *)url application:(UIApplication *)application {
	AlixPay *alixpay = [AlixPay shared];
	AlixPayResult *result = [alixpay handleOpenURL:url];
	if (result) {
        iOSLog(@"AliPay result=[%@], message=[%@].", result.resultString, result.statusMessage);
        NSString *msg = result.statusMessage;
        
		//是否支付成功
		if (9000 == result.statusCode) {
            if (msg == nil || msg.length < 1) {
                msg = @"支付成功！";
            }
            [EBuyOrderInfo changeState:0];
			// 用公钥验证签名
            id<DataVerifier> verifier = CreateRSADataVerifier(RSA_ALIPAY_PUBLIC);
			if ([verifier verifyString:result.resultString withSign:result.signString]) {
				UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" 
																	 message:msg
																	delegate:nil 
														   cancelButtonTitle:@"确定" 
														   otherButtonTitles:nil];
				[alertView show];
				[alertView release];
			} else { //验签错误
				UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" 
																	 message:@"签名错误" 
																	delegate:nil 
														   cancelButtonTitle:@"确定" 
														   otherButtonTitles:nil];
				[alertView show];
				[alertView release];
			}
		} else {
            [EBuyOrderInfo changeState:1];
            //如果支付失败,可以通过result.statusCode查询错误码
			UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" 
																 message:result.statusMessage 
																delegate:nil 
													   cancelButtonTitle:@"确定" 
													   otherButtonTitles:nil];
			[alertView show];
			[alertView release];
		}
		
	}	
}

//支付宝加入
- (BOOL)isSingleTask{
	struct utsname name;
	uname(&name);
	float version = [[UIDevice currentDevice].systemVersion floatValue];//判定系统版本。
	if (version < 4.0 || strstr(name.machine, "iPod1,1") != 0 || strstr(name.machine, "iPod2,1") != 0) {
		return YES;
	}
	else {
		return NO;
	}
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
	
	[self parseURL:url application:application];
	return YES;
}

@end
