//
//  UCMoviePlayer.m
//  FengZi
//
//  Created by  on 12-1-5.
//  Copyright (c) 2012年 iTotemStudio. All rights reserved.
//

#import "UCMoviePlayer.h"


@implementation UCMoviePlayer

@synthesize info;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        playButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
		//在这里初始化那个按键
		playButton.frame = CGRectMake(100, 100, 100, 30);
		[self.view addSubview:playButton];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)playVideo
{
	
    NSString *filePath = [iOSFile path:[Api filePath:info.productUrl]];
    iOSLog(@"1: %@", filePath);
    NSURL *fileURL = [NSURL fileURLWithPath:filePath];
	player = [[MPMoviePlayerController alloc]
				   initWithContentURL:fileURL];
    player.movieSourceType = MPMovieControlStyleFullscreen;
	//初始化视频播放器对象，并传入被播放文件的地址
	
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(moviePlaybackComplete:)
												 name:MPMoviePlayerPlaybackDidFinishNotification
											   object:player];
	player.movieSourceType = MPMovieControlStyleFullscreen;
	[player.view setFrame:CGRectMake(0, 50, 320, 280)];
    
	[self.view addSubview:player.view];
    //moviePlayerController.fullscreen = YES;
	
	//moviePlayerController.scalingMode = MPMovieScalingModeFill;
	
    [player play];
}

- (void)moviePlaybackComplete:(NSNotification *)notification
{
    MPMoviePlayerController *moviePlayerController = [notification object];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:moviePlayerController];
	
    [moviePlayerController.view removeFromSuperview];
    //[moviePlayerController release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillDisappear:(BOOL)animated
{
    if (player != nil) {
        [player.view removeFromSuperview];
        [player stop];
        //[player release];
        //player = nil;
    }
    [super viewWillDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewWillAppear:(BOOL)animated {
    UIImage *image = [UIImage imageNamed:@"navigation_bg.png"];
    Class ios5Class = (NSClassFromString(@"CIImage"));
    if (nil != ios5Class) {
        [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    } else {
        self.navigationController.navigationBar.layer.contents = (id)[UIImage imageNamed:@"navigation_bg.png"].CGImage;
    }
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(80, 0, 200,44)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = UITextAlignmentCenter;
    label.font = [UIFont fontWithName:@"黑体" size:60];
    label.textColor = [UIColor blackColor];
    label.text= info.shopname;
    UIButton *backbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backbtn.frame = label.frame;
    [backbtn addTarget:self action:@selector(textFieldShouldReturn:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:backbtn];
    self.navigationItem.titleView = label;
    [label release];
    
    backbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backbtn.frame =CGRectMake(0, 0, 60, 32);
    [backbtn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backbtn setImage:[UIImage imageNamed:@"back_tap.png"] forState:UIControlStateHighlighted];
    [backbtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backitem = [[UIBarButtonItem alloc] initWithCustomView:backbtn];
    self.navigationItem.leftBarButtonItem = backitem;
    [backitem release];
    
	[playButton setTitle:@"播放" forState:UIControlStateNormal];
	[playButton addTarget:self action:@selector(playVideo) forControlEvents:UIControlEventTouchUpInside];
	//设置按键属性，然后添加点击后触发的方法函数
    player = nil;
}

- (void)dealloc {
    [super dealloc];
}

@end
