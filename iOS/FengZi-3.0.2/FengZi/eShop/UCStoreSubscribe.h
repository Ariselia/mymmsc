//
//  UCStoreSubscribe.h
//  FengZi
//
//  Created by  on 12-1-4.
//  Copyright (c) 2012年 iTotemStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iOSApi/iOSTableViewController.h>
#import <iOSApi/HttpDownloader.h>
#import <MediaPlayer/MediaPlayer.h>

@interface UCStoreSubscribe : iOSTableViewController<HttpDownloaderDelegate, iOSTableDataDelegate> {
    UIButton           *_btnRight; // 导航条按钮
    UIImage            *_curImage;
    NSMutableArray     *items;
    
    MPMoviePlayerController *moviePlayer;
}

@end
