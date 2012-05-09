//
//  EBuyEditAddress.h
//  FengZi
//
//  Created by wangfeng on 12-4-23.
//  Copyright (c) 2012年 ifengzi.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
// 确认订单页
@interface EBuyEditAddress : UIViewController{
    UITextBorderStyle    _borderStyle;
    NSMutableArray      *_items;
    UIFont              *_font;
    int                  _page;
    BOOL                 isEmpty; // 地址簿是否空
}
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, copy) NSString *param;
@property (nonatomic, copy) NSString *shopName;

@end
