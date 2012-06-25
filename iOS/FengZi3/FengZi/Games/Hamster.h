//
//  Hamster.h
//  FengZi
//
//  Created by a on 12-5-3.
//  Copyright (c) 2012年 ifengzi.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Api+GameReward.h"
@interface Hamster : UIViewController
{
    NSMutableArray *btnArray;
    NSTimer *timer;
    UIButton *temBtn;
    NSString *luckyid;
    NSString *shopguid;
}
@property (nonatomic, copy) NSString *luckyid;
@property (nonatomic, copy) NSString *shopguid;
@property (nonatomic, retain)  IBOutlet UIButton *btn1;
@property (nonatomic, retain)  IBOutlet UIButton *btn2;
@property (nonatomic, retain)  IBOutlet UIButton *btn3;
@property (nonatomic, retain)  IBOutlet UIButton *btn4;
@property (nonatomic, retain)  IBOutlet UIButton *btn5;
@property (nonatomic, retain)  IBOutlet UIButton *btn6;
@property (nonatomic, retain)  IBOutlet UIButton *btn7;
@property (nonatomic, retain)  IBOutlet UIButton *btn8;
@property (nonatomic, retain)  IBOutlet UIButton *btn9;
@property (nonatomic, assign) int num;

@end
