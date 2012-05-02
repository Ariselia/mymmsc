//
//  EBuyEvaluatePage.h
//  FengZi
//
//  Created by wangfeng on 12-5-2.
//  Copyright (c) 2012年 ifengzi.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

// 撰写评论内容页
@interface EBuyEvaluatePage : UIViewController{
    
}
@property (nonatomic, retain) IBOutlet UISegmentedControl *xType;
@property (nonatomic, retain) IBOutlet UITextView *xContent;
@property (nonatomic, retain) IBOutlet UILabel *xState;

// 选择图片
- (IBAction)selectPic:(id)sender;

// 选择 喜爱度
- (IBAction)segmentAction:(UISegmentedControl *)segment;

@end
