//
//  UCRichMedia.h
//  FengZi
//
//  Created by  on 12-1-8.
//  Copyright (c) 2012年 iTotemStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * 富媒体 显示页面
 */
@interface UCRichMedia : UIViewController {
    NSString *urlMedia;
    UIButton *_btnRight; // 导航条按钮
    UIImage *_curImage;
    NSString *code;
    int      xCount;
}

@property (nonatomic, retain) UIImage *curImage;
@property (nonatomic, retain) IBOutlet UIImageView *picView1;
@property (nonatomic, retain) IBOutlet UIImageView *picView2;
@property (nonatomic, retain) IBOutlet UIImageView *picView3;
@property (nonatomic, retain) IBOutlet UIImageView *picView4;
@property (nonatomic, retain) IBOutlet UIImageView *picView5;
@property (nonatomic, retain) IBOutlet UIImageView *picView6;
@property (nonatomic, retain) NSString *urlMedia, *code;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollViewX;

@end
