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
@property (nonatomic, copy) NSString *recevtTme; // 收信时间

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
+ (NSMutableArray *)ebuy_goodslist:(int)page typeId:(int)typeId;

// 快报资讯推荐接口
+ (NSMutableArray *)ebuy_new:(int)page;

// 快报资讯详情接口
+ (EBProductInfo *)ebuy_messagenewinfo:(NSString *)id;

// 商品详情
+ (EBProductInfo *)ebuy_goodsinfo:(NSString *)id;

// 商品评论
+ (NSMutableArray *)ebuy_goodscomment:(NSString *)id page:(int)page;

// 收件箱
+ (NSMutableArray *)ebuy_message_recv:(NSString *)id page:(int)page;
// 发件箱
+ (NSMutableArray *)ebuy_message_send:(NSString *)id page:(int)page;

@end
