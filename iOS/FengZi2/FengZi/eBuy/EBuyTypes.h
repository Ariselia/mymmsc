//
//  EBuyTypes.h
//  FengZi
//
//  Created by wangfeng on 12-4-20.
//  Copyright (c) 2012年 ifengzi.cn. All rights reserved.
//

#import <iOSApi/iOSTableViewController.h>

@interface EBuyTypes : iOSTableViewController<iOSTableDataDelegate>{
    UITextBorderStyle   _borderStyle;
    NSMutableArray     *_items;
    UIFont             *_font;
    int                 _page;
    NSString           *_curSubject;
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, copy) NSString *subject;
@property (nonatomic, assign) int frontId;
@property (nonatomic, assign) int typeId;

@end
