//
//  UCWebView.h
//  FengZi
//
//  Created by a on 12-5-25.
//  Copyright (c) 2012年 ifengzi.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UCWebView : UIViewController<UIWebViewDelegate> 
{
   
    UIActivityIndicatorView *activity;
}
@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) NSString *webtitle;
@property (nonatomic, retain) NSString *weburl;
@end
