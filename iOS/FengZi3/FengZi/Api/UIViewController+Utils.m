//
//  UIViewController+Utils.m
//  FengZi
//
//  Created by wangfeng on 12-2-12.
//  Copyright (c) 2012年 ifengzi.cn. All rights reserved.
//

#import "UIViewController+Utils.h"
#import "UCLogin.h"
#import <FengZi/BusDecoder.h>
#import <FengZi/BusCategory.h>
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

#import "Roulette.h" // 轮盘
#import "Hamster.h"  // 打地鼠
#import "BreakEgg.h" // 砸蛋
#import "OpenBox.h"  // 开箱子

// 墙贴引入
#import "Api+eWall.h" // 墙贴
#import "EWallView.h"

#define FENGZI_URL @"http://ifengzi.cn/show.cgi?"
#define API_CODE_PREFIX  @"http://ifengzi.cn/show.cgi?"

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


#define AniInterval 0.3f

static int iTimes = -1;
#define kCODE_NONE (0)
#define kCODE_KMA  (9)

static NSString *s_luckyId = nil;

- (void)doGame:(int)n luckyId:(NSString *)luckyId{
    if (n == 0) {
        // 轮盘
        Roulette *theView = [[[Roulette alloc] init] autorelease];
        theView.luckyid = luckyId;
        theView.shopguid = luckyId;
        UINavigationController *nextView = [[UINavigationController alloc] initWithRootViewController:theView];
        [self presentModalViewController:nextView animated:YES];
        [nextView release];
    } else if (n == 1) {
        // 打地鼠
        Hamster *theView = [[[Hamster alloc] init] autorelease];
        theView.luckyid = luckyId;
        theView.shopguid = luckyId;
        UINavigationController *nextView = [[UINavigationController alloc] initWithRootViewController:theView];
        [self presentModalViewController:nextView animated:YES];
        [nextView release];
    } else if (n == 2) {
        // 开箱子
        OpenBox *theView = [[[OpenBox alloc] init] autorelease];
        theView.luckyid = luckyId;
        theView.shopguid = luckyId;
        UINavigationController *nextView = [[UINavigationController alloc] initWithRootViewController:theView];
        [self presentModalViewController:nextView animated:YES];
        [nextView release];
    } else if (n == 3) {
        // 砸蛋
        BreakEgg *theView = [[[BreakEgg alloc] init] autorelease];
        theView.luckyid = luckyId;
        theView.shopguid = luckyId;
        
        UINavigationController *nextView = [[UINavigationController alloc] initWithRootViewController:theView];
        [self presentModalViewController:nextView animated:YES];
        [nextView release];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger) buttonIndex {
    [self doGame:buttonIndex luckyId:s_luckyId];
}

-(NSString*)getString16:(int)type
{
    unsigned char typeUn = (unsigned char)type;
    NSString *type16 = [NSString stringWithFormat:@"%02X", typeUn];
    return type16;
    
}

-(BOOL)isHaveString:(NSString*)content param:(NSString*)param
{
    NSRange range = [content rangeOfString: param];
    if (range.length > 0) {
        return YES;
    }else {
        return NO;
    }
}

// 个人中心, 商城跳转
- (BOOL)jumpDigital:(NSString *)url{
    BOOL bRet = NO;
    if (url != nil && [url hasPrefix:API_URL_SHOW]) {
        NSDictionary *dict = [url uriParams];
        NSString *userId = [dict objectForKey:@"userId"];
        UCUpdateNikename *nextView = [[UCUpdateNikename alloc] init];
        nextView.idDest = [userId intValue];
        [self.navigationController pushViewController:nextView animated:YES];
        [nextView release];
        bRet = YES;
    } else if (url != nil && [url hasPrefix:API_QRCODE_ESHOP]) {
        // 数字商城
        NSDictionary *dict = [url uriParams];
        NSString *maId = [dict objectForKey:@"id"];
        if ([iOSApi regexpMatch:maId withPattern:@"[0-9]+"]) {
            UCStoreInfo *nextView = [[UCStoreInfo alloc] init];
            nextView.productId = [maId intValue];
            [self.navigationController pushViewController:nextView animated:YES];
            [nextView release];
            bRet = YES;
        }
    }
    // 网页标签跳转
    ApiCode *code = [[ApiCode codeWithUrl:url] retain];
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
            bRet = YES;
        }
    }    
    return bRet;
}

// 富媒体跳转
- (BOOL)jumpRichMedia:(int)jumpType content:(NSString *)content{
    BOOL bRet = YES;
    if (jumpType == API_RMJUMP_WWW || jumpType == API_RMJUMP_URL_PRICE) {
        // 网站链接
        NSString *url = [iOSApi urlDecode:content];
        if (![url hasPrefix:@"http"]) {
            url = [NSString stringWithFormat:@"http://%@", url];
        }
        [iOSApi openUrl:url];
    } else if (jumpType == API_RMJUMP_URL_PRICE) {
        // 优惠价链接
    } else if (jumpType == API_RMJUMP_ESHOP_SHOP) {
        // 数字商城 - 商户
        UCStoreTable *nextView = [[UCStoreTable alloc] init];
        nextView.person = content.intValue;
        nextView.page = 1;
        nextView.bPerson = YES;
        [self.navigationController pushViewController:nextView animated:YES];
        [nextView release];
    } else if (jumpType == API_RMJUMP_ESHOP_PROD) {
        // 数字商城 - 商品
        UCStoreInfo *nextView = [[UCStoreInfo alloc] init];
        nextView.productId = content.intValue;
        [self.navigationController pushViewController:nextView animated:YES];
        [nextView release];
    } else if (jumpType == API_RMJUMP_EBUY_SHOP) {
        // 电子商城 - 商户
        EBProductList *nextView = [[EBProductList alloc] init];
        nextView.way = 0;
        nextView.typeId = content;
        [self.navigationController pushViewController:nextView animated:YES];
        [nextView release];
    } else if (jumpType == API_RMJUMP_EBUY_PROD) {
        // 电子商城 - 商品
        EBProductDetail *nextView = [[EBProductDetail alloc] init];
        nextView.param = content;
        [self.navigationController pushViewController:nextView animated:YES];
        [nextView release];
    } else if (jumpType == API_RMJUMP_ACTION) {
        // 活动链接, 数据格式:参数1,参数2. 
        // 参数1:为游戏 1-轮盘,2-打地鼠,3-开箱子,4-砸蛋
        // 参数2:商户id
        NSArray *params = [content split:@","];
        if (params.count == 1) {
            IOSAPI_RELEASE(s_luckyId);
            s_luckyId = [[NSString alloc] initWithString:content];
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:nil
                                  message:nil
                                  delegate:self
                                  cancelButtonTitle:@"轮盘"
                                  otherButtonTitles:@"打地鼠",@"开箱子",@"砸金蛋",
                                  nil];
            [alert show];
            [alert release];
        } else if (params.count > 0) {
            int n = [[params objectAtIndex:0] intValue];
            NSString *shopId = [params objectAtIndex:1];
            [self doGame:n - 1 luckyId:shopId];
        } else {
            // 格式不对
            bRet = NO;
        }
    } else {
        // 默认, 怎么处理
        bRet = NO;
    }
    return bRet;
}

// 解码入口
- (void)chooseShowController:(NSString *)input isSave:(BOOL)isSave{
    iOSLog(@"QRCode-String = [%@]", input);
    input = [iOSApi urlDecode:input];
    UIImage *saveImage = [Api generateImageWithInput:input];
    UIImage *inputImage = saveImage;
    if (iTimes == kCODE_KMA) {
        inputImage = saveImage;
    }
    
    if (input == nil) {
        input = @"";
    }
    NSString *url = [Api fixUrl:input];
    if (url == nil) {
        url = @"";
    }
    // 个人中心, 商城类跳转
    if ([self jumpDigital:url] ) {
        return;
    }
    BusCategory *category = [BusDecoder classify:input];
    BusCategory *category_url = [BusDecoder classify:url];
    [TabBarController hide:NO animated:NO];
    
    if([category.type isEqualToString:CATEGORY_MEDIA] || [category_url.type isEqualToString:CATEGORY_MEDIA] ) {
        BOOL bJump = NO;
        NSDictionary *dict = [url uriParams];
        NSString *isJump = [dict objectForKey:@"issend"];
        if ([isJump isEqual:@"1"]) {
            // 富媒体跳转
            NSString *temp = [dict objectForKey:@"sendtype"];
            int jumpType = -1;
            if (temp != nil) {
                jumpType = temp.intValue;
            }
            temp = [dict objectForKey:@"sendcontent"];
            bJump = [self jumpRichMedia:jumpType content:temp];
        }
        if (bJump) {
            return;
        }
    } else if([category.type isEqualToString:CATEGORY_KMA] || [category_url.type isEqualToString:CATEGORY_KMA] ) {
        // 空码, 可以调到空码赋值页面, 默认为富媒体
        NSDictionary *dict = [url uriParams];
        NSString *xcode = [dict objectForKey:@"id"];
        [Api kmaSetId:xcode];
        iOSLog(@"uuid=[%@]", xcode);
        // 扫码
        KmaObject *info = [Api kmaContent:url];
        if (info.isKma == 0) {
            // 不是空码, 展示
            if (info.type == kModelRichMedia) {
                BOOL bJump = NO;
                MediaContent *media = info.mediaObj;
                if (media.isSend) {
                    // 富媒体跳转
                    NSString *temp = media.sendType;
                    int jumpType = -1;
                    if (temp != nil) {
                        jumpType = temp.intValue;
                    }
                    if (0) {
                        temp = [iOSApi urlDecode:media.sendContent];
                        bJump = [self jumpRichMedia:jumpType content:temp];
                    }                    
                } else {
                    NSDictionary *map = (NSDictionary *) info.mediaContent;
                    if (map.count > 0) {
                        RichMedia *rm = [iOSApi assignObject:map class:RichMedia.class];
                        NSDictionary *data = [map objectForKey:@"data"];
                        if ([data isKindOfClass:NSDictionary.class] && data.count > 0) {
                            rm = [iOSApi assignObject:data class:RichMedia.class];
                            rm.codeId = xcode;
                            UCRichMedia *nextVIew = [[UCRichMedia alloc] init];
                            nextVIew.richMedia = rm;
                            nextVIew.code = xcode;
                            [self.navigationController pushViewController:nextVIew animated:YES];
                            [nextVIew release];
                            bJump = YES;
                        } else {
                            iTimes = kCODE_KMA;
                            NSString *tmp = (NSString *)data;
                            if ([tmp isKindOfClass:NSString.class]) {
                                tmp = [iOSApi urlDecode:tmp];
                                [self chooseShowController:tmp isSave:isSave];
                            } else {
                                // 其它, 忽略
                            }                            
                        }
                    }
                }
                if (bJump) {
                    return;
                }
            } else if (info.type == kModelRide) {
                // 顺风车业务
                RMRide *nextView = [[RMRide alloc] init];
                nextView.maId = xcode;
                nextView.maUrl = url;
                [self.navigationController pushViewController:nextView animated:YES];
                [nextView release];
                return;
            } else {
                iTimes = kCODE_KMA;
                NSString *data = info.tranditionContent;
                {
                    NSDictionary *map = [data objectFromJSONString];
                    if (map != nil && map.count > 0) {
                        NSString *tmp = [map objectForKey:@"data"];
                        if ([tmp isKindOfClass:NSString.class]) {
                            data = [iOSApi urlDecode:tmp];
                        }
                    }
                }
                [self chooseShowController:data isSave:isSave];
                return;
            }
        }
        if(info.isKma == 1) {
            UCKmaViewController *nextView = [[UCKmaViewController alloc] init];
            //nextView.bKma = YES; // 标记为空码赋值富媒体
            nextView.code = xcode;
            nextView.curImage = [Api generateImageWithInput:input];
            [self.navigationController pushViewController:nextView animated:YES];
            [nextView release];
            return;
        }
    } else {
        // 墙贴条件判断判断 [WangFeng at 2012/05/14 11:31]
        EWall *param = [Api getWall:category content:input];
        if (param != nil) {
            EWallView *nextView = [[EWallView alloc] init];
            nextView.param = param;
            [self.navigationController pushViewController:nextView animated:YES];
            [nextView release];
            return;
        }
    }
    BaseModel *bm = [[Api parse:input timeout:30] retain];
    if (bm != nil) {
        iOSLog(@"扫码结果: [%@]", [bm typeName]);
        if (bm.typeId == kModelRichMedia) {
            // 跳转富媒体
            RichMedia *rm = (RichMedia *)bm;
            UCRichMedia *nextVIew = [[UCRichMedia alloc] init];
            nextVIew.richMedia = rm;
            nextVIew.code = rm.codeId;
            [self.navigationController pushViewController:nextVIew animated:YES];
            [nextVIew release];
        } else if (bm.typeId == kModelKma) {
            RichKma *rk = (RichKma *)bm;
            UCKmaViewController *nextView = [[UCKmaViewController alloc] init];
            //nextView.bKma = YES; // 标记为空码赋值富媒体
            nextView.code = rk.uuid;
            nextView.curImage = [Api generateImageWithInput:input];
            [self.navigationController pushViewController:nextView animated:YES];
            [nextView release];
        } else if (bm.typeId == kModelRide) {
            // 顺风车
        } else if (bm.typeId == kModelCard) {
            DecodeCardViewControlle *nextView = [[DecodeCardViewControlle alloc] initWithNibName:@"DecodeCardViewControlle" card:(Card *)bm withImage:inputImage withType:HistoryTypeFavAndHistory withSaveImage:saveImage];
            [self.navigationController pushViewController:nextView animated:YES];
            IOSAPI_RELEASE(nextView);
        } else {
            // 默认传统业务 [WangFeng at 2012/05/14 11:31]
            HistoryType hType = HistoryTypeNone;
            if (isSave) {
                hType = HistoryTypeFavAndHistory;
            }
            DecodeBusinessViewController *businessView = [[DecodeBusinessViewController alloc] initWithNibName:@"DecodeBusinessViewController" result:bm image:inputImage withType:hType withSaveImage:saveImage];
            [self.navigationController pushViewController:businessView animated:YES];
            RELEASE_SAFELY(businessView);
        }
        [bm release];
        return;
    }
}

@end
