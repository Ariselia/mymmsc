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

@synthesize id, title, content, picUrl, price, shopId, shopName;
@synthesize realizeTime;
// 商品详情字段
@synthesize Goodcommentcount,Experiencecount,Middlecommentcount,Poorcommentcount;
@synthesize storeInfo,info,orderId,service,listInfo,parameters;

- (void)encodeWithCoder:(NSCoder *)aCoder//要一一对应  
{
    [aCoder encodeObject:id forKey:@"id"];
    [aCoder encodeObject:title forKey:@"title"];
    [aCoder encodeObject:content forKey:@"content"];
    [aCoder encodeObject:picUrl forKey:@"picUrl"];
    [aCoder encodeFloat:price forKey:@"price"];
    [aCoder encodeInt:shopId forKey:@"shopId"];
    [aCoder encodeObject:shopName forKey:@"shopName"];
    [aCoder encodeObject:orderId forKey:@"orderId"];
}

- (id)initWithCoder:(NSCoder *)aDecoder//和上面对应  
{  
    if (self = [super init]) {
        self.id = [aDecoder decodeObjectForKey:@"id"];
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.content = [aDecoder decodeObjectForKey:@"content"];
        self.picUrl = [aDecoder decodeObjectForKey:@"picUrl"];
        self.price = [aDecoder decodeFloatForKey:@"price"];
        self.shopId = [aDecoder decodeIntForKey:@"shopId"];
        self.shopName = [aDecoder decodeObjectForKey:@"shopName"];
        self.orderId = [aDecoder decodeObjectForKey:@"orderId"];
    }
    return self;
}

@end

//--------------------< 电子商城 - 对象 - 商品分类 >--------------------

@implementation EBProductType

@synthesize typeId, typeName, child;

@end

//--------------------< 电子商城 - 对象 - 快讯类型 >--------------------
@implementation EBExpressType

@synthesize id, title, content;

@end

//--------------------< 电子商城 - 对象 - 商品评论 >--------------------
@implementation EBProductComment

@synthesize id,userName,content,picUrl,commentTime,love,grade;

@end

//--------------------< 电子商城 - 对象 - 站内消息 >--------------------
@implementation EBSiteMessage

@synthesize id,senderId,sendName,title,content,recevTime;

@end

//--------------------< 电子商城 - 对象 - 订单 >--------------------
@implementation EBOrder
@synthesize id,ordered,orderTime,price,state;
@end

@implementation EBOrderUser

@synthesize type,state,mobile,shopId,userId,address,orderId,payment,areaCode,receiver,shopName,goodsCount;

@end

@implementation EBOrderProduct

@synthesize id,name,price,picUrl,totalCount;

@end

@implementation EBOrderInfo

@synthesize products,userInfo;

@end
//--------------------< 电子商城 - 对象 - 商铺详情 >--------------------
@implementation EBShop

@synthesize id,des,picUrl,name,itemGroupType;

@end

@implementation EBTest

@synthesize id;

@end

//--------------------< 电子商城 - 对象 - 收货地址 >--------------------
@implementation EBAddress

@synthesize sheng,chengshi,dizhi,shouhuoren,youbian,shouji;

- (void)encodeWithCoder:(NSCoder *)aCoder//要一一对应
{
    [aCoder encodeObject:sheng forKey:@"sheng"];
    [aCoder encodeObject:chengshi forKey:@"chengshi"];
    [aCoder encodeObject:dizhi forKey:@"dizhi"];
    [aCoder encodeObject:shouhuoren forKey:@"shouhuoren"];
    [aCoder encodeObject:youbian forKey:@"youbian"];
    [aCoder encodeObject:shouji forKey:@"shouji"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{  
    if (self = [super init]) {
        self.sheng = [aDecoder decodeObjectForKey:@"sheng"];
        self.chengshi = [aDecoder decodeObjectForKey:@"chengshi"];
        self.dizhi = [aDecoder decodeObjectForKey:@"dizhi"];
        self.shouhuoren = [aDecoder decodeObjectForKey:@"shouhuoren"];
        self.youbian = [aDecoder decodeObjectForKey:@"youbian"];
        self.shouji = [aDecoder decodeObjectForKey:@"shouji"];
    }
    return self;
}

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
    NSString *name = [iOSApi urlEncode:key];
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
    NSString *query = [NSString stringWithFormat:@"page=%d", page];
    NSString *action = [NSString stringWithFormat:@"%@/%@?%@", API_URL_EBUY, method, query];
    NSDictionary *map = [Api post:action params:nil];
    if (map) {
        NSMutableArray *data = [map objectForKey:@"push"];
        if (data.count > 0) {
            list = [data toList:EBProductInfo.class];
        }
    }
    
    return list;
}

//--------------------< 电子商城 - 接口 - 分类 >--------------------

// 分类列表接口
+ (NSMutableArray *)ebuy_type:(int)page typeId:(int)typeId{
    NSMutableArray *list = nil;
    // 方法
    static NSString *method = @"type";
    if (page < 1) {
        page = 1;
    }
    NSString *query = [NSString stringWithFormat:@"page=%d&typeid=%d", page, typeId];
    NSString *action = [NSString stringWithFormat:@"%@/%@?%@", API_URL_EBUY, method, query];
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
+ (NSMutableArray *)ebuy_goodslist:(int)page way:(int)way typeId:(int)typeId{
    NSMutableArray *list = nil;
    // 方法
    static NSString *method = @"goodslist";
    if (page < 1) {
        page = 1;
    }
    NSString *query = [NSString stringWithFormat:@"page=%d&typeid=%d&way=%d", page, typeId, way];
    NSString *action = [NSString stringWithFormat:@"%@/%@?%@", API_URL_EBUY, method, query];
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
    if (page < 0) {
        page = 0;
    }
    NSString *query = [NSString stringWithFormat:@"page=%d", page];
    NSString *action = [NSString stringWithFormat:@"%@/%@?%@", API_URL_EBUY, method, query];
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
    NSString *query = [NSString stringWithFormat:@"id=%@", id];
    NSString *action = [NSString stringWithFormat:@"%@/%@?%@", API_URL_EBUY, method, query];
    NSDictionary *map = [Api post:action params:nil];
    if (map) {
        NSDictionary *data = [map objectForKey:@"messagenewinfo"];
        if (data.count > 0) {
            oRet = [data toObject:EBProductInfo.class];
        }
    }
    
    return oRet;
}

// 商品详情
+ (EBProductInfo *)ebuy_goodsinfo:(NSString *)id{
    EBProductInfo *oRet = nil;
    // 方法
    static NSString *method = @"goodsinfo";
    /*NSDictionary *heads = [NSDictionary dictionaryWithObjectsAndKeys:
     @"application/json", @"Content-Type",
     nil];
     */
    NSString *query = [NSString stringWithFormat:@"id=%@", id];
    NSString *action = [NSString stringWithFormat:@"%@/%@?%@", API_URL_EBUY, method, query];
    NSDictionary *map = [Api post:action params:nil];
    if (map) {
        NSDictionary *data = [map objectForKey:method];
        if (data.count > 0) {
            oRet = [data toObject:EBProductInfo.class];
        }
    }
    
    return oRet;
}

//--------------------< 电子商城 - 接口 - 评论 >--------------------

// 商品评论
+ (NSMutableArray *)ebuy_goodscomment:(NSString *)id
                                 page:(int)page {
    NSMutableArray *list = nil;
    // 方法
    static NSString *method = @"goodscomment";
    if (page < 0) {
        page = 0;
    }
    NSString *query = [NSString stringWithFormat:@"page=%d&id=%@", page, id];
    NSString *action = [NSString stringWithFormat:@"%@/%@?%@", API_URL_EBUY, method, query];
    NSDictionary *response = [Api post:action params:nil];
    if (response) {
        NSMutableArray *data = [response objectForKey:method];
        if (data.count > 0) {
            list = [data toList:EBProductComment.class];
        }
    }
    
    return list;
}

// 我的评论列表
+ (NSMutableArray *)ebuy_sdandcomentlist:(int)page {
    NSMutableArray *list = nil;
    // 方法
    static NSString *method = @"sdandcomentlist";
    if (page < 0) {
        page = 0;
    }
    NSString *query = [NSString stringWithFormat:@"page=%d", page];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            API_INTERFACE_TONKEN, @"token",
                            [NSString valueOf:[Api userId]], @"userid",
                            [NSString valueOf:page], @"page",
                            nil];
    NSString *action = [NSString stringWithFormat:@"%@/%@?%@", API_URL_EBUY, method, query];
    NSDictionary *response = [Api post:action params:params];
    if (response) {
        NSMutableArray *data = [response objectForKey:method];
        if (data.count > 0) {
            list = [data toList:EBProductComment.class];
        }
    }
    
    return list;
}

// 添加评论
+ (ApiResult *)ebuy_comment_add:(NSString *)pid // 商品ID
                        content:(NSString *)content // 评论内容
                          grade:(int)grade // 评论等级1、2、3、4、5
                         picUrl:(NSString *)picUrl
                           love:(int)love // 1喜欢, 2一般, 3不喜欢, 4其他
                        orderId:(NSString *)orderId // 订单号
{
    ApiResult *iRet = [ApiResult new];
    // 方法
    static NSString *method = @"addcomment";
    NSString *query = @"";
    NSDictionary *heads = [NSDictionary dictionaryWithObjectsAndKeys:
                           @"application/json", @"Content-Type",
                           nil];
    NSMutableDictionary *jsonDic = [NSMutableDictionary dictionary];
    NSMutableDictionary *request = [NSMutableDictionary dictionary];
    [request setObject:pid forKey:@"id"];
    [request setObject:[iOSApi urlEncode:content] forKey:@"content"];
    [request setObject:[NSString valueOf:grade] forKey:@"grade"];
    [request setObject:[iOSApi urlEncode:picUrl] forKey:@"picurl"];
    [request setObject:[NSString valueOf:love] forKey:@"love"];
    [request setObject:orderId forKey:@"orderid"];
    [jsonDic setObject:request forKey:method];
    
    NSString *params = [jsonDic JSONString];
    
    NSString *action = [NSString stringWithFormat:@"%@/%@?%@", API_URL_EBUY, method, query];
    NSDictionary *response = [Api post:action header:heads body:[params dataUsingEncoding:NSUTF8StringEncoding]];
    NSDictionary *data = [iRet parse:response];
    if (data) {
        //
    }
    return [iRet autorelease];
}

// 查询单个评论, 用户自己查询自己对某个商品的评论
+ (EBProductComment *)ebuy_comment_get:(NSString *)pid
                               orderId:(NSString *)orderId{
    // 方法
    static NSString *method = @"realize";
    NSString *query = [NSString stringWithFormat:@"id=%@", pid];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            API_INTERFACE_TONKEN, @"token",
                            [NSString valueOf:[Api userId]], @"userid",
                            orderId, @"orderid",
                            nil];
    NSString *action = [NSString stringWithFormat:@"%@/%@?%@", API_URL_EBUY, method, query];
    NSDictionary *response = [Api post:action params:params];
    EBProductComment *cRet = nil;
    if (response) {
        NSDictionary *data = [response objectForKey:method];
        if (data.count > 0) {
            cRet = [data toObject:EBProductComment.class];
        }
    }
    
    return cRet;
}

//--------------------< 电子商城 - 接口 - 收件箱 >--------------------
// 发送站内消息
+ (ApiResult *)ebuy_message_new:(NSString *)recvId
                         baseId:(NSString *)baseId
                        content:(NSString *)content{
    ApiResult *iRet = [ApiResult new];
    // 方法
    static NSString *method = @"newmessage";
    NSString *query = @"";
    NSDictionary *heads = [NSDictionary dictionaryWithObjectsAndKeys:
                           @"application/json", @"Content-Type",
                           nil];
    NSMutableDictionary *jsonDic = [NSMutableDictionary dictionary];
    NSMutableDictionary *request = [NSMutableDictionary dictionary];
    [request setObject:recvId forKey:@"recvid"];
    [request setObject:baseId forKey:@"basemessageid"];
    [request setObject:[NSString valueOf:[Api userId]] forKey:@"sendid"];
    [request setObject:[iOSApi urlEncode:content] forKey:@"content"];
    [jsonDic setObject:request forKey:method];
    
    NSString *params = [jsonDic JSONString];
    
    NSString *action = [NSString stringWithFormat:@"%@/%@?%@", API_URL_EBUY, method, query];
    NSDictionary *response = [Api post:action header:heads body:[params dataUsingEncoding:NSUTF8StringEncoding]];
    response = [response objectForKey:@"newmessage"];
    NSDictionary *data = [iRet parse:response];
    if (data) {
        //
    }
    return [iRet autorelease];
}
                                 
// 收件箱
+ (NSMutableArray *)ebuy_message_recv:(int)page{
    NSMutableArray *list = nil;
    // 方法
    static NSString *method = @"messagerecv";
    if (page < 0) {
        page = 0;
    }
    NSString *query = [NSString stringWithFormat:@"page=%d&id=%d", page, [Api userId]];
#if 0
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                        API_INTERFACE_TONKEN, @"token",
                        [NSString valueOf:[Api userId]], @"id",
                        nil];
#endif
    NSString *action = [NSString stringWithFormat:@"%@/%@?%@", API_URL_EBUY, method, query];
    NSDictionary *response = [Api post:action params:nil];
    //if (response == nil) {
        NSString *test = @"{\"messagerecv\":[{\"content\":\"robin%20robin\",\"title\":\"test2\",\"senderid\":1,\"sendname\":\"robin\",\"recevtime\":\"2012-01-11 10:01:15\",\"id\":\"9a6683dc-46ce-4cd0-a2fd-7e6ff1ab2c31\"},{\"content\":\"testtesttest%20test\",\"title\":\"test\",\"senderid\":1,\"sendname\":\"sunny\",\"recevtime\":\"2012-01-11 10:01:15\",\"id\":\"9a6683dc-46ce-4cd0-a2fd-7e6ff1ab2c32\"}]}";
        response = [test objectFromJSONString];
    //}
    if (response) {
        NSMutableArray *data = [response objectForKey:method];
        if (data.count > 0) {
            list = [data toList:EBSiteMessage.class];
        }
    }
    return list;
}

// 发件箱
+ (NSMutableArray *)ebuy_message_send:(int)page{
    NSMutableArray *list = nil;
    // 方法
    static NSString *method = @"messagesend";
    if (page < 0) {
        page = 0;
    }
    NSString *query = [NSString stringWithFormat:@"page=%d&id=%d", page, [Api userId]];
    NSString *action = [NSString stringWithFormat:@"%@/%@?%@", API_URL_EBUY, method, query];
    NSDictionary *response = [Api post:action params:nil];
    if (response) {
        NSMutableArray *data = [response objectForKey:method];
        if (data.count > 0) {
            list = [data toList:EBSiteMessage.class];
        }
    }
    return list;
}

// 站内消息回复
+ (ApiResult *)ebuy_message_reply:(NSString *)cid content:(NSString *)content{
    ApiResult *iRet = [ApiResult new];
    // 方法
    static NSString *method = @"addmessage";
    NSString *query = @"";
    NSDictionary *heads = [NSDictionary dictionaryWithObjectsAndKeys:
                           @"application/json", @"Content-Type",
                           nil];
    NSMutableDictionary *jsonDic = [NSMutableDictionary dictionary];
    NSMutableDictionary *request = [NSMutableDictionary dictionary];
    [request setObject:cid forKey:@"id"];
    [request setObject:[iOSApi urlEncode:content] forKey:@"content"];
    [jsonDic setObject:request forKey:method];
    
    NSString *params = [jsonDic JSONString];
    
    NSString *action = [NSString stringWithFormat:@"%@/%@?%@", API_URL_EBUY, method, query];
    NSDictionary *response = [Api post:action header:heads body:[params dataUsingEncoding:NSUTF8StringEncoding]];
    NSDictionary *data = [iRet parse:response];
    if (data) {
        //
    }
    return [iRet autorelease];
}

//--------------------< 电子商城 - 接口 - 收藏 >--------------------

// 我的收藏
+ (NSMutableArray *)ebuy_collect:(int)page{
    NSMutableArray *list = nil;
    static NSString *method = @"collect";
    NSString *query = [NSString stringWithFormat:@"id=%d&page=%d", [Api userId], page];
    NSString *action = [NSString stringWithFormat:@"%@/%@?%@", API_URL_EBUY, method, query];
    NSDictionary *response = [Api post:action params:nil];
    if (response) {
        NSMutableArray *data = [response objectForKey:method];
        if (data.count > 0) {
            list = [data toList:EBProductInfo.class];
        }
    }
    
    return list;
}

// 添加收藏
+ (ApiResult *)ebuy_collect_add:(NSString *)cid{
    ApiResult *iRet = [ApiResult new];
    // 方法
    static NSString *method = @"addcollect";
    NSString *query = [NSString stringWithFormat:@"id=%@&userid=%d", cid,[Api userId]];
    NSString *action = [NSString stringWithFormat:@"%@/%@?%@", API_URL_EBUY, method, query];
    NSDictionary *response = [Api post:action params:nil];
    NSDictionary *data = [iRet parse:response];
    if (data) {
        //
    }
    return [iRet autorelease];
}

// 删除收藏
+ (ApiResult *)ebuy_collect_delete:(NSString *)cid{
    ApiResult *iRet = [ApiResult new];
    // 方法
    static NSString *method = @"delcollect";
    NSString *query = [NSString stringWithFormat:@"id=%@&userid=%d", cid,[Api userId]];
    NSString *action = [NSString stringWithFormat:@"%@/%@?%@", API_URL_EBUY, method, query];
    NSDictionary *response = [Api post:action params:nil];
    NSDictionary *data = [iRet parse:response];
    if (data) {
        //
    }
    return [iRet autorelease];
}

//--------------------< 电子商城 - 接口 - 订单 >--------------------
// 订单获取接口
+ (NSMutableArray *)ebuy_order_list:(int)userId
                               type:(int)type
                               page:(int)page{
    NSMutableArray *list = nil;
    static NSString *method = @"orderlist";
    NSString *query = [NSString stringWithFormat:@"id=%d", [Api userId]];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            API_INTERFACE_TONKEN, @"token",
                            [NSString valueOf:[Api userId]], @"userId",
                            [NSString valueOf:type], @"type",
                            [NSString valueOf:page], @"page",
                            nil];
    NSString *action = [NSString stringWithFormat:@"%@/%@?%@", API_URL_EBUY, method, query];
    NSDictionary *response = [Api post:action params:params];
    if (response) {
        NSMutableArray *data = [response objectForKey:method];
        if (data.count > 0) {
            list = [data toList:EBOrder.class];
        }
    }
    
    return list;
}

// 订单详情
+ (EBOrderInfo *)ebuy_order_get:(NSString *)orderId{
    EBOrderInfo *iRet = nil;
    static NSString *method = @"orderinfo";
    NSString *query = [NSString stringWithFormat:@"id=%d", [Api userId]];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            API_INTERFACE_TONKEN, @"token",
                            [NSString valueOf:[Api userId]], @"userId",
                            orderId, @"orderid",
                            nil];
    NSString *action = [NSString stringWithFormat:@"%@/%@?%@", API_URL_EBUY, method, query];
    NSDictionary *response = [Api post:action params:params];
    if (response) {
        NSDictionary *data = [response objectForKey:method];
        if (data.count > 0) {
            iRet = [data toObject:EBOrderInfo.class];
        }
    }
    
    return iRet;
}
/*
// 订购
+ (ApiResult *)ebuy_order:(EBOrderInfo *)info{
    ApiResult *iRet = [ApiResult new];
    // 方法
    static NSString *method = @"order";
    NSString *query = [NSString stringWithFormat:@"id=%@", cid];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            API_INTERFACE_TONKEN, @"token",
                            [NSString valueOf:[Api userId]], @"userId",
                            nil];
    NSString *action = [NSString stringWithFormat:@"%@/%@?%@", API_URL_EBUY, method, query];
    NSDictionary *response = [Api post:action params:params];
    NSDictionary *data = [iRet parse:response];
    if (data) {
        //
    }
    return [iRet autorelease];
}
*/

//--------------------< 电子商城 - 接口 - 商铺 >--------------------
+ (NSMutableArray *)ebuy_shoplist:(int)page{
    NSMutableArray *list = nil;
    static NSString *method = @"shoplist";
    NSString *query = [NSString stringWithFormat:@"page=%d", page];
    /*
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            API_INTERFACE_TONKEN, @"token",
                            [NSString valueOf:[Api userId]], @"userId",
                            [NSString valueOf:page], @"page",
                            nil];
    */
    NSString *action = [NSString stringWithFormat:@"%@/%@?%@", API_URL_EBUY, method, query];
    NSDictionary *response = [Api post:action params:nil];
    if (response) {
        NSMutableArray *data = [response objectForKey:method];
        if (data.count > 0) {
            list = [data toList:EBShop.class];
        }
    }
    
    return list;
}

//--------------------< 电子商城 - 接口 - 购物车 >--------------------
// 购物车
static NSMutableDictionary *s_buycar = nil;
static NSString *s_carFilename = @"cache/files/fengzi_buycar.db";

// 购物车列表
+ (NSMutableDictionary *)ebuy_car_list{
    NSString *filename = [iOSFile path:s_carFilename];
    iOSLog(@"buycar=[%@]", filename);
    if (s_buycar == nil) {
        NSData *data = [NSData dataWithContentsOfFile:filename];
        s_buycar = [[NSMutableDictionary alloc] initWithDictionary:[NSKeyedUnarchiver unarchiveObjectWithData:data]];
    }
    if (s_buycar == nil) {
        s_buycar = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    return s_buycar;
}

// 放入购物车
+ (BOOL)ebuy_car_add:(EBProductInfo *)obj{
    BOOL bRet = NO;
    NSString *filename = [iOSFile path:s_carFilename];
    NSString *shopName = [obj.shopName copy];
    s_buycar = [self ebuy_car_list];
    NSMutableArray *list = [s_buycar objectForKey:shopName];
    if (list == nil) {
        list = [NSMutableArray arrayWithCapacity:0];
    }
    [list addObject:obj];
    [s_buycar setObject:list forKey:shopName];
    iOSLog(@"buycar=[%@]", filename);
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:s_buycar];
    bRet = [data writeToFile:filename atomically:YES];
    return bRet;
}

//--------------------< 电子商城 - 接口 - 地址簿 >--------------------
// 地址簿
static NSMutableArray *s_addressbook = nil;
static NSString *s_abFilename = @"cache/files/fengzi_addressbook.db";

// 地址簿列表
+ (NSMutableArray *)ebuy_address_list{
    NSString *filename = [iOSFile path:s_abFilename];
    iOSLog(@"addressbook=[%@]", filename);
    if (s_addressbook == nil) {
        NSData *data = [NSData dataWithContentsOfFile:filename];
        s_addressbook = [[NSMutableArray alloc] initWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:data]];
    }
    if (s_addressbook == nil) {
        s_addressbook = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return s_addressbook;
}

// 添加地址簿
+ (BOOL)ebuy_address_add:(EBAddress *)obj{
    BOOL bRet = NO;
    NSString *filename = [iOSFile path:s_abFilename];
    s_addressbook = [self ebuy_address_list];
    
    [s_addressbook addObject:obj];
    iOSLog(@"addressbook=[%@]", filename);
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:s_addressbook];
    bRet = [data writeToFile:filename atomically:YES];
    return bRet;
}

// 删除地址
+ (BOOL)ebuy_addess_del:(int)index{
    BOOL bRet = NO;
    NSString *filename = [iOSFile path:s_abFilename];
    s_addressbook = [self ebuy_address_list];
    
    [s_addressbook removeObjectAtIndex:index];
    iOSLog(@"addressbook=[%@]", filename);
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:s_addressbook];
    bRet = [data writeToFile:filename atomically:YES];
    return bRet;
}

@end
