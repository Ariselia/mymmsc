//
//  EBuyOrderWap.h
//  FengZi
//
//  Created by wangfeng on 12-5-20.
//  Copyright (c) 2012年 ifengzi.cn. All rights reserved.
//

#import "Api+eBuy.h"

@interface EBuyOrderWap : UIViewController<UIWebViewDelegate> {
    UIActivityIndicatorView *activity;
}
@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, copy) NSString *payUrl;
@property (nonatomic, assign) float totalFee;

@end
