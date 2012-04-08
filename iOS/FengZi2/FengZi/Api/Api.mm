//
//  Api.m
//  FengZi
//
//  Created by WangFeng on 11-12-15.
//  Copyright (c) 2012年 mymmsc.org. All rights reserved.
//

#import "Api.h"
#import <iOSApi/iOSApi+Crypto.h>
#import <iOSApi/iOSActivityIndicator.h>
#import "GTMBase64.h"
#import "CommonUtils.h"

//#define API_SERVER  @"http://220.231.48.34:8080"
#define API_SERVER  @"http://220.231.48.34:7000"
#define API_TIMEOUT (10)

#import <QRCode/QREncoder.h>
#import <QRCode/DataMatrix.h>

//====================================< 用户信息 >====================================

@implementation UserInfo

@synthesize userId, userName, phoneNumber, nikeName, password, sessionPassword;

- (id)init{
	if(!(self = [super init])) {
		return self;
	}
    userId = -1;
	
	return self;
}

- (void)dealloc {
    [userName release];
    [phoneNumber release];
    [nikeName release];
    [password release];
    [sessionPassword release];
    
    [super dealloc];
}

@end

//====================================< 接口响应类 >====================================
@implementation ApiResult

@synthesize status, message;

- (id)init{
	if(!(self = [super init])) {
		return self;
	}
    status = 1;
	message = @"系统正忙，请稍候...";
    message = [message trim];
	
	return self;
}

- (void)dealloc{
    [message release];
    message = nil;
    
    [super dealloc];
}

// 返回DATA区域 数据
- (NSDictionary *)parse:(NSDictionary *)map{
    NSDictionary *data = nil;
    if (map.count > 0) {
        id value = [map objectForKey:@"status"];
        if (value != nil) {
            status = ((NSNumber *)value).intValue;
        }
        value = [map objectForKey:@"msg"];
        if (value != nil) {
            if ([value isKindOfClass:[NSArray class]]) {
                NSArray *list = value;
                if (list.count > 0) {
                    message = [[NSString alloc] initWithString:[list objectAtIndex: 0]];
                }
            } else {
                message = [value retain];
            }
        }
        data = [map objectForKey:@"data"];
    } else {
        status = 1;
        message = @"服务器正忙，请稍候...";
    }
    if (status == API_SUCCESS && message.length < 1) {
        message = @"提交成功";
    }
    return data;
}

@end

//====================================< 接口功能 >====================================

@implementation Api

+ (NSString *)base64e:(NSString *)s {
    NSData *data = [s dataUsingEncoding:NSUTF8StringEncoding];
    NSData *dst = [GTMBase64 encodeData:data];
    return [[[NSString alloc] initWithData:dst encoding:NSUTF8StringEncoding] autorelease];
}

+ (NSString *)base64d:(NSString *)s {
    NSData *data = [s dataUsingEncoding:NSUTF8StringEncoding];
    NSData *dst = [GTMBase64 decodeData:data];
    return [[[NSString alloc] initWithData:dst encoding:NSUTF8StringEncoding] autorelease];
}

+ (NSData *)base64d_data:(NSString *)s {
    s = [iOSApi urlDecode:s];
    NSData *data = [s dataUsingEncoding:NSUTF8StringEncoding];
    return [GTMBase64 decodeData:data];
}

static BOOL cache_kma = NO;

// 是否空码, 默认为空码
+ (BOOL)kma{
    return cache_kma;
}

// 设定是否为空码模式
+ (void)setKma:(BOOL)isKma{
    cache_kma = isKma;
}

static UserInfo *cache_info = nil;

+ (void)initInfo{
    if (cache_info == nil) {
        cache_info = [[UserInfo alloc] init];
    }
}

// 设定用户ID
+ (void) setUserId:(int)userId{
    [self initInfo];
    [cache_info setUserId:userId];
}

// 获取用户ID
+ (int)userId{
    [self initInfo];
    return cache_info.userId;
}

// 设定用户手机号码
+ (void)setUserPhone:(NSString *)userPhone{
    [self initInfo];
    cache_info.phoneNumber = userPhone;
    [[iOSApi cache] setObject:cache_info.phoneNumber forKey:API_CACHE_USERID];
}

// 获取用户手机号码
+ (NSString *)userPhone{
    [self initInfo];
    NSString *sRet = cache_info.phoneNumber;
    if (sRet == nil) {
        sRet = [[iOSApi cache] objectForKey:API_CACHE_USERID];
    }
    if (sRet == nil) {
        //sRet = @"18632523200";
    }
    return sRet;
}

+ (NSString *)passwd{
    [self initInfo];
    NSString *sRet = cache_info.password;
    if (sRet == nil) {
        sRet = [[iOSApi cache] objectForKey:API_CACHE_PASSWD];
    }
    if (sRet == nil) {
        sRet = @"123456";
    }
    return sRet;
}

+ (void)setPasswd:(NSString *)passwd {
    [self initInfo];
    [cache_info setPassword:passwd];
    [[iOSApi cache] setObject:passwd forKey:API_CACHE_PASSWD];
}

+ (NSString *)sessionPassword{
    [self initInfo];
    return cache_info.sessionPassword;
}

+ (void)setSessionPassword:(NSString *)passwd {
    [self initInfo];
    [cache_info setSessionPassword:passwd];
}

+ (NSString *)nikeName{
    [self initInfo];
    NSString *sRet = cache_info.nikeName;
    if (sRet == nil) {
        sRet = [[iOSApi cache] objectForKey:API_CACHE_NKNAME];
    }
    if (sRet == nil) {
        sRet = @"匿名"; // 默认一个昵称
    }
    return sRet;
}

+ (void)setNikeName:(NSString *)nikeName {
    [self initInfo];
    [cache_info setNikeName:nikeName];
    [[iOSApi cache] setObject:nikeName forKey:API_CACHE_NKNAME];
}

+ (BOOL)isOnLine{
    [self initInfo];
    BOOL bRet = NO;
    NSString *uid = cache_info.phoneNumber;;
    if (uid != nil && ![uid isEqualToString:@""]) {
        bRet = YES;
    }
    
    return bRet;
}

+ (UserInfo *)user{
    [self initInfo];
    return cache_info;
}

+ (void)setUser:(UserInfo *)info {
    cache_info = info;
}

//--------------
+ (NSString *)filePath:(NSString *)url {
    NSString *tmpUrl = [iOSApi urlDecode:url];
    // 获得文件名
    NSString *filename = [NSString stringWithFormat:@"%@/%@", API_CACHE_FILEPATH, [tmpUrl lastPathComponent]];
    NSLog(@"1: %@", filename);
    //return [iOSFile path:filename];
    return filename;
}

+ (BOOL)fileIsExists:(NSString *)url {
    NSString *filepath = [iOSFile path:[self filePath:url]];
    BOOL bExists = NO;
    bExists = [[iOSFile manager] fileExistsAtPath:filepath];
    return bExists;
}

//--------------------< 业务处理 - 接口 >--------------------
+ (NSString *)fixUrl:(NSString *)url{
    NSString *sRet = nil;
    url = [iOSApi urlDecode:url];
    url = [url stringByReplacingOccurrencesOfString:@"\\:" withString:@":"];
    NSRange range = [url rangeOfString: @"http://"];
    if (range.length > 0) {
        NSString *_url = [url substringFromIndex:range.location];
        range = [_url rangeOfString:@";"];
        if (range.length > 0) {
            sRet = [_url substringToIndex:range.location - 1];
        } else {
            sRet = _url;
        }
    }
    
    return sRet;
}

+ (NSDictionary *)parseUrl:(NSString *)url {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    url = [self fixUrl:url];	    
    NSArray *tmpUrl = [url componentsSeparatedByString:@"?"];
    if (tmpUrl.count >= 2) {
        NSArray *attrs = [[tmpUrl objectAtIndex:1] componentsSeparatedByString:@"&"];
        for (int i = 0; i < attrs.count; i++) {
            NSArray *param = [[attrs objectAtIndex:i] componentsSeparatedByString:@"="];
            [dict setObject:[param objectAtIndex:1] forKey:[param objectAtIndex:0]];
        }
    }
    return dict;
}

+ (int)getInt:(id)value {
    int iRet = -1;
    if ([value isKindOfClass:[NSNumber class]]) {
        NSNumber *v = value;
        iRet = v.intValue;
    }
    return iRet;
}

+ (float)getFloat:(id)value {
    float iRet = 0.00f;
    if ([value isKindOfClass:[NSNumber class]]) {
        NSNumber *v = value;
        iRet = v.floatValue;
    }
    return iRet;
}

+ (NSString *)getString:(id)value {
    NSString *sRet = @"";
    if ([value isKindOfClass:[NSString class]]) {
        sRet = value;
    }
    return sRet;
}

+ (NSMutableDictionary *)post:(NSString *)action params:(NSDictionary *)params {
    NSMutableDictionary *ret = nil;
    
    NSString *url = action;
    if (![action hasPrefix:@"http://"]) {
        url = [NSString stringWithFormat:@"%@/%@", API_SERVER, action];
    }
        
    HttpClient *client = [[HttpClient alloc] initWithURL:url timeout:API_TIMEOUT];
    
    [client formAddFields:params];
    NSData *response = [client post];
    if (response == nil) {
        //[iOSApi Alert:@"提示" message:@"服务器正忙，请稍候。"];
    } else {
        iOSLog(@"Date=%@", [client header:@"Date"]);
        
        // 取得JSON数据的字符串
        NSString *json_string = [[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding] autorelease];
        iOSLog(@"json.string = %@", json_string);
        //json_string = [json_string stringByReplacingOccurrencesOfString:@".00" withString:@".01"];
        // 把JSON转为数组
        ret = [json_string objectFromJSONString];
    }
    [client release];
    return ret;
}

+ (NSMutableDictionary *)post:(NSString *)action header:(NSDictionary *)heads body:(NSData *)params {
    NSMutableDictionary *ret = nil;
    
    NSString *url = action;
    if (![action hasPrefix:@"http://"]) {
        url = [NSString stringWithFormat:@"%@/%@", API_SERVER, action];
    }
    
    HttpClient *client = [[HttpClient alloc] initWithURL:url timeout:API_TIMEOUT];
    
    NSData *response = [client post:heads body:params];
    if (response == nil) {
        //[iOSApi Alert:@"提示" message:@"服务器正忙，请稍候。"];
    } else {
        iOSLog(@"Date=%@", [client header:@"Date"]);
        
        // 取得JSON数据的字符串
        NSString *json_string = [[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding] autorelease];
        iOSLog(@"json.string = %@", json_string);
        //json_string = [json_string stringByReplacingOccurrencesOfString:@".00" withString:@".01"];
        // 把JSON转为数组
        ret = [json_string objectFromJSONString];
    }
    [client release];
    return ret;
}

+ (UIImage*)generateImageWithInput:(NSString*)s{
    int qrcodeImageDimension = 250;
    //the string can be very long
    NSString* aVeryLongURL = s;
    //first encode the string into a matrix of bools, TRUE for black dot and FALSE for white. Let the encoder decide the error correction level and version
    int qr_level = QR_ECLEVEL_L;
    DataMatrix* qrMatrix = [QREncoder encodeWithECLevel:qr_level version:QR_VERSION_AUTO string:aVeryLongURL];
    //then render the matrix
    UIImage* qrcodeImage = [QREncoder renderDataMatrix:qrMatrix imageDimension:qrcodeImageDimension];
    return qrcodeImage;
}

@end
