//
//  Api+RichMedia.h
//  FengZi
//
//  Created by WangFeng on 11-12-15.
//  Copyright (c) 2012年 mymmsc.org. All rights reserved.
//

#import "Api.h"

//====================================< 富媒体 - 接口 >====================================

//--------------------< 富媒体 - 对象 - 媒体信息类 >--------------------
@interface MediaInfo : ucResult {
    
    NSString *key;
    int type;
    NSString *tinyName;
}

@property (nonatomic, retain) NSString *key;
@property (nonatomic, assign) int type;
@property (nonatomic, retain) NSString *tinyName;

@end

//--------------------< 富媒体 - 对象 - 模板类 >--------------------
@interface ModelInfo : ucResult {
    NSString *mediaKey;
    NSString *url;
}

@property (nonatomic, retain) NSString *mediaKey;
@property (nonatomic, retain) NSString *url;

@end


//--------------------< 富媒体 - 接口 - 应用程序相关 >--------------------
@interface Api (RichMedia)

// 获得app属性信息串
+ (NSString *)appAttribute:(int)type;

+ (MediaInfo *)uploadImage:(NSData *)buffer;

// 上传模板
+ (ModelInfo *)uploadModel:(NSString *)title
                  content:(NSString *)content
                    sound:(NSString *)sound
                    vedio:(NSString *)vedio
                     type:(int)type
                     tiny:(NSString *)tiny;

//--------------------< 空码赋值 - 对象 - 接口 >--------------------

+ (void)kmaSetId:(NSString *)code;
+ (NSString *)kmaId;

+ (ucResult *)kmaUpload:(NSString *)pid
                   type:(int)type
                content:(NSString *)content;

+ (MediaInfo *)kmaRichMedia:(NSString *)pid;

+ (void)uploadKma:(NSString *)_content;

@end
