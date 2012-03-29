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
    NSString *picUrl;      // 商品图片
    float     price;       // 商品价格
    NSString *realizeTime; // 快报资讯发送的时间, 仅快讯详细信息有此字段
}
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *title, *content, *picUrl;
@property (nonatomic, assign) float price;
@property (nonatomic, copy) NSString *realizeTime;

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

@end
