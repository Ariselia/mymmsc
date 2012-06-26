//
//  UIButton+Utils.m
//  FengZi
//
//  Created by wangfeng on 12-5-2.
//  Copyright (c) 2012年 ifengzi.cn. All rights reserved.
//

#import "UIButton+Utils.h"

@implementation UIButton (Utils)

- (void)setImage:(NSString *)filename{
    NSString *nameNormal = filename;
    NSString *nameHigh = [nameNormal stringByReplacingOccurrencesOfString:@".png" withString:@"_tap.png"];
    [self setImage:[UIImage imageNamed:nameNormal] forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:nameHigh] forState:UIControlStateHighlighted];
}

@end
