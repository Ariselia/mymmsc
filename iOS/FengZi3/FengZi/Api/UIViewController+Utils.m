//
//  UIViewController+Utils.m
//  FengZi
//
//  Created by wangfeng on 12-2-12.
//  Copyright (c) 2012年 ifengzi.cn. All rights reserved.
//

#import "UIViewController+Utils.h"
#import "UCLogin.h"
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

// 解码入口
- (void)chooseShowController:(NSString *)input isSave:(BOOL)isSave{
    iOSLog(@"input = [%@]", input);
    input = [iOSApi urlDecode:input];
    BusCategory *_category = [BusDecoder classify:input];
    UIImage *saveImage = [Api generateImageWithInput:input];
    UIImage *inputImage = saveImage;
    if (iTimes == kCODE_KMA) {
        inputImage = saveImage;
    }

    if (input != nil) {
        if ([input hasPrefix:API_CODE_PREFIX]) {
            // 是码开头的, 截取字符串, 去掉前缀
            NSString *str = [input substringFromIndex:[API_CODE_PREFIX length]];
            if ([str hasPrefix:@"id="]) {
                // 富媒体, 或者空码, 转换地址
                NSString *iskma = [str substringFromIndex:3];
                NSString *url = [NSString stringWithFormat:@"%@/apps/getCode.action?%@",API_APPS_SERVER,str];
                if([iskma rangeOfString:@"-"].length>0) {
                    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                            [NSString valueOf:[Api userId]], @"userid",
                                            nil];
                    NSDictionary *map = [Api post:url params:params];
                    if (map.count > 0) {
                        if([[map objectForKey:@"data"] isKindOfClass:[NSString class]])
                        {
                            
                            //NSLog(@"//普通解码");
                            NSString *_content=nil;
                            _content =  [[NSString stringWithFormat:@"%@%@", API_CODE_PREFIX,[map objectForKey:@"data"]] retain];
                            [self chooseShowController:_content isSave:isSave];
                            return;
                        } else {
                            UCRichMedia *nextView = [[UCRichMedia alloc] init];
                            nextView.urlMedia = url;
                            nextView.curImage = [Api generateImageWithInput:input];
                            [self.navigationController pushViewController:nextView animated:YES];
                            [nextView release];
                            return;
                        }
                        
                    }
                } else {
                    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                            [NSString valueOf:[Api userId]], @"userid",
                                            nil];
                    NSDictionary *map = [Api post:url params:params];                    
                    if (map.count > 0) {
                        NSString *status =[NSString stringWithFormat:@"%d", [Api getInt:[map objectForKey:@"status"]]];
                        // NSLog(@"%@",status);    
                        if ([status isEqualToString:@"404"]) {
                            //跳到空码赋值
                            UCKmaViewController *nextView = [[UCKmaViewController alloc] init];
                            //nextView.bKma = YES; // 标记为空码赋值富媒体
                            nextView.code = iskma;
                            nextView.curImage = [Api generateImageWithInput:input];
                            [self.navigationController pushViewController:nextView animated:YES];
                            [nextView release];
                            return;
                        }  else  {
                            //进行解码
                            if([[map objectForKey:@"data"] isKindOfClass:[NSString class]])
                            {                                
                                //NSLog(@"//普通解码");                               
                                NSString *_content=nil;
                                _content =  [[NSString stringWithFormat:@"%@%@", API_CODE_PREFIX,[map objectForKey:@"data"]] retain];
                                [self chooseShowController:_content isSave:isSave];
                                return;
                            } else {
                                //NSLog(@"//服媒体");
                                UCRichMedia *nextView = [[UCRichMedia alloc] init];
                                nextView.urlMedia = url;
                                 nextView.curImage = [Api generateImageWithInput:input];
                                [self.navigationController pushViewController:nextView animated:YES];
                                [nextView release];
                                return;                                
                            }
                        }
                    }
                }
            } else {
                // 普通码规则, 前两位是十六进制串
                const char *s = [[str substringToIndex:2] UTF8String];
                int type = -1;
                sscanf(s, "%02X", &type);
                if (type > 0) {
                    // 已经取到类型了, 进一步剥离类型, 取的编码串
                    str = [str substringFromIndex:2];
                    // 下面的这个数组的内容, 就是从A开始的连续的值
                    //NSArray *list = [BusDecoder parse0:str];
                    if (type == 5) {
                        if (isSave) {
                            DecodeCardViewControlle *cardView = [[DecodeCardViewControlle alloc] initWithNibName:@"DecodeCardViewControlle" category:_category result:str withImage:inputImage withType:HistoryTypeFavAndHistory withSaveImage:saveImage];
                            [self.navigationController pushViewController:cardView animated:YES];
                            RELEASE_SAFELY(cardView);
                            return;                            
                        } else {                            
                            DecodeCardViewControlle *cardView = [[DecodeCardViewControlle alloc] initWithNibName:@"DecodeCardViewControlle" category:_category result:str withImage:inputImage withType:HistoryTypeNone withSaveImage:saveImage];
                            [self.navigationController pushViewController:cardView animated:YES];
                            RELEASE_SAFELY(cardView);
                            return;
                        }
                    }
                }
            }
        }
    }
              
                
    NSLog(@"decode input = %@", input);
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
   //      NSString *strCard =[NSString stringWithFormat:@"%@%@",FENGZI_URL,[self getString16:BusinessTypeCard]];
   // if ([self isHaveString:input param:strCard]) {
    if([category.type isEqualToString:CATEGORY_MEDIA] || [category_url.type isEqualToString:CATEGORY_MEDIA] ) {
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
                NSArray *params = [temp split:@","];
                if (params.count > 1) {
                    int n = [[params objectAtIndex:0] intValue];
                    NSString *shopId = [params objectAtIndex:1];
                    if (n == 1) {
                        // 轮盘
                        Roulette *theView = [[[Roulette alloc] init] autorelease];
                        theView.luckyid = shopId;
                        theView.shopguid = shopId;
                        UINavigationController *nextView = [[UINavigationController alloc] initWithRootViewController:theView];
                        [self presentModalViewController:nextView animated:YES];
                        [nextView release];
                    } else if (n == 2) {
                        // 打地鼠
                        Hamster *theView = [[[Hamster alloc] init] autorelease];
                        theView.luckyid = shopId;
                        theView.shopguid = shopId;
                        UINavigationController *nextView = [[UINavigationController alloc] initWithRootViewController:theView];
                        [self presentModalViewController:nextView animated:YES];
                        [nextView release];
                    } else if (n == 3) {
                        // 开箱子
                        OpenBox *theView = [[[OpenBox alloc] init] autorelease];
                        theView.luckyid = shopId;
                        theView.shopguid = shopId;
                        UINavigationController *nextView = [[UINavigationController alloc] initWithRootViewController:theView];
                        [self presentModalViewController:nextView animated:YES];
                        [nextView release];
                    } else if (n == 4) {
                        // 砸蛋
                        BreakEgg *theView = [[[BreakEgg alloc] init] autorelease];
                        theView.luckyid = shopId;
                        theView.shopguid = shopId;
                        
                        UINavigationController *nextView = [[UINavigationController alloc] initWithRootViewController:theView];
                        [self presentModalViewController:nextView animated:YES];
                        [nextView release];
                    }
                } else {
                    // 格式不对
                }
            } else {
                // 默认, 怎么处理
            }
            return;
        } else {
            // 富媒体业务
            NSLog(@"富媒体业务");
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
        // 扫码
        //KmaObject *info = [Api kmaContent:xcode];
        KmaObject *info = [Api kmaContent:url];
        if (info.isKma == 0) {
            // 不是空码, 展示
            if (info.type == 14) {
                MediaContent *media = info.mediaObj;
                if (media.isSend) {
                    // 富媒体跳转
                    NSString *temp = media.sendType;
                    int jumpType = -1;
                    if (temp != nil) {
                        jumpType = temp.intValue;
                    }
                    temp = [iOSApi urlDecode:media.sendContent];
                    if (jumpType == API_RMJUMP_WWW || jumpType == API_RMJUMP_URL_PRICE) {
                        // 网站链接
                        NSString *url = [iOSApi urlDecode:temp];
                        if (![url hasPrefix:@"http"]) {
                            url = [NSString stringWithFormat:@"http://%@", url];
                        }
                        [iOSApi openUrl:url];
                    } else if (jumpType == API_RMJUMP_URL_PRICE) {
                        // 优惠价链接
                    } else if (jumpType == API_RMJUMP_ESHOP_SHOP) {
                        // 数字商城 - 商户
                        UCStoreTable *nextView = [[UCStoreTable alloc] init];
                        nextView.person = temp.intValue;
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
                        NSArray *params = [temp split:@","];
                        if (params.count == 1) {
                            IOSAPI_RELEASE(s_luckyId);
                            s_luckyId = [[NSString alloc] initWithString:temp];
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
                        }
                    } else {
                        // 默认, 怎么处理
                    }
                } else {
                    // 富媒体业务
                    UCRichMedia *nextView = [[UCRichMedia alloc] init];
                    nextView.urlMedia = nil;
                    nextView.code = xcode;
                    [self.navigationController pushViewController:nextView animated:YES];
                    [nextView release];
                    return;
                }
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
                [self chooseShowController:info.tranditionContent isSave:isSave];
                return;
            }
        }
        UCKmaViewController *nextView = [[UCKmaViewController alloc] init];
        //nextView.bKma = YES; // 标记为空码赋值富媒体
        nextView.code = xcode;
        nextView.curImage = [Api generateImageWithInput:input];
        [self.navigationController pushViewController:nextView animated:YES];
        [nextView release];
        return;
    } else {
        // 墙贴条件判断判断 [WangFeng at 2012/05/14 11:31]
        EWall *param = [Api getWall:category content:input];
        if (param != nil) {
            EWallView *nextView = [[EWallView alloc] init];
            nextView.param = param;
            [self.navigationController pushViewController:nextView animated:YES];
            [nextView release];
            return;
        } else {
            // 默认传统业务 [WangFeng at 2012/05/14 11:31]
            if (isSave) {
                DecodeBusinessViewController *businessView = [[DecodeBusinessViewController alloc] initWithNibName:@"DecodeBusinessViewController" category:category result:input image:inputImage withType:HistoryTypeFavAndHistory withSaveImage:saveImage];
                [self.navigationController pushViewController:businessView animated:YES];
                RELEASE_SAFELY(businessView);
                return;
            } else {
                DecodeBusinessViewController *businessView = [[DecodeBusinessViewController alloc] initWithNibName:@"DecodeBusinessViewController" category:category result:input image:inputImage withType:HistoryTypeNone withSaveImage:saveImage];
                [self.navigationController pushViewController:businessView animated:YES];
                RELEASE_SAFELY(businessView);
                return;
                
            }
        }
    }
}

@end
