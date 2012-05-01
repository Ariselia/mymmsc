//
//  EBuyEvaluatePage.h
//  FengZi
//
//  Created by wangfeng on 12-5-2.
//  Copyright (c) 2012年 ifengzi.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EBuyEvaluatePage : UIViewController{
    
}
@property (nonatomic, retain) IBOutlet UISegmentedControl *xType;
@property (nonatomic, retain) IBOutlet UITextView *xContent;
@property (nonatomic, retain) IBOutlet UILabel *xState;

// 选择图片
- (IBAction)selectPic:(id)sender;

// 文本框变动的时候
- (void)textUpdate:(UITextView *)textView;

@end
