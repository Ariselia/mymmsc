//
//  EBShopInfo.h
//  FengZi
//
//  Created by wangfeng on 12-3-28.
//  Copyright (c) 2012年 iTotemStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Api+Ebuy.h"

@interface EBShopInfo : UITableViewCell {
    
}

@property (nonatomic, retain) IBOutlet UILabel *subject;
@property (nonatomic, retain) IBOutlet UILabel *desc;
@property (nonatomic, retain) IBOutlet iOSImageView *pic;
@property (nonatomic, retain) IBOutlet UILabel *price;

@end
