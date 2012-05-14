//
//  EWallView.h
//  FengZi
//
//  Created by wangfeng on 12-5-14.
//  Copyright (c) 2012年 ifengzi.cn. All rights reserved.
//

// 墙贴 来自文本应用扩展

#import "Api+eWall.h"

@interface EWallView : UIViewController<UIWebViewDelegate> {
    UIActivityIndicatorView *activity;
}
@property (nonatomic, retain) EWall *param;
@property (nonatomic, retain) IBOutlet UIWebView *webView;

@end
