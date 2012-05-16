//
//  EBuyRecommend.m
//  FengZi
//
//  Created by wangfeng on 12-3-8.
//  Copyright (c) 2012年 iTotemStudio. All rights reserved.
//

#import "EBuyRecommend.h"
#import "Api+Ebuy.h"
#import "EBuyPortal.h"
#import "EBExpressDetail.h"
#import "EBProductList.h"
#import "EBProductDetail.h"

@implementation EBuyRecommend

@synthesize ownerId;
@synthesize scrollView=_scrollView;
@synthesize desc;
@synthesize group;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        //_scrollView.delegate = self;
        segIndex = -1;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//static EBProductInfo *dst = nil;
static int dst_index = 0;
static int segIndex = 0;

+ (void)setType:(int)index{
    segIndex = index;
}

+ (int)type{
    return segIndex;
}

- (NSString *)subject:(int)pos{
    dst_index = pos;
    id obj = [_items objectAtIndex:pos];
    NSString *title = @"没有商品或商铺信息";
    if ([obj isKindOfClass:EBShop.class]) {
        EBShop *info = (EBShop *)obj;
        title = [iOSApi urlDecode:info.name];
    } else if ([obj isKindOfClass:EBProductInfo.class]) {
        EBProductInfo *info = (EBProductInfo *)obj;
        title = [iOSApi urlDecode:info.title];
    }
    return title;
}

- (NSString *)picUrl:(int)pos{
    dst_index = pos;
    id obj = [_items objectAtIndex:pos];
    NSString *title = @"没有商品或商铺信息";
    if ([obj isKindOfClass:EBShop.class]) {
        EBShop *info = (EBShop *)obj;
        title = [iOSApi urlDecode:info.picUrl];
    } else if ([obj isKindOfClass:EBProductInfo.class]) {
        EBProductInfo *info = (EBProductInfo *)obj;
        title = [iOSApi urlDecode:info.picUrl];
    }
    return title;
}

- (void)gotoInfo{
    EBuyPortal *portal = ownerId;
    id obj = [_items objectAtIndex:dst_index];
    if ([obj isKindOfClass:EBExpressType.class]) {
        EBExpressType *info = (EBExpressType *)obj;
        EBExpressDetail *nextView = [[EBExpressDetail alloc] init];
        nextView.param = info;
        [portal.navigationController pushViewController:nextView animated:YES];
        [nextView release];
    } else if ([obj isKindOfClass:EBShop.class]) {
        EBShop *info = (EBShop *)obj;
        EBProductList *nextView = [[EBProductList alloc] init];
        nextView.way = 0;
        nextView.typeId = [NSString valueOf:info.id];
        [portal.navigationController pushViewController:nextView animated:YES];
        [nextView release];
    } else if ([obj isKindOfClass:EBProductInfo.class]) {
        EBProductInfo *info = (EBProductInfo *)obj;
        EBProductDetail *nextView = [[EBProductDetail alloc] init];
        nextView.param = info.id;
        [portal.navigationController pushViewController:nextView animated:YES];
        [nextView release];
    }
}

- (void)setAction:(int)pos{
    if (pos < 1) {
        return;
    }
    dst_index = pos;
    desc.text = [self subject:dst_index];
}

- (void)moveInfo1{
    if (dst_index < 0) {
        return;
    }
    int pos = dst_index - 1;
    [CATransaction begin];
    [CATransaction setAnimationDuration:0.3];
    [CATransaction commit];
    self.scrollView.contentOffset = CGPointMake(pos * 90, 0);
    [self setAction:pos];
}

- (void)moveInfo2{
    if (dst_index < 1) {
        return;
    }
    int pos = dst_index + 1;
    [CATransaction begin];
    [CATransaction setAnimationDuration:0.3];
    [CATransaction commit];
    self.scrollView.contentOffset = CGPointMake(pos * 90, 0);
    
    [self setAction:pos];
}


- (void)awakeFromNib{
    [super awakeFromNib];
    group.selectedSegmentIndex = [EBuyRecommend type];
    if (_items.count < 1) {
        _items = [[NSMutableArray alloc] initWithCapacity:0];
    }
    [_items removeAllObjects];
    NSArray *list = nil;
    if (segIndex == 0) {
        // 疯狂抢购:push接口
        list = [[Api ebuy_push:1] retain];
    } else {
        // 金牌店铺:shoplist接口
        list = [[Api ebuy_shoplist:1] retain];
    }
    [_scrollView removeSubviews];
    if (list.count > 0) {
        [list retain];
        [_items addObjectsFromArray:list];
        int xWidth = 90;
        int xHeight = 90;
        int num = list.count;
        _scrollView.contentSize = CGSizeMake(xWidth * (num + 2) , xHeight);
        CGRect bounds = _scrollView.bounds;
        bounds.size.width = 90;
        _scrollView.contentOffset = CGPointMake(90, 180);
        UIImage *undef = [UIImage imageNamed:@"unknown.png"];
        int i = 1;
        for (int j = 0; j < _items.count; j++) {
            iOSImageView *iv = [[[iOSImageView alloc] initWithImage:undef] autorelease];
            [iv imageWithURL:[self picUrl:j]];
            CGRect frame = iv.frame;
            frame.origin.x = xWidth * i;
            frame.origin.y = 15;
            frame.size.height = 70;
            frame.size.width = 70;
            iv.frame = frame;
            [_scrollView addSubview:iv];
            i ++;
        }
        [list release];
        _scrollView.contentOffset = CGPointMake(0, 90);
        _scrollView.contentOffset = CGPointMake(90, 180);
        if (_items.count >= 2) {
            [self setAction:1];
        }
        [_scrollView flashScrollIndicators];
        CGRect frame = CGRectMake(115, 30, 90, 90);
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = frame;
        [btn addTarget:self action:@selector(gotoInfo) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        frame = CGRectMake(25, 30, 90, 90);
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = frame;
        [btn addTarget:self action:@selector(moveInfo1) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        frame = CGRectMake(205, 30, 90, 90);
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = frame;
        [btn addTarget:self action:@selector(moveInfo2) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
}

// 选择
- (IBAction)segmentAction:(UISegmentedControl *)segment{
    NSInteger Index = segment.selectedSegmentIndex;
    EBuyPortal *potal = ownerId;
    [potal doSelect:Index];
}

#pragma mark - scroll view

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGPoint currentOffset = [scrollView contentOffset];
    int offset = currentOffset.x;
    int pos = offset / 90;
    int min = pos * 90;
    int max = min + 90;
    if (currentOffset.x >= min && currentOffset.x < min + 45) {
        scrollView.contentOffset = CGPointMake(min, currentOffset.y);
        desc.text = [self subject:pos];
    } else if (currentOffset.x >= min + 45 && currentOffset.x < max) {
        scrollView.contentOffset = CGPointMake(max, currentOffset.y);
        pos ++;
        if (pos >= [_items count] ) {
            return;
        }
        [self setAction:pos];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self scrollViewDidEndDecelerating:scrollView];
}

@end
