//
//  AppDelegate.h
//  FengZi
//
//  Copyright (c) 2011 iTotemStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ITTDataRequest.h"
#import "Reachability.h"
#import <CoreLocation/CoreLocation.h>
//摇晃手机加入
#import "PaintingWindow.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate,DataRequestDelegate,UIAlertViewDelegate>{
    UIImageView *_defaultImageView;
    UIActivityIndicatorView *_acivityIndicatorView;
    Reachability  *hostReach;
    CLLocationManager *_locationManager;
}

@property (retain, nonatomic) UIWindow *window;
-(void)setLocationStatus;
@end
