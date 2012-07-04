//
//  UCRichMedia.h
//  FengZi
//
//  Created by  on 12-1-8.
//  Copyright (c) 2012年 iTotemStudio. All rights reserved.
//

#import "Api+RichMedia.h"

/**
 * 富媒体 显示页面
 */
@interface UCRichMedia : UIViewController {
    UIButton *_btnRight; // 导航条按钮
    UIImage  *_curImage;
    int       xCount;
    BOOL      isInit;
    NSString *code;
    RichMedia *richMedia;
}

@property (nonatomic, retain) UIImage *curImage;
@property (nonatomic, retain) IBOutlet UIImageView *picView1;
@property (nonatomic, retain) IBOutlet UIImageView *picView2;
@property (nonatomic, retain) IBOutlet UIImageView *picView3;
@property (nonatomic, retain) IBOutlet UIImageView *picView4;
@property (nonatomic, retain) IBOutlet UIImageView *picView5;
@property (nonatomic, retain) IBOutlet UIImageView *picView6;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollViewX;

@property (nonatomic, copy) NSString *code;
@property (nonatomic, retain) RichMedia *richMedia;

@end
