//
//  UCMusicPlayer.h
//  FengZi
//
//  Created by  on 12-1-5.
//  Copyright (c) 2012年 iTotemStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "Api+eShop.h"

@interface UCMusicPlayer : UIViewController {
    UIButton *playButton;
    AVAudioPlayer *player;;
    ProductInfo *info;
    
}

@property (nonatomic, retain) ProductInfo *info;

@end
