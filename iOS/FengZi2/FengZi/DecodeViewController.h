//
//  DecodeViewController.h
//  QRCode
//
//  Copyright (c) 2011 iTotemStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXingWidgetController.h"
#import "Decoder.h"
#import "UCAppStore.h"

@interface DecodeViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,ZXingDelegate,DecoderDelegate,UIAlertViewDelegate,UCAppStoreDelegate>{
    UIImage *_curImage;
    IBOutlet UIImageView *_camecaScanImagevView;
    IBOutlet UIImageView *_imageScanImageVew;
    IBOutlet UIImageView *_webSiteScanImageView;
    BOOL _isHideNavi;
}

@property (nonatomic, retain) IBOutlet UIButton *btnLogin;

- (IBAction)tapOnSelectImageBtn:(id)sender;
- (IBAction)doLogin:(id)sender;

- (IBAction)gotoStore:(id)sender;

@end
