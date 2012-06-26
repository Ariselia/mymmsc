//
//  Roulette.h
//  FengZi
//
//  Created by a on 12-5-2.
//  Copyright (c) 2012年 ifengzi.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Api+GameReward.h"
@interface Roulette : UIViewController
{
NSString *luckyid;
NSString *shopguid;
}
@property (nonatomic, copy) NSString *luckyid;
@property (nonatomic, copy) NSString *shopguid;
@property (nonatomic, retain)  IBOutlet UIButton *btn1;
@property (nonatomic, retain)  IBOutlet UIImageView *imgView;
@property (nonatomic, assign) int num;
@property (nonatomic, assign) int time;
@property (nonatomic, assign) int jstime;
@property (nonatomic, assign) BOOL isJs;
- (IBAction)goBreak:(id)sender;
@end
