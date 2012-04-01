//
//  UCMyComments.h
//  FengZi
//
//  Created by wangfeng on 12-3-31.
//  Copyright (c) 2012年 iTotemStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

// 我的评论
@interface UCMyComments : UIViewController{
    NSMutableArray    *items;
    UIFont            *font;
    UITextBorderStyle  _borderStyle;
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;

@end
