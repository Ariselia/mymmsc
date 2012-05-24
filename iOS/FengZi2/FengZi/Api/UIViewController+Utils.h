//
//  UIViewController+Utils.h
//  FengZi
//
//  Created by  on 12-2-12.
//  Copyright (c) 2012年 iTotemStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 默认返回上一页 */
#define kLoginBackDefault (0)
/** 返回上一页 */
#define kLoginBackFront   kLoginBackDefault
/** 返回导航第一页 */
#define kLoginBackRoot    (1)
/** 模式返回, 即关闭下拉的模式视图 */
#define kLoginBackModel   (2)

@interface UIViewController (Utils)

// 跳转登录页面
- (void)gotoLogin;

- (void)gotoLogin:(int)type;

- (NSString *)kmaContent;
- (void)setKmaContent:(NSString *)content;

// 通用解码业务页面跳转
-(void) chooseShowController:(NSString*)input;

@end
