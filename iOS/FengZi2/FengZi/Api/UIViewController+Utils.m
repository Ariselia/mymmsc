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

// 商城信息
#import "UCStoreTable.h"    // 数字商城 - 商户信息
#import "UCStoreInfo.h"     // 数字商城 - 商品信息展示
#import "EBProductDetail.h" // 电子商城 - 商品详情
#import "EBProductList.h"   // 电子商城 - 商铺信息

// 墙贴引入
#import "Api+eWall.h" // 墙贴
#import "EWallView.h"

#define AniInterval 0.3f

static int iTimes = -1;
#define kCODE_NONE (0)
#define kCODE_KMA  (9)

- (void)chooseShowController:(NSString *)input{
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
        BOOL bGoto = NO;
        // eshop:数字商城, ebuy:电商; Ctype->shanghu:商户,shangpin:商品;Id->用户id或者商品id
        // 数字商城
        if ([code.shopType isSame:@"eshop"]) {
            UCStoreInfo *nextView = [[UCStoreInfo alloc] init];
            nextView.productId = code.id.intValue;
            [self.navigationController pushViewController:nextView animated:YES];
            [nextView release];
            bGoto = YES;
        } else if ([code.shopType isSame:@"ebuy"]) {
            // 电子商城
            if ([code.cType isSame:@"shanghu"]) {
                // 商户
                EBProductList *nextView = [[EBProductList alloc] init];
                nextView.way = 0;
                nextView.typeId = code.id;
                [self.navigationController pushViewController:nextView animated:YES];
                [nextView release];
            } else {
                // 商品
                EBProductDetail *nextView = [[EBProductDetail alloc] init];
                nextView.param = code.id;
                [self.navigationController pushViewController:nextView animated:YES];
                [nextView release];
            }
            bGoto = YES;
        }
        [code release];
        // 如果跳转了, 返回, 否则按照其它业务规则继续处理
        if (bGoto) {
            return;
        }
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
        NSDictionary *dict = [url uriParams];
        NSString *isJump = [dict objectForKey:@"isend"];
        if ([isJump isEqual:@"1"]) {
            // 富媒体跳转
            NSString *temp = [dict objectForKey:@"sendtype"];
            int jumpType = -1;
            if (temp != nil) {
                jumpType = temp.intValue;
            }
            temp = [dict objectForKey:@"sendcontent"];
            if (jumpType == API_RMJUMP_WWW || jumpType == API_RMJUMP_URL_PRICE) {
                // 网站链接
                [iOSApi openUrl:temp];
            } else if (jumpType == API_RMJUMP_URL_PRICE) {
                // 优惠价链接
            } else if (jumpType == API_RMJUMP_ESHOP_SHOP) {
                // 数字商城 - 商户
                UCStoreTable *nextView = [[UCStoreTable alloc] init];
                nextView.person = temp.intValue;
                nextView.person = 0;
                nextView.page = 1;
                nextView.bPerson = YES;
                [self.navigationController pushViewController:nextView animated:YES];
                [nextView release];
            } else if (jumpType == API_RMJUMP_ESHOP_PROD) {
                // 数字商城 - 商品
                UCStoreInfo *nextView = [[UCStoreInfo alloc] init];
                nextView.productId = temp.intValue;
                [self.navigationController pushViewController:nextView animated:YES];
                [nextView release];
            } else if (jumpType == API_RMJUMP_EBUY_SHOP) {
                // 电子商城 - 商户
                EBProductList *nextView = [[EBProductList alloc] init];
                nextView.way = 0;
                nextView.typeId = temp;
                [self.navigationController pushViewController:nextView animated:YES];
                [nextView release];
            } else if (jumpType == API_RMJUMP_EBUY_PROD) {
                // 电子商城 - 商品
                EBProductDetail *nextView = [[EBProductDetail alloc] init];
                nextView.param = temp;
                [self.navigationController pushViewController:nextView animated:YES];
                [nextView release];
            } else if (jumpType == API_RMJUMP_ACTION) {
                // 活动链接, 数据格式:参数1,参数2. 
                // 参数1:为游戏 1-轮盘,2-打地鼠,3-开箱子,4-砸蛋
                // 参数2:商户id
            } else {
                // 默认, 怎么处理
            }
            return; // 终止流程
        } else {
            // 富媒体业务
            UCRichMedia *nextView = [[UCRichMedia alloc] init];
            nextView.urlMedia = url;
            [self.navigationController pushViewController:nextView animated:YES];
            [nextView release];
        }
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
    } else {
        // 墙贴条件判断判断 [WangFeng at 2012/05/14 11:31]
        EWall *param = [Api getWall:category content:input];
        if (param != nil) {
            EWallView *nextView = [[EWallView alloc] init];
            nextView.param = param;
            [self.navigationController pushViewController:nextView animated:YES];
            [nextView release];
        } else { // 默认传统业务 [WangFeng at 2012/05/14 11:31]
            DecodeBusinessViewController *businessView = [[DecodeBusinessViewController alloc] initWithNibName:@"DecodeBusinessViewController" category:category result:input image:inputImage withType:HistoryTypeFavAndHistory withSaveImage:saveImage];
            [self.navigationController pushViewController:businessView animated:YES];
            RELEASE_SAFELY(businessView);
        }
    }
}

@end
