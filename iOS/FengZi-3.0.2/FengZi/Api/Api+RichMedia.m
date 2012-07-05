//
//  Api+RichMedia.m
//  FengZi
//
//  Created by WangFeng on 11-12-15.
//  Copyright (c) 2012年 mymmsc.org. All rights reserved.
//

#import "Api+RichMedia.h"
#import <FengZi/BusDecoder.h>

//====================================< 富媒体 - 接口 >====================================
//#define API_CODE_PREFIX @"http://ifengzi.cn/show.cgi?"
//--------------------< 富媒体 - 对象 - 媒体信息类 >--------------------
@implementation MediaInfo

@synthesize key, type, tinyName;

- (void)dealloc{
    [key release];
    [tinyName release];
    
    [super dealloc];
}

@end

//--------------------< 富媒体 - 对象 - 模板类 >--------------------

@implementation ModelInfo
@synthesize mediaKey, url;

- (void)dealloc {
    [mediaKey release];
    [url release];
    
    [super dealloc];
}

@end

//--------------------< 富媒体 - 对象 - 内容类 >--------------------

@implementation MediaObject
@synthesize content, title, image, video, audio,picType;
@synthesize isSend, sendType, sendContent;

- (void)dealloc{
    IOSAPI_RELEASE(content);
    IOSAPI_RELEASE(title);
    IOSAPI_RELEASE(image);
    IOSAPI_RELEASE(audio);
    IOSAPI_RELEASE(video);
    IOSAPI_RELEASE(sendType);
    IOSAPI_RELEASE(sendContent);
    
    [super dealloc];
}

@end

//--------------------< 富媒体 - 对象 - 内容类 >--------------------
@implementation MediaContent

@synthesize title,content,pagelist,audio;
@synthesize isSend, sendType, sendContent;

- (void)dealloc{
    IOSAPI_RELEASE(title);
    IOSAPI_RELEASE(content);
    IOSAPI_RELEASE(pagelist);
    IOSAPI_RELEASE(audio);
    
    IOSAPI_RELEASE(sendType);
    IOSAPI_RELEASE(sendContent);
    
    [super dealloc];
}

@end

//--------------------< 富媒体 - 对象 - 空码内容类 >--------------------
@implementation KmaObject

@synthesize type, isKma, tranditionContent, mediaContent, mediaObj;

@end

//--------------------< 空码 - 对象 - 顺风车 >--------------------
@implementation RidePath

@synthesize shour,sminut,drvpath,destaddr,startaddr;

@end

@implementation RideReal

@synthesize his,decl,carimg,drvage,gender,cartype,headimg,carcolor,carplate,realname,carseries;

@end

@implementation RideInfo

@synthesize status, info, drvList, psgList, real;

@end

//--------------------< 富媒体 - 接口 - 应用程序相关 >--------------------
@implementation Api (RichMedia)

// 获得app属性信息串
+ (NSString *)appAttribute:(int)type{
   NSString *sRet = [NSString stringWithFormat:@"imei=%@&type=%d&loc=%@", @"", type, DATA_ENV.curLocation];
    return sRet;
}

// 上传图片
+ (MediaInfo *)uploadImage:(NSData *)buffer{
    //static NSString *path = @"dynamic/m_picUpload.action";
    //NSString *action = [NSString stringWithFormat:@"%@/%@?userid=%d", API_URL_RICHMEDIA, path, [Api userId]];
    
      NSString *action = [NSString stringWithFormat:@"%@%s?userid=%d", API_APPS_SERVER, API_FILE_UPLOAD, [Api userId]];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            buffer, @"mediaContent",
                            nil];
    
    NSDictionary *map = [Api post:action params:params];
    MediaInfo *iRet = [[MediaInfo alloc] init];
    NSDictionary *data = [iRet parse:map];
    if (data.count > 0) {
        NSString *value = [data objectForKey:@"key"];
        if (value != nil) {
            iRet.key = value;
        }
        iRet.tinyName = [data objectForKey:@"tinyKey"];
        iRet.type = [Api getInt:[data objectForKey:@"type"]];
    }
    
    return [iRet autorelease];
}

// 上传音频文件
+ (ApiResult *)uploadAudio:(NSString *)filename
                     type:(NSString *)type {
    ApiResult *iRet = [ApiResult new];
    
    
    
    return [iRet autorelease];
}

// 上传Flash
+ (ApiResult *)uploadFlash:(NSString *)filename
                     type:(NSString *)type {
    ApiResult *iRet = [ApiResult new];
    
    
    
    return [iRet autorelease];
}

// 上传视频
+ (ApiResult *)uploadMovie:(NSString *)filename
                     type:(NSString *)type {
    ApiResult *iRet = [ApiResult new];
    
    return [iRet autorelease];
}


// 上传模板
+ (ModelInfo *)uploadModel:(NSString *)title
                   content:(NSString *)content
                       url:(NSString *)url
                      type:(int)type
                      uuid:(NSString *)uuid
{

    // 数据准备
    NSMutableDictionary *jsonDic = [NSMutableDictionary dictionary];
   
    [jsonDic setObject:title forKey:@"title"];
    [jsonDic setObject:content forKey:@"content"];
    [jsonDic setObject:@"" forKey:@"audio"]; 
    
    if ([Api kma]) {
       
    [jsonDic setObject:uuid forKey:@"codeid"];
    }
        
    NSMutableArray *pageList = [NSMutableArray array];
    NSMutableDictionary *media = [NSMutableDictionary dictionary];
    [media setObject:title forKey:@"title"];
    [media setObject:content forKey:@"content"];
    switch (type)
    {
        case 1:
    [media setObject:url forKey:@"audio"];
        break;
        case 2:
    [media setObject:url forKey:@"image"];
        break;
        case 4:
    [media setObject:url forKey:@"video"];
        break;
    
        default:
        break;
    }                     
    
    [pageList addObject:media];
    
    [jsonDic setObject:pageList forKey:@"pagelist"];

    NSString *serv =API_APPS_SERVER;
    
    NSString *path = @"apps/MakeCode.action";
    NSString *action;
    if ([Api kma]) {
        
    action = [NSString stringWithFormat:@"%@%@?userid=%d&type=30", serv, path, [Api userId]];
    } else {
     action = [NSString stringWithFormat:@"%@%@?userid=%d&type=14", serv, path, [Api userId]];
    }
    NSString *jsonStr = [jsonDic JSONString];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            uuid, @"codeid",
                            jsonStr, @"content",
                            title,@"title",
                            nil];
    
    NSDictionary *map = [Api post:action params:params];
    ModelInfo *iRet = [[ModelInfo alloc] init];
    NSDictionary *data = [iRet parse:map];
    if (data.count > 0) {
        NSString *value = [data objectForKey:@"type"];
        if (value != nil) {
            iRet.mediaKey = value;
        }
        
        if ([Api kma]) {
            path = API_APPS_SERVER API_MAKE_CODE;
            iRet.url = [NSString stringWithFormat:@"%@?id=%@", path, uuid];
        } else {
             iRet.url = [data objectForKey:@"codeid"];
        }
    }
 
    return [iRet autorelease];
}

// 获取媒体内容
+ (MediaContent *)getContent:(NSString *)uuid{

    NSString *action = [NSString stringWithFormat:@"%@?id=%@", API_APPS_SERVER API_GET_CODE, uuid];
    
    NSString *app = [Api base64e:[Api appAttribute:DATA_ENV.curBusinessType]];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            uuid, @"codeid",
                            app, @"a",
                            nil];
    
    NSDictionary *map = [Api post:action params:params];
    MediaContent *iRet = [[MediaContent alloc] init];
    
    NSDictionary *data = [iRet parse:map];
    if (data.count > 0) {
        NSString *value = [data objectForKey:@"title"];
        NSString *content = [data objectForKey:@"content"];
//        BOOL            isSend;      // 富媒体是否跳转
//        NSString       *sendType;    // 跳转类型
//        NSString       *sendContent; // 跳转内容
        NSString *sendContent = [data objectForKey:@"sendContent"];
        NSString *isSend = [data objectForKey:@"isSend"];
        NSString *sendType =[NSString stringWithFormat:@"%d", [Api getInt:[data objectForKey:@"sendType"]]];
        
        if(isSend!=nil)
        {
            iRet.isSend = YES;
        }
        
        if(sendContent!=nil)
        {
            iRet.sendContent = sendContent;
        }

        
        if(sendType!=nil)
        {
            iRet.sendType = sendType;
        }

        
        if (value != nil) {
            iRet.title = value;
        } else {
            iRet.title = @"题目";
        }
        
        if (content != nil) {
            iRet.content = content;
        } else {
            iRet.content = @"内容：";
        }
        
        iRet.audio =  [data objectForKey:@"audio"];
            
        NSArray *pagelist = [data objectForKey:@"pagelist"];
        if (pagelist.count > 0) {
            iRet.pagelist = [pagelist toList:MediaObject.class];
        }
        else {
         NSArray *pageList = [data objectForKey:@"pageList"];
          iRet.pagelist = [pageList toList:MediaObject.class];  
            
        }
    }
    
    return [iRet autorelease];
}


//--------------------< 空码赋值 - 对象 - 接口 >--------------------
static NSString *kma_id = nil;

+ (void)kmaSetId:(NSString *)code {
    if (kma_id != nil) {
        [kma_id release];
        kma_id = nil;
    }
    kma_id = [[NSString alloc] initWithString:code];
}

+ (NSString *)kmaId {
    return  kma_id;
}

/**
 * 空码扫码, 确定业务及内容
 * 参数url, 如果是码id, 则以默认的主机
 */
+ (KmaObject *)kmaContent:(NSString *)url {
    static NSString *path = @"kma/getContent.action";
    
    NSString *app = [Api base64e:[Api appAttribute:DATA_ENV.curBusinessType]];
    NSString *action = nil;
    if ([url hasPrefix:@"http://"]) {
        action = url;
    } else {
        // 如果不是URL, 则认为是空码ID
        action = [NSString stringWithFormat:@"%@/%@?id=%@", API_APPS_SERVER, path, url];
       // action = [NSString stringWithFormat:@"%@%@?id=%@", API_RICHMEDIA_SERVER, path, url];
    }
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSString valueOf:[Api userId]], @"userid",
                            app, @"a",
                            nil];
    
    NSDictionary *map = [Api post:action params:params];
    KmaObject *iRet = [KmaObject new];
    iRet.type = API_KMA_INVAILD;
    NSDictionary *data = [iRet parse:map];
    if (data.count > 0) {
        // 填充对象数值
        [data fillObject:iRet];
        if (iRet.type == 14) {
            // 富媒体
            NSDictionary *mo = [data objectForKey:@"mediacontent"];
            MediaContent *media = [mo toObject:MediaContent.class];
            if (media.title == nil) {
                media.title = @"富媒体 内容";
            }
            NSArray *pageList = [mo objectForKey:@"pagelist"];
            if (pageList.count > 0) {
                media.status = iRet.status;
                media.pagelist = [pageList toList:MediaObject.class];
            }
            iRet.mediaObj = media;
        }
    }
    
    return [iRet autorelease];
}

+ (ApiResult *)kmaUpload:(NSString *)pid
                   type:(int)type
                content:(NSString *)content{
    NSString *action = [NSString stringWithFormat:@"%@", API_APPS_SERVER API_MAKE_CODE];
    BaseModel *bm = [[Api parse:content timeout:30] retain];
    int types = bm.typeId;
    NSString *title = @"";
    if (types == kModelUrl) {
        Url *object = (Url *)bm;
        title = object.content;        
    } else if(types == kModelBookMark) {
        BookMark *object = (BookMark *)bm;
        title = object.title;
    } else if(types == kModelAppUrl) {
        AppUrl *object = (AppUrl *)bm;
        title = object.title;
    } else if(types == kModelWeibo) {
        Weibo *object = (Weibo *)bm;
        title = object.title;
    } else if(types == kModelCard) {
        Card *object = (Card *)bm;
        title = object.name;
    } else if(types == kModelPhone) {
        Phone *object = (Phone *)bm;
        title = object.telephone;
    } else if(types == kModelEmail) {
        Email *object = (Email *)bm;
        title = object.title;
    }  else if(types == kModelText) {
        Text *object = (Text *)bm;
        title = object.content;
    } else if(types == kModelEncText) {
        //EncText *object = (EncText *)bm;
        title = @"加密文本";
    } else if(types == kModelShortMessage) {
        ShortMessage *object = (ShortMessage *)bm;
        title = object.content;        
    } else if(types == kModelWiFiText) {
        WiFiText *object = (WiFiText *)bm;
        title = object.name;
    } else if(types == kModelGMap) {
        GMap *object = (GMap *)bm;
        title = object.url;
    } else if(types == kModelSchedule) {
        Schedule *object = (Schedule *)bm;
        title = object.title;
    }
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSString valueOf:[Api userId]], @"userid",
                            pid, @"codeid",
                            [NSString valueOf:type+16], @"type",
                            content, @"content",
                            title,@"title",
                            nil];
    
    NSDictionary *map = [Api post:action params:params];
    ApiResult *iRet = [[ApiResult alloc] init];
    NSDictionary *data = [iRet parse:map];
    if (data.count > 0) {
        // 业务数据处理
    }
    [bm release];
    return [iRet autorelease];
}

+ (void)uploadKma:(NSString *)content{
    // 视图加载完毕, 上传业务信息
    [iOSApi showAlert:@"正在上传赋值信息..."];    
    NSString *str = [content substringFromIndex:[API_CODE_PREFIX length]];
    NSString *msg = str;
    ApiResult *iRet = [Api kmaUpload:[Api kmaId] type:DATA_ENV.curBusinessType content:msg];
    if (iRet.status == 0) {
        [iOSApi Alert:@"空码赋值 提示" message:@"上传成功"];
    } else {
        [iOSApi Alert:@"空码赋值 提示" message:iRet.message];
        //[iOSApi Alert:@"空码赋值 提示" message:@"上传成功"];
    }
    [iOSApi closeAlert];
}

//--------------------< 空码 - 接口 - 顺风车 >--------------------

+ (RideInfo *)sfc_info:(NSString *)id{
    RideInfo *oRet = [[RideInfo alloc] init];
    static NSString *method = @"info";
    NSString *query = [NSString stringWithFormat:@"id=%@", id];
    NSString *action = [NSString stringWithFormat:@"%@/%@?%@", API_URL_RIDE, method, query];
    NSDictionary *response = [Api post:action params:nil];
#if 0
    // 增加测试数据
    if(response == nil) {
        NSString *s = @"{\"info\":{\"data\":{\"drvlist\":[{\"destaddr\":\"%E8%A5%BF%E5%B1%B1\",\"drvpath\":\"%E6%98%86%E5%B1%B1-%E8%8B%8F%E5%B7%9E-%E8%A5%BF%E5%B1%B1\",\"startaddr\":\"%E6%98%86%E5%B1%B1\",\"shour\":7,\"sminut\":0},{\"destaddr\":\"%E6%BB%A8%E6%B5%B7\",\"drvpath\":\"%E4%B8%9C%E5%8F%B0-%E5%A4%A7%E4%B8%B0-%E6%BB%A8%E6%B5%B7\",\"startaddr\":\"%E4%B8%9C%E5%8F%B0\",\"shour\":7,\"sminut\":30},{\"destaddr\":\"%E9%A1%BA%E4%B9%89\",\"drvpath\":\"%E6%B7%80%E6%B5%B7-%E5%97%A8%E5%97%A8-%E9%A1%BA%E4%B9%89\",\"startaddr\":\"%E6%B7%80%E6%B5%B7\",\"shour\":8,\"sminut\":0},{\"destaddr\":\"%E4%BA%94%E6%A3%B5%E6%9D%BE\",\"drvpath\":\"%E4%BA%94%E9%81%93%E5%8F%A3-%E4%BA%94%E6%A3%B5%E6%9D%BE\",\"startaddr\":\"%E4%BA%94%E9%81%93%E5%8F%A3\",\"shour\":9,\"sminut\":20}],\"psglist\":[{\"destaddr\":\"%E8%8B%8F%E5%B7%9E\",\"startaddr\":\"%E6%98%86%E5%B1%B1\",\"shour\":7,\"sminut\":0},{\"destaddr\":\"%E4%BA%94%E9%81%93%E5%8F%A3\",\"startaddr\":\"%E4%BA%94%E6%A3%B5%E6%9D%BE\",\"shour\":9,\"sminut\":30},{\"destaddr\":\"%E5%BC%A0%E5%AE%B6%E6%B8%AF\",\"startaddr\":\"%E6%98%86%E5%B1%B1\",\"shour\":9,\"sminut\":0}],\"real\":{\"carcolor\":\"red\",\"carimg\":\"http%3A%2F%2Flocalhost%3A8080%2Fsfc%2FUploadImg%2F20120411%2Fdbdeca07-3bca-4c62-873b-4c02dcdb6c39.jpg\",\"carplate\":\"de12232\",\"carseries\":121212,\"cartype\":121212,\"decl\":\"%E4%BD%A0%E6%95%A2%E6%8B%BC%EF%BC%8C%E6%88%91%E6%95%A2%E6%8E%A5%EF%BC%81\",\"drvage\":12,\"gender\":2,\"headimg\":\"http%3A%2F%2Flocalhost%3A8080%2Fsfc%2FUploadImg%2F20120411%2Fe672204a-c90a-418d-b5d0-2fb646ab17c5.jpg\",\"his\":\"%E6%B1%82%E6%8B%BC%E8%BD%A6%EF%BC%8C%E6%B1%82%E6%8B%BC%E8%BD%A6\",\"realname\":\"%E8%AE%B8%E8%BF%9B\"}},\"info\":\"\",\"status\":0}}";
        response = [s objectFromJSONString];
    }
#endif
    if (response) {
        [response fillObject:oRet];
        NSDictionary *data1 = [response objectForKey:method];
        if (data1.count > 0) {
            NSDictionary *data = [data1 objectForKey:@"data"];
            if(data.count > 0) {
                // 加载车找人
                NSMutableArray *srvList = [data objectForKey:@"drvlist"];
                oRet.drvList = [srvList toList:RidePath.class];
                srvList = [data objectForKey:@"psglist"];
                oRet.psgList = [srvList toList:RidePath.class];
                NSDictionary *real = [data objectForKey:@"real"];
                oRet.real = [real toObject:RideReal.class];
            }
        }
    }
    
    return [oRet autorelease];
}

@end
