//
//  RMRideReal.h
//  FengZi
//
//  Created by wangfeng on 12-4-19.
//  Copyright (c) 2012年 ifengzi.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Api.h"

// 顺风车 － 车主资料
@interface RMRideReal : UITableViewCell{
    
}
@property (nonatomic, retain) IBOutlet UILabel *name;
@property (nonatomic, retain) IBOutlet UILabel *sex;
@property (nonatomic, retain) IBOutlet UILabel *jiLing;
@property (nonatomic, retain) IBOutlet UILabel *carType;
@property (nonatomic, retain) IBOutlet UILabel *carModel;
@property (nonatomic, retain) IBOutlet UILabel *carColor;
@property (nonatomic, retain) IBOutlet UILabel *carNumber;
@property (nonatomic, retain) IBOutlet iOSImageView *photo;
@property (nonatomic, retain) IBOutlet iOSImageView *carPhoto;
@end
