//
//  EBuyComments.h
//  FengZi
//
//  Created by wangfeng on 12-4-12.
//  Copyright (c) 2012年 ifengzi.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

// 商品评论
@interface EBuyComments : UIViewController{
    UITextBorderStyle   _borderStyle;
    NSMutableArray     *_items;
    UIFont             *_font;
    int                 _page;
}
@property (nonatomic, copy) NSString *param;
@property (nonatomic, retain) IBOutlet UITableView *tableView;

@end
