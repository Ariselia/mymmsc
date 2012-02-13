//
//  UCMediaPage.h
//  FengZi
//
//  Created by  on 12-1-10.
//  Copyright (c) 2012年 iTotemStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iOSApi/HttpDownload.h>
#import <MediaPlayer/MediaPlayer.h>
#import "Api+RichMedia.h"

@interface UCMediaPage : UIViewController<HttpDownloadDelegate> {
    MediaObject *info;
    NSString *filePath;
}
@property (nonatomic, copy) NSString *filePath;
@property (nonatomic, retain) MediaObject *info;
@property (nonatomic, retain) IBOutlet UILabel *subject;
@property (nonatomic, retain) IBOutlet UILabel  *content;
@property (nonatomic, retain) IBOutlet UIImageView *pic;

@property (nonatomic, retain) MPMoviePlayerController *moviePlayer;
@property (nonatomic, assign) int state, stText;
@property (nonatomic, retain) IBOutlet UIButton *button, *btnText;

-(IBAction)playMovie:(id)sender;
-(IBAction)allText:(id)sender;

@end
