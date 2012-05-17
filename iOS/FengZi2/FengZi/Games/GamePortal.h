//
//  GamePortal.h
//  FengZi
//
//  Created by wangfeng on 12-5-14.
//  Copyright (c) 2012年 ifengzi.cn. All rights reserved.
//

#import "Api+GameReward.h"
#import <iOSApi/iOSTableViewController.h>

@interface GamePortal : iOSTableViewController<iOSTableDataDelegate>{
    UITextBorderStyle   _borderStyle;
    NSMutableArray     *_items;
    UIFont             *_font;
    int                 _page;
    NSString           *_curSubject;
    
    int                 _type;
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UILabel *lable1;
@property (nonatomic, retain) IBOutlet UILabel *lable2;
@property (nonatomic, retain) IBOutlet UILabel *lable3;
@property (nonatomic, retain) IBOutlet UILabel *lable4;
@property (nonatomic, retain) IBOutlet UILabel *lable5;
@property (nonatomic, retain) IBOutlet UILabel *lable6;

@end
