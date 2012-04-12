//
//  EBProductIntro.h
//  FengZi
//
//  Created by wangfeng on 12-4-8.
//  Copyright (c) 2012年 iTotemStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Api+Ebuy.h"

// 商品介绍
@interface EBProductIntro : UIViewController{
    UITextBorderStyle   _borderStyle;
    NSMutableArray     *_items;
    UIFont             *_font;
    int                 _page;
    EBProductInfo      *_product;
}
@property (nonatomic, copy) NSString *param;
@property (nonatomic, retain) IBOutlet UILabel *proId, *proPrice; // 商品编号, 商品价格
@property (nonatomic, retain) IBOutlet UITableView *tableView;

- (IBAction)optionAction:(UISegmentedControl *)segment;

@end
