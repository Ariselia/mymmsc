//
//  EBuyOrderUserCell.h
//  FengZi
//
//  Created by wangfeng on 12-4-23.
//  Copyright (c) 2012年 ifengzi.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EBuyOrderUserCell : UITableViewCell{
    
}
@property (nonatomic, retain) IBOutlet UILabel *orderId;
@property (nonatomic, retain) IBOutlet UILabel *orderModel;
@property (nonatomic, retain) IBOutlet UILabel *orderState;
@property (nonatomic, retain) IBOutlet UILabel *orderNumber;
@property (nonatomic, retain) IBOutlet UILabel *orderPrice;
@property (nonatomic, retain) IBOutlet UILabel *orderPayStatus;

@end
