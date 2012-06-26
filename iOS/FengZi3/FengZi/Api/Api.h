//
//  Api.h
//  FengZi
//
//  Created by WangFeng on 11-12-15.
//  Copyright (c) 2012年 mymmsc.org. All rights reserved.
//

#import <iOSApi/iOSApi.h>
#import <iOSApi/iOSApi+jSon.h>
#import <iOSApi/iOSApi+Reflex.h>
#import <iOSApi/iOSApi+Window.h>
#import <iOSApi/iOSApi+Crypto.h>
#import <iOSApi/iOSAction.h>
#import <iOSApi/iOSFile.h>
#import <iOSApi/iOSInput.h>
#import <iOSApi/JSONKit.h>
#import <iOSApi/HttpClient.h>
#import <iOSApi/UIImage+Utils.h>
#import <iOSApi/NSArray+Utils.h>
#import <iOSApi/NSDate+Utils.h>
#import <iOSApi/NSObject+Utils.h>
#import <iOSApi/NSString+Utils.h>
#import <iOSApi/NSDictionary+Utils.h>
#import <iOSApi/UIImageView+Utils.h>
#import <iOSApi/iOSImageView.h>
#import <QuartzCore/QuartzCore.h>

#define API_SUCCESS (0)
#define kCellIconHeight 24.0f

#define API_INTERFACE_TEST (1)

#define API_TEXT_SPACE @"　"

// 文件缓冲路径
#define API_CACHE_FILEPATH   @"cache/files"
// 码前缀
#define API_CODE_PREFIX      @"http://ifengzi.cn/show.cgi?"
// 应用服务器
#define API_APPS_SERVER      @"http://ifengzi.cn/"
// 文件服务器
#define API_FILE_SERVER      @"http://f.ifengzi.cn/"
//文件上传
#define API_FILE_UPLOAD      "apps/FileUpload.action"
//生码分为富媒体个性生码、个人用户空码赋值、企业用户批量生成空码：
#define API_MAKE_CODE        "apps/MakeCode.action"
//展示二维码
#define API_SHOW_CODE        "apps/ShowCode.action"

//获取富媒体内容采用GET方式的URL重定向，参数一定要按照顺序填写。
#define API_GET_CODE	     "apps/getCode.action"

// 个人空间秀
#define API_URL_SHOW         @"http://ifengzi.cn/apps/getUserInfo.action"
// 顺风车 接口地址
#define API_URL_RIDE         @"http://m.ifengzi.cn/sfc/fx/facade"

// 数字商城
#define API_URL_ESHOP        @"http://apps.ifengzi.cn/eshop"
// 数字商城二维码前缀
#define API_QRCODE_ESHOP     API_URL_ESHOP "/info.action"

// 电子商城
#define API_URL_EBUY         @"http://apps.ifengzi.cn/ebuy"

// 电子蜂夹
#define API_URL_EFILE        @"http://220.231.48.34:38090/mobile/fx"
// 蜂幸运
#define API_URL_LUCKY        @"http://devp.ifengzi.cn:38090/lucky"

//====================================< 用户信息 >====================================

#define API_CACHE_USERID @"app_userId"
#define API_CACHE_NKNAME @"app_nikename"
#define API_CACHE_PASSWD @"app_passwd"
#define API_CACHE_ISSAVE @"app_isSave"
#define API_CACHE_TOKEN @"FengZi-Token"
#define API_CACHE_LASTDATE @"app_lastdate"
#define API_CACHE_LASTIP @"app_lastid"

@interface UserInfo : NSObject {
    int       userId;          // 用户Id
    NSString *userName;        // 姓名
    NSString *phoneNumber;     // 用户手机号码
    NSString *nikeName;        // 用户昵称
    NSString *password;        // 用户密码
    NSString *token;           // 服务器返回的token值
    NSString *lastdate;        // 最后一次登录的时间
    NSString *lastip;          // 最后一次登录的ip地址
}

@property (nonatomic, assign) int userId;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *phoneNumber;
@property (nonatomic, copy) NSString *nikeName;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *lastdate;
@property (nonatomic, copy) NSString *lastip;

@end

//====================================< 接口响应类 >====================================
@interface ApiResult : NSObject {
    int       status;
    NSString *message;
    NSString *data;
}

@property (nonatomic, assign) int status;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSString *data;

// 返回DATA区域 数据
- (NSDictionary *)parse:(NSDictionary *)map;

@end

//--------------------< 接口 - 业务类型 - 码 >--------------------
@interface ApiCode : NSObject{
    NSString *_shopType;
    NSString *_cType;
    NSString *_id;
}
@property (nonatomic, copy) NSString *shopType;
@property (nonatomic, copy) NSString *cType;
@property (nonatomic, copy) NSString *id;

+ (id)codeWithUrl:(NSString *)url;

@end

//====================================< 接口功能 >====================================
@interface Api : NSObject {
    //
}

//--------------------< 接口 - 视图 - 一个变态的用法 >--------------------

// 只为激活当前视图
+ (UIViewController *)tabView;
+ (void)seTabView:(UIViewController *)view;

//--------------------< 接口 - 对象 - BASE64 >--------------------
+ (NSString *)base64e:(NSString *)s;
+ (NSData *)base64d_data:(NSString *)s;

//--------------------< 接口 - 对象 - 用户信息 >--------------------
+ (UserInfo *)user;

+ (void)setUser:(UserInfo *)info;

// 设定用户ID
+ (void)setUserId:(int)userId;

// 获取用户ID
+ (int)userId;

// 设定用户手机号码
+ (void)setUserPhone:(NSString *)userPhone;

// 获取用户手机号码
+ (NSString *)userPhone;

// 获取用户密码
+ (NSString *)passwd;

// 设定用户密码
+ (void)setPasswd:(NSString *)passwd;

// 获取昵称
+ (NSString *)nikeName;

// 设定昵称
+ (void)setNikeName:(NSString *)nikeName;

// 设定Token值
+(void)setToken:(NSString *)token;

// 设定最后一次登录时间
+(void)setLastdate:(NSString *)lastdate;

// 设定最后一次登录的ip地址
+(void)setLastip:(NSString *)lastip;

+(NSString *)token;
+(NSString *)lastdate;
+(NSString *)lastip;

// 判断用户是否在线
+ (BOOL)isOnLine;

//------------

+ (NSString *)filePath:(NSString *)url;
+ (BOOL) fileIsExists:(NSString *)url;
//--------------------< 富媒体 - 对象 - 模板类 >--------------------

// 是否空码, 默认为空码
+ (BOOL)kma;

// 设定是否为空码模式
+ (void)setKma:(BOOL)isKma;

//--------------------< 业务处理 - 接口 >--------------------

// 新增业务码处理
+ (NSString *)fixUrl:(NSString *)url;
+ (int)getInt:(id)value;
+ (float)getFloat:(id)value;
+ (NSString *)getString:(id)value;

+ (NSMutableDictionary *)post:(NSString *)action params:(NSDictionary *)param;
+ (NSMutableDictionary *)post:(NSString *)action header:(NSDictionary *)heads body:(NSData *)params ;

+ (UIImage *)generateImageWithInput:(NSString*)s;

@end
