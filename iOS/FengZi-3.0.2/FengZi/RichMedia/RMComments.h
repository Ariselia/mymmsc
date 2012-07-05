//
//  RMComments.h
//  FengZi
//
//  Created by wangfeng on 12-4-3.
//  Copyright (c) 2012年 iTotemStudio. All rights reserved.
//

// 記得在 header 檔裡引入 QuartzCore
#import <QuartzCore/QuartzCore.h>
#import "Api+UserCenter.h"
#import <iOSApi/iOSTableViewController.h>

@interface RMComments : iOSTableViewController<iOSTableDataDelegate>{
    NSMutableArray    *_items;
    UIFont            *_font;
    UITextBorderStyle  _borderStyle;
    int                _page;
    int                _size;
    int                _firstId;
    
    UITextField *content;
}
@property (nonatomic, copy) NSString *param;
@property (nonatomic, retain) IBOutlet UITableView *tableView;

@end
