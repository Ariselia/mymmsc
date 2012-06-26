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
@synthesize nicname,contact,QQ,sex,email,likes,weibo,isopen,userid,address,modTime,regTime,birthday,postCode,realname,idNumber;

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

//--------------------< 用户中心 - 对象 - 留言板 >--------------------
@implementation ucComment

@synthesize commentDate, commentName, commentUserName, commentUserId, commentContent, id, userId, delFlag;

- (void)dealloc{
    [super dealloc];
}
@end

//--------------------< 用户中心 - 对象 - 数据统计 >--------------------
@implementation ucToal

@synthesize totalCount, codeCount;

@end

//====================================< 用户中心 >====================================

@implementation Api (UserCenter)

+ (ucLoginResult *)login:(NSString *)username passwd:(NSString *)passwd authcode:(NSString *)authcode{
    ucLoginResult *iRet = [[ucLoginResult alloc] init];
    static NSString *action = API_URL_Apps "/apps/login.action";
    authcode = [Api base64e:username];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            username, @"username",
                            [Api base64e:passwd], @"password",
                            nil];
    NSDictionary *map = [Api post:action params:params];
    NSDictionary *data = [iRet parse:map];
    if (data.count > 0) {
        [Api setUserPhone:username];
        for (NSString *key in [data allKeys]) {
            id value = [data objectForKey:key];
            if([key isSame:@"nikename"]) {
                [Api setNikeName:value];
            } else if([key isSame:@"userid"]) {
                
                NSNumber *t = value;
                [Api setUserId:t.intValue];
            } else if ([key isSame:@"token"]){
                [Api setToken:value];
            } else if ([key isSame:@"lastdate"]){
                
                [Api setLastdate:value];
            } else if ([key isSame:@"lastip"]){
                
                [Api setLastip:value];
            }
        }
    }
    return [iRet autorelease];
}

// 根据用户手机号码获取验证码, 理解为同时发短信给用户
+ (ucAuthCode *)authcodeWithName:(NSString *)username {
    ucAuthCode *iRet = [[ucAuthCode alloc] init];
    
    static NSString *action = API_URL_Apps "/apps/genCheckCode.action";
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
    
    static NSString *action = API_URL_Apps "/apps/genCheckCode.action";
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            phone, @"username",
                            [Api token], @"token",
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
    static NSString *action = API_URL_Apps "/apps/register.action";
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            username, @"username",
                            [Api base64e:passwd], @"password",
                            [Api base64e:passwd], @"repassword",
                            authcode, @"checkcode",
                            nikename, @"nikename",
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
    static NSString *action = API_URL_Apps"/apps/modPassword.action";
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            username, @"username",
                            [Api base64e:newpasswd], @"newpswd",
                            authcode,@"checkcode",
                            nil];
    NSDictionary *map = [Api post:action params:params];
    ApiResult *iRet = [[ApiResult alloc] init];
    NSDictionary *data = [iRet parse:map];
    if (data.count > 0) {
        // 业务数据处理
        for (NSString *key in [data allKeys]) {
            id value = [data objectForKey:key];
            if([key isSame:@"userid"]) {
                
                NSNumber *t = value;
                [Api setUserId:t.intValue];
            } else if ([key isSame:@"token"]){
                
                [Api setToken:value];
            } 
        }
        
        
    }
    return [iRet autorelease];}

// 修改昵称
+ (ApiResult *)updateNikename:(NSString *)nikename{
    static NSString *action = API_URL_Apps "/apps/modNikename.action";
    NSString *userId = [NSString valueOf:[Api userId]];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            API_INTERFACE_TONKEN, @"token",
                            userId, @"userid",
                            nikename, @"nikename",
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
    static NSString *action = API_URL_Apps "/apps/modPassword.action";
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [Api token], @"token",
                            [NSString valueOf:[Api userId]], @"userid",
                            [Api base64e:passwd], @"oldpswd",
                            [Api base64e:newpasswd], @"newpswd",
                            nil];
    NSDictionary *map = [Api post:action params:params];
    ApiResult *iRet = [[ApiResult alloc] init];
    NSDictionary *data = [iRet parse:map];
    if (data.count > 0) {
        // 业务数据处理
        for (NSString *key in [data allKeys]) {
            id value = [data objectForKey:key];
            if([key isSame:@"userid"]) {
                
                NSNumber *t = value;
                [Api setUserId:t.intValue];
            } else if ([key isSame:@"token"]){
                
                [Api setToken:value];
            } 
        }
        
        
    }
    return [iRet autorelease];
}

// 我的码
+ (NSMutableArray *)codeMyList:(int)number
                          size:(int)size {
    static NSString *action =  API_URL_Apps "/apps/listCode.action";
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSString valueOf:[Api userId]], @"userid",
                            [NSString valueOf:size], @"pagesize",
                            [NSString valueOf:number], @"pagenum",
                            nil];
    NSDictionary *map = [Api post:action params:params];
    ApiResult *iRet = [[ApiResult alloc] init];
    NSArray *data = (NSArray *)[iRet parse:map];
    NSMutableArray *aRet = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
    if (iRet.status == API_USERCENTET_SUCCESS && data.count > 0) {
        // 业务数据处理
        NSArray *codeList = data;
        // 找到我的码数据区
        for (NSDictionary *dict in codeList) {
            CodeInfo *obj = [dict toObject:CodeInfo.class];
            [aRet addObject:obj];
        }
    }
    [iRet release];
    return aRet;
}

// 获取用户个人信息
+ (ucUserInfo *)uc_userinfo_get:(int)userId{
    static NSString *action = API_URL_Apps "/apps/getUserInfo.action";
    //static NSString *action = @"http://devp.ifengzi.cn" "/uc/m_getUserDetailInfo.action";
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            API_INTERFACE_TONKEN, @"token",
                            [NSString valueOf:userId], @"userid",
                            nil];
    NSDictionary *map = [Api post:action params:params];
    ucUserInfo *iRet = [[ucUserInfo alloc] init];
    NSDictionary *data = [iRet parse:map];
    if (iRet.status == API_USERCENTET_SUCCESS && data.count > 0) {
        // 业务数据处理
        [data fillObject:iRet];
        //NSString *nn = [data objectForKey:@"nicname"];
        NSDictionary *info = [data objectForKey:@"userInfo"];
        if (info.count > 0) {
            [info fillObject:iRet];
        }
    }
    return [iRet autorelease];
}

+ (ApiResult *)uc_userinfo_set:(NSString *)realname
                           sex:(NSString *)sex
                         email:(NSString *)email
                      birthday:(NSString *)birthday
                      idNumber:(NSString *)idNumber
                       address:(NSString *)address
                      postCode:(NSString *)postCode
                         likes:(NSString *)likes
                        isopen:(NSString *)isopen
                         weibo:(NSString *)weibo
                            QQ:(NSString *)QQ
                       contact:(NSString *)contact {
    static NSString *action = API_URL_Apps "/apps/modUserInfo.action";
    if (realname == nil) realname = @"";
    if (sex == nil) sex = @"";
    if (email == nil) email = @"";
    if (birthday == nil) birthday = @"";
    if (idNumber == nil) idNumber = @"";
    if (address == nil) address = @"";
    if (postCode == nil) postCode = @"";
    if (likes == nil) likes = @"";
    if (QQ == nil) QQ = @"";
    if (weibo == nil) weibo = @"";
    if (contact == nil) contact = @"";
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [Api token], @"token",
                            [NSString valueOf:[Api userId]], @"userid",
                            realname, @"realname",
                            sex, @"sex",
                            email, @"email",
                            birthday, @"birthday",
                            idNumber, @"idNumber",
                            address, @"address",
                            postCode, @"postCode",
                            likes, @"likes",
                            isopen, @"isopen",
                            weibo, @"weibo",
                            QQ, @"QQ",
                            contact, @"contact",nil];
    NSDictionary *map = [Api post:action params:params];
    ApiResult *iRet = [[ApiResult alloc] init];
    NSDictionary *data = [iRet parse:map];
    if (data.count > 0) {
        //
    }
    return [iRet autorelease];
}

+ (ApiResult *)uc_userinfo_set:(ucUserInfo *)info {
    return [self uc_userinfo_set:info.realname sex:[NSString valueOf:info.sex] email:info.email birthday:info.birthday idNumber:info.idNumber address:info.address postCode:info.postCode likes:info.likes isopen:[NSString valueOf:info.isopen] weibo:info.weibo QQ:[NSString valueOf:info.QQ] contact:info.contact];
}

// 上传照片
+ (ApiResult *)uc_photo_post:(NSData *)buffer{
    ApiResult *iRet = [ApiResult new];
    static NSString *action = API_URL_Apps "/apps/modAvatar.action";
    [iOSApi showAlert:@"正在上传图片"];
    HttpClient *hc = [[HttpClient alloc] initWithURL:action timeout:10];
    NSString *filename = [NSString stringWithFormat:@"%d.jpg", [Api userId]];
    [hc formAddField:@"userid" value:[ NSString stringWithFormat:@"%010d",[Api userId]]];
    [hc formAddImage:@"content" filename:filename data:buffer];

//    [hc formAddImage:@"image" filename:filename data:buffer];
    NSData *response = [hc post];
    [iOSApi closeAlert];
    if (response == nil) {
        [iOSApi showCompleted:@"服务器正忙，请稍候重新登录。"];
    } else {
        // 取得JSON数据的字符串
        NSString *json_string = [[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding] autorelease];
        iOSLog(@"json.string = %@", json_string);
        // 把JSON转为数组
        NSDictionary *ret = [json_string objectFromJSONString];
        // 把JSON转为数组
        [iRet parse:ret];
        if (iRet.status == 0) {
            [iOSApi showCompleted:@"上传成功!"];
        } else {
            [iOSApi showCompleted:iRet.message];
        }
    }
    [hc release];
    [iOSApi closeAlert];
    
    return [iRet autorelease];
}

+ (NSString *)uc_photo_name:(int)userId{
    return [NSString stringWithFormat:@"%d.jpg", userId];
}

// 下载照片
+ (void)uc_photo_down:(int)userId{
    ApiResult *iRet = [ApiResult new];
    static NSString *action = API_URL_USERCENTER "/apps/avatar.cgi";
    [iOSApi showAlert:@"正在下载照片"];
    NSString *url = [NSString stringWithFormat:@"%@?id=%010d",action,userId];
    HttpClient *hc = [[HttpClient alloc] initWithURL:url timeout:10];
    NSString *filename = [NSString stringWithFormat:@"%d.jpg", userId];
    NSData *response = [hc post];
    [iOSApi closeAlert];
    if (response == nil) {
        [iOSApi showCompleted:@"服务器正忙，请稍候重新下载。"];
    } else {
          UIImage *p = [UIImage imageWithData:response];
          if (p) {
            NSString *filePath = [Api filePath:filename];
            NSFileHandle *fileHandle = [iOSFile create:filePath];
            [fileHandle writeData:response];
            [fileHandle closeFile];  
        } else {
            [iOSApi showCompleted:iRet.message];
        }
    }
    [hc release];
    [iRet release];
    [iOSApi closeAlert];
}

// 蜂巢留言板 
+ (NSMutableArray *)uc_comments_get:(int)number
                               size:(int)size {
    static NSString *action = API_URL_USERCENTER "/uc/m_findZoneComment.action";
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            API_INTERFACE_TONKEN, @"token",
                            [Api base64e:[Api passwd]], @"sessionPassword",
                            [NSString valueOf:[Api userId]], @"userId",
                            [NSString valueOf:number], @"curPage",
                            [NSString valueOf:size], @"pageSize",
                            nil];
    NSDictionary *map = [Api post:action params:params];
    ApiResult *iRet = [[ApiResult alloc] init];
    NSDictionary *data = [iRet parse:map];
    NSMutableArray *aRet = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
    if (iRet.status == API_USERCENTET_SUCCESS && data.count > 0) {
        // 业务数据处理
        NSArray *codeList = [data objectForKey:@"commentList"];
        // 找到我的码数据区
        for (NSDictionary *dict in codeList) {
            CodeInfo *obj = [dict toObject:ucComment.class];
            [aRet addObject:obj];
        }
    }
    [iRet release];
    return aRet;
}
//对个人空间发表评论
+ (ApiResult *)uc_comment_add:(int)userId
                      content:(NSString *)content{
    static NSString *action = API_URL_Apps "/apps/addZoneComment.action";
    NSString *date = [NSDate now];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            API_INTERFACE_TONKEN, @"token",
                            [NSString valueOf:userId], @"userId",
                            [NSString valueOf:[Api userId]], @"commentUserId",
                            [Api nikeName], @"commentName",
                            content, @"commentContent",
                            date, @"commentDate",
                            nil];
    NSDictionary *map = [Api post:action params:params];
    ApiResult *iRet = [[ApiResult alloc] init];
    NSDictionary *data = [iRet parse:map];
    if (data.count > 0) {
        // 业务数据处理
    }
    return [iRet autorelease];
}
//查看个人空间评论
+ (NSMutableArray *)uc_comment_list:(int)number size:(int)size
{
    static NSString *action = API_URL_Apps "/apps/listZoneComment.action";

    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
//                            API_INTERFACE_TONKEN, @"token",
                            [NSString valueOf:[Api userId]], @"userid",
//                            [NSString valueOf:[Api userId]], @"commentUserId",
//                            [Api nikeName], @"commentName",
//                            content, @"commentContent",
//                            date, @"commentDate",
                            [NSString valueOf:size], @"pagesize",
                            [NSString valueOf:number], @"pagenum",
                            nil];
    NSDictionary *map = [Api post:action params:params];
    ApiResult *iRet = [[ApiResult alloc] init];
    NSDictionary *data = [iRet parse:map];
    NSMutableArray *aRet = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];

    if (iRet.status == API_USERCENTET_SUCCESS && data.count > 0) {
        // 业务数据处理

        // 找到我的码数据区
        for (NSDictionary *dict in data) {
            CodeInfo *obj = [dict toObject:ucComment.class];
            [aRet addObject:obj];
        }
    }
    [iRet autorelease];
    return aRet;
}

+ (ucToal *)uc_total_get:(int)userId{
    static NSString *action = API_URL_Apps "/apps/getCodeCount.action";
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            API_INTERFACE_TONKEN, @"token",
                            [NSString valueOf:userId], @"userid",
                            nil];
    NSDictionary *map = [Api post:action params:params];
    ucToal *iRet = [[ucToal alloc] init];
    NSDictionary *data = [iRet parse:map];
    if (data.count > 0) {
        // 业务数据处理
        iRet.totalCount = [[data valueForKey:@"numscan"]intValue];
        iRet.codeCount = [[data valueForKey:@"numcode"]intValue];

    }
    return [iRet autorelease];
}

// 富媒体 评论列表
+ (NSMutableArray *)mb_comments_get:(NSString *)maId
                               page:(int)number
                               size:(int)size {
    static NSString *action = API_URL_Apps "/apps/listCodeComment.action";
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            API_INTERFACE_TONKEN, @"token",
                            [Api base64e:[Api passwd]], @"sessionPassword",
                            maId, @"codeid",
                            [NSString valueOf:number], @"pagenum",
                            [NSString valueOf:size], @"pagesize",
                            nil];
    NSDictionary *map = [Api post:action params:params];
    ApiResult *iRet = [[ApiResult alloc] init];
    NSDictionary *data = [iRet parse:map];
    NSMutableArray *aRet = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
    
    if (iRet.status == API_USERCENTET_SUCCESS && data.count > 0) {
        // 业务数据处理
       
        // 找到我的码数据区
        for (NSDictionary *dict in data) {
            CodeInfo *obj = [dict toObject:ucComment.class];
            [aRet addObject:obj];
        }
    }
    [iRet release];
    return aRet;
}

// 富媒体 增加评论
+ (ApiResult *)mb_comment_add:(NSString *)maId
                      content:(NSString *)content{
    static NSString *action = API_URL_Apps "/apps/addCodeComment.action";
    NSString *date = [NSDate now];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            API_INTERFACE_TONKEN, @"token",
                            maId, @"codeid",
                            [NSString valueOf:[Api userId]], @"commentUserId",
                            [Api nikeName], @"commentUserName",
                            content, @"commentContent",
                            date, @"commentDate",
                            nil];
    NSDictionary *map = [Api post:action params:params];
    ApiResult *iRet = [[ApiResult alloc] init];
    NSDictionary *data = [iRet parse:map];
    if (data.count > 0) {
        // 业务数据处理
    }
    return [iRet autorelease];
}

@end
