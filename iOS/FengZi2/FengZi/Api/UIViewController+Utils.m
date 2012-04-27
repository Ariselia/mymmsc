//
//  UIViewController+Utils.m
//  FengZi
//
//  Created by wangfeng on 12-2-12.
//  Copyright (c) 2012年 ifengzi.cn. All rights reserved.
//

#import "UIViewController+Utils.h"
#import "UCLogin.h"

@implementation UIViewController (Utils)

// 跳转登录页面
- (void)gotoLogin{
    UCLogin *nextView = [UCLogin new];
    [self.navigationController pushViewController:nextView animated:YES];
    [nextView release];
}

static NSString *kma_content = @"";

- (NSString *)kmaContent {
    return kma_content;
}

- (void)setKmaContent:(NSString *)content {
    kma_content = content;
}

#import "BusDecoder.h"
#import "BusCategory.h"
#import "DecodeViewController.h"
#import "DecodeCardViewControlle.h"
#import "TabBarController.h"

#import "UCRichMedia.h"
#import "UCUpdateNikename.h" // 个人空间
#import "RMRide.h" // 顺风车
#import "UCKmaViewController.h"
#import "DecodeBusinessViewController.h"
#import "UCStoreInfo.h" // 数字商城 - 商品信息展示

#define AniInterval 0.3f

static int iTimes = -1;
#define kCODE_NONE (0)
#define kCODE_KMA  (9)

-(void) chooseShowController:(NSString*)input{
    iOSLog(@"decode input = %@", input);
    if (input == nil) {
        input = @"";
    }
    NSString *url = [Api fixUrl:input];
    if (url == nil) {
        url = @"";
    }
    if (url != nil && [url hasPrefix:API_URL_SHOW]) {
        NSDictionary *dict = [url uriParams];
        NSString *userId = [dict objectForKey:@"userId"];
        UCUpdateNikename *nextView = [[UCUpdateNikename alloc] init];
        nextView.idDest = [userId intValue];
        [self.navigationController pushViewController:nextView animated:YES];
        [nextView release];
        return;
    } else if (url != nil && [url hasPrefix:API_QRCODE_ESHOP]) {
        // 数字商城
        NSDictionary *dict = [url uriParams];
        NSString *maId = [dict objectForKey:@"id"];
        if ([iOSApi regexpMatch:maId withPattern:@"[0-9]+"]) {
            UCStoreInfo *nextView = [[UCStoreInfo alloc] init];
            nextView.productId = [maId intValue];
            [self.navigationController pushViewController:nextView animated:YES];
            [nextView release];
            return;
        }        
    }
    ApiCode *code = [[ApiCode codeWithUrl:input] retain];
    if (code != nil) {
        // eshop:数字商城, ebuy:电商; Ctype->shanghu:商户,shangpin:商品;Id->用户id或者商品id
        // 数字商城
        if ([code.shopType isSame:@"eshop"] && code.id > 0) {
            UCStoreInfo *nextView = [[UCStoreInfo alloc] init];
            nextView.productId = code.id;
            [self.navigationController pushViewController:nextView animated:YES];
            [nextView release];
        }
        [code release];
        return;
    }
    BusCategory *category = [BusDecoder classify:input];
    BusCategory *category_url = [BusDecoder classify:url];
    [TabBarController hide:NO animated:NO];
    UIImage *saveImage = [Api generateImageWithInput:input];
    UIImage *inputImage = saveImage;
    if (iTimes == kCODE_KMA) {
        inputImage = saveImage;
    }
    if ([category.type isEqualToString:CATEGORY_CARD]) {
        DecodeCardViewControlle *cardView = [[DecodeCardViewControlle alloc] initWithNibName:@"DecodeCardViewControlle" category:category result:input withImage:inputImage withType:HistoryTypeFavAndHistory withSaveImage:saveImage];
        [self.navigationController pushViewController:cardView animated:YES];
        RELEASE_SAFELY(cardView);
    } else if([category.type isEqualToString:CATEGORY_MEDIA] || [category_url.type isEqualToString:CATEGORY_MEDIA] ) {
        // 富媒体业务
        UCRichMedia *nextView = [[UCRichMedia alloc] init];
        nextView.urlMedia = url;
        [self.navigationController pushViewController:nextView animated:YES];
        [nextView release];
    } else if([category.type isEqualToString:CATEGORY_KMA] || [category_url.type isEqualToString:CATEGORY_KMA] ) {
        // 空码, 可以调到空码赋值页面, 默认为富媒体
        NSDictionary *dict = [url uriParams];
        NSString *xcode = [dict objectForKey:@"id"];
        [Api kmaSetId:xcode];
        iOSLog(@"uuid=[%@]", xcode);
        //[iOSApi Alert:@"赋值码" message:[NSString stringWithFormat:@"id=%@", xcode]];
        // 扫码
        KmaObject *info = [Api kmaContent:xcode];
        if (info.isKma == 0) {
            // 不是空码, 展示
            if (info.type == 14) {
                // 富媒体业务
                UCRichMedia *nextView = [[UCRichMedia alloc] init];
                nextView.urlMedia = nil;
                nextView.code = xcode;
                [self.navigationController pushViewController:nextView animated:YES];
                [nextView release];
                return;
            } else if (info.type == 15) {
                // 顺风车业务
                RMRide *nextView = [[RMRide alloc] init];
                nextView.maId = xcode;
                nextView.maUrl = url;
                [self.navigationController pushViewController:nextView animated:YES];
                [nextView release];
                return;
            } else {
                iTimes = kCODE_KMA;
                [self chooseShowController:info.tranditionContent];
                return;
            }
        }
        UCKmaViewController *nextView = [[UCKmaViewController alloc] init];
        //nextView.bKma = YES; // 标记为空码赋值富媒体
        nextView.code = xcode;
        nextView.curImage = [Api generateImageWithInput:input];
        [self.navigationController pushViewController:nextView animated:YES];
        [nextView release];
    } else{
        DecodeBusinessViewController *businessView = [[DecodeBusinessViewController alloc] initWithNibName:@"DecodeBusinessViewController" category:category result:input image:inputImage withType:HistoryTypeFavAndHistory withSaveImage:saveImage];
        [self.navigationController pushViewController:businessView animated:YES];
        RELEASE_SAFELY(businessView);
    }
}

@end
