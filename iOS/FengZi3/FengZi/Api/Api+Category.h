//
//  Api+Category.h
//  FengZi
//
//  Created by wangfeng on 12-4-22.
//  Copyright (c) 2012年 fengxiafei.com. All rights reserved.
//

#import "Api.h"

// 二期码 - 应用服务器地址
#define V2APP_URL     @"http://m.ifengzi.cn"
// 二期码 - 富媒体 - 前缀
#define V2CODE_PREFIX V2APP_URL "/mb/dynamic/getContent.action?"
// 二期码 - 空码 - 前缀
#define V2KMA_PREFIX  V2APP_URL "/mb/kma/getContent.action?"

#ifdef __cplusplus
extern "C" {
#endif
typedef enum BusinessType{
    // 基础类型
	kModelBASE = 0x00,
	// URL
	kModelUrl,
	// 书签
	kModelBookMark,
	// 应用程序链接地址
	kModelAppUrl,
	/** 微博 */
	kModelWeibo,
	/** 名片 */
	kModelCard,
	/** 电话号码 */
	kModelPhone,
	/** 电子邮件 */
	kModelEmail,
	/** 文本 */
	kModelText,
	/** 加密文本 */
	kModelEncText,
	/** 短信 */
	kModelShortMessage,
	/** WIFI */
	kModelWiFiText,
	/** 地图 */
	kModelGMap,
	/** 日程 */
	kModelSchedule,
	/** 富媒体 */
	kModelRichMedia,
	/** 顺风车 */
	kModelRide,
    /** 空码 */
    kModelKma = kModelBASE,
	/** 未知类型文本 */
	kModelUNKNOWN_TEXT = kModelText,
	/** 未知类型连接地址 */
	kModelUNKNOWN_URL = kModelUrl,
	/** 错误基数 */
	kModelERROR_BASE = (0X80),
	/** 空码请求异常时的码类型 */
	kModelERROR_KMA = (kModelERROR_BASE | kModelBASE),
	/** 富媒体请求异常时的码类型 */
	kModelERROR_RICHMEDIA = (kModelERROR_BASE | kModelRichMedia)
}BusinessType;

typedef enum{
    BOOKMARK = 0,
    WEIBO,
    GMAP,
    APP
} UrlType;

#ifdef __cplusplus
}
#endif

//--------------------< 业务类型 - 对象 - 基础业务模型 >--------------------
@interface BaseModel : NSObject{
    // 业务类型
	Byte typeId;
	// 标示身份的id, 用作记录传递
	NSString *logId;
}
@property (nonatomic, assign) Byte typeId;
@property (nonatomic, copy) NSString *logId;

- (NSString *)typeName;
+ (Class)getType:(BusinessType)codeType;

@end

@interface ITTBaseModelObject :NSObject <NSCoding> {
    
}
- (id)initWithDataDic:(NSDictionary*)data;
- (NSDictionary*)attributeMapDictionary;
- (void)setAttributes:(NSDictionary*)dataDic;
- (NSString *)customDescription;
- (NSString *)description;
- (NSData*)getArchivedData;
@end

//--------------------< 业务类型 - 对象 - 收藏 >--------------------
@interface FaviroteObject : NSObject{
    int           _uuid;
    NSString     *_content;
    NSString     *_image;
    NSString     *_date;
    BusinessType  _type;
}

@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) int uuid;
@property (nonatomic, assign) BusinessType type;
@end

//--------------------< 业务类型 - 对象 - 历史记录 >--------------------
@interface HistoryObject : NSObject{
    int          _uuid;
    NSString    *_content;
    NSString    *_image;
    NSString    *_date;
    BusinessType _type;
    BOOL         _isEncode;
}

@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) int uuid;
@property (nonatomic, assign) BusinessType type;
@property (nonatomic, assign) BOOL isEncode;
@end

//--------------------< 业务类型 - 对象 - 应用程序 >--------------------
@interface AppUrl : BaseModel{
    NSString *_url;
    NSString *_title;
}

@property (copy, nonatomic) NSString *url;
@property (copy, nonatomic) NSString *title;

@end

//--------------------< 业务类型 - 对象 - 书签 >--------------------
@interface BookMark : BaseModel{
    NSString *_title;
	NSString *_url;
}

@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *url;

@end

//--------------------< 业务类型 - 对象 - 通讯录 >--------------------
@interface Card : BaseModel{
    NSString* _name;
	NSString* _title;
	NSString* _department;
	NSString* _corporation;
	NSString* _cellphone;
	NSString* _telephone;
	NSString* _fax;
	NSString* _email;
	NSString* _url;
	NSString* _address;
	NSString* _zipCode;
	NSString* _qq;
	NSString* _msn;
	NSString* _weibo;
}

@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *department;
@property (copy, nonatomic) NSString *corporation;
@property (copy, nonatomic) NSString *cellphone;
@property (copy, nonatomic) NSString *telephone;
@property (copy, nonatomic) NSString *fax;
@property (copy, nonatomic) NSString *email;
@property (copy, nonatomic) NSString *url;
@property (copy, nonatomic) NSString *address;
@property (copy, nonatomic) NSString *zipCode;
@property (copy, nonatomic) NSString *qq;
@property (copy, nonatomic) NSString *msn;
@property (copy, nonatomic) NSString *weibo;

@end

//--------------------< 业务类型 - 对象 - 电子邮件 >--------------------
@interface Email : BaseModel{
    NSString* _mail;
	NSString* _title;
	NSString* _content;
}
@property (copy, nonatomic) NSString *mail;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *content;

@end

//--------------------< 业务类型 - 对象 - 加密文本 >--------------------
@interface EncText : BaseModel{
    NSString* _key;
    NSString* _content;
}
@property (copy, nonatomic) NSString *key;
@property (copy, nonatomic) NSString *content;

@end

//--------------------< 业务类型 - 对象 - 位置信息 >--------------------
@interface GMap : BaseModel{
    NSString* _url;
}
@property (copy, nonatomic) NSString *url;

@end

//--------------------< 业务类型 - 对象 - 电话号码 >--------------------
@interface Phone : BaseModel{
    NSString* _telephone;
}
@property (copy, nonatomic) NSString *telephone;

@end

//--------------------< 业务类型 - 对象 - 日程 >--------------------
@interface Schedule : BaseModel{
    NSString* _content;	
    NSString* _date;
	NSString* _title;	
}
@property (copy, nonatomic) NSString *content;
@property (copy, nonatomic) NSString *date;
@property (copy, nonatomic) NSString *title;

@end

//--------------------< 业务类型 - 对象 - 文本 >--------------------
@interface Text : BaseModel{	
	NSString* _content;	
}
@property (copy, nonatomic) NSString *content;

@end

//--------------------< 业务类型 - 对象 - 网络地址 >--------------------
@interface Url : BaseModel{	
	NSString* _content;	
}
@property (copy, nonatomic) NSString *content;

@end

//--------------------< 业务类型 - 对象 - 短信 >--------------------
@interface ShortMessage : BaseModel{
    NSString* _phone;
	NSString* _content;	
}
@property (copy, nonatomic) NSString *phone;
@property (copy, nonatomic) NSString *content;

@end

//--------------------< 业务类型 - 对象 - 微博 >--------------------
@interface Weibo : BaseModel{	
	NSString* _title;
    NSString* _url;
}
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *url;

@end

//--------------------< 业务类型 - 对象 - WIFI >--------------------
@interface WiFiText : BaseModel{	
	NSString* _name;
    NSString* _password;
}
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *password;

@end

//--------------------< 业务类型 - 对象 - 富媒体 >--------------------

@interface MediaPage : NSObject{
    NSString *title; // 标题
	NSString *content; // 内容
	NSString *audio; // 背景音乐URL
	NSString *image; // 图片URL
	NSString *video; // 视频URL
}

@property (nonatomic, copy) NSString *title; // 标题
@property (nonatomic, copy) NSString *content; // 内容
@property (nonatomic, copy) NSString *audio; // 背景音乐URL
@property (nonatomic, copy) NSString *image; // 图片URL
@property (nonatomic, copy) NSString *video; // 视频URL

@end

@interface RichMedia : BaseModel {
    NSString *codeId; // 码ID
	NSString *title; // 标题
	NSString *content; // 内容
	NSString *audio; // 默认背景音乐
	BOOL isSend; // 是否跳转
	int sendType;// 跳转类型
	NSString *sendContent;// 跳转位置
	NSString *mediaType;// 富媒体类型
    NSArray *pageList; // 富媒体页
    
    NSString *_url; // 服务器返回的url
    int       _type; // 媒体类型
}
@property (nonatomic, copy) NSString *codeId; // 码ID
@property (nonatomic, copy) NSString *title; // 标题
@property (nonatomic, copy) NSString *content; // 内容
@property (nonatomic, copy) NSString *audio; // 默认背景音乐
@property (nonatomic, assign) BOOL isSend; // 是否跳转
@property (nonatomic, assign) int sendType;// 跳转类型
@property (nonatomic, copy) NSString *sendContent;// 跳转位置
@property (nonatomic, copy) NSString *mediaType;// 富媒体类型
@property (nonatomic, retain) NSArray *pageList; // 富媒体页

@property (nonatomic, assign) int type;
@property (nonatomic, copy) NSString *url;

// 媒体页数据类型
- (Class)pageListClass;

@end

//--------------------< 业务类型 - 对象 - 顺风车 >--------------------

@interface Ride : BaseModel {
    //
}

@end

//--------------------< 业务类型 - 对象 - 空码 >--------------------

@interface RichKma : BaseModel{
    // 空码ID
    NSString *uuid;
}
@property (nonatomic, copy) NSString *uuid;

@end

//====================================< 词条 - 接口 >====================================
@interface Api (Category)

+ (id)parseV3Common:(NSString *)string;
+ (id)parseV3Kma:(NSString *)string timeout:(int)timeout;
+ (id)parseV2Common:(NSString *)string;
+ (id)parseV2Kma:(NSString *)string timeout:(int)timeout;

/**
 * 二维码解码
 * 
 * @param string
 * @param timeout 超时
 * @return BaseModel
 */
+ (id)parse:(NSString *)string timeout:(int)timeout;

@end
