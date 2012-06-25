//
//  DecodeViewController.h
//  QRCode
//
//  Copyright (c) 2011 iTotemStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ZXing/ZXingWidgetController.h>
#import <ZXing/Decoder.h>
#import "UCAppStore.h"

@interface DecodeViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,ZXingDelegate,DecoderDelegate,UIAlertViewDelegate,UCAppStoreDelegate>{
    UIImage *_curImage;
    IBOutlet UIImageView *_camecaScanImagevView;
    IBOutlet UIImageView *_imageScanImageVew;
    IBOutlet UIImageView *_webSiteScanImageView;
    IBOutlet UIView *_curtainView;//幕布
    IBOutlet UIButton *_curtainBtn;
    BOOL _isHideNavi;
    BOOL _isHideCurtain;
    UIView* maskView;              //遮罩层
    CGRect frameRect;

}

@property (nonatomic, retain) IBOutlet UIButton *btnLogin;

- (IBAction)tapOnSelectImageBtn:(id)sender;
- (IBAction)doLogin:(id)sender;

- (IBAction)gotoStore:(id)sender;
//拉动幕布
- (IBAction)doCurtain:(id)sender;

// 转向数字商城
- (IBAction)gotoStoreTable:(id)sender;
// 转向电子商城
- (IBAction)gotoEBuy:(id)sender;
// 转向电子蜂夹
- (IBAction)gotoEFile:(id)sender;
// 转向蜂幸运
- (IBAction)gotoLucky:(id)sender;
@end
