//
//  UIViewController+Utils.h
//  FengZi
//
//  Created by  on 12-2-12.
//  Copyright (c) 2012年 iTotemStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kLoginBackFront (0)
#define kLoginBackRoot  (1)
#define kLoginBackModel (2)

@interface UIViewController (Utils)

// 跳转登录页面
- (void)gotoLogin;

- (NSString *)kmaContent;
- (void)setKmaContent:(NSString *)content;

// 通用解码业务页面跳转
-(void) chooseShowController:(NSString*)input;

@end
