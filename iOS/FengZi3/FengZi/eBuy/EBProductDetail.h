//
//  EBProductDetail.h
//  FengZi
//
//  Created by wangfeng on 12-3-22.
//  Copyright (c) 2012年 iTotemStudio. All rights reserved.
//

//
// 商品详情页
// 

#import "Api+Ebuy.h"

@interface EBProductDetail : UIViewController{
    UITextBorderStyle   _borderStyle;
    NSMutableArray     *_items;
    UIFont             *_font;
    int                 _page;
    EBProductInfo      *_product;
}
@property (nonatomic, copy) NSString *param;
@property (nonatomic, retain) IBOutlet UILabel *proId, *proPrice; // 商品编号, 商品价格
@property (nonatomic, retain) IBOutlet UITableView *tableView;

@end
