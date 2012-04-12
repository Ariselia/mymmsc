//
//  Api+Ebuy.h
//  FengZi
//
//  Created by wangfeng on 12-1-29.
//  Copyright (c) 2012年 iTotemStudio. All rights reserved.
//

/**
 * 电子商城接口
 */
#import "Api.h"

//====================================< 电子商城 - 常量定义 >====================================
#define API_EBUY_SCROLL_IMGCOUNT (3)
#define API_EBUY_SCROLL_IMGWIDTH (48.0f)

//====================================< 电子商城 - 对象定义 >====================================

//--------------------< 电子商城 - 对象 - 商品 >--------------------
@interface EBProductInfo : NSObject {
    NSString *id;          // 商品编号
    NSString *title;       // 商品名称
    NSString *content;     // 商品介绍
    NSString *picUrl;      // 商品图片,商品的缩略图,多个商品图片用*分开 (Encode)
    float     price;       // 商品价格
    NSString *realizeTime; // 快报资讯发送的时间, 仅快讯详细信息有此字段
}
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *title, *content, *picUrl;
@property (nonatomic, assign) float price;
@property (nonatomic, assign) int shopId;
@property (nonatomic, copy) NSString *shopName;

@property (nonatomic, copy) NSString *realizeTime;

@property (nonatomic, assign) int storeInfo; //库存信息，如 10、100，表示目前库存10件商品
@property (nonatomic, assign) int Goodcommentcount;//好评数
@property (nonatomic, assign) int Middlecommentcount;// 中评数
@property (nonatomic, assign) int Poorcommentcount;//差评数
@property (nonatomic, assign) int Experiencecount;//评价数
@property (nonatomic, copy) NSString *orderId; //商品编号 (Encode)
@property (nonatomic, copy) NSString *info;//商品介绍 (Encode)
@property (nonatomic, copy) NSString *parameters;//规格参数 (Encode)
@property (nonatomic, copy) NSString *listInfo;//包装清单 (Encode)
@property (nonatomic, copy) NSString *service;//售后服务 (Encode)

@end

//--------------------< 电子商城 - 对象 - 商品分类 >--------------------
@interface EBProductType : NSObject {
@private
    int typeId;         // 商品类型ID
    int child;          // 是否有子分类
    NSString *typeName; // 商品类型名称
}

@property (nonatomic, assign) int typeId, child;
@property (nonatomic, copy) NSString *typeName;

@end

//--------------------< 电子商城 - 对象 - 快讯类型 >--------------------
@interface EBExpressType : NSObject {
@private
    NSString *id;
    NSString *title;
    NSString *content;
}

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *title, *content;

@end

//--------------------< 电子商城 - 对象 - 商品评论 >--------------------

@interface EBProductComment : NSObject{
    //
}
@property (nonatomic, copy) NSString *id; // 该评论的id
@property (nonatomic, copy) NSString *userName; //用户昵称 (encode)
@property (nonatomic, copy) NSString *content; // 评论的内容 (encode)
@property (nonatomic, copy) NSString *picUrl; // 图片url (encode)
@property (nonatomic, copy) NSString *commentTime;// 评论的时间

@end

//--------------------< 电子商城 - 对象 - 站内消息 >--------------------

@interface EBSiteMessage : NSObject{
    //
}
@property (nonatomic, copy) NSString *id; // 信息ID
@property (nonatomic, assign) int senderId; // 系统id定义为0，其它为商家
@property (nonatomic, copy) NSString *sendName; // 发件人 (Encode)
@property (nonatomic, copy) NSString *title; // 站内信的信息标题 (Encode)
@property (nonatomic, copy) NSString *content; // 站内信信息内容 (Encode)
@property (nonatomic, copy) NSString *recevTime; // 收信时间

@end

//--------------------< 电子商城 - 对象 - 订单 - 基本信息 >--------------------
@interface EBOrder : ApiResult{
    //
}
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *ordered;
@property (nonatomic, assign) float price;
@property (nonatomic, copy) NSString *orderTime;
@property (nonatomic, assign) int state;
@end

//--------------------< 电子商城 - 对象 - 订单 - 用户信息 >--------------------
@interface EBOrderUser : NSObject{
    //
}
@property (nonatomic, assign) int userId; // 用户ID
@property (nonatomic, copy) NSString *orderId; // 订单编号
@property (nonatomic, assign) int goodsCount; // 订单商品总数
@property (nonatomic, assign) int state; // 订单状态
@property (nonatomic, copy) NSString *payment;
@property (nonatomic, copy) NSString *type; // 01-货到付款
@property (nonatomic, copy) NSString *receiver; // 收件人
@property (nonatomic, copy) NSString *address; // 地址
@property (nonatomic, copy) NSString *areaCode; // 邮编
@property (nonatomic, copy) NSString *mobile; // 电话
@property (nonatomic, copy) NSString *shopId;
@property (nonatomic, copy) NSString *shopName;
@end

//--------------------< 电子商城 - 对象 - 订单 - 商品信息 >--------------------

#define EBUY_ORDER_FINISHED (0) // 完成
#define EBUY_ORDER_PROCESS  (1) // 处理中
#define EBUY_ORDER_DISPATCH (2) // 派发途中
#define EBUY_ORDER_CONFIRM  (3) // 等待用户确认

@interface EBOrderProduct : NSObject{
    //
}
@property (nonatomic, copy) NSString *name; // 商品名称
@property (nonatomic, copy) NSString *id; // 商品ID
@property (nonatomic, copy) NSString *picUrl;
@property (nonatomic, assign) float price; // 价格
//@property (nonatomic, copy) NSString *orderTime; // 订单时间
//@property (nonatomic, assign) int state; // 订单状态
@property (nonatomic, assign) int totalCount; // 商品数量单位

@end

//--------------------< 电子商城 - 对象 - 订单详情 >--------------------
@interface EBOrderInfo : NSObject{
    //
}
@property (nonatomic, retain) EBOrderUser *userInfo;
@property (nonatomic, retain) NSMutableArray *products;
@end

//--------------------< 电子商城 - 对象 - 商铺详情 >--------------------
@interface EBShop : NSObject{
    //
}
@property (nonatomic, assign) int itemGroupType;
@property (nonatomic, copy) NSString *picUrl;
@property (nonatomic, copy) NSString *des;
@property (nonatomic, assign) int id;
@property (nonatomic, copy) NSString *name;

@end


//====================================< 电子商城 - 接口 >====================================

@interface Api (Ebuy)

// 商品模糊搜索
+ (NSMutableArray *)ebuy_search:(NSString *)key;

// 商品推荐接口
+ (NSMutableArray *)ebuy_push:(int)page;

// 分类列表接口 typeId=0为全部分类
+ (NSMutableArray *)ebuy_type:(int)page typeId:(int)typeId;

// 获取商品列表
+ (NSMutableArray *)ebuy_goodslist:(int)page way:(int)way typeId:(int)typeId;

// 快报资讯推荐接口
+ (NSMutableArray *)ebuy_new:(int)page;

// 快报资讯详情接口
+ (EBProductInfo *)ebuy_messagenewinfo:(NSString *)id;

// 商品详情
+ (EBProductInfo *)ebuy_goodsinfo:(NSString *)id;

//--------------------< 电子商城 - 接口 - 评论 >--------------------
// 商品评论
+ (NSMutableArray *)ebuy_goodscomment:(NSString *)id page:(int)page;

// 我的评论列表
+ (NSMutableArray *)ebuy_sdandcomentlist:(int)page;
// 添加评论
+ (ApiResult *)ebuy_comment_add:(NSString *)pid // 商品ID
                        content:(NSString *)content // 评论内容
                          grade:(int)grade // 评论等级1、2、3、4、5
                         picUrl:(NSString *)picUrl
                           love:(int)love // 1喜欢, 2一般, 3不喜欢, 4其他
                        orderId:(NSString *)orderId; // 订单号

// 查询单个评论, 用户自己查询自己对某个商品的评论
+ (EBProductComment *)ebuy_comment_get:(NSString *)pid
                               orderId:(NSString *)orderId;

//--------------------< 电子商城 - 接口 - 站内消息 >--------------------

// 发送站内消息
+ (ApiResult *)ebuy_message_new:(NSString *)recvId
                         baseId:(NSString *)baseId
                        content:(NSString *)content;
// 收件箱
+ (NSMutableArray *)ebuy_message_recv:(int)page;
// 发件箱
+ (NSMutableArray *)ebuy_message_send:(int)page;

// 站内消息回复
+ (ApiResult *)ebuy_message_reply:(NSString *)cid content:(NSString *)content;

//--------------------< 电子商城 - 接口 - 收藏 >--------------------

// 我的收藏
+ (NSMutableArray *)ebuy_collect:(int)userId
                            page:(int)page;
// 添加收藏
+ (ApiResult *)ebuy_collect_add:(NSString *)cid;
// 删除收藏
+ (ApiResult *)ebuy_collect_delete:(NSString *)cid;

//--------------------< 电子商城 - 接口 - 订单 >--------------------

// 订单获取接口
+ (NSMutableArray *)ebuy_order_list:(int)userId
                               type:(int)type
                               page:(int)page;

// 订单详情
+ (EBOrderInfo *)ebuy_order_get:(NSString *)orderId;

//--------------------< 电子商城 - 接口 - 商铺列表 >--------------------
+ (NSMutableArray *)ebuy_shoplist:(int)page;

@end
