//
//  UCAppStore.h
//  FengZi
//
//  Created by WangFeng on 11-12-15.
//  Copyright (c) 2012年 mymmsc.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UCAppStoreDelegate;

/**
 * 商城总入口
 */
@interface UCAppStore : UIViewController {
    //
}

@property (nonatomic, assign) id<UCAppStoreDelegate> proxy;

- (IBAction)hideWindow:(id)sender;

// 转向数字商城
- (IBAction)gotoStoreTable:(id)sender;
// 转向电子商城
- (IBAction)gotoEBuy:(id)sender;
// 转向电子蜂夹
- (IBAction)gotoEFile:(id)sender;

@end

@protocol UCAppStoreDelegate

// 关闭商城视图
- (void)closeAppStore;

@end