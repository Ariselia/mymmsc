//
//  EBuyRecommend.h
//  FengZi
//
//  Created by wangfeng on 12-3-8.
//  Copyright (c) 2012年 iTotemStudio. All rights reserved.
//
// 

#import "Api+Ebuy.h"

@interface EBuyRecommend : UITableViewCell<UIScrollViewDelegate>{
    UIScrollView *_scrollView;
    int           _imgCount; // 一屏图片数
    int           _imgWidth; // 单个图片宽度
    int           _imgHeight; // 单个图片高度
    
    NSMutableArray *_items;
}
@property(nonatomic, assign) id ownerId;
@property (nonatomic, retain) IBOutlet UISegmentedControl *group;
@property(nonatomic, retain) IBOutlet UIScrollView *scrollView; // 滚动视图
@property(nonatomic, retain) IBOutlet UILabel *desc; // 推荐图片显示文本
//@property(nonatomic, assign) int segIndex;
+ (void)setType:(int)index;
+ (int)type;
// 选择
- (IBAction)segmentAction:(UISegmentedControl *)segment;
@end
