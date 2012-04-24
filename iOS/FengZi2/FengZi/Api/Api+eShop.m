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

@synthesize pid, type, name, price, info, writer, orderProductUrl, realUrl, picurl, productLogo;
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
    NSString *sRet = [NSString stringWithFormat:API_URL_ESHOP "/eshop/download.action?userid=%d&id=%d", 1, pid];
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


@implementation ContentInfo

@synthesize pid, username, content;

- (void) dealloc{
    [username release];
    [content release];
    [super dealloc];
}
@end

//====================================< 数字商城 - 接口 >====================================
@implementation Api (AppStore)

+ (NSString *)typeIcon:(NSString *)type {
    return [NSString stringWithFormat:@"as_app_%@.png", type];
    
}

+ (NSString *)typeName:(NSString *)type {
    // type 媒体文件的类型
    NSDictionary *list = [NSDictionary dictionaryWithObjectsAndKeys:
                          @"全部", @"all",
                          @"电子书", @"dianzishu",
                          @"音乐", @"yinyue",
                          @"游戏", @"youxi",
                          @"图片", @"meitu",
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
    static NSString *path = @"eshop/main.action";
    NSString *action = [NSString stringWithFormat:@"%@/%@?type=%d&sortype=%d&pricetype=%d&person=%d&page=%d", API_URL_ESHOP, path, type, sorttype, pricetype, person, page];
    NSDictionary *map = [Api post:action params:nil];
    ApiResult *iRet = [[ApiResult alloc] init];
    NSArray *list = (NSArray *)map;
    NSMutableArray *aRet = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
    if (list.count > 0) {
        // 业务数据处理
        ProductInfo *obj = nil;
        for (NSDictionary *item in list) {
            obj = [ProductInfo new];
            obj.pid = [Api getInt:[item objectForKey:@"id"]];
            obj.name = [item objectForKey:@"name"];
            obj.type = [item objectForKey:@"type"];
            obj.info = [item objectForKey:@"info"];
            obj.writer = [item objectForKey:@"writer"];
            obj.price = [Api getFloat:[item objectForKey:@"price"]];
            obj.orderProductUrl = [item objectForKey:@"orderProductUrl"];
            obj.productLogo = [item objectForKey:@"productLogo"];
            [aRet addObject:obj];
            [obj release];
        }
    }
    [iRet release];
    return aRet;
}

// 订购
+ (ApiResult *)subscribe:(int)pid {
    static NSString *path = @"eshop/order.action";
    NSString *action = [NSString stringWithFormat:@"%@/%@?userid=%d&id=%d", API_URL_ESHOP, path, [Api userId], pid];
    NSDictionary *map = [Api post:action params:nil];
    ApiResult *iRet = [[ApiResult alloc] init];
    [iRet parse:map];
    return [iRet autorelease];
}

// 我的订购
+ (NSMutableArray *)orderList:(int)page {
    static NSString *path = @"eshop/orderlist.action";
    NSString *action = [NSString stringWithFormat:@"%@/%@?userid=%d&page=%d", API_URL_ESHOP, path, [Api userId], page];
    NSDictionary *map = [Api post:action params:nil];
    ApiResult *iRet = [[ApiResult alloc] init];
    NSArray *list = (NSArray *)map;
    NSMutableArray *aRet = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
    if (list.count > 0) {
        // 业务数据处理
        ProductInfo *obj = nil;
        for (NSDictionary *item in list) {
            obj = [ProductInfo new];
            obj.pid = [Api getInt:[item objectForKey:@"id"]];
            obj.name = [item objectForKey:@"name"];
            obj.type = [item objectForKey:@"type"];
            obj.info = [item objectForKey:@"info"];
            obj.writer = [item objectForKey:@"writer"];
            obj.price = [Api getFloat:[item objectForKey:@"price"]];
            obj.orderProductUrl = [item objectForKey:@"orderProductUrl"];
            obj.productLogo = [item objectForKey:@"productLogo"];
            [aRet addObject:obj];
            [obj release];
        }        
    }
    [iRet release];
    return aRet;
}

+ (NSMutableArray *)personList{
    static NSString *path = @"eshop/person.action";
    NSString *action = [NSString stringWithFormat:@"%@/%@?userid=%d&page=%d", API_URL_ESHOP, path, [Api userId], 1];
    NSDictionary *map = [Api post:action params:nil];
    ApiResult *iRet = [[ApiResult alloc] init];
    NSArray *list = (NSArray *)map;
    NSMutableArray *aRet = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
    if (list.count > 0) {
        // 业务数据处理
        PersonInfo *obj = nil;
        for (NSDictionary *item in list) {
            obj = [PersonInfo new];
            obj.pid = [Api getInt:[item objectForKey:@"id"]];
            obj.picUrl = [item objectForKey:@"picurl"];
            [aRet addObject:obj];
            [obj release];
        }
        
    }
    [iRet release];
    return aRet;
}

// 相关产品
+ (NSMutableArray *)relation:(int)pid
                        page:(int)page{
    static NSString *path = @"eshop/relation.action";
    NSString *action = [NSString stringWithFormat:@"%@/%@?userid=%d&page=%d&id=%d", API_URL_ESHOP, path, [Api userId], page, pid];
    NSDictionary *map = [Api post:action params:nil];
    ApiResult *iRet = [[ApiResult alloc] init];
    NSArray *list = (NSArray *)map;
    NSMutableArray *aRet = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
    if (list.count > 0) {
        // 业务数据处理
        ProductInfo *obj = nil;
        for (NSDictionary *item in list) {
            obj = [ProductInfo new];
            obj.pid = [Api getInt:[item objectForKey:@"id"]];
            obj.name = [item objectForKey:@"name"];
            obj.type = [item objectForKey:@"type"];
            obj.info = [item objectForKey:@"info"];
            obj.writer = [item objectForKey:@"writer"];
            obj.price = [Api getFloat:[item objectForKey:@"price"]];
            obj.orderProductUrl = [item objectForKey:@"orderProductUrl"];
            obj.productLogo = [item objectForKey:@"productLogo"];
            [aRet addObject:obj];
            [obj release];
        }
    }
    [iRet release];
    return aRet;
}

// 评论信息列表
+ (NSMutableArray *)bbsList:(int)pid
                       page:(int)page {
    static NSString *path = @"eshop/commnetlist.action";
    NSString *action = [NSString stringWithFormat:@"%@/%@?userid=%d&page=%d&id=%d", API_URL_ESHOP, path, [Api userId], page, pid];
    NSDictionary *map = [Api post:action params:nil];
    ApiResult *iRet = [[ApiResult alloc] init];
    NSArray *list = (NSArray *)map;
    NSMutableArray *aRet = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
    if (list.count > 0) {
        // 业务数据处理
        ContentInfo *obj = nil;
        for (NSDictionary *item in list) {
            obj = [ContentInfo new];
            obj.pid = [Api getInt:[item objectForKey:@"id"]];
            obj.username = [item objectForKey:@"userName"];
            obj.content = [item objectForKey:@"content"];
            [aRet addObject:obj];
            [obj release];
        }
        
    }
    [iRet release];
    return aRet;
}

+ (ApiResult *)conmment:(int)pid
              username:(NSString *)username
                   msg:(NSString *)msg {
    //http://220.231.48.34:9000/eshop/eshop/commnet.action;jsessionid=9E4C07BB88579E5C14033C64EC218D8D?content=aebcs&id=1&userid=1
    static NSString *path = @"eshop/commnet.action";
    NSString *action = [NSString stringWithFormat:@"%@/%@?userid=%d&id=%d", API_URL_ESHOP, path, [Api userId], pid];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            username, @"username",
                            msg, @"content",
                            nil];
    NSDictionary *map = [Api post:action params:params];
    
    ApiResult *iRet = [[ApiResult alloc] init];
    [iRet parse:map];
    return [iRet autorelease];
}

+ (ProductInfo2 *)proinfo:(int)pid {
    //http://220.231.48.34:9000/eshop/eshop/commnet.action;jsessionid=9E4C07BB88579E5C14033C64EC218D8D?content=aebcs&id=1&userid=1
    static NSString *path = @"eshop/info.action";
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
