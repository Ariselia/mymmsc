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

//====================================< 用户信息 >====================================

@implementation UserInfo

@synthesize userId, userName, phoneNumber, nikeName, password, sessionPassword;

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
@implementation ucResult

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
    cache_info.phoneNumber = [userPhone copy];
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

+ (NSString *)nikeName{
    [self initInfo];
    NSString *sRet = cache_info.nikeName;
    if (sRet == nil) {
        sRet = [[iOSApi cache] objectForKey:API_CACHE_NKNAME];
    }
    if (sRet == nil) {
        sRet = @"蜂子"; // 默认一个昵称
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
//--------------------< 业务处理 - 接口 >--------------------

+ (NSDictionary *)parseUrl:(NSString *)url {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    url = [iOSApi urlDecode:url];
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
    
    //[client formAddField:@"username" value:@"18632523200"];
    [client formAddFields:params];
    NSData *response = [client post];
    if (response == nil) {
        //[iOSApi Alert:@"提示" message:@"服务器正忙，请稍候。"];
    } else {
        iOSLog(@"Date=%@", [client header:@"Date"]);
        
        // 取得JSON数据的字符串
        NSString *json_string = [[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding] autorelease];
        iOSLog(@"json.string = %@", json_string);
        // 把JSON转为数组
        ret = [json_string objectFromJSONString];
    }
    [client release];
    return ret;
}

@end
