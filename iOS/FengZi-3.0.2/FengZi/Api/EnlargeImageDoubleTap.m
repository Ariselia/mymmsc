//
//  EnlargeImageDoubleTap.m
//  EnlargeImagedouble
//
//  Created by 东 王 on 12-3-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EnlargeImageDoubleTap.h"

@implementation EnlargeImageDoubleTap

@synthesize parentview;
@synthesize imageBackground,imageBackView,maskView;
@interface EnlargeImageDoubleTap (private)
- (void)fadeIn;
- (void)fadeOut;
- (void)closeImage:(id)sender;
@end

/*
 * SetScaleAndRotation 初始化图片
 * @parent UIView 父窗口
 */
- (void)setDoubleTap:(UIView*) parent {
    parentview=parent;
    parentview.userInteractionEnabled=YES;
    self.userInteractionEnabled=YES;
    
    UITapGestureRecognizer *doubleTapRecognize = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleDoubleTap:)];
    //单机 1,双击 2
    doubleTapRecognize.numberOfTapsRequired = 1;
    [doubleTapRecognize setEnabled :YES];
    [doubleTapRecognize delaysTouchesBegan];
    [doubleTapRecognize cancelsTouchesInView];
    [self addGestureRecognizer:doubleTapRecognize];
}

#pragma UIGestureRecognizer Handles

/*
 * handleDoubleTap 双击图片弹出单独浏览图片层
 * recognizer 双击手势
 */
-(void) handleDoubleTap:(UITapGestureRecognizer *)recognizer
{   
    if (imageBackView==nil) {
        if( [[UIDevice currentDevice] orientation]==UIDeviceOrientationLandscapeLeft||[[UIDevice currentDevice] orientation]==UIDeviceOrientationLandscapeRight) {
            frameRect = CGRectMake(0, 0, parentview.frame.size.height, parentview.frame.size.width);
        } else {   
            frameRect = CGRectMake(0, 0, parentview.frame.size.width, parentview.frame.size.height);
        }
        //imageBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.image.size.width+20, self.image.size.height+60)];
        if(self.image.size.width >= 280) {
            imageBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 290, self.image.size.height*280/self.image.size.width+10)]; 
        } else {
            imageBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.image.size.width+10, self.image.size.height+10)];   
        }
        imageBackView.backgroundColor = [UIColor grayColor];
        imageBackView.layer.cornerRadius = 10.0; //根据需要调整
        [[imageBackView layer] setShadowOffset:CGSizeMake(10, 10)];
        [[imageBackView layer] setShadowRadius:5];
        [[imageBackView layer] setShadowOpacity:0.7];
        [[imageBackView layer] setShadowColor:[UIColor blackColor].CGColor];
        maskView = [[UIView alloc]initWithFrame:frameRect];
        maskView.backgroundColor = [UIColor grayColor];
        maskView.alpha=0.7;
        
        UIImage *imagepic = self.image;
        //UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(10, 30, self.image.size.width, self.image.size.height)];
        UIImageView *view;
        if(self.image.size.width>=280) {
            view = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 280, self.image.size.height*280/self.image.size.width)];
        } else {
            view  = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, self.image.size.width, self.image.size.height)];
        }
        [view setImage:imagepic];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *closeimg = [UIImage imageNamed:@"closeImage.png"];
        //btn.frame = CGRectMake(self.image.size.width-30,0, closeimg.size.width,closeimg.size.height);
        btn.frame = CGRectMake(view.frame.size.width- closeimg.size.width/2,view.frame.origin.y-closeimg.size.height/2, closeimg.size.width,closeimg.size.height);
        [btn setBackgroundImage:closeimg forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(closeImage:) forControlEvents:UIControlEventTouchUpInside];
    
        [imageBackView addSubview:view];
        [parentview addSubview:maskView];
        imageBackView.center= CGPointMake((frameRect.origin.x+frameRect.size.width)/2
                                      ,(frameRect.origin.y+frameRect.size.height)/2);
        [parentview addSubview:imageBackView];
        [imageBackView addSubview:btn];
        [parentview bringSubviewToFront:imageBackView];
        [parentview bringSubviewToFront:btn];
        [self fadeIn];
    }
}

/*
 * fadeIn 图片渐入动画
 */
- (void)fadeIn {
    imageBackView.transform = CGAffineTransformMakeScale(1.3, 1.3);
    imageBackView.alpha = 0;
    [UIView animateWithDuration:.55 animations:^{
        imageBackView.alpha = 1;
        imageBackView.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

/*
 * fadeOut 图片逐渐消失动画
 */
- (void)fadeOut{
    [UIView animateWithDuration:.35 animations:^{
        imageBackView.transform = CGAffineTransformMakeScale(1.3, 1.3);
        imageBackView.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [imageBackView removeFromSuperview];
        }
    }];
}

/*
 * closeImage 关闭弹出图片层
 */
-(void)closeImage:(id)sender {
    [self fadeOut];
    imageBackView=nil;
    [maskView removeFromSuperview];
    maskView=nil;
}

@end
