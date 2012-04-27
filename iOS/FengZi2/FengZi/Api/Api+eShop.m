//
//  Api+eShop.m
//  FengZi
//
//  Created by WangFeng on 11-12-15.
//  Copyright (c) 2012年 mymmsc.org. All rights reserved.
//

#import "Api+eShop.h"
#import <iOSApi/NSObject+Utils.h>
#import <objc/runtime.h>

@implementation ProductInfo

@synthesize id, type, name, price, info, writer, orderProductUrl, realUrl, picurl, productLogo;
@synthesize state;

- (void)dealloc {
    [name release];
    [info release];
    [writer release];
    [orderProductUrl release];
    [picurl release];
    [super dealloc];
}

- (NSString *)url {
    NSString *sRet = [NSString stringWithFormat:API_URL_ESHOP "/download.action?userid=%d&id=%d", 1, id];
    iOSLog(@"real url: %@", sRet);
    return sRet;
}

@end

@implementation ProductInfo2

@synthesize picurl, id, pricetype, publisher, typename, info, writer, shopname,isOrder, productUrl;

@end

@implementation PersonInfo

@synthesize pid, picUrl;

- (void)dealloc{
    [picUrl release];
    [super dealloc];
}

@end


@implementation ESContentInfo

@synthesize id, username, content,userId,productId,createTime;

- (void) dealloc{
    IOSAPI_RELEASE(createTime);
    [username release];
    [content release];
    [super dealloc];
}
@end

//====================================< 数字商城 - 接口 >====================================
@implementation Api (AppStore)

// 商品二维码的URL
+ (UIImage *)eshop_qrcode:(int)id{
    NSString *s = [NSString stringWithFormat:@"%@/info.action?id=%d", API_URL_ESHOP, id];
    return [Api generateImageWithInput:s];
}

// 类型图片
+ (NSString *)typeIcon:(NSString *)type {
    return [NSString stringWithFormat:@"as_app_%@.png", type];
    
}

+ (NSString *)eshop_type:(NSString *)type {
    // type 媒体文件的类型
    NSDictionary *list = [NSDictionary dictionaryWithObjectsAndKeys:
                          @"all", @"全部", 
                          @"dianzishu",@"电子书", 
                          @"yinyue",@"音乐", 
                          @"youxi",@"游戏", 
                          @"meitu",@"美图", 
                          @"shipin",@"视频", 
                          @"manhua",@"漫画", 
                          @"qita",@"其它", 
                          nil];
    //NSArray *list = [NSArray arrayWithObjects:@"全部", @"电子书", @"音乐", @"游戏", @"图片", @"视频", @"漫画", @"其它", nil];
    NSString *sRet = [list objectForKey:[type trim]];
    if (sRet == nil) {
        sRet = @"其它";
    }
    return sRet;
}

+ (NSString *)eshop_typename:(NSString *)type {
    // type 媒体文件的类型
    NSDictionary *list = [NSDictionary dictionaryWithObjectsAndKeys:
                          @"全部", @"all",
                          @"电子书", @"dianzishu",
                          @"音乐", @"yinyue",
                          @"游戏", @"youxi",
                          @"美图", @"meitu",
                          @"视频", @"shipin",
                          @"漫画", @"manhua",
                          @"其它", @"qita",
                           nil];
    //NSArray *list = [NSArray arrayWithObjects:@"全部", @"电子书", @"音乐", @"游戏", @"图片", @"视频", @"漫画", @"其它", nil];
    NSString *sRet = [list objectForKey:[type trim]];
    if (sRet == nil) {
        sRet = @"其它";
    }
    return sRet;
}

+ (NSString *)sortName:(int)index {
    // sorttype	订购排行的类型
    NSArray *list = [NSArray arrayWithObjects:@"全部", @"最新", @"热门", nil];
    index = index < 0 ? 0 : index;
    index = index >= list.count ? list.count - 1: index;
    NSString *sRet = [list objectAtIndex:index];
    if (sRet == nil) {
        sRet = @"全部";
    }
    return sRet;
}


+ (NSString *)priceName:(int)index {
    // pricetype
    NSArray *list = [NSArray arrayWithObjects:@"全部", @"免费", @"收费", nil];
    index = index < 0 ? 0 : index;
    index = index >= list.count ? list.count - 1: index;
    NSString *sRet = [list objectAtIndex:index];
    if (sRet == nil) {
        sRet = @"全部";
    }
    return sRet;
}

// 商城列表
+ (NSMutableArray *)storeList:(int)type
                     sorttype:(int)sorttype
                    pricetype:(int)pricetype
                       person:(int)person
                         page:(int)page {
    static NSString *path = @"main.action";
    NSArray *list1 = [[[NSArray alloc] initWithObjects:@"all", @"dianzishu", @"yinyue", @"youxi", @"meitu", @"shipin", @"manhua", @"qita", nil] autorelease];
    NSString *sType = [list1 objectAtIndex:type];
    NSString *action = [NSString stringWithFormat:@"%@/%@?type=%@&sortype=%d&pricetype=%d&person=%d&page=%d", API_URL_ESHOP, path, sType, sorttype, pricetype, person, page];
    NSDictionary *map = [Api post:action params:nil];
    ApiResult *iRet = [[ApiResult alloc] init];
    NSArray *list = (NSArray *)map;
    NSMutableArray *aRet = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
    if (list.count > 0) {
        // 业务数据处理
        aRet = [list toList:ProductInfo.class];
    }
    [iRet release];
    return aRet;
}

// 订购
+ (ApiResult *)subscribe:(int)pid {
    static NSString *path = @"order.action";
    NSString *action = [NSString stringWithFormat:@"%@/%@?userid=%d&id=%d", API_URL_ESHOP, path, [Api userId], pid];
    NSDictionary *map = [Api post:action params:nil];
    ApiResult *iRet = [[ApiResult alloc] init];
    [iRet parse:map];
    return [iRet autorelease];
}

// 我的订购
+ (NSMutableArray *)orderList:(int)page {
    static NSString *path = @"orderlist.action";
    NSString *action = [NSString stringWithFormat:@"%@/%@?userid=%d&page=%d", API_URL_ESHOP, path, [Api userId], page];
    NSDictionary *map = [Api post:action params:nil];
    ApiResult *iRet = [[ApiResult alloc] init];
    NSArray *list = (NSArray *)map;
    NSMutableArray *aRet = nil;
    if (list.count > 0) {
        // 业务数据处理
        aRet = [list toList:ProductInfo.class];
    }
    [iRet release];
    return aRet;
}

+ (NSMutableArray *)personList{
    static NSString *path = @"person.action";
    NSString *action = [NSString stringWithFormat:@"%@/%@?userid=%d&page=%d", API_URL_ESHOP, path, [Api userId], 1];
    NSDictionary *map = [Api post:action params:nil];
    ApiResult *iRet = [[ApiResult alloc] init];
    NSArray *list = (NSArray *)map;
    NSMutableArray *aRet = nil;
    if (list.count > 0) {
        // 业务数据处理
        aRet = [list toList:PersonInfo.class];
    }
    [iRet release];
    return aRet;
}

// 相关产品
+ (NSMutableArray *)relation:(int)pid
                        page:(int)page{
    static NSString *path = @"relation.action";
    NSString *action = [NSString stringWithFormat:@"%@/%@?userid=%d&page=%d&id=%d", API_URL_ESHOP, path, [Api userId], page, pid];
    NSDictionary *map = [Api post:action params:nil];
    ApiResult *iRet = [[ApiResult alloc] init];
    NSArray *list = (NSArray *)map;
    NSMutableArray *aRet = nil;
    if (list.count > 0) {
        // 业务数据处理
        aRet = [list toList:ProductInfo.class];
    }
    [iRet release];
    return aRet;
}

// 评论信息列表
+ (NSMutableArray *)bbsList:(int)pid
                       page:(int)page {
    static NSString *path = @"commnetlist.action";
    NSString *action = [NSString stringWithFormat:@"%@/%@?userid=%d&page=%d&id=%d", API_URL_ESHOP, path, [Api userId], page, pid];
    NSDictionary *map = [Api post:action params:nil];
    ApiResult *iRet = [[ApiResult alloc] init];
    NSArray *list = (NSArray *)map;
    NSMutableArray *aRet = nil;
    if (list.count > 0) {
        aRet = [list toList:ESContentInfo.class];
    }
    [iRet release];
    return aRet;
}

+ (ApiResult *)conmment_old:(int)pid
               username:(NSString *)username
                    msg:(NSString *)msg {
    //http://devp.ifengzi.cn:38090/eshop/commnet.action?content=aebcs&id=3&userid=1&username=%E6%B5%8B%E8%AF%95%E5%91%98
    static NSString *path = @"commnet.action";
    NSString *action = [NSString stringWithFormat:@"%@/%@?userid=%d&id=%d", API_URL_ESHOP, path, [Api userId], pid];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            username, @"username",
                            msg, @"content",
                            nil];
    NSDictionary *map = [Api post:action params:params];
    
    ApiResult *iRet = [[ApiResult alloc] init];
    if ([map isKindOfClass:NSDictionary.class]) {
        [iRet parse:map];
    }
    
    return [iRet autorelease];
}

//TODO: 评论前后变化是POST方法不支持了。
+ (ApiResult *)conmment:(int)pid
              username:(NSString *)username
                   msg:(NSString *)msg {
    //http://devp.ifengzi.cn:38090/eshop/commnet.action?content=aebcs&id=3&userid=1&username=%E6%B5%8B%E8%AF%95%E5%91%98
    static NSString *path = @"commnet.action";
    NSString *action = [NSString stringWithFormat:@"%@/%@?userid=%d&id=%d&username=%@&content=%@", API_URL_ESHOP, path, [Api userId], pid, [iOSApi urlEncode:username], [iOSApi urlEncode:msg]];
    NSDictionary *map = [Api post:action params:nil];
    
    ApiResult *iRet = [[ApiResult alloc] init];
    if ([map isKindOfClass:NSDictionary.class]) {
        [iRet parse:map];
    }
    
    return [iRet autorelease];
}

+ (ProductInfo2 *)proinfo:(int)pid {
    //http://220.231.48.34:9000/eshop/eshop/commnet.action;jsessionid=9E4C07BB88579E5C14033C64EC218D8D?content=aebcs&id=1&userid=1
    static NSString *path = @"info.action";
    NSString *action = [NSString stringWithFormat:@"%@/%@?userid=%d&id=%d", API_URL_ESHOP, path, [Api userId], pid];
    NSDictionary *map = [Api post:action params:nil];
    
    ProductInfo2 *iRet = [[ProductInfo2 alloc] init];
    for (NSString *key in [map allKeys]) {
        id value = [map objectForKey:key];
        [iRet setValue:value forSameKey:key];
    }
    //NSArray *list = (NSArray *)map;
    //for (NSDictionary *item in list) {
        //iRet.pid = [Api getInt:[map objectForKey:@"id"]];
        //iRet.pid = [item objectForKey:@"id"];
        //iRet.typename = [map objectForKey:@"typename"];
        iRet.picurl = [iOSApi urlDecode:iRet.picurl];
    //}
    return [iRet autorelease];;
}

@end
