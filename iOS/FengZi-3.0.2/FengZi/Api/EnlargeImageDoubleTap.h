//
//  EnlargeImageDoubleTap.h
//  EnlargeImagedouble
//
//  Created by 东 王 on 12-3-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface EnlargeImageDoubleTap : UIImageView
{
    UIView      *parentview;       // 父窗口，即用将UIImageEx所加到的UIView
    UIImageView *imageBackground;  // 放大图片后的背景
    UIView      *imageBackView;    // 单独查看时的背景
    
    UIView      *maskView;         // 遮罩层
    CGRect       frameRect;
}

@property (nonatomic,retain) UIView *parentview;
@property (nonatomic,retain) UIImageView *imageBackground;
@property (nonatomic,retain) UIView* imageBackView;
@property (nonatomic,retain) UIView* maskView;



- (void)handleDoubleTap:(UITapGestureRecognizer *)recognizer;

//必须设置的
- (void)setDoubleTap:(UIView*)imageView;
@end
