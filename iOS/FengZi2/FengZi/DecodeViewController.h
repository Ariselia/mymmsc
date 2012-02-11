//
//  DecodeViewController.h
//  QRCode
//
//  Copyright (c) 2011 iTotemStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXingWidgetController.h"
#import "Decoder.h"

@interface DecodeViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,ZXingDelegate,DecoderDelegate,UIAlertViewDelegate>{
    UIImage *_curImage;
    IBOutlet UIImageView *_camecaScanImagevView;
    IBOutlet UIImageView *_imageScanImageVew;
    IBOutlet UIImageView *_webSiteScanImageView;
    BOOL _isHideNavi;
}

- (IBAction)tapOnSelectImageBtn:(id)sender;
- (IBAction)doLogin:(id)sender;

@end
