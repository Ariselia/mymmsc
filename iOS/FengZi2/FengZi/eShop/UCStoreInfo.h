//
//  UCStoreInfo.h
//  FengZi
//
//  Created by  on 12-1-3.
//  Copyright (c) 2012年 iTotemStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Api+eShop.h"
#import <iOSApi/iOSTableViewController.h>
#import <iOSApi/HttpDownload.h>

@interface UCStoreInfo : UITableViewController{
    ProductInfo    *info;
    NSMutableArray *items;
    UIFont         *font;
    int             _page;
}

@property (nonatomic, retain) ProductInfo *info;
@property (nonatomic, assign) int page;

@end
