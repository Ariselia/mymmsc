//
//  Api+eBuy.h
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

//商品当前所处物流状态
typedef enum EBOrderState{
    kOrderStateNotShipped   = 0x01, // 未发货
    kOrderStateShipped      = 0x11, // 已发货
    kOrderStateNotReceiving = 0x02, // 未收货
    kOrderStateReceiving    = 0x12, // 已收货
    kOrderStateNotConfirm   = 0x03, // 未确认
    kOrderStateConfirm      = 0x13, // 已确认
    kOrderStateNotReturn    = 0x04, // 未退货
    kOrderStateReturn       = 0x14  // 已退货
}EBOrderState;

// 支付类型
typedef enum EBPayWay {
    kPayWayAlipay = 0x0, // 支付宝客户端支付
    kPayWayAliWap = 0x1, // 支付宝wap支付
    kPayWayMobile = 0x2, // 移动支付
    kPayWayQuick  = 0x3  // 快钱支付
}EBPayWay;

// 支付状态
typedef enum EBPayStatus {
    kPayStatusYes = 0x01, // 已支付
    kPayStatusNo  = 0x11  // 未支付
} EBPayStatus;
//====================================< 电子商城 - 对象定义 >====================================

//--------------------< 电子商城 - 对象 - 首页广告条 >--------------------

// 广告接口
@interface EBAd_OLD : NSObject{
    //
}
@property (nonatomic, copy) NSString *mainadpic;
@property (nonatomic, copy) NSString *mainadurl;
@property (nonatomic, copy) NSString *adpic1;
@property (nonatomic, copy) NSString *adpic2;
@property (nonatomic, copy) NSString *adpic3;
@property (nonatomic, copy) NSString *adpic4;
@property (nonatomic, copy) NSString *adpic5;
@property (nonatomic, copy) NSString *adurl1;
@property (nonatomic, copy) NSString *adurl2;
@property (nonatomic, copy) NSString *adurl3;
@property (nonatomic, copy) NSString *adurl4;
@property (nonatomic, copy) NSString *adurl5;

@end

@interface EBAd : NSObject{
    NSString *_pic;
    NSString *_url;
    UIImage  *_image;
}
@property (nonatomic, copy) NSString *pic;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, retain) UIImage *image;

@end

//--------------------< 电子商城 - 对象 - 商品 >--------------------
@interface EBProductInfo : NSObject<NSCoding> {
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
@property (nonatomic, assign) int carCount;

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
@property (nonatomic, copy) NSString *service;//售后服务 (Encode)@

@end

//--------------------< 电子商城 - 对象 - 商品分类 >--------------------
@interface EBProductType : NSObject {
@private
    NSString *typeId;   // 商品类型ID
    NSString *typeName; // 商品类型名称
    int       child;    // 是否有子分类
}

@property (nonatomic, copy) NSString *typeId;
@property (nonatomic, copy) NSString *typeName;
@property (nonatomic, assign) int child;

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
@property (nonatomic, copy) NSString *orderId; // 订单id
@property (nonatomic, assign) BOOL state; // 状态
@property (nonatomic, copy) NSString *userName; //用户昵称 (encode)
@property (nonatomic, copy) NSString *content; // 评论的内容 (encode)
@property (nonatomic, assign) int grade;
@property (nonatomic, assign) int love;
@property (nonatomic, copy) NSString *picUrl; // 图片url (encode)
@property (nonatomic, copy) NSString *commentTime;// 评论的时间
@property (nonatomic, copy) NSString *realizeTime;

@end

//--------------------< 电子商城 - 对象 - 站内消息 >--------------------

@interface EBSiteMessage : NSObject{
    //
}
@property (nonatomic, copy) NSString *id; // 信息ID
@property (nonatomic, assign) int senderId; // 系统id定义为0，其它为商家
@property (nonatomic, copy) NSString *sendName; // 发件人 (Encode)
@property (nonatomic, copy) NSString *recvName; // 收件人 (Encode)
@property (nonatomic, copy) NSString *title; // 站内信的信息标题 (Encode)
@property (nonatomic, copy) NSString *content; // 站内信信息内容 (Encode)
@property (nonatomic, copy) NSString *recevTime; // 收信时间
@property (nonatomic, copy) NSString *sendTime; // 收信时间

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
@property (nonatomic, assign) int payStatus; // 支付状态
@property (nonatomic, assign) int payWay; // 支付类型

@property (nonatomic, copy) NSString *type; // 01-货到付款
@property (nonatomic, copy) NSString *receiver; // 收件人
@property (nonatomic, copy) NSString *address; // 地址
@property (nonatomic, assign) int areaCode; // 邮编
@property (nonatomic, assign) long long mobile; // 电话

@property (nonatomic, assign) int shopId;
@property (nonatomic, copy) NSString *shopName;
@property (nonatomic, copy) NSString *actionSource; // 操作来源

@property (nonatomic, copy) NSString *logicDt;   // 发货日期
@property (nonatomic, copy) NSString *logicId;   // 快递单号
@property (nonatomic, copy) NSString *logicName; // 快递公司
@property (nonatomic, copy) NSString *servicNo;  // 客服电话

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
//@property (nonatomic, copy) NSString *totalCount; // 商品数量单位

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

@interface EBTest : NSObject
@property (nonatomic, assign) long long id;

@end

//--------------------< 电子商城 - 对象 - 收货地址 >--------------------
@interface EBAddress : NSObject<NSCoding>{
    //
}
@property(nonatomic, copy) NSString *sheng;// 省份
@property(nonatomic, copy) NSString *chengshi;// 城市
@property(nonatomic, copy) NSString *dizhi;// 详细地址
@property(nonatomic, copy) NSString *shouhuoren;// 收货人
@property(nonatomic, copy) NSString *youbian;// 邮编
@property(nonatomic, copy) NSString *shouji;// 手机号
@end

//====================================< 电子商城 - 接口 >====================================

@interface Api (Ebuy)

// 广告列表
+ (NSMutableArray *)ebuy_ad_list;

// 商品模糊搜索
+ (NSMutableArray *)ebuy_search:(NSString *)key;

// 商品推荐接口
+ (NSMutableArray *)ebuy_push:(int)page;

//--------------------< 电子商城 - 接口 - 分类 >--------------------
// 分类列表接口 typeId=0为全部分类
+ (NSMutableArray *)ebuy_type:(int)page typeId:(NSString *)typeId;

// 获取商品列表
+ (NSMutableArray *)ebuy_goodslist:(int)page way:(int)way typeId:(NSString *)typeId;

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

// 这个接口不安全
+ (NSString *)ebuy_commentpic_upload:(NSData *)buffer;
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
+ (NSMutableArray *)ebuy_collect:(int)page;
// 添加收藏
+ (ApiResult *)ebuy_collect_add:(NSString *)cid;
// 删除收藏
+ (ApiResult *)ebuy_collect_delete:(NSString *)cid;

//--------------------< 电子商城 - 接口 - 订单 >--------------------

// 订单状态
+ (NSString *)ebuy_state_order:(int)state;
// 支付类型
+ (NSString *)ebuy_pay_type:(int)type;

// 订单获取接口
+ (NSMutableArray *)ebuy_order_list:(int)type
                               page:(int)page;

// 订单详情
+ (EBOrderInfo *)ebuy_order_get:(NSString *)orderId;

// 订购
+ (ApiResult *)ebuy_order:(EBOrderInfo *)info;

//--------------------< 电子商城 - 接口 - 商铺列表 >--------------------
+ (NSMutableArray *)ebuy_shoplist:(int)page;

//--------------------< 电子商城 - 接口 - 购物车 >--------------------
// 购物车列表
+ (NSMutableDictionary *)ebuy_car_list;

// 放入购物车
+ (BOOL)ebuy_car_add:(EBProductInfo *)obj;
// 购物车 删除商品
+ (BOOL)ebuy_car_delete:(EBProductInfo *)obj;
+ (BOOL)ebuy_car_delete:(NSString *)shopName index:(int)index;

//--------------------< 电子商城 - 接口 - 地址簿 >--------------------
// 地址簿列表
+ (NSMutableArray *)ebuy_address_list;
// 添加地址簿
+ (BOOL)ebuy_address_set:(EBAddress *)obj index:(int)index;
// 删除地址
+ (BOOL)ebuy_addess_del:(int)index;

@end
