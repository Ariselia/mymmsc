//
//  Api+eBuy.m
//  FengZi
//
//  Created by wangfeng on 12-1-29.
//  Copyright (c) 2012年 iTotemStudio. All rights reserved.
//

#import "Api+eBuy.h"

//====================================< 电子商城 - 对象定义 >====================================

//--------------------< 电子商城 - 对象 - 首页广告条 >--------------------
@implementation EBAd_OLD

@synthesize mainadpic, mainadurl;
@synthesize adpic1, adpic2, adpic3, adpic4, adpic5;
@synthesize adurl1, adurl2, adurl3, adurl4, adurl5;

@end

@implementation EBAd

@synthesize pic = _pic, url = _url, image = _image;

@end

//--------------------< 电子商城 - 对象 - 商品 >--------------------
@implementation EBProductInfo

@synthesize id, title, content, picUrl, price, shopId, shopName,carCount;
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
    [aCoder encodeInt:carCount forKey:@"carCount"];
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
        self.carCount = [aDecoder decodeIntForKey:@"carCount"];
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

@synthesize id,state,orderId,userName,content,picUrl,commentTime,love,grade,realizeTime;

@end

//--------------------< 电子商城 - 对象 - 站内消息 >--------------------
@implementation EBSiteMessage

@synthesize id,senderId,sendName,recvName,title,content,recevTime,sendTime;

@end

//--------------------< 电子商城 - 对象 - 订单 >--------------------
// 商品当前所处物流状态
static const char *kOrderState[] = {"", "发货", "收货", "确认", "退货"};

//支付类型
static const char *kPayWay[] = {"支付宝客户端支付", "支付宝wap支付", "移动支付", "快钱支付"};
//paystatus	支付状态：0x01：已支付，0x11：未支付

@implementation EBOrder
@synthesize id,ordered,orderTime,price,state;
@end

@implementation EBOrderUser

@synthesize type,state,mobile,shopId,userId,address,orderId,payment,areaCode,receiver,shopName,goodsCount, payWay, payStatus, actionSource;
@synthesize logicName, logicId, logicDt, servicNo;

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

//--------------------< 电子商城 - 接口 - 首页广告条 >--------------------
// 广告列表
+ (NSMutableArray *)ebuy_ad_list{
    //http://220.231.48.34:38090/ebuy/fx/sysad
    NSMutableArray *list = nil;
    // 方法名
    static NSString *method = @"sysad";
    NSString *action = [NSString stringWithFormat:@"%@/%@", API_URL_EBUY "/fx", method];
    NSDictionary *map = [Api post:action params:nil];
    if (map) {
        NSDictionary *data = [map objectForKey:method];
        // 有主广告
        if (data.count > 1) {
            list = [[NSMutableArray alloc] initWithCapacity:0];
            EBAd *ad = [[[EBAd alloc] init] autorelease];
            ad.pic = [data objectForKey:@"mainadpic"];
            ad.url = [data objectForKey:@"mainadurl"];
            [list addObject:ad];
        }
        for (int i = 1; i <= (data.count - 2)/2; i++) {
            EBAd *ad = [[[EBAd alloc] init] autorelease];
            NSString *kPic = [NSString stringWithFormat:@"adpic%d", i];
            NSString *kUrl = [NSString stringWithFormat:@"adurl%d", i];
            ad.pic = [data objectForKey:kPic];
            ad.url = [data objectForKey:kUrl];
            [list addObject:ad];
        }
    }
    
    return [list autorelease];
}

//--------------------< 电子商城 - 接口 - 首页搜索 >--------------------
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
    
    NSString *action = [NSString stringWithFormat:@"%@/%@", API_URL_EBUY "/fx", method];
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
    NSString *action = [NSString stringWithFormat:@"%@/%@?%@", API_URL_EBUY "/fx", method, query];
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
+ (NSMutableArray *)ebuy_type:(int)page typeId:(NSString *)typeId{
    NSMutableArray *list = nil;
    // 方法
    static NSString *method = @"type";
    if (page < 1) {
        page = 1;
    }
    NSString *query = [NSString stringWithFormat:@"page=%d&typeid=%@", page, typeId];
    NSString *action = [NSString stringWithFormat:@"%@/%@?%@", API_URL_EBUY "/fx", method, query];
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
+ (NSMutableArray *)ebuy_goodslist:(int)page way:(int)way typeId:(NSString *)typeId{
    NSMutableArray *list = nil;
    // 方法
    static NSString *method = @"goodslist";
    if (page < 1) {
        page = 1;
    }
    NSString *query = [NSString stringWithFormat:@"page=%d&typeid=%@&way=%d", page, typeId, way];
    NSString *action = [NSString stringWithFormat:@"%@/%@?%@", API_URL_EBUY "/fx", method, query];
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
    NSString *action = [NSString stringWithFormat:@"%@/%@?%@", API_URL_EBUY "/fx", method, query];
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
    NSString *action = [NSString stringWithFormat:@"%@/%@?%@", API_URL_EBUY "/fx", method, query];
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
    NSString *action = [NSString stringWithFormat:@"%@/%@?%@", API_URL_EBUY "/fx", method, query];
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
    NSString *action = [NSString stringWithFormat:@"%@/%@?%@", API_URL_EBUY "/fx", method, query];
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
    NSString *query = [NSString stringWithFormat:@"page=%d&userid=%d", page, [Api userId]];
    NSString *action = [NSString stringWithFormat:@"%@/%@?%@", API_URL_EBUY "/fx", method, query];
    NSDictionary *response = [Api post:action params:nil];
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
    if (love < 1) {
        love = 1;
    } else if (love > 3) {
        love = 3;
    }
    if (grade < 1) {
        grade = 1;
    } else if (grade > 5) {
        grade = 5;
    }
    if (picUrl == nil) {
        picUrl = @"";
    }
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
    
    NSString *action = [NSString stringWithFormat:@"%@/%@?%@", API_URL_EBUY "/fx", method, query];
    NSDictionary *response = [Api post:action header:heads body:[params dataUsingEncoding:NSUTF8StringEncoding]];
    NSDictionary *data = [response objectForKey:method];
    if (data == nil) {
        // 没有method标签
        data = response;
    }
    if (data.count > 0) {
        NSNumber *v = [data objectForKey:@"status"];
        if ([v isKindOfClass:NSNumber.class]) {
            iRet.status = v.intValue;
        }
        if (iRet.status != 0) {
            iRet.message = @"提交失败";
        } else {
            iRet.message = @"提交成功";
        }
    }
    return [iRet autorelease];
}

// 查询单个评论, 用户自己查询自己对某个商品的评论
+ (EBProductComment *)ebuy_comment_get:(NSString *)pid
                               orderId:(NSString *)orderId{
    // 方法
    static NSString *method = @"realize";
    NSString *query = [NSString stringWithFormat:@"id=%@&orderid=%@&userid=%d", pid, orderId, [Api userId]];
    NSString *action = [NSString stringWithFormat:@"%@/%@?%@", API_URL_EBUY "/fx", method, query];
    NSDictionary *response = [Api post:action params:nil];
    EBProductComment *cRet = nil;
    if (response) {
        NSDictionary *data = [response objectForKey:method];
        if (data.count > 0) {
            cRet = [data toObject:EBProductComment.class];
        }
    }
    
    return cRet;
}

// 评论上传图片
+ (NSString *)ebuy_commentpic_upload:(NSData *)buffer{
    NSString *sRet = nil;
    static NSString *action = API_URL_EBUY "/fx/file/pic";
    [iOSApi showAlert:@"正在上传图片"];
    HttpClient *hc = [[HttpClient alloc] initWithURL:action timeout:10];
    //NSString *filename = [NSString stringWithFormat:@"%d.jpg", [Api userId]];
    //[hc formAddImage:@"image" filename:filename data:buffer];
    //[hc formAddField:@"token" value:API_INTERFACE_TONKEN];
    //[hc formAddField:@"filename" value:filename];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"image/png", @"Content-Type",
                            nil];
    NSData *response = [hc post:params body:buffer];
    [iOSApi closeAlert];
    if (response == nil) {
        [iOSApi showCompleted:@"服务器正忙，请稍候重新登录。"];
    } else {
        // 取得JSON数据的字符串
        NSString *json_string = [[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding] autorelease];
        iOSLog(@"json.string = %@", json_string);
        if ([json_string hasPrefix:@"http://"]) {
            sRet = [json_string copy];
            [json_string release];
            [iOSApi showCompleted:@"上传成功"];
        } else {
            [iOSApi showCompleted:@"上传失败"];
        }
    }
    [hc release];
    [iOSApi closeAlert];
    
    return sRet;
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
    
    NSString *action = [NSString stringWithFormat:@"%@/%@?%@", API_URL_EBUY "/fx", method, query];
    NSDictionary *response = [Api post:action header:heads body:[params dataUsingEncoding:NSUTF8StringEncoding]];
    response = [response objectForKey:@"newmessage"];
    if (response) {
        NSDictionary *data = [response objectForKey:method];
        [iRet parse:data];
        if (iRet.status != API_SUCCESS) {
            iRet.message = @"发送失败";
        } else {
            iRet.message = @"发送成功";
        }
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
    NSString *action = [NSString stringWithFormat:@"%@/%@?%@", API_URL_EBUY "/fx", method, query];
    NSDictionary *response = [Api post:action params:nil];
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
    NSString *action = [NSString stringWithFormat:@"%@/%@?%@", API_URL_EBUY "/fx", method, query];
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
    
    NSString *action = [NSString stringWithFormat:@"%@/%@?%@", API_URL_EBUY "/fx", method, query];
    NSDictionary *response = [Api post:action header:heads body:[params dataUsingEncoding:NSUTF8StringEncoding]];
    if (response) {
        NSDictionary *data = [response objectForKey:method];
        [iRet parse:data];
    }
    return [iRet autorelease];
}

//--------------------< 电子商城 - 接口 - 收藏 >--------------------

// 我的收藏
+ (NSMutableArray *)ebuy_collect:(int)page{
    NSMutableArray *list = nil;
    static NSString *method = @"collect";
    NSString *query = [NSString stringWithFormat:@"id=%d&page=%d", [Api userId], page];
    NSString *action = [NSString stringWithFormat:@"%@/%@?%@", API_URL_EBUY "/fx", method, query];
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
    NSString *action = [NSString stringWithFormat:@"%@/%@?%@", API_URL_EBUY "/fx", method, query];
    NSDictionary *response = [Api post:action params:nil];
    if (response.count > 0) {
        NSDictionary *data = [response objectForKey:method];
        [iRet parse:data];
        if(iRet.status < 0) {
            iRet.message = @"商品不可以重复收藏";
        }
    }
    return [iRet autorelease];
}

// 删除收藏
+ (ApiResult *)ebuy_collect_delete:(NSString *)cid{
    ApiResult *iRet = [ApiResult new];
    // 方法
    static NSString *method = @"delcollect";
    NSString *query = [NSString stringWithFormat:@"id=%@&userid=%d", cid,[Api userId]];
    NSString *action = [NSString stringWithFormat:@"%@/%@?%@", API_URL_EBUY "/fx", method, query];
    NSDictionary *response = [Api post:action params:nil];
    if (response.count > 0) {
        NSDictionary *data = [response objectForKey:method];
        [iRet parse:data];
    }
    return [iRet autorelease];
}

//--------------------< 电子商城 - 接口 - 订单 >--------------------

// 订单状态
+ (NSString *)ebuy_state_order:(int)state{
    // 计算订单状态数组的长度
    int c = sizeof(kOrderState) / sizeof(kOrderState[0]);
    int s = state >> 4;
    int t = state & 0x0f;
    NSString *prefix = @"未";
    if (s == 1) {
        prefix = @"已";
    }
    NSString *sRet = @"状态未知";
    if (t >= 0 && t < c) {
        sRet = [NSString stringWithFormat:@"%@%@", prefix, [NSString stringWithCString:kOrderState[t] encoding:NSUTF8StringEncoding]];
    }
    return sRet;
}

// 支付类型
+ (NSString *)ebuy_pay_type:(int)type{
    // 计算支付类型数组的长度
    int c = sizeof(kPayWay) / sizeof(kPayWay[0]);
    NSString *sRet = @"货到付款";
    if (type >= 0 && type < c) {
        sRet = [NSString stringWithCString:kPayWay[type] encoding:NSUTF8StringEncoding];
    }
    return sRet;
}

// 订单获取接口
+ (NSMutableArray *)ebuy_order_list:(int)type
                               page:(int)page{
    NSMutableArray *list = nil;
    static NSString *method = @"orderlist";
    NSString *query = [NSString stringWithFormat:@"id=%d&type=%d&page=%d", [Api userId],type,page];
    NSString *action = [NSString stringWithFormat:@"%@/%@?%@", API_URL_EBUY "/fx", method, query];
    NSDictionary *response = [Api post:action params:nil];
    if (response) {
        NSMutableArray *data = [response objectForKey:method];
        if ([data isKindOfClass:NSMutableArray.class] && data.count > 0) {
            list = [data toList:EBOrder.class];
        }
    }
    
    return list;
}

// 订单详情
+ (EBOrderInfo *)ebuy_order_get:(NSString *)orderId{
    EBOrderInfo *iRet = nil;
    static NSString *method = @"orderinfo";
    NSString *query = [NSString stringWithFormat:@"orderid=%@", orderId];
    NSString *action = [NSString stringWithFormat:@"%@/%@?%@", API_URL_EBUY "/fx", method, query];
    NSDictionary *response = [Api post:action params:nil];
    if (response) {
        NSDictionary *data = [response objectForKey:method];
        if ([data isKindOfClass:NSDictionary.class] && data.count > 0) {
            iRet = [[EBOrderInfo alloc] init];
            NSDictionary *head = [data objectForKey:@"orderhead"];
            EBOrderUser *oHead = [head toObject:EBOrderUser.class];
            iRet.userInfo = oHead;
            NSArray *body = [data objectForKey:@"orderbody"];
            NSMutableArray *oBody = [body toList:EBOrderProduct.class];
            iRet.products = oBody;
        }
    }
    return iRet;
}

// 订购
+ (ApiResult *)ebuy_order:(EBOrderInfo *)info{
    ApiResult *iRet = [ApiResult new];
    // 方法
    static NSString *method = @"order";
    NSString *query = @"";
    NSDictionary *heads = [NSDictionary dictionaryWithObjectsAndKeys:
                           @"application/json", @"Content-Type",
                           nil];
    NSMutableDictionary *jsonDic = [NSMutableDictionary dictionary];
    NSMutableDictionary *request = [NSMutableDictionary dictionary];
    // 订单头信息
    NSMutableDictionary *orderhead = [NSMutableDictionary dictionary];
    EBOrderUser *user = info.userInfo;
    //{"userid":"001","type":"01","address":"北京朝阳区","receiver":"孙超","mobile":"12345678901","areacode":"100010","orderid":"OD20120115000003","state":0,"goodscount":10}
    NSNumber *mobile = [NSNumber numberWithLongLong:user.mobile];
    NSNumber *areaCode = [NSNumber numberWithInt:user.areaCode];
    [orderhead setObject:[NSString valueOf:user.userId] forKey:@"userid"];
    [orderhead setObject:info.userInfo.type forKey:@"type"];
    [orderhead setObject:user.address forKey:@"address"];
    [orderhead setObject:user.receiver forKey:@"receiver"];
    [orderhead setObject:mobile forKey:@"mobile"];;
    [orderhead setObject:areaCode forKey:@"areacode"];
    [orderhead setObject:user.orderId forKey:@"orderid"];
    [orderhead setObject:[NSString valueOf:user.state] forKey:@"state"];
    [orderhead setObject:[NSString valueOf:user.goodsCount] forKey:@"goodscount"];
    [orderhead setObject:@"ios" forKey:@"actionsource"];
    
    [request setObject:orderhead forKey:@"orderhead"];
    
    // 订单消息体
    NSMutableArray *orderbody = [NSMutableArray array];
    //{"id":"8ae40e1a-73fb-469a-8123-dcd973bf6264","name":"内衣","totalcount":"1","price":"10.00"}
    for (EBOrderProduct *obj in info.products) {
        NSMutableDictionary *product = [NSMutableDictionary dictionary];
        [product setObject:obj.id forKey:@"id"];
        [product setObject:obj.name forKey:@"name"];
        [product setObject:[NSString valueOf:obj.totalCount] forKey:@"totalcount"];
        [product setObject:[NSString stringWithFormat:@"%.2f", obj.price] forKey:@"price"];
        [orderbody addObject:product];
    }
    [request setObject:orderbody forKey:@"orderbody"];
    
    [jsonDic setObject:request forKey:method];
    
    NSString *params = [jsonDic JSONString];
    
    NSString *action = [NSString stringWithFormat:@"%@/%@?%@", API_URL_EBUY "/fx", method, query];
    NSDictionary *response = [Api post:action header:heads body:[params dataUsingEncoding:NSUTF8StringEncoding]];
    NSDictionary *data = [iRet parse:response];
    if (data == nil) {
        data = [response objectForKey:@"Response"];
    }
    if (data) {
        NSNumber *state = [data objectForKey:@"status"];
        iRet.status = state.intValue;
        NSString *msg = [data objectForKey:@"status_code"];
        if (msg != nil) {
            iRet.message = msg;
            if ([msg hasPrefix:@"Duplicate"]) {
                iRet.message = @"重复订购";
            }/* else {
                iRet.message = @"订购失败";
            }*/
        } else {
            if (iRet.status == 0) {
                iRet.message = @"订购成功";
            }else {
                iRet.message = @"订购失败";
            }
        }        
    }
    return [iRet autorelease];
}

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
    NSString *action = [NSString stringWithFormat:@"%@/%@?%@", API_URL_EBUY "/fx", method, query];
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
    if (obj.carCount < 1) {
        obj.carCount = 1;
    }
    BOOL bFound = NO;
    int nIndex = -1;
    for (int i = 0; i < list.count; i++) {
        EBProductInfo *t = [list objectAtIndex:i];
        if ([t.id isEqualToString:obj.id]) {
            bFound = YES;
            nIndex = i;
            obj.carCount = t.carCount + 1;
        }
    }
    if (bFound) {
        [list replaceObjectAtIndex:nIndex withObject:obj];
    } else {
        obj.carCount = 1;
        [list addObject:obj];
    }
    
    [s_buycar setObject:list forKey:shopName];
    iOSLog(@"buycar=[%@]", filename);
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:s_buycar];
    bRet = [data writeToFile:filename atomically:YES];
    return bRet;
}

// 购物车 删除商品
+ (BOOL)ebuy_car_delete:(EBProductInfo *)obj{
    BOOL bRet = NO;
    NSString *filename = [iOSFile path:s_carFilename];
    NSString *shopName = [obj.shopName copy];
    s_buycar = [self ebuy_car_list];
    [s_buycar removeObjectForKey:shopName];
    iOSLog(@"buycar=[%@]", filename);
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:s_buycar];
    bRet = [data writeToFile:filename atomically:YES];
    return bRet;
}

+ (BOOL)ebuy_car_delete:(NSString *)shopName index:(int)index{
    BOOL bRet = NO;
    NSString *filename = [iOSFile path:s_carFilename];
    s_buycar = [self ebuy_car_list];
    NSMutableArray *list = [s_buycar objectForKey:shopName];
    if (list == nil) {
        list = [NSMutableArray arrayWithCapacity:0];
    }
    if (list.count > index) {
        [list removeObjectAtIndex:index];
        if (list.count == 0) {
            [s_buycar removeObjectForKey:shopName];
        } else {
            [s_buycar setObject:list forKey:shopName];
        }
    }
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
+ (BOOL)ebuy_address_set:(EBAddress *)obj index:(int)index{
    BOOL bRet = NO;
    NSString *filename = [iOSFile path:s_abFilename];
    s_addressbook = [self ebuy_address_list];
    if (index < 0 || index >= s_addressbook.count) {
        [s_addressbook addObject:obj];
    } else {
        [s_addressbook replaceObjectAtIndex:index withObject:obj];
    }
    
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
