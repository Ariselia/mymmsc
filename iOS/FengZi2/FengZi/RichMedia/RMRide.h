//
//  RMRide.h
//  FengZi
//
//  Created by wangfeng on 12-4-15.
//  Copyright (c) 2012年 ifengzi.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Api+RichMedia.h"

@interface RMRide : UIViewController{
    RideInfo       *_ride;
    NSMutableArray *_items;
}
@property (nonatomic, copy) NSString *maId; // 调用者传入的空码ID
@property (nonatomic, retain) IBOutlet UITableView *tableView;

@end
