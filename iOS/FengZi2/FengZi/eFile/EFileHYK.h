//
//  EBuyPortal.h
//  FengZi
//
//  Created by wangfeng on 12-3-5.
//  Copyright (c) 2012年 iTotemStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Api+eFile.h"
// 电子蜂夹 入口
@interface EFileHYK : UIViewController{
    //UIButton           *_btnRight; // 导航条按钮
    //UIImage            *_curImage;
    UITextBorderStyle   _borderStyle;
    NSMutableArray     *_headers; // 表头显示CELL
    NSMutableArray     *_items; // 数据CELL
    UIFont             *_font;
    int                 _page;
    BOOL                isOnline;
  }
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) EFileMember *param;

@end
