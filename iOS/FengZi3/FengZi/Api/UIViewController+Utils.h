//
//  UIViewController+Utils.h
//  FengZi
//
//  Created by  on 12-2-12.
//  Copyright (c) 2012年 fengxiafei.com. All rights reserved.
//

#import "Api.h"

@interface UIViewController (Utils)

// 跳转登录页面
- (void)gotoLogin;

- (NSString *)kmaContent;
- (void)setKmaContent:(NSString *)content;


// 通用解码业务页面跳转
- (void)chooseShowController:(NSString*)input isSave:(BOOL)isSave;

@end
