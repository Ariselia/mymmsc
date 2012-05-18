//
//  EBuyOrderInfo.h
//  FengZi
//
//  Created by wangfeng on 12-4-23.
//  Copyright (c) 2012年 ifengzi.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Api+Ebuy.h"

@interface EBuyOrderInfo : UIViewController{
    UITextBorderStyle    _borderStyle;
    NSMutableArray      *_items;
    UIFont              *_font;
    int                  _page;
    BOOL                 isEmpty; // 地址簿是否空
    
    EBOrderInfo         *_orderInfo;
    int                  _shopId;
}
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, assign) BOOL bPay;
@property (nonatomic, assign) int xType;
@end
