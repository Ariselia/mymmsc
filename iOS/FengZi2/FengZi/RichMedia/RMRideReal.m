//
//  RMRideReal.m
//  FengZi
//
//  Created by wangfeng on 12-4-19.
//  Copyright (c) 2012年 ifengzi.cn. All rights reserved.
//

#import "RMRideReal.h"

@implementation RMRideReal
@synthesize sex,photo,name,jiLing,carType,carColor,carModel,carPhoto,carNumber;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
