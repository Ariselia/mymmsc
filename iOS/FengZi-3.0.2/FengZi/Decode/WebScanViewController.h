//
//  WebScanViewController.h
//  FengZi
//

//  Copyright (c) 2011年 iTotemStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ZXing/Decoder.h>
@interface WebScanViewController : UIViewController<UIWebViewDelegate,DecoderDelegate>{
    UISearchBar *_webSeachBar;
    UIWebView *_scanWebView;
    UIActivityIndicatorView *_activityIndicatorView;
    UIImage *_webImage;
    IBOutlet UITextField *_searchField;
}
@property (retain, nonatomic) IBOutlet UIWebView *scanWebView;

@end
