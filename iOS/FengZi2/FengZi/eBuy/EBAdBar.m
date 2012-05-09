//
//  EBAdBar.m
//  FengZi
//
//  Created by wangfeng on 12-3-23.
//  Copyright (c) 2012年 iTotemStudio. All rights reserved.
//

#import "EBAdBar.h"
#import "Api+Ebuy.h"

@implementation EBAdBar
@synthesize ownerId;
@synthesize pic;

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

- (void)dealloc{
    IOSAPI_RELEASE(_items);
    [super dealloc];
}

- (void)awakeFromNib{
    [super awakeFromNib];
    _number = -1;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = pic.frame;
    [btn addTarget:self action:@selector(adGoto:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    _items = [NSMutableArray array];
    NSArray *list = [Api ebuy_ad_list];
    if (list.count > 0) {
        [list retain];
        _items = [[NSMutableArray alloc] initWithCapacity:0];
        [_items addObjectsFromArray:list];
        [list release];
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(handleTimer:) userInfo:nil repeats:NO];
    }
}

- (void)handleTimer:(NSTimer *)theTimer{
    EBAd *obj = nil;
    if (_number >= 0 && pic.isReady) {
        obj = [_items objectAtIndex:_number];
        obj.image = pic.image;
    }
    if (_number + 1 >= _items.count) {
        _number = -1;
    }
    obj = [_items objectAtIndex:++_number];
    if (obj.image == nil) {
        NSString *url = [iOSApi urlDecode:obj.pic];
        //iOSLog(@"%d: %@", _number, url);
        [pic imageWithURL:url];
    } else {
        pic.image = obj.image;
        pic.isReady = YES;
    }
    [_timer invalidate];
    _timer = nil;
    _timer = [NSTimer scheduledTimerWithTimeInterval:10.0f target:self selector:@selector(handleTimer:) userInfo:nil repeats:NO];
}

- (void)adGoto:(id)sender{
    NSString *sUrl = @"www.ifengzi.cn";
    EBAd *obj = nil;
    if (_number >= 0) {
        if (pic.isReady) {
            obj = [_items objectAtIndex:_number];
        } else if(_number - 1 >= 0){
            obj = [_items objectAtIndex:_number -1];
        }
        sUrl = [iOSApi urlDecode:obj.url];
    }
    [iOSApi openUrl:sUrl];
}
@end
