//
//  EBuyCollect.h
//  FengZi
//
//  Created by wangfeng on 12-4-22.
//  Copyright (c) 2012年 ifengzi.cn. All rights reserved.
//

#import <iOSApi/iOSTableViewController.h>

// 我的收藏
@interface EBuyCollect : iOSTableViewController<iOSTableDataDelegate>{
    UITextBorderStyle   _borderStyle;
    NSMutableArray     *_items;
    UIFont             *_font;
    int                 _page;
    NSString           *_curSubject;
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;

@end
