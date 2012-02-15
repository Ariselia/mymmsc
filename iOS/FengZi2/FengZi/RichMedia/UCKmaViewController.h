//
//  UCKmaViewController.h
//  FengZi
//
//  Created by  on 12-1-8.
//  Copyright (c) 2012年 iTotemStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArcScrollView.h"

@interface UCKmaViewController : UIViewController<ArcScrollViewDelegate>{
    ArcScrollView *_arcView;
    //IBOutlet UIButton *_commonEncodeBtn;
    //IBOutlet UIButton *_iconEncodeBtn;
    //IBOutlet UIImageView *_commonEncodeImageView;
    //IBOutlet UIImageView *_iconEncodeImageView;
    EncodeImageType _curType;
    NSString *code;
}
@property (nonatomic, retain) UIImage *curImage;
@property (nonatomic, retain) NSString *code;
@property (nonatomic, assign) BOOL forceEdit;

@end
