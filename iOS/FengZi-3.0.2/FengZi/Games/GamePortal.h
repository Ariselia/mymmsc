//
//  GamePortal.h
//  FengZi
//
//  Created by wangfeng on 12-5-14.
//  Copyright (c) 2012年 ifengzi.cn. All rights reserved.
//

#import "Api+GameReward.h"
#import <iOSApi/iOSTableViewController.h>

@interface GamePortal : UIViewController{
    UITextBorderStyle   _borderStyle;
    NSMutableArray     *_items;
    UIFont             *_font;
    int                 _page;
    NSString           *_curSubject;
    UIScrollView *_sview;
    int                 _type;
}
@property(nonatomic, retain) IBOutlet UIScrollView *scrollView; // 滚动视图
@end
