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
#import "EBProductDetail.h"
#import "EBShopList.h"

@implementation EBuyRecommend

@synthesize ownerId;
@synthesize scrollView=_scrollView;
@synthesize desc;
//@synthesize pic;

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

- (IBAction)doShopList:(id)sender {
    EBuyPortal *portal = ownerId;
    EBShopList *nextView = [[EBShopList alloc] init];
    //nextView.param = dst;
    [portal.navigationController pushViewController:nextView animated:YES];
    [nextView release];
}

static EBProductInfo *dst = nil;

- (void)gotoInfo{
    EBuyPortal *portal = ownerId;
    EBProductDetail *nextView = [[EBProductDetail alloc] init];
    nextView.param = dst.id;
    [portal.navigationController pushViewController:nextView animated:YES];
    [nextView release];
}

- (void)setAction:(int)pos{
    if (pos < 1) {
        return;
    }
    dst = [items objectAtIndex: pos];
    desc.text = [iOSApi urlDecode:dst.title];
    /*
    CGRect frame = desc.frame;
    frame.origin.y += 5;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    [btn addTarget:self action:@selector(gotoInfo) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    */
}

- (void)awakeFromNib{
    //[items removeAllObjects];
    //UIImage *image = [UIImage imageNamed:@"ebuy_sun_main_putbg.png"];
    //desc.backgroundColor = [UIColor colorWithPatternImage:[image scaleToSize:desc.frame.size]];
    if (items.count < 1) {
        items = [[NSMutableArray alloc] initWithCapacity:0];
    }
    NSArray *list = [Api ebuy_push:1];
    if (list.count > 0) {
        [list retain];
        [items addObjectsFromArray: list];
        int xWidth = 90;
        int xHeight = 90;
        int num = list.count;
        _scrollView.contentSize = CGSizeMake(xWidth * (num + 2) , xHeight);
        CGRect bounds = _scrollView.bounds;
        bounds.size.width = 90;
        //_scrollView.bounds = bounds;
        _scrollView.contentOffset = CGPointMake(90, 180);
        UIImage *undef = [UIImage imageNamed:@"unknown.png"];
        int i = 1;
        for (EBProductInfo *obj in list) {
            iOSImageView *iv = [[[iOSImageView alloc] initWithImage:undef] autorelease];
            [iv imageWithURL:[iOSApi urlDecode:obj.picUrl]];
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
        if (items.count >= 2) {
            [self setAction:1];
        }
        CGRect frame = CGRectMake(115, 30, 90, 90);
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = frame;
        [btn addTarget:self action:@selector(gotoInfo) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
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
        //desc.text = [NSString stringWithFormat:@"第 %d 个商品", pos];
        EBProductInfo *obj = [items objectAtIndex:pos];
        desc.text = [iOSApi urlDecode:obj.title];
    } else if (currentOffset.x >= min + 45 && currentOffset.x < max) {
        scrollView.contentOffset = CGPointMake(max, currentOffset.y);
        //desc.text = [NSString stringWithFormat:@"第 %d 个商品", pos];
        pos ++;
        if (pos >= [items count] ) {
            return;
        }
        [self setAction:pos];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self scrollViewDidEndDecelerating:scrollView];
}

@end
