//
//  EBProductList.h
//  FengZi
//
//  Created by wangfeng on 12-4-11.
//  Copyright (c) 2012年 ifengzi.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EBProductList : UIViewController{
    int                 _page;
    UITextBorderStyle   _borderStyle;
    NSMutableArray     *_items;
}
@property (nonatomic, assign) int way;
@property (nonatomic, assign) int typeId;

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UILabel *subject;
@property (nonatomic, retain) IBOutlet UILabel *pClass;

@end
