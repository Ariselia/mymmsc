//
//  EBMessageList.h
//  FengZi
//
//  Created by wangfeng on 12-4-10.
//  Copyright (c) 2012年 ifengzi.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

// 站内消息
@interface EBMessageList : UIViewController{
    UITextBorderStyle   _borderStyle;
    NSMutableArray     *_items;
    UIFont             *_font;
    int                 _page;
    int                 _selected;
    UITextField *content;
}
@property (nonatomic, retain) IBOutlet UITableView *tableView;
// 选择
- (IBAction)segmentAction:(UISegmentedControl *)segment;
@end
