//
//  EBExpressDetail.h
//  FengZi
//
//  Created by wangfeng on 12-3-20.
//  Copyright (c) 2012年 iTotemStudio. All rights reserved.
//

#import "Api+Ebuy.h"

@interface EBExpressDetail : UIViewController{
    
}

@property (nonatomic, retain) EBExpressType *param;

@property (nonatomic, retain) IBOutlet UILabel *subject;
@property (nonatomic, retain) IBOutlet UILabel *time;
@property (nonatomic, retain) IBOutlet UIImageView *pic;
@property (nonatomic, retain) IBOutlet UITextView *desc;

@end
