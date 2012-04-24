//
//  Api+UserCenter.h
//  FengZi
//
//  Created by WangFeng on 11-12-15.
//  Copyright (c) 2012年 mymmsc.org. All rights reserved.
//

#import "Api.h"
//====================================< 用户中心 - 开关 >====================================
// 用户中心接口调用正确的状态码
#define API_USERCENTET_SUCCESS (0)
// 页面验证码需要用户手机号码开关
#define UC_AUTHCODE_FROM_USERNAME (1)

#define UC_FILENAME_PHOTO @"my_photo.jpg"
//====================================< 用户中心 - 登录信息 >====================================

@interface ucLoginResult : ApiResult {
    NSString *userId; // 用户ID, 这个和用户是什么关系，没搞明白
}

@end

//--------------------< 用户中心 - 对象 - 个人信息 >--------------------
@interface ucUserInfo : ApiResult {
}
@property (nonatomic, copy) NSString *nicname;
@property (nonatomic, copy) NSString *contact;
@property (nonatomic, copy) NSString *birthday;
//@property (nonatomic, copy) NSString *QQ;
@property (nonatomic, assign) int QQ;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *idNumber;
@property (nonatomic, assign) int isopen;
@property (nonatomic, copy) NSString *likes;
@property (nonatomic, copy) NSString *modTime;
@property (nonatomic, copy) NSString *postCode;
@property (nonatomic, copy) NSString *realname;
@property (nonatomic, copy) NSString *regTime;
@property (nonatomic, assign) int sex;
@property (nonatomic, copy) NSString *userid;
@property (nonatomic, copy) NSString *weibo;
@end

//--------------------< 用户中心 - 对象 - 验证码 >--------------------
@interface ucAuthCode : ApiResult {
    NSString *code;
}

@property (nonatomic, retain) NSString *code;

@end

//--------------------< 用户中心 - 对象 - 我的码 >--------------------

@interface CodeInfo : NSObject {
    NSString *createTime; //2011-12-13T09:51:25
    NSString *key;
    NSString *title;
    NSString *url;
    int type;
}

@property (nonatomic, retain) NSString *createTime;
@property (nonatomic, retain) NSString *key;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *url;
@property (nonatomic, assign) int type;

@end

//--------------------< 用户中心 - 对象 - 留言板 >--------------------

@interface ucComment : NSObject {
    //
}

@property (nonatomic, copy) NSString *commentContent;
@property (nonatomic, copy) NSString *commentDate;
@property (nonatomic, copy) NSString *commentName;
@property (nonatomic, copy) NSString *commentUserName;
@property (nonatomic, assign) int commentUserId;
@property (nonatomic, assign) int delFlag, id, userId;

@end

//--------------------< 用户中心 - 对象 - 数据统计 >--------------------
@interface ucToal : ApiResult{
    //
}
@property (nonatomic, assign) int totalCount, codeCount;

@end

//====================================< 用户中心 >====================================
@interface Api (UserCenter)

+ (ucLoginResult *)login:(NSString *)username passwd:(NSString *)passwd authcode:(NSString *)authcode;

// 根据用户手机号码获取验证码, 理解为同时发短信给用户
+ (ucAuthCode *)authcodeWithName:(NSString *)username;

// 找回密码, 获取验证码
+ (ucAuthCode *)authcode:(NSString *)phone;

// 注册账号
+ (ApiResult *)createId:(NSString *)username
                 passwd:(NSString *)passwd
               authcode:(NSString *)authcode
               nikename:(NSString *)nikename;

// 忘记密码, 密码重置
+ (ApiResult *)forget:(NSString *)username
               passwd:(NSString *)passwd
            newpasswd:(NSString *)newpasswd
             authcode:(NSString *)authcode;

// 修改昵称
+ (ApiResult *)updateNikename:(NSString *)passwd
                     nikename:(NSString *)nikename;

// 修改密码
+ (ApiResult *)updatePassword:(NSString *)passwd
                    newpasswd:(NSString *)newpasswd;

// 我的码
+ (NSMutableArray *) codeMyList:(int)number
                           size:(int)size;

// 获取用户个人信息
+ (ucUserInfo *)uc_userinfo_get:(int)userId;

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
                       contact:(NSString *)contact;
+ (ApiResult *)uc_userinfo_set:(ucUserInfo *)info;

// 照片
+ (NSString *)uc_photo_name:(int)userId;

+ (ApiResult *)uc_photo_post:(NSData *)buffer;

// 下载照片
+ (void)uc_photo_down:(int)userId;

// 蜂巢留言板
+ (NSMutableArray *)uc_comments_get:(int)number
                               size:(int)size;

+ (ApiResult *)uc_comment_add:(int)userId
                      content:(NSString *)content;
// 查看统计数据
+ (ucToal *)uc_total_get:(int)userId;

// 富媒体 评论列表
+ (NSMutableArray *)mb_comments_get:(NSString *)maId
                               page:(int)number
                               size:(int)size;

// 富媒体 增加评论
+ (ApiResult *)mb_comment_add:(NSString *)maId
                      content:(NSString *)content;

@end
