//
//  EBuyCar.h
//  FengZi
//
//  Created by wangfeng on 12-4-22.
//  Copyright (c) 2012年 ifengzi.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

// 购物车
@interface EBuyCar : UIViewController{
    UITextBorderStyle    _borderStyle;
    NSMutableDictionary *_items;
    UIFont              *_font;
    int                  _page;
}
@property (nonatomic, retain) IBOutlet UITableView *tableView;

@end
