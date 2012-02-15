//
//  UIViewController+Utils.m
//  FengZi
//
//  Created by  on 12-2-12.
//  Copyright (c) 2012年 iTotemStudio. All rights reserved.
//

#import "UIViewController+Utils.h"
#import "UCLogin.h"

@implementation UIViewController (Utils)

// 跳转登录页面
- (void)gotoLogin{
    UCLogin *nextView = [UCLogin new];
    [self.navigationController pushViewController:nextView animated:YES];
    [nextView release];
}

static NSString *kma_content = @"";

- (NSString *)kmaContent {
    return kma_content;
}

- (void)setKmaContent:(NSString *)content {
    kma_content = content;
}

@end
