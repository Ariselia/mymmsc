//
//  ImageDecodeViewController.h
//  FengZi
//
//  Created by lt ji on 12-1-5.
//  Copyright (c) 2012年 iTotemStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ZXing/Decoder.h>
@interface ImageDecodeViewController : UIViewController<DecoderDelegate,UIGestureRecognizerDelegate>{
    UIImage *_curImage;
    IBOutlet UIImageView *_editImageView;
    IBOutlet UIScrollView *_scrollView;
    CGFloat lastScale;
    IBOutlet UIImageView *_frameImageView;
}
@property(nonatomic, retain) UIImage *curImage;
@end
