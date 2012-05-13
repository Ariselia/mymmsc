//
//  EFileMain.h
//  FengZi
//
//  Created by a on 12-4-19.
//  Copyright (c) 2012年 ifengzi.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EFilePortal.h"
#import "Api+eFile.h"
#import "UITableViewCellExt.h"
#import "EFileHYK.h"
#import "UCAppStore.h"
#import "CommonUtils.h"

@interface EFileMain : UIViewController
<UIWebViewDelegate>{
	
	IBOutlet UIWebView *myWebView;
    IBOutlet UIImageView *myImg;
}
@property (nonatomic, retain)  UIWebView *myWebView;
@property (nonatomic, retain)  UIImageView *myImg;
@end
