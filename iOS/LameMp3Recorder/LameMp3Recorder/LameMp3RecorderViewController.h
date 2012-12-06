//
//  LameMp3RecorderViewController.h
//  LameMp3Recorder
//
//  Created by jian zhang on 12-7-13.
//  Copyright (c) 2012年 txtws.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface LameMp3RecorderViewController : UIViewController
<
UITableViewDelegate,
UITableViewDataSource,
AVAudioPlayerDelegate,//播放
AVAudioRecorderDelegate,//录音
UIAlertViewDelegate
>
{
//    Path
    NSString *_strCAFPath;
    NSString *_strMp3Path;
    
//    Recorder & Player
    AVAudioRecorder *_avRecorder;
    AVAudioPlayer *_avPlayer;
    
//    DataSource 
    
    NSMutableArray *_arrayCAFFiles;
    NSMutableArray *_arrayMp3Files;
    
//    Table
    UITableView *_tableViewMp3;
    UITableView *_tableViewCAF;
    
//    Flag
    BOOL _isRecording;
    BOOL _isConverting;
    
    NSString* _lastRecordFileName;
}


@property (retain, nonatomic) IBOutlet UIButton    *_btnRecStop;
@property (retain, nonatomic) IBOutlet UITableView *_tableViewMp3;
@property (retain, nonatomic) IBOutlet UITableView *_tableViewCAF;
@property (retain, nonatomic) IBOutlet UITextField *_txtFileName;

@property (retain, nonatomic) NSString* _lastRecordFileName;
@property (retain, nonatomic) NSMutableArray *_arrayCAFFiles;
@property (retain, nonatomic) NSMutableArray *_arrayMp3Files;

- (IBAction)recordOrStop:(id)sender;

- (IBAction)toPlay:(id)sender;


@end
