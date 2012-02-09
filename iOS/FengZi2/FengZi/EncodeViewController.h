//
//  EncodeViewController.h
//  QRCode
//
//  Copyright (c) 2011 iTotemStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArcScrollView.h"
@interface EncodeViewController : UIViewController<ArcScrollViewDelegate>{
    ArcScrollView *_arcView;
    IBOutlet UIButton *_commonEncodeBtn;
    IBOutlet UIButton *_iconEncodeBtn;
    IBOutlet UIImageView *_commonEncodeImageView;
    IBOutlet UIImageView *_iconEncodeImageView;
    EncodeImageType _curType;
}

@end
