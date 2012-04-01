//
//  EBShopList.h
//  FengZi
//
//  Created by wangfeng on 12-3-23.
//  Copyright (c) 2012年 iTotemStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iOSApi/iOSTableViewController.h>
#import "Api+Ebuy.h"

@interface EBShopList : UIViewController{
    int _page;
    UITextBorderStyle   _borderStyle;
    NSMutableArray     *items;
}
@property (nonatomic, copy) NSString *param;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UILabel *subject;
@property (nonatomic, retain) IBOutlet UILabel *pClass;


@end
