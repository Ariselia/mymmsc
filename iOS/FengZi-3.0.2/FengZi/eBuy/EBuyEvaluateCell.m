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
#import "EBuyEvaluateInfo.h"

@implementation EBuyEvaluateCell
@synthesize comm, productId, orderId;
@synthesize ownerId, imageView,subject,content;
@synthesize action;

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
    UIButton *btn = sender;
    EBuyEvaluate *owner = (EBuyEvaluate *)ownerId;
    if ([btn.titleLabel.text isEqualToString:@"发表评论"]) {
        EBuyEvaluatePage *nextView = [[EBuyEvaluatePage alloc] init];
        nextView.productId = productId;
        nextView.orderId = orderId;
        [owner.navigationController pushViewController:nextView animated:YES];
        [nextView release];
    } else {
        EBuyEvaluateInfo *nextView = [[EBuyEvaluateInfo alloc] init];
        nextView.id = comm.id;
        nextView.orderId = comm.orderId;
        [owner.navigationController pushViewController:nextView animated:YES];
        [nextView release];
    }    
}

@end
