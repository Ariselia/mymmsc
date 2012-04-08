//
//  UITableViewCell+Effect.m
//  FengZi
//
//  Created by wangfeng on 12-4-9.
//  Copyright (c) 2012年 ifengzi.cn. All rights reserved.
//

#import "UIView+Effect.h"

@implementation UITableViewCell (Effect)

- (void)setLayerEffect:(CALayer *)layer{
    //effectView.backgroundColor = [UIColor whiteColor]; // 把背景設成白色
    //effectView.backgroundColor = [UIColor clearColor]; // 透明背景
    
    layer.cornerRadius = 4.0f; // 圓角的弧度
    layer.masksToBounds = NO;
    
    layer.shadowColor = [[UIColor blackColor] CGColor];
    layer.shadowOffset = CGSizeMake(1.0f, 1.0f); // [水平偏移, 垂直偏移]
    layer.shadowOpacity = 0.5f; // 0.0 ~ 1.0 的值
    layer.shadowRadius = 1.0f; // 陰影發散的程度
    
    layer.borderWidth = 2.0;
    layer.borderColor = [[UIColor lightTextColor] CGColor];
    
    /*CAGradientLayer *gradient = [CAGradientLayer layer];
     gradient.frame = sampleView.bounds;
     gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor whiteColor] CGColor], (id)[[UIColor grayColor] CGColor], nil]; // 由上到下的漸層顏色
     [effectView.layer insertSublayer:gradient atIndex:0];
     */
}

@end
