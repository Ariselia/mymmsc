//
//  UCMediaPage.m
//  FengZi
//
//  Created by  on 12-1-10.
//  Copyright (c) 2012年 iTotemStudio. All rights reserved.
//

#import "UCMediaPage.h"
#import <iOSApi/UIImage+Scale.h>
#import <iOSApi/iOSImageView.h>
#import "Api+RichMedia.h"
#import "Api+AppStore.h"

@implementation UCMediaPage

@synthesize subject, content, pic;
@synthesize urlPic, urlSound, urlMedia;
@synthesize button, btnText;
@synthesize moviePlayer, state, stText;

// 媒体状态
#define MS_INITED      (0) // 界面初始状态
#define MS_DOWNLOADING (1) // 正在下载
#define MS_READY       (2) // 下载完毕, 进入加载状态
#define MS_STOPPED     (3) // 加载完毕, 进度停止状态
#define MS_PLAYING     (4) // 播放中
#define MS_ERROR       (5) // 媒体资源文件状态错误

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

// 下载媒体文件
- (void)doDownload {
    HttpDownload *hd = [HttpDownload new];
    hd.delegate = self;
    iOSLog(@"下载路径: [%@]", urlMedia);
    NSString *result = [iOSApi urlDecode:urlMedia];
    iOSLog(@"正在下载: [%@]", result);
    NSURL *url = [NSURL URLWithString:result];
    [hd bufferFromURL:url];
    [iOSApi showAlert:@"正在下载"];
    state = MS_DOWNLOADING;
}

// 下载异常
- (BOOL)httpDownload:(HttpDownload *)httpDownload didError:(BOOL)isError {
    [iOSApi closeAlert];
    [iOSApi Alert:@"下载提示" message:@"下载失败"];
    state = MS_ERROR;
    return YES;
}

// 下载完毕, 保存文件
- (BOOL)httpDownload:(HttpDownload *)httpDownload didFinished:(NSMutableData *)buffer {
    [iOSApi closeAlert];
    // 下载完毕保存到本地
    NSString *filePath = [Api filePath:urlMedia];
    NSLog(@"1: %@", filePath);
    NSFileHandle *fileHandle = [iOSFile create:filePath];
    [fileHandle writeData:buffer];
    [fileHandle closeFile];
    state = MS_READY;
    return YES;
}

// 下载图片
- (void)downImage {
    NSString *url = urlPic;
    UIImage *im = [[[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]] autorelease];
    if (im != nil) {
        [pic setImage: [im scaleToSize:pic.frame.size]];
    }
}

-(IBAction)allText:(id)sender {
    if (stText == 0) {
        [btnText setImage:[UIImage imageNamed:@"duomeiti_up.png"] forState:UIControlStateNormal];
        [btnText setImage:[UIImage imageNamed:@"duomeiti_up.png"] forState:UIControlStateHighlighted];
        stText = 1;
        [content setNumberOfLines:5];
    } else {
        [btnText setImage:[UIImage imageNamed:@"duomeiti_down.png"] forState:UIControlStateNormal];
        [btnText setImage:[UIImage imageNamed:@"duomeiti_down.png"] forState:UIControlStateHighlighted];
        stText = 0;
        [content setNumberOfLines:2];
    }
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    subject.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg33.png"]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    if (moviePlayer != nil) {
        [moviePlayer release];
    }    
    moviePlayer = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
}

-(IBAction)playMovie:(id)sender {
    if (state == MS_INITED) {
        // 开始下载
        [self doDownload];
    } else if(state == MS_READY || state == MS_STOPPED) {
        // 如果处在准备状态, 加载媒体文件
        if (state == MS_READY) {
            NSString *filePath = [iOSFile path:[Api filePath:urlMedia]];
            iOSLog(@"1: %@", filePath);
            NSURL *fileURL = [NSString stringWithFormat:@"file://%@", filePath];
            fileURL = [NSURL fileURLWithPath:filePath];
            moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:fileURL];
                        
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(moviePlaybackComplete:)
                                                         name:MPMoviePlayerPlaybackDidFinishNotification
                                                       object:moviePlayer];
            moviePlayer.movieSourceType = MPMovieControlStyleFullscreen;
            [moviePlayer.view setFrame:CGRectMake(pic.frame.origin.x, 
                                             pic.frame.origin.y, 
                                             pic.frame.size.width, 
                                             pic.frame.size.height)];
            
            [self.view addSubview:moviePlayer.view];
            [self.view sendSubviewToBack:moviePlayer.view];
            state = MS_STOPPED;
            stText = 0;
        }
        // 暂停状态, 播放
        //[pic setHidden:YES];
        [self.view sendSubviewToBack:pic];
        [moviePlayer play];
        state = MS_PLAYING;
        [button setImage:[UIImage imageNamed:@"duomeiti_stop.png"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"duomeiti_stop.png"] forState:UIControlStateHighlighted];
    } else if(state == MS_PLAYING) {
        // 播放状态, 显示停止
        [button setImage:[UIImage imageNamed:@"duomeiti_play.png"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"duomeiti_play.png"] forState:UIControlStateHighlighted];
        state = MS_STOPPED;
        [moviePlayer stop];
        [self.view sendSubviewToBack:moviePlayer.view];
    } else if(state == MS_ERROR) {
        [iOSApi Alert:@"错误提示" message:@"媒体资源文件不能播放"];
        // 下载失败, 可以重置初始状态, 以便可以再次下载
        state = MS_INITED;
    }
}

- (void)moviePlaybackComplete:(NSNotification *)notification
{
    MPMoviePlayerController *moviePlayerController = [notification object];
    [[NSNotificationCenter defaultCenter] removeObserver:self
													name:MPMoviePlayerPlaybackDidFinishNotification
												  object:moviePlayerController];
	
    // 播放状态, 显示停止
    [button setImage:[UIImage imageNamed:@"duomeiti_play.png"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"duomeiti_play.png"] forState:UIControlStateHighlighted];
    state = MS_STOPPED;
}

@end
