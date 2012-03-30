//
//  Api+Ebuy.m
//  FengZi
//
//  Created by wangfeng on 12-1-29.
//  Copyright (c) 2012年 iTotemStudio. All rights reserved.
//

#import "Api+Ebuy.h"

//====================================< 电子商城 - 对象定义 >====================================

//--------------------< 电子商城 - 对象 - 商品 >--------------------
@implementation EBProductInfo

@synthesize id, title, content, picUrl, price, realizeTime;

@end

//--------------------< 电子商城 - 对象 - 商品分类 >--------------------

@implementation EBProductType

@synthesize typeId, typeName, child;

@end

//--------------------< 电子商城 - 对象 - 快讯类型 >--------------------
@implementation EBExpressType

@synthesize id, title, content;

@end

//====================================< 电子商城 - 接口 >====================================
@implementation Api (Ebuy)

// 商品模糊搜索
+ (NSMutableArray *)ebuy_search:(NSString *)key {
    NSMutableArray *list = nil;
    // 方法
    static NSString *method = @"search";
    NSDictionary *heads = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"application/json", @"Content-Type",
                            nil];
    NSMutableDictionary *jsonDic = [NSMutableDictionary dictionary];
    NSMutableDictionary *search = [NSMutableDictionary dictionary];
    NSString *name = [iOSApi urlDecode:key];
    [search setObject:name forKey:@"name"];
    [jsonDic setObject:search forKey:method];
    
    NSString *params = [jsonDic JSONString];
    
    NSString *action = [NSString stringWithFormat:@"%@/%@", API_URL_EBUY, method];
    NSDictionary *map = [Api post:action header:heads body:[params dataUsingEncoding:NSUTF8StringEncoding]];
    if (map) {
        NSMutableArray *data = [map objectForKey:@"search"];
        if (data.count > 0) {
            list = [data toList:EBProductInfo.class];
        }
    }
    
    return list;
}

// 商品推荐接口
+ (NSMutableArray *)ebuy_push:(int)page{
    NSMutableArray *list = nil;
    // 方法
    static NSString *method = @"push";
    if (page < 1) {
        page = 1;
    }
    NSString *params = [NSString stringWithFormat:@"page=%d", page];
    NSString *action = [NSString stringWithFormat:@"%@/%@?%@", API_URL_EBUY, method, params];
    NSDictionary *map = [Api post:action params:nil];
    if (map) {
        NSMutableArray *data = [map objectForKey:@"push"];
        if (data.count > 0) {
            list = [data toList:EBProductInfo.class];
        }
    }
    
    return list;
}

// 分类列表接口
+ (NSMutableArray *)ebuy_type:(int)page typeId:(int)typeId{
    NSMutableArray *list = nil;
    // 方法
    static NSString *method = @"type";
    if (page < 1) {
        page = 1;
    }
    NSString *params = [NSString stringWithFormat:@"page=%d&typeid=%d", page, typeId];
    NSString *action = [NSString stringWithFormat:@"%@/%@?%@", API_URL_EBUY, method, params];
    NSDictionary *map = [Api post:action params:nil];
    if (map) {
        NSMutableArray *data = [map objectForKey:@"type"];
        if (data.count > 0) {
            list = [data toList:EBProductType.class];
        }
    }
    
    return list;
}

// 获取商品列表
+ (NSMutableArray *)ebuy_goodslist:(int)page typeId:(int)typeId{
    NSMutableArray *list = nil;
    // 方法
    static NSString *method = @"goodslist";
    if (page < 1) {
        page = 1;
    }
    NSString *params = [NSString stringWithFormat:@"page=%d&typeid=%d", page, typeId];
    NSString *action = [NSString stringWithFormat:@"%@/%@?%@", API_URL_EBUY, method, params];
    NSDictionary *map = [Api post:action params:nil];
    if (map) {
        NSMutableArray *data = [map objectForKey:@"goodslist"];
        if (data.count > 0) {
            list = [data toList:EBProductInfo.class];
        }
    }
    
    return list;
}

// 快报资讯推荐接口
+ (NSMutableArray *)ebuy_new:(int)page{
    NSMutableArray *list = nil;
    // 方法
    static NSString *method = @"new";
    if (page < 1) {
        page = 1;
    }
    NSString *params = [NSString stringWithFormat:@"page=%d", page];
    NSString *action = [NSString stringWithFormat:@"%@/%@?%@", API_URL_EBUY, method, params];
    NSDictionary *map = [Api post:action params:nil];
    if (map) {
        NSMutableArray *data = [map objectForKey:@"new"];
        if (data.count > 0) {
            list = [data toList:EBExpressType.class];
        }
    }
    
    return list;
}

// 快报资讯详情接口
+ (EBProductInfo *)ebuy_messagenewinfo:(NSString *)id{
    EBProductInfo *oRet = nil;
    // 方法
    static NSString *method = @"messagenewinfo";
    NSString *params = [NSString stringWithFormat:@"id=%@", id];
    NSString *action = [NSString stringWithFormat:@"%@/%@?%@", API_URL_EBUY, method, params];
    NSDictionary *map = [Api post:action params:nil];
    if (map) {
        NSDictionary *data = [map objectForKey:@"messagenewinfo"];
        if (data.count > 0) {
            oRet = [data toObject:EBProductInfo.class];
        }
    }
    
    return oRet;
}

@end
