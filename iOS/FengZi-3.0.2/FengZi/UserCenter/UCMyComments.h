//
//  UCMyComments.h
//  FengZi
//
//  Created by wangfeng on 12-3-31.
//  Copyright (c) 2012年 iTotemStudio. All rights reserved.
//
// 記得在 header 檔裡引入 QuartzCore
#import <QuartzCore/QuartzCore.h>
#import "Api+UserCenter.h"
#import <iOSApi/iOSTableViewController.h>

// 我的评论
@interface UCMyComments : iOSTableViewController<iOSTableDataDelegate>{
    NSMutableArray    *_items;
    UIFont            *_font;
    UITextBorderStyle  _borderStyle;
    int                _page;
    int                _size;
    BOOL isInit;
}


@property (nonatomic, retain) IBOutlet UITableView *tableView;

@end
