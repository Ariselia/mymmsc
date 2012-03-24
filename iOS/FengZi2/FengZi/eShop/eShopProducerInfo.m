//
//  eShopProducerInfo.m
//  FengZi
//
//  Created by wangfeng on 12-3-5.
//  Copyright (c) 2012年 iTotemStudio. All rights reserved.
//

#import "eShopProducerInfo.h"
#import "Api+eShop.h"
#import "SHKItem.h"
#import "ShareView.h"
#import "UCLogin.h"
#import <iOSApi/HttpDownload.h>
#import "UCStoreSubscribe.h"
#import "UCStoreBBS.h"
#import <iOSApi/iOSAsyncImageView.h>
#import <iOSApi/UIImage+Scale.h>
#import <iOSApi/iOSImageView2.h>
#import <iOSApi/iOSImageView.h>
#import "UCBookReader.h"
#import "UCMoviePlayer.h"
#import "UCMusicPlayer.h"
#import "UCStoreInfo.h"

@implementation eShopProducerInfo

@synthesize info, infoInfo, infoType, infoWriter, infoUploader, infoName, infoPrice, infoImage;
@synthesize btnAction;
@synthesize idInfo;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        bRead = NO;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)doShare:(id)sender {
    SHKItem *item = [SHKItem text:@"快来扫码，即有惊喜！"];
    //item.image = _image;
    item.shareType = SHKShareTypeURL;
    NSString *result = [iOSApi urlDecode:info.orderProductUrl];
    
    item.URL = [NSURL URLWithString:result];
    item.title = @"快来扫码，即有惊喜！\n来自蜂子客户端";
    ShareView *actionSheet = [[ShareView alloc] initWithItem:item];
    [actionSheet showInView:self];
    [actionSheet release];
}

- (IBAction)doPinglun:(id)sender {
    UCStoreInfo *view = idInfo;
    UCStoreBBS *nextView = [[UCStoreBBS alloc] init];
    nextView.info = info;
    [view.navigationController pushViewController:nextView animated:YES];
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


// 根据最新流程, 不用判断是否登录 [WangFeng@2012-03-01 18:00:00]
- (IBAction)doDownload:(id)sender{
    UCStoreInfo *view = idInfo;
    // 是否可展示
    if (bRead) {
        // 可以显示
        if (info.type == 5) {
            UCMoviePlayer *nextView = [[UCMoviePlayer alloc] init];
            nextView.info = info;
            [view.navigationController pushViewController:nextView animated:YES];
            [nextView release];
        } else if(info.type == 4) {
            // 图片
            NSString *filePath = [iOSFile path:[Api filePath:info.orderProductUrl]];
            UIImage *im = [UIImage imageWithData:[NSData dataWithContentsOfFile:filePath]];
            iOSImageView2 *iv = [[iOSImageView2 alloc] initWithImage:im superView:self];
            [iv release];
        } else if(info.type == 2) {
            // 音频
            UCMusicPlayer *nextView = [[UCMusicPlayer alloc] init];
            nextView.info = info;
            [view.navigationController pushViewController:nextView animated:YES];
            [nextView release];
        } else if(info.type == 1){
            // 电子书
            UCBookReader *nextView = [UCBookReader new];
            nextView.subject = info.name;
            NSString *filePath = [iOSFile path:[Api filePath:info.orderProductUrl]];
            NSLog(@"1: %@", filePath);
            NSData *buffer = [NSData dataWithContentsOfFile:filePath]; 
            nextView.bookContent = [[[NSString alloc] initWithData:buffer encoding:NSUTF8StringEncoding] autorelease];
            
            [view.navigationController pushViewController:nextView animated:YES];
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

- (void)loadData:(ProductInfo *)pInfo
{
    info = [pInfo retain];
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
    UIImage *im = [UIImage imageNamed:@"unknown.png"];
    if ([info2.picurl length] > 10) {
        //im = [[[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:info2.picurl]]] autorelease];
        [infoImage imageWithURL:info2.picurl];
        [infoImage autoresizingMask];
    }
    
    if (im != nil) {
        //[infoImage setImage: [im scaleToSize:infoImage.frame.size]];
        int xHeight = infoImage.frame.origin.y;
        CGSize size = infoImage.frame.size;
        CGFloat max_width = size.width;
        CGFloat max_height = size.height;
        float sc = max_width / max_height;
        
        max_height = max_height - xHeight;
        int _width = sc * max_width;
        if (_width >= max_width) {
            _width = max_width;
        }
        max_width = _width;
        max_height = max_width /sc;
        
        CGSize imgSize = im.size;
        // 图片宽高比例
        CGFloat scale = 0;
        // 确定以高还是宽为主进行缩放
        if ((imgSize.width / imgSize.height) > (max_width / max_height)) {
            // 以宽
            if (max_width < imgSize.width) {
                // 图片宽
                scale = max_width / imgSize.width;
            } else {
                // 图片窄
                scale = 1;
            }
        } else {
            // 以高
            if (max_height < imgSize.height) {
                // 图片高
                scale = max_height / imgSize.height;
            } else {
                scale = 1;
            }
        }
        
        CGFloat w = imgSize.width * scale;
        CGFloat h = imgSize.height * scale;
        
        CGFloat x = (size.width - w) / 2;
        CGFloat y = (size.height - h) / 2;
        y = xHeight;
        CGRect frame = CGRectMake(x, y, w, h);
        [infoImage setImage:im];
        infoImage.frame = frame;
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

@end
