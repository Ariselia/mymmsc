//
//  UCStoreInfo.m
//  FengZi
//
//  Created by  on 12-1-3.
//  Copyright (c) 2012年 iTotemStudio. All rights reserved.
//

#import "UCStoreInfo.h"
#import "Api+eShop.h"
#import "SHKItem.h"
#import "ShareView.h"
#import "UCLogin.h"
#import <iOSApi/HttpDownload.h>
#import "UCStoreSubscribe.h"
#import "UCStoreBBS.h"
#import <iOSApi/iOSAsyncImageView.h>

#import <iOSApi/UIImage+Scale.h>
#import <iOSApi/iOSImageView.h>
#import "UCBookReader.h"
#import "UCMoviePlayer.h"
#import "UCMusicPlayer.h"

@implementation UCStoreInfo

@synthesize info, infoInfo, infoType, infoWriter, infoUploader, infoName, infoPrice, infoImage;
@synthesize btnAction;
@synthesize page;

static int iTimes = -1;
static BOOL bRead = NO;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.proxy = self;
        bRead = NO;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (IBAction)doShare:(id)sender {
    SHKItem *item = [SHKItem text:@"快来扫码，即有惊喜！"];
    //item.image = _image;
    item.shareType = SHKShareTypeImage;
    item.title = @"快来扫码，即有惊喜！\n来自蜂子客户端";
    ShareView *actionSheet = [[ShareView alloc] initWithItem:item];
    [actionSheet showInView:self.view];
    [actionSheet release];
}

- (IBAction)doPinglun:(id)sender {
    UCStoreBBS *nextView = [[UCStoreBBS alloc] init];
    nextView.info = info;
    [self.navigationController pushViewController:nextView animated:YES];
    [nextView release];
}

- (void)changeState:(BOOL)isOrder{
    NSString *btnTitle = @"下载";
    if (isOrder) {
        btnTitle = @"阅读";
        switch (info.type) {
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
    }
    [btnAction setTitle:btnTitle forState:UIControlStateNormal];
    [btnAction setTitle:btnTitle forState:UIControlStateSelected];
}

// 判断是否登录
- (IBAction)doDownload_ISONLINE:(id)sender {
    if (!bRead) {
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
        } else {
            // 已登录, 订购
            iTimes = 1;
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"提示"
                                  message: @"您还没有订购"
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  otherButtonTitles:@"订购", nil];
            [alert show];
            [alert release];
        }
    } else {
        // 转向到我的订购
        UCStoreSubscribe *nextView = [UCStoreSubscribe new];
        [self.navigationController pushViewController:nextView animated:YES];
        [nextView release];
    }
    
}

// 根据最新流程, 不用判断是否登录 [WangFeng@2012-03-01 18:00:00]
- (IBAction)doDownload:(id)sender{
    // 是否可展示
    if (bRead) {
        // 可以显示
        if (info.type == 5) {
            UCMoviePlayer *nextView = [[UCMoviePlayer alloc] init];
            nextView.info = info;
            [self.navigationController pushViewController:nextView animated:YES];
            [nextView release];
        } else if(info.type == 4) {
            // 图片
            NSString *filePath = [iOSFile path:[Api filePath:info.orderProductUrl]];
            UIImage *im = [UIImage imageWithData:[NSData dataWithContentsOfFile:filePath]];
            iOSImageView *iv = [[iOSImageView alloc] initWithImage:im superView:self.view];
            [iv release];
        } else if(info.type == 2) {
            // 音频
            UCMusicPlayer *nextView = [[UCMusicPlayer alloc] init];
            nextView.info = info;
            [self.navigationController pushViewController:nextView animated:YES];
            [nextView release];
        } else if(info.type == 1){
            // 电子书
            UCBookReader *nextView = [UCBookReader new];
            nextView.subject = info.name;
            NSString *filePath = [iOSFile path:[Api filePath:info.orderProductUrl]];
            NSLog(@"1: %@", filePath);
            NSData *buffer = [NSData dataWithContentsOfFile:filePath]; 
            nextView.bookContent = [[[NSString alloc] initWithData:buffer encoding:NSUTF8StringEncoding] autorelease];
            
            [self.navigationController pushViewController:nextView animated:YES];
            [nextView release];
        } else {
            [iOSApi Alert:@"提示" message:[NSString stringWithFormat:@"暂不支持%@格式文件", [Api typeName:info.type]]];
        }
    } else {
        // 不能展示进行下载
        HttpDownload *hd = [HttpDownload new];
        hd.delegate = self;
        iOSLog(@"下载路径: [%@]", info2.productUrl);
        NSString *result = [iOSApi urlDecode:info2.productUrl];
        iOSLog(@"正在下载: [%@]", result);
        //theUrl = obj.orderProductUrl;
        //theBtn = sender;
        //theObj = obj;
        NSURL *url = [NSURL URLWithString:result];
        [hd bufferFromURL:url];
        [iOSApi showAlert:@"正在下载"];
    }
}

- (BOOL)httpDownload:(HttpDownload *)httpDownload didError:(BOOL)isError {
    [iOSApi closeAlert];
    [iOSApi Alert:@"下载提示" message:@"下载失败"];
    //iDownload = API_DOWNLOAD_NONE;
    //theBtn = nil;
    //theObj = nil;
    return YES;
}

- (BOOL)httpDownload:(HttpDownload *)httpDownload didFinished:(NSMutableData *)buffer {
    [iOSApi closeAlert];
    
    NSString *filePath = [Api filePath:info2.productUrl];
    NSLog(@"1: %@", filePath);
    NSFileHandle *fileHandle = [iOSFile create:filePath];
    if (info.type == 1) {
        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSString *content = [[[NSString alloc] initWithData:buffer encoding:enc] autorelease];
        [fileHandle writeData:[content dataUsingEncoding:NSUTF8StringEncoding]];
    } else {
        [fileHandle writeData:buffer];
    }
    [fileHandle closeFile];
    //iDownload = API_DOWNLOAD_NONE;
    //theObj.state = 1;
    [self changeState:YES];
    bRead = YES;
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
				// 订购流程
                [iOSApi showAlert:@"订购中..."];
                ucResult *iRet = [Api subscribe:info.pid];
                [iOSApi closeAlert];
                NSString *msg = nil;
                if (iRet.status == 0) {
                    msg = @"订购成功";
                    bRead = YES;
                } else {
                    switch (iRet.status) {
                        case -1:
                            bRead = YES;
                            msg = @"已订购，无须重复订购";
                            break;
                        default:
                            msg = @"订购失败";
                            break;
                    }
                }
                if (bRead) {
                    NSString *btnTitle = @"阅读";
                    switch (info.type) {
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
                    [btnAction setTitle:btnTitle forState:UIControlStateNormal];
                    [btnAction setTitle:btnTitle forState:UIControlStateSelected];
                }
                
                [iOSApi Alert:@"提示" message:msg];
                //[iOSApi showAlert:msg];
                //[iOSApi closeAlert];
			}
				break;
			default:
				break;
		}
	} else if (iTimes == 2) {
        //
	}
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
    label.text= info.name;
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

    infoType.text     = [NSString stringWithFormat:@"商品类型:  %@", [Api typeName:info.type]];
    infoName.text     = [NSString stringWithFormat:@"商品名称:  %@", info.name];
    infoUploader.text = [NSString stringWithFormat:@"商品发布:  %@", @"未知"];;
    infoWriter.text   = [NSString stringWithFormat:@"署名作者:  %@", info.writer];;
    infoInfo.text     = [NSString stringWithFormat:@"内容描述:  %@", info.info];;
    infoPrice.text    = [NSString stringWithFormat:@"收费金额:  %0.2f", info.price];;
    
    info2 = [[Api proinfo:info.pid] retain];
    // 修订类型名称
    if (info2 != nil) {
        infoType.text     = [NSString stringWithFormat:@"商品类型:  %@", info2.typename];
    }
    UIImage *im = nil;
    if ([info2.picurl length] > 10) {
        im = [[[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:info2.picurl]]] autorelease];
    }
    if (im == nil) {
        im = [UIImage imageNamed:@"unknown.png"];
    }
    if (im != nil) {
        [infoImage setImage: [im scaleToSize:infoImage.frame.size]];
    }
    
    // 如果已经下载, 显示展示内容按钮
    BOOL isDownload = [Api fileIsExists:info2.productUrl];
    if (isDownload) {
        [self changeState:YES];
        bRead = YES;
    } else {
        [self changeState:NO];
        bRead = NO;
    }
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
    // 设置字体
    UIFont *textFont = [UIFont systemFontOfSize:17.0];
    UIFont *detailFont = [UIFont systemFontOfSize:12.0];
    int imageHeight = 36;
    
    //cell.imageView.image = [[iOSApi imageNamed:[Api typeIcon:obj.type]] scaleToSize:CGSizeMake(36, 36)];
    // 占位
    cell.imageView.image = [[UIImage imageNamed:@"unknown.png"] scaleToSize:CGSizeMake(imageHeight, imageHeight)];
    NSString *tmpUrl = [iOSApi urlDecode:obj.productLogo];
    //UIImage *im = [[[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:tmpUrl]]] autorelease];
    //cell.imageView.image = im;
    CGRect frame;
    frame.size.width = imageHeight;
    frame.size.height = imageHeight;
    frame.origin.x = 0;
    frame.origin.y = 0;
    iOSAsyncImageView *ai = nil; //[info aimage];
    if (ai == nil)
    {
        // 默认图片
        cell.imageView.image = [[UIImage imageNamed:@"unknown.png"] scaleToSize:CGSizeMake(imageHeight, imageHeight)];
        ai = [[[iOSAsyncImageView alloc] initWithFrame:frame] autorelease];
        //ai.tag = tagImage;
        //NSString *tmpUrl;
        
        NSURL *url = [NSURL URLWithString: tmpUrl];
        [ai loadImageFromURL:url];
    }
    [cell.imageView addSubview:ai];
    //[cell.imageView setImage:ai.image];
    
    cell.textLabel.text = [Api typeName:obj.type];
    cell.textLabel.font = textFont;
    cell.detailTextLabel.textColor = [UIColor blueColor];
    NSString *tmpPrice = [NSString stringWithFormat:@"%.02f元", obj.price];
    if (obj.price < 0.01) {
        tmpPrice = @"免费";
    }
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@　%@", obj.name, obj.writer];
    cell.detailTextLabel.font = detailFont;
    
    frame.origin.x = 240;
    frame.origin.y = 15;
    frame.size.width = 100;
    frame.size.height = 18;
    UILabel *price = [[UILabel alloc] initWithFrame:frame];
    price.textColor = [UIColor blueColor];
    price.text = tmpPrice;
    [cell.contentView addSubview:price];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return YES;
}

- (void)tableView:(UITableViewCell *)cell onCustomAccessoryTapped:(id)object {
    ProductInfo *obj = object;
    UCStoreInfo *nextView = [[UCStoreInfo alloc] init];
    nextView.info = obj;
    [self.navigationController pushViewController:nextView animated:YES];
    [nextView release];
}

- (NSArray *)reloadData:(iOSTableViewController *)tableView {
    return [Api relation:info.pid page:_page];
}

- (NSArray *)arrayOfHeader:(iOSTableViewController *)tableView {
    return nil;
}

- (NSArray *)arrayOfFooter:(iOSTableViewController *)tableView {
    NSArray *list = [Api relation:info.pid  page:_page + 1];
    if (list.count > 0) {
        _page += 1;
    }
    return list;
}

@end
