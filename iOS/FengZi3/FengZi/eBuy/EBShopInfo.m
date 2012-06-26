//
//  EBShopInfo.m
//  FengZi
//
//  Created by wangfeng on 12-3-28.
//  Copyright (c) 2012年 iTotemStudio. All rights reserved.
//

#import "EBShopInfo.h"

@implementation EBShopInfo
@synthesize subject, desc, pic, price;

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
