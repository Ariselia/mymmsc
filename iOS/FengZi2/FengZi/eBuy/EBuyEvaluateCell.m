//
//  EBuyEvaluateCell.m
//  FengZi
//
//  Created by wangfeng on 12-4-24.
//  Copyright (c) 2012年 ifengzi.cn. All rights reserved.
//

#import "EBuyEvaluateCell.h"
#import "EBuyEvaluatePage.h"
#import "EBuyEvaluate.h"

@implementation EBuyEvaluateCell
@synthesize productId, orderId;
@synthesize ownerId, imageView,subject,content;

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

// 跳转发表评论页面
- (IBAction)doWrite:(id)sender{
    EBuyEvaluate *owner = (EBuyEvaluate *)ownerId;
    EBuyEvaluatePage *nextView = [[EBuyEvaluatePage alloc] init];
    nextView.productId = productId;
    nextView.orderId = orderId;
    [owner.navigationController pushViewController:nextView animated:YES];
    [nextView release];
}

@end
