//
//  EBuyPanel.m
//  FengZi
//
//  Created by wangfeng on 12-4-10.
//  Copyright (c) 2012年 ifengzi.cn. All rights reserved.
//

#import "EBuyPanel.h"
#import "EBuyPortal.h"
#import "EBMessageList.h"
#import "EBuyTypes.h"
#import "EBuyCar.h"
#import "EBuyCollect.h"
#import "EBuyOrderList.h"
#import "EBuyEvaluate.h"

@implementation EBuyPanel
@synthesize ownerId;
//@synthesize group;
@synthesize photo,name,userType,jiFen;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        //_scrollView.delegate = self;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

// 站内消息
- (IBAction)doSiteMsg:(id)sender{
    EBuyPortal *potal = ownerId;
    EBMessageList *nextView = [[EBMessageList alloc] init];
    [potal.navigationController pushViewController:nextView animated:YES];
    [nextView release];
}

// 我的订单
- (IBAction)doMyOrder:(id)sender{
    EBuyPortal *potal = ownerId;
    EBuyOrderList *nextView = [[EBuyOrderList alloc] init];
    [potal.navigationController pushViewController:nextView animated:YES];
    [nextView release];
}

// 购物车
- (IBAction)doShoppingCar:(id)sender{
    EBuyPortal *potal = ownerId;
    EBuyCar *nextView = [[EBuyCar alloc] init];
    [potal.navigationController pushViewController:nextView animated:YES];
    [nextView release];
}

// 我的收藏
- (IBAction)doCollect:(id)sender{
    EBuyPortal *potal = ownerId;
    EBuyCollect *nextView = [[EBuyCollect alloc] init];
    [potal.navigationController pushViewController:nextView animated:YES];
    [nextView release];
}

// 评价
- (IBAction)doComment:(id)sender{
    EBuyPortal *potal = ownerId;
    EBuyEvaluate *nextView = [[EBuyEvaluate alloc] init];
    [potal.navigationController pushViewController:nextView animated:YES];
    [nextView release];
}

// 分类
- (IBAction)doGroup:(id)sender{
    EBuyPortal *potal = ownerId;
    EBuyTypes *nextView = [[EBuyTypes alloc] init];
    nextView.typeId = 0;
    [potal.navigationController pushViewController:nextView animated:YES];
    [nextView release];
}

/*
// 选择
- (IBAction)segmentAction:(UISegmentedControl *)segment{
    NSInteger Index = segment.selectedSegmentIndex;
    EBuyPortal *potal = ownerId;
    [potal doSelect:Index];
}
*/
- (void)awakeFromNib{
    [super awakeFromNib];
}

@end
