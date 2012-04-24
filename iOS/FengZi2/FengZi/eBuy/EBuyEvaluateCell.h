//
//  EBuyEvaluateCell.h
//  FengZi
//
//  Created by wangfeng on 12-4-24.
//  Copyright (c) 2012年 ifengzi.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Api.h"

@interface EBuyEvaluateCell : UITableViewCell{
    
}

@property (nonatomic, assign) id ownerId;
@property (nonatomic, retain) IBOutlet iOSImageView *imageView;
@property (nonatomic, retain) IBOutlet UILabel *subject;
@property (nonatomic, retain) IBOutlet UILabel *content;

@end
