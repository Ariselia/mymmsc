//
//  UCStoreSubscribe.m
//  FengZi
//
//  Created by  on 12-1-4.
//  Copyright (c) 2012年 iTotemStudio. All rights reserved.
//

#import "UCStoreSubscribe.h"
#import "Api+eShop.h"
#import <iOSApi/UIImage+Scale.h>
#import <iOSApi/iOSImageView.h>
#import "UCStoreInfo.h"
#import "UCLogin.h"
#import "UCBookReader.h"

#import "UCMoviePlayer.h"
#import "UCMusicPlayer.h"

#define API_DOWNLOAD_NONE (0)
#define API_DOWNLOAD_ING  (1)


@implementation UCStoreSubscribe

static int iTimes = -1;
static int iDownload = API_DOWNLOAD_NONE;
static NSString *theUrl = nil;
static UIButton *theBtn = nil;
static ProductInfo *theObj = nil;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.proxy = self;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIImage *image = [UIImage imageNamed:@"navigation_bg.png"];
    Class ios5Class = (NSClassFromString(@"CIImage"));
    if (nil != ios5Class) {
        [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    } else {
        self.navigationController.navigationBar.layer.contents = (id)[UIImage imageNamed:@"navigation_bg.png"].CGImage;
    }
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(110, 0, 150,44)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = UITextAlignmentCenter;
    label.font = [UIFont fontWithName:@"黑体" size:60];
    label.textColor = [UIColor blackColor];
    label.text= @"我的订购";
    self.navigationItem.titleView = label;
    [label release];
    
    UIButton *backbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backbtn.frame =CGRectMake(0, 0, 60, 32);
    [backbtn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backbtn setImage:[UIImage imageNamed:@"back_tap.png"] forState:UIControlStateHighlighted];
    [backbtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backitem = [[UIBarButtonItem alloc] initWithCustomView:backbtn];
    self.navigationItem.leftBarButtonItem = backitem;
    [backitem release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewWillAppear:(BOOL)animated {
    if ([items count] == 0) {
        // 预加载项
        items = [[NSMutableArray alloc] initWithCapacity:0];
    }
}

- (BOOL)configure:(UITableViewCell *)cell withObject:(id)object {
    ProductInfo *obj = object;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    // 设置字体
    UIFont *textFont = [UIFont systemFontOfSize:15.0];
    UIFont *detailFont = [UIFont systemFontOfSize:10.0];
    cell.imageView.image = [[iOSApi imageNamed:[Api typeIcon:obj.type]] scaleToSize:CGSizeMake(36, 36)];
    cell.textLabel.text = [Api typeName:obj.type];
    cell.textLabel.font = textFont;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@  %@  %.02f", obj.name, obj.writer, obj.price];
    cell.detailTextLabel.font = detailFont;
    cell.accessoryType = UITableViewCellAccessoryNone;
    CGRect frame = CGRectMake(240, 3, 50, 20);
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = frame;
    NSString *btnTitle = nil;
    if ([Api fileIsExists:obj.orderProductUrl]) {
        btnTitle = nil;
        switch (obj.type) {
            case 1: // 电子书
                btnTitle = @"阅读";
                break;
            case 2: // 音乐
                btnTitle = @"收听";
                break;
            case 3: // 游戏
                btnTitle = @"安装";
                break;
            case 4: // 美图
                btnTitle = @"查看";
                break;
            case 5: // 视频
                btnTitle = @"播放";
                break;
            case 6: // 漫画
                btnTitle = @"阅览";
                break;
            default:
                btnTitle = @"XX";
                break;
        }
        obj.state = 1;
    } else {
        btnTitle = @"下载";
        obj.state = 0;
    }
    [btn setTitle:btnTitle forState:UIControlStateNormal];
    [btn setTitle:btnTitle forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(onButtonClick:event:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:btn];
    return YES;
}

// 按钮点击事件
- (void)onButtonClick:(id)sender event:(id)event {
    //UIButton *btn = sender;
    ProductInfo *obj = [self objectForEvent:event];
    if (obj.state == 0) {
        //判断是否登录
        if (![Api isOnLine]) {
            iTimes = 0;
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"提示"
                                  message: @"您还没有登录"
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  otherButtonTitles:@"登录", nil];
            [alert show];
            [alert release];
        } else if(iDownload < API_DOWNLOAD_ING){
            iDownload = API_DOWNLOAD_ING;
            HttpDownload *hd = [HttpDownload new];
            hd.delegate = self;
            iOSLog(@"下载路径: [%@]", obj.orderProductUrl);
            NSString *result = [iOSApi urlDecode:obj.orderProductUrl];
            iOSLog(@"正在下载: [%@]", result);
            theUrl = obj.orderProductUrl;
            theBtn = sender;
            theObj = obj;
            NSURL *url = [NSURL URLWithString:result];
            [hd bufferFromURL:url];
            [iOSApi showAlert:@"正在下载"];
        }
    } else {
        // 阅读
        //[iOSApi closeAlert];
        if (obj.type == 5) {
            UCMoviePlayer *nextView = [[UCMoviePlayer alloc] init];
            nextView.info = obj;
            [self.navigationController pushViewController:nextView animated:YES];
            [nextView release];
        } else if(obj.type == 4) {
            // 图片
            NSString *filePath = [iOSFile path:[Api filePath:obj.orderProductUrl]];
            UIImage *im = [UIImage imageWithData:[NSData dataWithContentsOfFile:filePath]];
            iOSImageView *iv = [[iOSImageView alloc] initWithImage:im superView:self.view];
            [iv release];
        } else if(obj.type == 2) {
            // 音频
            UCMusicPlayer *nextView = [[UCMusicPlayer alloc] init];
            nextView.info = obj;
            [self.navigationController pushViewController:nextView animated:YES];
            [nextView release];
        } else if(obj.type == 1){
            // 电子书
            UCBookReader *nextView = [UCBookReader new];
            nextView.subject = obj.name;
            NSString *filePath = [iOSFile path:[Api filePath:obj.orderProductUrl]];
            NSLog(@"1: %@", filePath);
            NSData *buffer = [NSData dataWithContentsOfFile:filePath]; 
            nextView.bookContent = [[[NSString alloc] initWithData:buffer encoding:NSUTF8StringEncoding] autorelease];
            
            [self.navigationController pushViewController:nextView animated:YES];
            [nextView release];
        } else {
            [iOSApi Alert:@"提示" message:[NSString stringWithFormat:@"暂不支持%@格式文件", [Api typeName:obj.type]]];
        }
    }
}

- (BOOL)httpDownload:(HttpDownload *)httpDownload didError:(BOOL)isError {
    [iOSApi closeAlert];
    [iOSApi Alert:@"下载提示" message:@"下载失败"];
    iDownload = API_DOWNLOAD_NONE;
    theBtn = nil;
    theObj = nil;
    return YES;
}

- (BOOL)httpDownload:(HttpDownload *)httpDownload didFinished:(NSMutableData *)buffer {
    [iOSApi closeAlert];
    
    NSString *filePath = [Api filePath:theUrl];
    NSLog(@"1: %@", filePath);
    NSFileHandle *fileHandle = [iOSFile create:filePath];
    if (theObj.type == 1) {
        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSString *content = [[[NSString alloc] initWithData:buffer encoding:enc] autorelease];
        [fileHandle writeData:[content dataUsingEncoding:NSUTF8StringEncoding]];
    } else {
        [fileHandle writeData:buffer];
    }
    [fileHandle closeFile];
    iDownload = API_DOWNLOAD_NONE;
    theObj.state = 1;
    NSString *btnTitle = nil;
    switch (theObj.type) {
        case 1: // 电子书
            btnTitle = @"阅读";
            break;
        case 2: // 音乐
            btnTitle = @"收听";
            break;
        case 3: // 游戏
            btnTitle = @"安装";
            break;
        case 4: // 美图
            btnTitle = @"查看";
            break;
        case 5: // 视频
            btnTitle = @"播放";
            break;
        case 6: // 漫画
            btnTitle = @"阅览";
            break;
        default:
            btnTitle = @"XX";
            break;
    }
    //theBtn.titleLabel.text = btnTitle;
    [theBtn setTitle:btnTitle forState:UIControlStateNormal];
    [theBtn setTitle:btnTitle forState:UIControlStateSelected];
    return YES;
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger) buttonIndex {
	if (iTimes == 0) {
		switch (buttonIndex) {
			case 1: {
                UCLogin *nextView = [UCLogin new];
                nextView.bDownload = YES;
                [self.navigationController pushViewController:nextView animated:YES];
                [nextView release];
            }
				break;
			default:
				break;
		}
	} else if (iTimes == 1) {
		switch (buttonIndex) {
			case 1:
			{
				//
			}
				break;
			default:
				break;
		}
	} else if (iTimes == 2) {
        //
	}
}

/*
- (void)tableView:(UITableViewCell *)cell onCustomAccessoryTapped:(id)object {
    ProductInfo *obj = object;
    UCStoreInfo *nextView = [[UCStoreInfo alloc] init];
    nextView.info = obj;
    [self.navigationController pushViewController:nextView animated:YES];
    [nextView release];
}
*/
- (NSArray *)reloadData:(iOSTableViewController *)tableView {
    return [Api orderList:0];
}

- (NSArray *)arrayOfHeader:(iOSTableViewController *)tableView {
    return nil;
}

- (NSArray *)arrayOfFooter:(iOSTableViewController *)tableView {
    return nil;
}

@end
