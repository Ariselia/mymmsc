//
//  EBuyEvaluate.h
//  FengZi
//
//  Created by wangfeng on 12-4-23.
//  Copyright (c) 2012年 ifengzi.cn. All rights reserved.
//

#import <iOSApi/iOSTableViewController.h>

@interface EBuyEvaluate : iOSTableViewController<iOSTableDataDelegate>{
    UITextBorderStyle   _borderStyle;
    NSMutableArray     *_items;
    UIFont             *_font;
    int                 _page;
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;

@end