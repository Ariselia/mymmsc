//
//  EBuyRecommend.h
//  FengZi
//
//  Created by wangfeng on 12-3-8.
//  Copyright (c) 2012年 iTotemStudio. All rights reserved.
//
// 

#import <UIKit/UIKit.h>
#import "Api+Ebuy.h"

@interface EBuyRecommend : UITableViewCell<UIScrollViewDelegate>{
    UIScrollView *_scrollView;
    int          imgCount; // 一屏图片数
    int          imgWidth; // 单个图片宽度
    int          imgHeight; // 单个图片高度
    
    NSMutableArray *items;
}
@property(nonatomic, assign) id idInfo;
@property(nonatomic, retain) IBOutlet UIScrollView *scrollView; // 滚动视图
@property(nonatomic, retain) IBOutlet iOSImageView *pic;
@property(nonatomic, retain) IBOutlet UILabel *desc; // 推荐图片显示文本

@end
