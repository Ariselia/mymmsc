//
//  UCMoviePlayer.h
//  FengZi
//
//  Created by  on 12-1-5.
//  Copyright (c) 2012年 iTotemStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Api+eShop.h"
#import <MediaPlayer/MediaPlayer.h>

@interface UCMoviePlayer : UIViewController {
    UIButton *playButton;
    MPMoviePlayerController *player;
    ProductInfo2 *info;
    
}

@property (nonatomic, retain) ProductInfo2 *info;

@end
