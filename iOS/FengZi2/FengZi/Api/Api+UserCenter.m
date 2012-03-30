//
//  Api+UserCenter.m
//  FengZi
//
//  Created by WangFeng on 11-12-15.
//  Copyright (c) 2012年 mymmsc.org. All rights reserved.
//

#import "Api+UserCenter.h"
#import <iOSApi/iOSApi+Crypto.h>
#import <iOSApi/NSObject+Utils.h>
#import <objc/runtime.h>

//====================================< 用户中心 - 登录信息 >====================================
@implementation ucLoginResult

- (void) dealloc{
   
    [super dealloc];
}
@end

//--------------------< 用户中心 - 对象 - 个人信息 >--------------------
@implementation ucUserInfo
@synthesize QQ,sex,email,likes,weibo,isopen,userid,address,modTime,regTime,birthday,postCode,realname,idNumber;

@end

//====================================< 用户中心 - 验证码 >====================================

@implementation ucAuthCode
@synthesize code;

- (void)dealloc {
    [code release];
    code = nil;
    
    [super dealloc];
}

@end

//====================================< 用户中心 - 我的码 >====================================

@implementation CodeInfo

@synthesize createTime, key, title, url, type;

- (void)dealloc {
    [createTime release];
    [key release];
    [title release];
    [url release];
    
    [super dealloc];
}

@end

//====================================< 用户中心 >====================================

@implementation Api (UserCenter)

// 登录
+ (ucLoginResult *)login:(NSString *)username passwd:(NSString *)passwd authcode:(NSString *)authcode{
    ucLoginResult *iRet = [[ucLoginResult alloc] init];
    static NSString *action = API_URL_USERCENTER "/uc/m_login.action";
    authcode = [Api base64e:username];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            username, @"username",
                            [Api base64e:passwd], @"password",
                            authcode, @"checkcode",
                            API_INTERFACE_TONKEN, @"token",
                            nil];
    NSDictionary *map = [Api post:action params:params];
    NSDictionary *data = [iRet parse:map];
    if (data.count > 0) {
        for (NSString *key in [data allKeys]) {
            id value = [data objectForKey:key];
            if ([key isSame:@"username"]) {
                [Api setUserPhone:value];
            } else if([key isSame:@"nicname"]) {
                [Api setNikeName:value];
            } else if([key isSame:@"password"]) {
                [Api setPasswd:value];
            } else if([key isSame:@"userid"]) {
                NSNumber *t = value;
                [Api setUserId:t.intValue];
            } else if([key isSame:@"sessionPassword"]) {
                [Api setSessionPassword:value];
            }
        }
        //[Api setUser:ui];
    }
    return [iRet autorelease];
}

// 根据用户手机号码获取验证码, 理解为同时发短信给用户
+ (ucAuthCode *)authcodeWithName:(NSString *)username {
    ucAuthCode *iRet = [[ucAuthCode alloc] init];
    
    static NSString *action = API_URL_USERCENTER "/uc/m_genCheckCode.action";
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            username,@"username",
                            API_INTERFACE_TONKEN, @"token",
                            nil];
    NSDictionary *map = [Api post:action params:params];
    NSDictionary *data = [iRet parse:map];
    if (data.count > 0) {
        NSString *value = [data objectForKey:@"listData"];
        if (value != nil) {
            iRet.code = value;
        }
    }
    return [iRet autorelease];
}

// 找回密码, 获取验证码
+ (ucAuthCode *)authcode:(NSString *)phone{
    ucAuthCode *iRet = [[ucAuthCode alloc] init];
    
    static NSString *action = API_URL_USERCENTER "/uc/m_callCheckCode.action";
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            phone, @"username",
                            API_INTERFACE_TONKEN, @"token",
                            nil];
    NSDictionary *map = [Api post:action params:params];
    
    NSDictionary *data = [iRet parse:map];
    if (data.count > 0) {
        NSString *value = [data objectForKey:@"listData"];
        if (value != nil) {
            iRet.code = value;
        }
    }
    return [iRet autorelease];
}

// 注册账号
+ (ApiResult *)createId:(NSString *)username
                passwd:(NSString *)passwd
              authcode:(NSString *)authcode
              nikename:(NSString *)nikename {
    static NSString *action = API_URL_USERCENTER "/uc/m_register.action";
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            API_INTERFACE_TONKEN, @"token",
                            username, @"username",
                            [Api base64e:passwd], @"password",
                            [Api base64e:passwd], @"repassword",
                            authcode, @"checkcode",
                            nikename, @"nicname",
                            nil];
    NSDictionary *map = [Api post:action params:params];
    
    ApiResult *iRet = [[ApiResult alloc] init];
    NSDictionary *data = [iRet parse:map];
    if (data.count > 0) {
        // 业务数据处理
    }
    return [iRet autorelease];
}

// 忘记密码, 密码重置
+ (ApiResult *)forget:(NSString *)username
              passwd:(NSString *)passwd
           newpasswd:(NSString *)newpasswd
            authcode:(NSString *)authcode {
    static NSString *action = API_URL_USERCENTER "/uc/m_resetpass.action";
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            API_INTERFACE_TONKEN, @"token",
                            username, @"username",
                            [Api base64e:passwd], @"password",
                            [Api base64e:newpasswd], @"newpassword",
                            authcode, @"checkcode",
                            nil];
    NSDictionary *map = [Api post:action params:params];
    ApiResult *iRet = [[ApiResult alloc] init];
    NSDictionary *data = [iRet parse:map];
    if (data.count > 0) {
        // 业务数据处理
    }
    return [iRet autorelease];
}

// 修改昵称
+ (ApiResult *)updateNikename:(NSString *)passwd
                    nikename:(NSString *)nikename{
    static NSString *action = API_URL_USERCENTER "/uc/m_modnicname.action";
    NSString *userId = [NSString valueOf:[Api userId]];
    NSString *pwd = [Api base64e:passwd];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            API_INTERFACE_TONKEN, @"token",
                            [Api base64e:passwd], @"sessionPassword",
                            userId, @"userid",
                            pwd, @"password",
                            nikename, @"nicname",
                            nil];
    NSDictionary *map = [Api post:action params:params];
    ApiResult *iRet = [[ApiResult alloc] init];
    NSDictionary *data = [iRet parse:map];
    if (data.count > 0) {
        // 业务数据处理
    }
    return [iRet autorelease];
}

// 修改密码
+ (ApiResult *)updatePassword:(NSString *)passwd
                   newpasswd:(NSString *)newpasswd {
    static NSString *action = API_URL_USERCENTER "/uc/m_modpass.action";
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            API_INTERFACE_TONKEN, @"token",
                            [Api base64e:passwd], @"sessionPassword",
                            [NSString valueOf:[Api userId]], @"userid",
                            [Api base64e:passwd], @"password",
                            [Api base64e:newpasswd], @"newpassword",
                            nil];
    NSDictionary *map = [Api post:action params:params];
    ApiResult *iRet = [[ApiResult alloc] init];
    NSDictionary *data = [iRet parse:map];
    if (data.count > 0) {
        // 业务数据处理
    }
    return [iRet autorelease];
}

// 我的码
+ (NSMutableArray *)codeMyList:(int)number
                           size:(int)size {
    static NSString *action = @"http://m.ifengzi.cn/mb" "/kma/m_getCodeList.action";
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            API_INTERFACE_TONKEN, @"token",
                            [Api base64e:[Api passwd]], @"sessionPassword",
                            [NSString valueOf:[Api userId]], @"userid",
                            [Api passwd], @"password",
                            [NSString valueOf:number], @"curPage",
                            [NSString valueOf:size], @"pageSize",
                            nil];
    NSDictionary *map = [Api post:action params:params];
    ApiResult *iRet = [[ApiResult alloc] init];
    NSDictionary *data = [iRet parse:map];
    NSMutableArray *aRet = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
    if (iRet.status == API_USERCENTET_SUCCESS && data.count > 0) {
        // 业务数据处理
        NSArray *codeList = [data objectForKey:@"codeList"];
        // 找到我的码数据区
        for (NSDictionary *dict in codeList) {
            CodeInfo *obj = [dict toObject:CodeInfo.class];
            [aRet addObject:obj];
        }
    }
    [iRet release];
    return aRet;
}


@end
