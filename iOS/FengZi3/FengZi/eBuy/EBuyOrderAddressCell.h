//
//  EBuyOrderAddressCell.h
//  FengZi
//
//  Created by wangfeng on 12-4-23.
//  Copyright (c) 2012年 ifengzi.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EBuyOrderAddressCell : UITableViewCell{
    
}
@property (nonatomic, retain) IBOutlet UILabel *addrAddress;
@property (nonatomic, retain) IBOutlet UILabel *addrCode;
@property (nonatomic, retain) IBOutlet UILabel *addrName;
@property (nonatomic, retain) IBOutlet UILabel *addrPhone;

@property (nonatomic, retain) IBOutlet UILabel *logicName;
@property (nonatomic, retain) IBOutlet UILabel *logicId;
@property (nonatomic, retain) IBOutlet UILabel *logicDate;
@property (nonatomic, retain) IBOutlet UILabel *logicPhone;
@end
