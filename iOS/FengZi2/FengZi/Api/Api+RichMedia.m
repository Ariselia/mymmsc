//
//  Api+RichMedia.m
//  FengZi
//
//  Created by WangFeng on 11-12-15.
//  Copyright (c) 2012年 mymmsc.org. All rights reserved.
//

#import "Api+RichMedia.h"
//====================================< 富媒体 - 接口 >====================================

#define API_RICHMEDIA_TOKEN @"uLN9UhI9Uhd-UhGGuh78uQ"

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

@synthesize textContent, soundUrl, picType, tinyPicUrl, mediaUrl;

@end

//--------------------< 富媒体 - 对象 - 内容类 >--------------------
@implementation MediaContent

@synthesize title, pageList;

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

/*
 //获得要发送的扫描信息的AppAttribute
 public String getAppAttribute(){
 PhotoUtil phoneutil = new PhotoUtil(this);
 
 StringBuffer appAttribute = new StringBuffer();
 //		appAttribute.append("imei=");
 appAttribute.append(phoneutil.getImei());
 appAttribute.append("&type=");
 appAttribute.append(Globals.TYPE); 
 appAttribute.append("&loc=");
 appAttribute.append(new SharedPreferencesUtil(this).getGeoPoint());//存放当前位置坐标
 
 return appAttribute.toString();
 }
*/

// 获得app属性信息串
+ (NSString *)appAttribute:(int)type{
   NSString *sRet = [NSString stringWithFormat:@"imei=%@&type=%d&loc=%@", @"", type, DATA_ENV.curLocation];
    return sRet;
}

// 上传图片
+ (MediaInfo *)uploadImage:(NSData *)buffer{
    static NSString *path = @"dynamic/m_picUpload.action";
    NSString *action = [NSString stringWithFormat:@"%@/%@?userid=%d", API_URL_RICHMEDIA, path, [Api userId]];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            API_RICHMEDIA_TOKEN, @"token",
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
                     sound:(NSString *)sound
                     vedio:(NSString *)vedio
                      type:(int)type
                      tiny:(NSString *)tiny
                      uuid:(NSString *)uuid{
    /*
    {
        "totalCount": 1,
        "title": 1,
        "pageList": [{
            “title”:,
            “textContent”:,
            “soundName”:,
            “vedioName”:
            “type”:,
            “tinyName”:
		}]
    */
     
    // 数据准备
    NSMutableDictionary *jsonDic = [NSMutableDictionary dictionary];
    //[jsonDic setObject:[NSNumber numberWithInt:1] forKey:@"totalCount"];
    [jsonDic setObject:@"1" forKey:@"totalCount"];
    [jsonDic setObject:title forKey:@"title"];
    
    NSMutableArray *pageList = [NSMutableArray array];
    NSMutableDictionary *media = [NSMutableDictionary dictionary];
    [media setObject:content forKey:@"textContent"];
    [media setObject:sound forKey:@"soundName"];
    [media setObject:vedio forKey:@"vedioName"];
    //[media setObject:[NSNumber numberWithInt:type] forKey:@"type"];
    [media setObject:[NSString valueOf:type] forKey:@"type"];
    [media setObject:tiny forKey:@"tinyName"];
    [pageList addObject:media];
    [jsonDic setObject:pageList forKey:@"pageList"];
    
    NSString *path = @"dynamic/m_uploadMediaInfo.action";
    if ([Api kma]) {
        path = @"kma/m_uploadMediaInfo.action";
    }
    NSString *action = [NSString stringWithFormat:@"%@/%@?userid=%d", API_URL_RICHMEDIA, path, [Api userId]];
    NSString *jsonStr = [jsonDic JSONString];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            API_RICHMEDIA_TOKEN, @"token",
                            uuid, @"id",
                            [Api base64e:[Api passwd]], @"sessionPassword",
                            jsonStr, @"mediaContent",
                            nil];
    
    NSDictionary *map = [Api post:action params:params];
    ModelInfo *iRet = [[ModelInfo alloc] init];
    NSDictionary *data = [iRet parse:map];
    if (data.count > 0) {
        NSString *value = [data objectForKey:@"mediaKey"];
        if (value != nil) {
            iRet.mediaKey = value;
        }
        iRet.url = [data objectForKey:@"url"];
        
    }
    if (iRet.url == nil || iRet.url.length < 5) {
        path = API_URL_RICHMEDIA "dynamic/getContent.action";
        if ([Api kma]) {
            path = API_URL_KMA "kma/getContent.action";
        }
        iRet.url = [NSString stringWithFormat:@"%@?id=$@", path, uuid];
    }
    /*
    if (iRet.url == nil) {
        // 服务器异常, 此处模拟数据
        iRet.url = [[NSString alloc] initWithString:@"http://m.fengxiafei.com/mb/dynamic/getContent.action?id=test_mediakey"];
        iRet.status = 0;
    }
     */
    return [iRet autorelease];
}

// 获取媒体内容
+ (MediaContent *)getContent:(NSString *)uuid{
    static NSString *path = @"dynamic/getContent.action";
    NSString *action = [NSString stringWithFormat:@"%@/%@?userid=%d", API_URL_RICHMEDIA, path, [Api userId]];
    NSString *app = [Api base64e:[Api appAttribute:DATA_ENV.curBusinessType]];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            API_RICHMEDIA_TOKEN, @"token",
                            uuid, @"id",
                            app, @"a",
                            nil];
    
    NSDictionary *map = [Api post:action params:params];
    MediaContent *iRet = [[MediaContent alloc] init];
    NSDictionary *data = [iRet parse:map];
    if (data.count > 0) {
        NSString *value = [data objectForKey:@"title"];
        
        if (value != nil) {
            iRet.title = value;
        } else {
            iRet.title = @"富媒体 内容";
        }
        NSArray *pageList = [data objectForKey:@"pageList"];
        if (pageList.count > 0) {
            NSMutableArray *list = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
            iRet.pageList = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
            for (NSDictionary *dict in pageList) {
                MediaObject *obj = [MediaObject new];
                for (NSString *key in [dict allKeys]) {
                    id value = [dict objectForKey:key];
                    [obj setValue:value forSameKey:key];
                }
                [list addObject:obj];
                [obj release];
            }
            iRet.pageList = list;
        }
    }
    
    return [iRet autorelease];
}

// 获取媒体内容
+ (MediaContent *)getContent_new:(NSString *)uuid{
    static NSString *path = @"dynamic/getContent.action";
    NSString *action = [NSString stringWithFormat:@"%@/%@?id=%@", API_URL_RICHMEDIA, path, uuid];
    NSString *app = [Api base64e:[Api appAttribute:DATA_ENV.curBusinessType]];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            API_RICHMEDIA_TOKEN, @"token",
                            [NSString valueOf:[Api userId]], @"userid",
                            app, @"a",
                            nil];
    
    NSDictionary *map = [Api post:action params:params];
    MediaContent *iRet = [[MediaContent alloc] init];
    NSDictionary *data = [iRet parse:map];
    if (data.count > 0) {
        NSString *value = [data objectForKey:@"title"];
        
        if (value != nil) {
            iRet.title = value;
        } else {
            iRet.title = @"富媒体 内容";
        }
        NSArray *pageList = [data objectForKey:@"pageList"];
        if (pageList.count > 0) {
            NSMutableArray *list = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
            iRet.pageList = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
            for (NSDictionary *dict in pageList) {
                MediaObject *obj = [MediaObject new];
                for (NSString *key in [dict allKeys]) {
                    id value = [dict objectForKey:key];
                    [obj setValue:value forSameKey:key];
                }
                [list addObject:obj];
                [obj release];
            }
            iRet.pageList = list;
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

// 空码扫码, 确定业务及内容
+ (KmaObject *)kmaContent:(NSString *)pid {
    static NSString *path = @"kma/getContent.action";
    NSString *action = [NSString stringWithFormat:@"%@/%@?userid=%d", API_URL_KMA, path, [Api userId]];
    
    NSString *app = [Api base64e:[Api appAttribute:DATA_ENV.curBusinessType]];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            API_RICHMEDIA_TOKEN, @"token",
                            pid, @"id",
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
            MediaContent *media = [[[MediaContent alloc] init] autorelease];
            NSDictionary *mo = [data objectForKey:@"mediacontent"];
            NSString *value = [mo objectForKey:@"title"];
            
            if (value != nil) {
                media.title = value;
            } else {
                media.title = @"富媒体 内容";
            }
            NSArray *pageList = [mo objectForKey:@"pageList"];
            if (pageList.count > 0) {
                NSMutableArray *list = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
                media.pageList = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
                for (NSDictionary *dict in pageList) {
                    MediaObject *obj = [MediaObject new];
                    for (NSString *key in [dict allKeys]) {
                        id value = [dict objectForKey:key];
                        [obj setValue:value forSameKey:key];
                    }
                    [list addObject:obj];
                    [obj release];
                }
                media.status = iRet.status;
                media.pageList = list;
            }
            iRet.mediaObj = media;
        }
    }
    
    return [iRet autorelease];
}

+ (ApiResult *)kmaUpload:(NSString *)pid
                   type:(int)type
                content:(NSString *)content{
    // http://m.fengxiafei.com/mb/kma/m_uploadTraditionInfo.action
    static NSString *path = @"kma/m_uploadTraditionInfo.action";
    NSString *action = [NSString stringWithFormat:@"%@/%@?userid=%d", API_URL_RICHMEDIA, path, [NSString valueOf:[Api userId]]];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            API_RICHMEDIA_TOKEN, @"token",
                            [NSString valueOf:[Api userId]], @"userid",
                            [Api base64e:[Api passwd]], @"sessionPassword",
                            [Api base64e:[Api passwd]], @"password",
                            pid, @"id",
                            [NSString valueOf:type+1], @"type",
                            content, @"tranditionContent",
                            nil];
    
    NSDictionary *map = [Api post:action params:params];
    ApiResult *iRet = [[ApiResult alloc] init];
    NSDictionary *data = [iRet parse:map];
    if (data.count > 0) {
        // 业务数据处理
    }
    return [iRet autorelease];
}

+ (void)uploadKma:(NSString *)_content{
    // 视图加载完毕, 上传业务信息
    [iOSApi showAlert:@"上传空码赋值信息"];
    NSString *msg = _content;
    ApiResult *iRet = [Api kmaUpload:[Api kmaId] type:DATA_ENV.curBusinessType content:msg];
    if (iRet.status == 0) {
        //[iOSApi Alert:@"空码赋值 提示" message:@"上传成功"];
    } else {
        //[iOSApi Alert:@"空码赋值 提示" message:iRet.message];
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
