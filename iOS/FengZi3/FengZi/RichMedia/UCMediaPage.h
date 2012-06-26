//
//  UCMediaPage.h
//  FengZi
//
//  Created by  on 12-1-10.
//  Copyright (c) 2012年 iTotemStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iOSApi/HttpDownloader.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "Api+RichMedia.h"
//大图添加
#import "EnlargeImageDoubleTap.h"
@interface UCMediaPage : UIViewController<HttpDownloaderDelegate> {
    MediaObject *info;
    NSString *filePath;
    UIButton *btnDown;
    AVAudioPlayer *audioPlayer;
    MediaContent *maContent;
   
}
@property (nonatomic, assign) id idMedia;
@property (nonatomic, copy) NSString *filePath;
@property (nonatomic, retain) MediaContent *maContent;
@property (nonatomic, retain) MediaObject *info;
@property (nonatomic, retain) IBOutlet UILabel *subject, *bgAudio;
@property (nonatomic, retain) IBOutlet UITextView *content;
@property (nonatomic, retain) IBOutlet EnlargeImageDoubleTap *pic;

@property (nonatomic, retain) MPMoviePlayerController *moviePlayer;
@property (nonatomic, assign) int state, stText;
@property (nonatomic, retain) IBOutlet UIButton *button, *btnAudio;

// 富媒体跳转
@property (nonatomic, retain) IBOutlet UIButton *btnJump;

- (IBAction)playAudio:(id)sender;
- (IBAction)playMovie:(id)sender;
- (void)loadData;

// 富媒体 评论
- (IBAction)doDiscuss:(id)sender;

// 富媒体跳转
- (IBAction)doJump:(id)sender;

@end
