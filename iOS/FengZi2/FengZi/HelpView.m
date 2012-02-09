//
//  HelpView.m
//  FengZi
//
//  Created by lt ji on 11-12-20.
//  Copyright (c) 2011年 iTotemStudio. All rights reserved.
//

#import "HelpView.h"

@implementation HelpView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void)startHelp{
    _scrollview.contentSize=CGSizeMake(1000, 480);
    self.frame = [UIScreen mainScreen].bounds;
    [UIApplication sharedApplication].keyWindow.windowLevel = UIWindowLevelAlert;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGPoint currentOffset = [scrollView contentOffset];
    if (currentOffset.x > 640) {
        self.frame = CGRectMake(0, 0, 0, 0);
        [UIApplication sharedApplication].keyWindow.windowLevel = UIWindowLevelNormal;
        [[UIApplication sharedApplication].keyWindow sendSubviewToBack:self];
        [USER_DEFAULT setBool:YES forKey:HELPSHOW];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc {
    [_scrollview release];
    [super dealloc];
}
@end
