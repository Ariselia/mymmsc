//
//  EBuyEvaluateInfo.h
//  FengZi
//
//  Created by wangfeng on 12-5-15.
//  Copyright (c) 2012年 ifengzi.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iOSApi/iOSStar.h>
#import <iOSApi/iOSImageView.h>

@interface EBuyEvaluateInfo : UIViewController{
    iOSStar *_star;
}
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, retain) IBOutlet UITextView *xContent;
@property (nonatomic, retain) IBOutlet UILabel *xState;
@property (nonatomic, retain) IBOutlet UILabel *xTime;
@property (nonatomic, retain) IBOutlet iOSImageView *xPic;

@end
