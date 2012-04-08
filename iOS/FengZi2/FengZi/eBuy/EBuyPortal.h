//
//  EBuyPortal.h
//  FengZi
//
//  Created by wangfeng on 12-3-5.
//  Copyright (c) 2012年 iTotemStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EBuyPortal : UIViewController{
    UIButton           *_btnRight; // 导航条按钮
    UIImage            *_curImage;
    UITextBorderStyle   _borderStyle;
    NSMutableArray     *_items;
    UIFont             *_font;
    int                 _page;
}
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UISearchBar *searchBar;

@end
