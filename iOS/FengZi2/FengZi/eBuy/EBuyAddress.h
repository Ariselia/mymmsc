//
//  EBuyAddress.h
//  FengZi
//
//  Created by wangfeng on 12-4-23.
//  Copyright (c) 2012年 ifengzi.cn. All rights reserved.
//
#import <iOSApi/DropDownList.h>
#import <iOSApi/UIViewController+KeyBoard.h>

// 地址簿
@interface EBuyAddress : UIViewController<DropDownListDelegate>{
    DropDownList *ddShengs;
}
@property (nonatomic, copy) NSString *shopName;
@property (nonatomic, assign) int seqId; // 地址簿序号 
@property (nonatomic, retain) IBOutlet UITextField *sheng;
@property (nonatomic, retain) IBOutlet UITextField *chengshi;
@property (nonatomic, retain) IBOutlet UITextField *dizhi;
@property (nonatomic, retain) IBOutlet UITextField *shouhuoren;
@property (nonatomic, retain) IBOutlet UITextField *youbian;
@property (nonatomic, retain) IBOutlet UITextField *shouji;

- (IBAction)doSave:(id)sender;
- (IBAction)doCancel:(id)sender;
- (IBAction)doShowList:(id)sender;
@end
