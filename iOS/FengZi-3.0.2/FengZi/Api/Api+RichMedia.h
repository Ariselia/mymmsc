//
//  Api+RichMedia.h
//  FengZi
//
//  Created by WangFeng on 11-12-15.
//  Copyright (c) 2012年 mymmsc.org. All rights reserved.
//

#import <FengZi/Api+Category.h>
//====================================< 富媒体 - 接口 >====================================

#define API_KMA_INVAILD             (-1)
// 媒体内容 类型
#define API_RICHMEDIA_PICTYPE_IMAGE (0)
#define API_RICHMEDIA_PICTYPE_FLASH (1)
#define API_RICHMEDIA_PICTYPE_VIDEO (3)

// 富媒体跳转 类型
#define API_RICHMEDIA_ISJUMP  (1) // 富媒体是否跳转
#define API_RMJUMP_WWW        (1) // 网站链接
#define API_RMJUMP_EBUY_SHOP  (2) // 电商商户
#define API_RMJUMP_EBUY_PROD  (3) // 电商商品
#define API_RMJUMP_ESHOP_SHOP (4) // 数字商城商户
#define API_RMJUMP_ESHOP_PROD (5) // 数字商城商品
#define API_RMJUMP_ACTION     (6) // 活动链接
#define API_RMJUMP_URL_PRICE  (7) // 优惠价链接

//--------------------< 富媒体 - 对象 - 媒体信息类 >--------------------
@interface MediaInfo : ApiResult {
    
    NSString *key;//filetype
    int type;//typeid
    NSString *tinyName;//url
}

@property (nonatomic, retain) NSString *key;
@property (nonatomic, assign) int type;
@property (nonatomic, retain) NSString *tinyName;

@end

//--------------------< 富媒体 - 对象 - 模板类 >--------------------
@interface ModelInfo : ApiResult {
    NSString *mediaKey;
    NSString *url;
}

@property (nonatomic, retain) NSString *mediaKey;
@property (nonatomic, retain) NSString *url;

@end

//--------------------< 富媒体 - 对象 - 内容类 >--------------------
@interface MediaObject : NSObject {
    NSString *content;
    NSString *title;
    NSString *image; //缩略图url
    NSString *video; //大视频url
    NSString *audio;
    
    BOOL            isSend;      // 富媒体是否跳转
    NSString       *sendType;    // 跳转类型
    NSString       *sendContent; // 跳转内容
    //    NSString *soundUrl;
    int       picType;
}
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *video;
@property (nonatomic, copy) NSString *audio;
@property (nonatomic, assign) BOOL isSend;
@property (nonatomic, copy) NSString *sendType;
@property (nonatomic, copy) NSString *sendContent;
@property (nonatomic, assign) int picType;
@end

@interface MediaContent : ApiResult {
    NSString       *title;
    NSString       *content;
    NSMutableArray *pagelist;
    NSString       *audio;
    BOOL            isSend;      // 富媒体是否跳转
    NSString       *sendType;    // 跳转类型
    NSString       *sendContent; // 跳转内容
}

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSMutableArray *pagelist;
@property (nonatomic, copy) NSString *audio;

@property (nonatomic, assign) BOOL isSend;
@property (nonatomic, copy) NSString *sendType;
@property (nonatomic, copy) NSString *sendContent;

@end

//--------------------< 富媒体 - 对象 - 空码内容类 >--------------------
@interface KmaObject : ApiResult {
    int      isKma;              // 是否空码
    int      type;               // 类型
    NSString *tranditionContent; // 属性编码?
    NSString *mediaContent;      // 资源内容
    MediaContent *mediaObj;       // 媒体对象
}
@property (nonatomic, assign) int isKma, type;
@property (nonatomic, copy) NSString *tranditionContent;
@property (nonatomic, copy) NSString *mediaContent;
@property (nonatomic, retain) MediaContent *mediaObj;

@end

//--------------------< 空码 - 对象 - 顺风车 >--------------------
@interface RidePath : NSObject{
    //
}
@property (nonatomic, copy) NSString *destaddr;//目的地(encode)
@property (nonatomic, copy) NSString *drvpath;//驾驶路线(encode)
@property (nonatomic, copy) NSString *startaddr;//起始地址(encode)
@property (nonatomic, assign) int shour;//出发开始小时
@property (nonatomic, assign) int sminut;//出发开始分钟

@end

// real
@interface RideReal : NSObject

@property (nonatomic, copy) NSString *carcolor;//车颜色(encode)
@property (nonatomic, copy) NSString *carimg;//车图片地址(encode)
@property (nonatomic, copy) NSString *carplate;//车牌(encode)
@property (nonatomic, copy) NSString *carseries;//车类型(encode)
@property (nonatomic, copy) NSString *cartype;//车款式(encode)
@property (nonatomic, copy) NSString *decl;//宣言(encode)
@property (nonatomic, assign) int drvage;//车龄
@property (nonatomic, assign) int gender;//性别：0：其他；1：男；2：女
@property (nonatomic, copy) NSString *headimg;//头像地址(encode)
@property (nonatomic, copy) NSString *his;//顺风车历史(encode)
@property (nonatomic, copy) NSString *realname;//真实姓名(encode)

@end

@interface RideInfo : NSObject{
    
}
@property (nonatomic, assign) int status; // 调用接口状态: 0(成功)
@property (nonatomic, copy) NSString *info; // 调用接口信息
@property (nonatomic, retain) NSMutableArray *drvList; // 车找人 RidePath数组
@property (nonatomic, retain) NSMutableArray *psgList;// 人找车 RidePath数组
@property (nonatomic, retain) RideReal *real; // 车况
@end


//--------------------< 富媒体 - 接口 - 应用程序相关 >--------------------
@interface Api (RichMedia)

// 获得app属性信息串
+ (NSString *)appAttribute:(int)type;

+ (MediaInfo *)uploadImage:(NSData *)buffer;

+ (ModelInfo *)uploadModel:(NSString *)title
                   content:(NSString *)content
                       url:(NSString *)url
                      type:(int)type
                      uuid:(NSString *)uuid;

// 获取媒体内容
+ (MediaContent *)getContent:(NSString *)uuid;

//--------------------< 空码赋值 - 对象 - 接口 >--------------------

+ (void)kmaSetId:(NSString *)code;
+ (NSString *)kmaId;

/**
 * 空码扫码, 确定业务及内容
 * 参数url, 如果是码id, 则以默认的主机
 */
+ (KmaObject *)kmaContent:(NSString *)url;

+ (ApiResult *)kmaUpload:(NSString *)pid
                   type:(int)type
                content:(NSString *)content;



+ (void)uploadKma:(NSString *)_content;

//--------------------< 空码 - 接口 - 顺风车 >--------------------
+ (RideInfo *)sfc_info:(NSString *)id;

@end
