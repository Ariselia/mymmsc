//
//  RMRideGuest.h
//  FengZi
//
//  Created by wangfeng on 12-4-23.
//  Copyright (c) 2012年 ifengzi.cn. All rights reserved.
//

#import "Api.h"

// 顺风车 - 客人
@interface RMRideGuest : UITableViewCell{
    
}
@property (nonatomic, retain) IBOutlet UILabel *name;
@property (nonatomic, retain) IBOutlet UILabel *sex;
@property (nonatomic, retain) IBOutlet iOSImageView *photo;
@end
