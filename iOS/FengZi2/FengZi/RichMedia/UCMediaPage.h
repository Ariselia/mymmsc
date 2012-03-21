//
//  UCMediaPage.h
//  FengZi
//
//  Created by  on 12-1-10.
//  Copyright (c) 2012年 iTotemStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iOSApi/HttpDownload.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "Api+RichMedia.h"

@interface UCMediaPage : UIViewController<HttpDownloadDelegate> {
    MediaObject *info;
    NSString *filePath;
    UIButton *btnDown;
    AVAudioPlayer *audioPlayer;;
}
@property (nonatomic, copy) NSString *filePath;
@property (nonatomic, retain) MediaObject *info;
@property (nonatomic, retain) IBOutlet UILabel *subject, *bgAudio;
@property (nonatomic, retain) IBOutlet UITextView *content;
@property (nonatomic, retain) IBOutlet UIImageView *pic;

@property (nonatomic, retain) MPMoviePlayerController *moviePlayer;
@property (nonatomic, assign) int state, stText;
@property (nonatomic, retain) IBOutlet UIButton *button, *btnAudio;

-(IBAction)playAudio:(id)sender;
-(IBAction)playMovie:(id)sender;
- (void)loadData;

@end
