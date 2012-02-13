//
//  UCCreateCode.h
//  FengZi
//
//  Created by  on 12-1-1.
//  Copyright (c) 2012年 iTotemStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <iOSApi/DropDownList.h>
#import "RichMedia.h"
#import "Api+RichMedia.h"
#import <iOSApi/iOSImageView.h>

#define VideoPickerItemImageWidth  (320)
#define VideoPickerItemImageHeight (480)

@interface UCCreateCode : UIViewController<UIImagePickerControllerDelegate,
    MPMediaPickerControllerDelegate, UINavigationControllerDelegate, DropDownListDelegate, ImageViewDelegate> {
    UIButton *_btnRight; // 导航条按钮
    UIImage *_curImage;
    NSData *fmtBuffer;
    RichMedia *media;
    NSString *tmpKey;
    NSString *bgMuisc; // 背景音乐
    MediaInfo *info;
    DropDownList *ddTypes;
    NSURL *urlFile;
    
    BOOL bKma; // 是否空码赋值
    NSString *code; // 空码
        int  type;
}

@property (nonatomic, retain) IBOutlet UITextField *subject;
@property (nonatomic, retain) IBOutlet UITextView  *content;
@property (nonatomic, retain) IBOutlet UISegmentedControl *mtype;
@property (nonatomic, assign) BOOL bKma;
@property (nonatomic, retain) NSString * code;

// 插入
- (IBAction)doFmtAdd:(id)sender;
// 插入音频
- (IBAction)doFmtAddAudio:(id)sender;

- (IBAction)textFieldDidEnd:(id)sender;

@end
