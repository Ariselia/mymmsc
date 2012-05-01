//
//  EBuyPortal.h
//  FengZi
//
//  Created by wangfeng on 12-3-5.
//  Copyright (c) 2012年 iTotemStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

// 电子商城 入口
@interface EBuyPortal : UIViewController{
    UITextBorderStyle   _borderStyle;
    NSMutableArray     *_headers; // 表头显示CELL
    NSMutableArray     *_items; // 数据CELL
    UIFont             *_font;
    int                 _page;
    BOOL                isOnline;
    int                 _segIndex;
}
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UISearchBar *searchBar;

// 登录后选择疯狂抢购或者金牌店铺
- (void)doSelect:(int)index;

@end
