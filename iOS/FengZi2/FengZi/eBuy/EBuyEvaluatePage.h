//
//  EBuyEvaluatePage.h
//  FengZi
//
//  Created by wangfeng on 12-5-2.
//  Copyright (c) 2012年 ifengzi.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iOSApi/iOSStar.h>

// 撰写评论内容页
@interface EBuyEvaluatePage : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate>{
    iOSStar *_star;
    NSString *picUrl;
    int grade;
}
@property (nonatomic, copy) NSString *productId; // 商品id
@property (nonatomic, copy) NSString *orderId; // 订单id
@property (nonatomic, retain) IBOutlet UISegmentedControl *xType;
@property (nonatomic, retain) IBOutlet UITextView *xContent;
@property (nonatomic, retain) IBOutlet UILabel *xState;
@property (nonatomic, retain) IBOutlet UILabel *xStar;
@property (nonatomic, retain) IBOutlet UIButton *xButton;

// 选择图片
- (IBAction)selectPic:(id)sender;

// 选择 喜爱度
- (IBAction)segmentAction:(UISegmentedControl *)segment;

// 提交评论
- (IBAction)doSubmit:(id)sender;

@end
