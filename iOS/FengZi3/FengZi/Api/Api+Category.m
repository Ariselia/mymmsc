//
//  Api+Category.m
//  FengZi
//
//  Created by wangfeng on 12-4-22.
//  Copyright (c) 2012年 fengxiafei.com. All rights reserved.
//

#import "Api+Category.h"
// 所有词条
//--------------------< 业务类型 - 对象 - 基础业务模型 >--------------------
@implementation BaseModel

@synthesize typeId, logId;

- (id)init{
    if(!(self = [super init])) {
		return self;
	}
    if (typeId <= 0) {
        Class clazz = [self class];
        if (clazz == Url.class) {
            typeId = kModelUrl;
        } else if (clazz == BookMark.class) {
            typeId = kModelBookMark;
        } else if (clazz == AppUrl.class) {
            typeId = kModelAppUrl;
        } else if (clazz == Weibo.class) {
            typeId = kModelWeibo;
        } else if (clazz == Card.class) {
            typeId = kModelCard;
        } else if (clazz == Email.class) {
            typeId = kModelEmail;
        } else if (clazz == Phone.class) {
            typeId = kModelPhone;
        } else if (clazz == Text.class) {
            typeId = kModelText;
        } else if (clazz == EncText.class) {
            typeId = kModelEncText;
        } else if (clazz == ShortMessage.class) {
            typeId = kModelShortMessage;
        } else if (clazz == WiFiText.class) {
            typeId = kModelWiFiText;
        } else if (clazz == GMap.class) {
            typeId = kModelGMap;
        } else if (clazz == Schedule.class) {
            typeId = kModelSchedule;
        } else if (clazz == RichMedia.class) {
            typeId = kModelRichMedia;
        } else if (clazz == Ride.class) {
            typeId = kModelRide;
        } else {
            typeId = kModelText;
        }
    }
	
	return self;
}

+ (Class)getType:(BusinessType)codeType{
    Class clazz = nil;
    switch (codeType) {
		case kModelUrl:
			// 01-URL
			clazz = Url.class;
			break;
		case kModelBookMark:
			// 02-书签
			clazz = BookMark.class;
			break;
		case kModelAppUrl:
			// 03-应用程序链接地址
			clazz = AppUrl.class;
			break;
		case kModelWeibo:
			// 04-微博
			clazz = Weibo.class;
			break;
		case kModelCard:
			// 05-名片
			clazz = Card.class;
			break;
		case kModelPhone:
			// 06-电话号码
			clazz = Phone.class;
			break;
		case kModelEmail:
			// 07-电子邮件
			clazz = Email.class;
			break;
		case kModelText:
			// 08-文本
			clazz = Text.class;
			break;
		case kModelEncText:
			// 09-名片
			clazz = EncText.class;
			break;
		case kModelShortMessage:
			// 0A-短信
			clazz = ShortMessage.class;
			break;
		case kModelWiFiText:
			// 0B-WIFI
			clazz = WiFiText.class;
			break;
		case kModelGMap:
			// 0C-地图
			clazz = GMap.class;
			break;
		case kModelSchedule:
			// 0D-日程
			clazz = Schedule.class;
			break;
		case kModelRichMedia:
			// 0E-富媒体
			clazz = RichMedia.class;
			break;
		case kModelRide:
			// 0F-顺风车
			clazz = Ride.class;
			break;
		default:
			// 默认
			break;
    }
    return clazz;
}

- (NSString *)typeName {
    NSString *sRet = @"未知码类型";
    if (typeId >= 0) {
        Class clazz = [self class];
        if (clazz == Url.class) {
            sRet = @"网站链接";
        } else if (clazz == BookMark.class) {
            sRet = @"书签";
        } else if (clazz == AppUrl.class) {
            sRet = @"应用程序下载地址";
        } else if (clazz == Weibo.class) {
            sRet = @"微博";
        } else if (clazz == Card.class) {
            sRet = @"名片";
        } else if (clazz == Email.class) {
            sRet = @"电子邮件";
        } else if (clazz == Phone.class) {
            sRet = @"电话号码";
        } else if (clazz == Text.class) {
            sRet = @"文本";
        } else if (clazz == EncText.class) {
            sRet = @"加密文本";
        } else if (clazz == ShortMessage.class) {
            sRet = @"短信";
        } else if (clazz == WiFiText.class) {
            sRet = @"WiFi";
        } else if (clazz == GMap.class) {
            sRet = @"地图信息";;
        } else if (clazz == Schedule.class) {
            sRet = @"日程";
        } else if (clazz == RichMedia.class) {
            sRet = @"富媒体";
        } else if (clazz == Ride.class) {
            sRet = @"顺风车";
        } else {
            sRet = @"文本";
        }
    }
    return sRet;
}

- (void)dealloc{
    IOSAPI_RELEASE(logId);
    [super dealloc];
}

@end

@implementation ITTBaseModelObject

- (id)initWithDataDic:(NSDictionary*)data{
	if (self = [super init]) {
		[self setAttributes:data];
	}
	return self;
}

- (NSDictionary*)attributeMapDictionary{
	return nil;
}

- (SEL)getSetterSelWithAttibuteName:(NSString*)attributeName{
	NSString *capital = [[attributeName substringToIndex:1] uppercaseString];
	NSString *setterSelStr = [NSString stringWithFormat:@"set%@%@:",capital,[attributeName substringFromIndex:1]];
	return NSSelectorFromString(setterSelStr);
}

- (NSString *)customDescription{
	return nil;
}

- (NSString *)description{
	NSMutableString *attrsDesc = [NSMutableString stringWithCapacity:100];
	NSDictionary *attrMapDic = [self attributeMapDictionary];
	NSEnumerator *keyEnum = [attrMapDic keyEnumerator];
	id attributeName;
	
	while ((attributeName = [keyEnum nextObject])) {
		SEL getSel = NSSelectorFromString(attributeName);
		if ([self respondsToSelector:getSel]) {
			NSMethodSignature *signature = nil;
			signature = [self methodSignatureForSelector:getSel];
			NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
			[invocation setTarget:self];
			[invocation setSelector:getSel];
			NSObject *valueObj = nil;
			[invocation invoke];
			[invocation getReturnValue:&valueObj];
			if (valueObj) {
				[attrsDesc appendFormat:@" [%@=%@] ",attributeName,valueObj];
			} else {
				[attrsDesc appendFormat:@" [%@=nil] ",attributeName];
			}
		}
	}
	
	NSString *customDesc = [self customDescription];
	NSString *desc;
	
	if (customDesc && [customDesc length] > 0 ) {
		desc = [NSString stringWithFormat:@"%@:{%@,%@}",[self class],attrsDesc,customDesc];
	}else {		
		desc = [NSString stringWithFormat:@"%@:{%@}",[self class],attrsDesc];
	}
	
	return desc;
}

- (void)setAttributes:(NSDictionary *)dataDic{
	NSDictionary *attrMapDic = [self attributeMapDictionary];
	if (attrMapDic == nil) {
		return;
	}
	NSEnumerator *keyEnum = [attrMapDic keyEnumerator];
	id attributeName;
	while ((attributeName = [keyEnum nextObject])) {
		SEL sel = [self getSetterSelWithAttibuteName:attributeName];
		if ([self respondsToSelector:sel]) {
			NSString *dataDicKey = [attrMapDic objectForKey:attributeName];
			[self performSelectorOnMainThread:sel 
                                   withObject:[dataDic objectForKey:dataDicKey] 
                                waitUntilDone:[NSThread isMainThread]];		
		}
	}
}

- (id)initWithCoder:(NSCoder *)decoder{
	if( self = [super init] ){
		NSDictionary *attrMapDic = [self attributeMapDictionary];
		if (attrMapDic == nil) {
			return self;
		}
		NSEnumerator *keyEnum = [attrMapDic keyEnumerator];
		id attributeName;
		while ((attributeName = [keyEnum nextObject])) {
			SEL sel = [self getSetterSelWithAttibuteName:attributeName];
			if ([self respondsToSelector:sel]) {
				id obj = [decoder decodeObjectForKey:attributeName];
				[self performSelectorOnMainThread:sel 
                                       withObject:obj
                                    waitUntilDone:[NSThread isMainThread]];
			}
		}
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder{
	NSDictionary *attrMapDic = [self attributeMapDictionary];
	if (attrMapDic == nil) {
		return;
	}
	NSEnumerator *keyEnum = [attrMapDic keyEnumerator];
	id attributeName;
	while ((attributeName = [keyEnum nextObject])) {
		SEL getSel = NSSelectorFromString(attributeName);
		if ([self respondsToSelector:getSel]) {
			NSMethodSignature *signature = nil;
			signature = [self methodSignatureForSelector:getSel];
			NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
			[invocation setTarget:self];
			[invocation setSelector:getSel];
			NSObject *valueObj = nil;
			[invocation invoke];
			[invocation getReturnValue:&valueObj];
			
			if (valueObj) {
				[encoder encodeObject:valueObj forKey:attributeName];	
			}
		}
	}
}

- (NSData*)getArchivedData{
	return [NSKeyedArchiver archivedDataWithRootObject:self];
}

@end

//--------------------< 业务类型 - 对象 - 收藏 >--------------------
@implementation FaviroteObject
@synthesize uuid=_uuid;
@synthesize type=_type;
@synthesize content=_content;
@synthesize image=_image;
@synthesize date=_date;

-(void)dealloc{
    [_content release];
    [_image release];
    [_date release];
    [super dealloc];
}
@end

//--------------------< 业务类型 - 对象 - 历史记录 >--------------------
@implementation HistoryObject
@synthesize uuid=_uuid;
@synthesize type=_type;
@synthesize content=_content;
@synthesize image=_image;
@synthesize date=_date;
@synthesize isEncode=_isEncode;

-(void)dealloc{
    [_content release];
    [_image release];
    [_date release];
    [super dealloc];
}
@end

//--------------------< 业务类型 - 对象 - 应用程序 >--------------------
@implementation AppUrl
@synthesize url=_url;
@synthesize title=_title;

- (void)dealloc {
    IOSAPI_RELEASE(_url);
    IOSAPI_RELEASE(_title);
    [super dealloc];
}
@end

//--------------------< 业务类型 - 对象 - 书签 >--------------------
@implementation BookMark
@synthesize url=_url;
@synthesize title=_title;

- (void)dealloc {
    IOSAPI_RELEASE(_url);
    IOSAPI_RELEASE(_title);
    [super dealloc];
}
@end

//--------------------< 业务类型 - 对象 - 通讯录 >--------------------
@implementation Card
@synthesize name=_name;
@synthesize title=_title;
@synthesize url=_url;
@synthesize qq=_qq;
@synthesize fax=_fax;
@synthesize address=_address;
@synthesize msn=_msn;
@synthesize email=_email;
@synthesize weibo=_weibo;
@synthesize zipCode=_zipCode;
@synthesize cellphone=_cellphone;
@synthesize telephone=_telephone;
@synthesize department=_department;
@synthesize corporation=_corporation;

- (void)dealloc {
    IOSAPI_RELEASE(_url);
    IOSAPI_RELEASE(_name);
    IOSAPI_RELEASE(_title);
    IOSAPI_RELEASE(_qq);
    IOSAPI_RELEASE(_fax);
    IOSAPI_RELEASE(_address);
    IOSAPI_RELEASE(_msn);
    IOSAPI_RELEASE(_email);
    IOSAPI_RELEASE(_weibo);
    IOSAPI_RELEASE(_zipCode);
    IOSAPI_RELEASE(_cellphone);
    IOSAPI_RELEASE(_telephone);
    IOSAPI_RELEASE(_department);
    IOSAPI_RELEASE(_corporation);
    [super dealloc];
}
@end

//--------------------< 业务类型 - 对象 - 电子邮件 >--------------------
@implementation Email
@synthesize mail=_mail;
@synthesize title=_title;
@synthesize content=_content;

- (void)dealloc {
    IOSAPI_RELEASE(_mail);
    IOSAPI_RELEASE(_content);
    IOSAPI_RELEASE(_title);
    [super dealloc];
}
@end

//--------------------< 业务类型 - 对象 - 加密文本 >--------------------
@implementation EncText

@synthesize key=_key;
@synthesize content=_content;

- (void)dealloc {
    IOSAPI_RELEASE(_key);
    IOSAPI_RELEASE(_content);

    [super dealloc];
}

@end

//--------------------< 业务类型 - 对象 - 位置信息 >--------------------
@implementation GMap
@synthesize url=_url;

- (void)dealloc {
    IOSAPI_RELEASE(_url);

    [super dealloc];
}

@end

//--------------------< 业务类型 - 对象 - 电话号码 >--------------------
@implementation Phone
@synthesize telephone=_telephone;

- (void)dealloc {
    IOSAPI_RELEASE(_telephone);
    [super dealloc];
}
@end

//--------------------< 业务类型 - 对象 - 日程 >--------------------
@implementation Schedule

@synthesize content = _content;
@synthesize date = _date;
@synthesize title = _title;

- (void)dealloc {
    IOSAPI_RELEASE(_title);
    IOSAPI_RELEASE(_date);
    IOSAPI_RELEASE(_content);
    [super dealloc];
}

@end

//--------------------< 业务类型 - 对象 - 文本 >--------------------
@implementation Text
@synthesize content = _content;

- (void)dealloc {
    IOSAPI_RELEASE(_content);

    [super dealloc];
}
@end

//--------------------< 业务类型 - 对象 - 网络地址 >--------------------
@implementation Url
@synthesize content=_content;

- (void)dealloc {
    IOSAPI_RELEASE(_content);

    [super dealloc];
}

@end

//--------------------< 业务类型 - 对象 - 短信 >--------------------
@implementation ShortMessage
@synthesize content=_content;
@synthesize phone=_phone;

- (void)dealloc {
    IOSAPI_RELEASE(_phone);
    IOSAPI_RELEASE(_content);
    
    [super dealloc];
}
@end

//--------------------< 业务类型 - 对象 - 微博 >--------------------
@implementation Weibo
@synthesize title=_title;
@synthesize url=_url;

- (void)dealloc {
    IOSAPI_RELEASE(_url);
    IOSAPI_RELEASE(_title);
    [super dealloc];
}
@end

//--------------------< 业务类型 - 对象 - WIFI >--------------------
@implementation WiFiText
@synthesize name=_name;
@synthesize password=_password;

- (void)dealloc {
    IOSAPI_RELEASE(_name);
    IOSAPI_RELEASE(_password);

    [super dealloc];
}
@end

//--------------------< 业务类型 - 对象 - 富媒体 >--------------------
@implementation MediaPage

@synthesize title, content, image, audio, video;

- (void)dealloc {
    IOSAPI_RELEASE(title);
    IOSAPI_RELEASE(content);
    IOSAPI_RELEASE(image);
    IOSAPI_RELEASE(audio);
    IOSAPI_RELEASE(video);
    
    [super dealloc];
}

@end

@implementation RichMedia

@synthesize codeId, title, content, audio, pageList;
@synthesize isSend, mediaType, sendContent, sendType;
@synthesize type = _type, url = _url;

- (void)dealloc {
    IOSAPI_RELEASE(codeId);
    IOSAPI_RELEASE(title);
    IOSAPI_RELEASE(content);
    IOSAPI_RELEASE(audio);
    IOSAPI_RELEASE(pageList);
    
    // isSend
    IOSAPI_RELEASE(mediaType);
    //sendType
    IOSAPI_RELEASE(sendContent);
    
    IOSAPI_RELEASE(_url);
    
    [super dealloc];
}

- (Class)pageListClass{
    return MediaPage.class;
}

@end

//--------------------< 业务类型 - 对象 - 顺风车 >--------------------

@implementation Ride

@end

//--------------------< 业务类型 - 对象 - 空码 >--------------------
@implementation RichKma

@synthesize uuid;

- (void)dealloc {
    IOSAPI_RELEASE(uuid);
    [super dealloc];
}

@end

//====================================< 词条 - 接口 >====================================
#import <iOSApi/iOSApi+Reflex.h>
#import <iOSApi/iOSApi+Json.h>
#import "BusDecoder.h"

@implementation Api (Category)

#define SEPERATOR_PRE @":"
#define SEPERATOR_POST @";"

/**
 * 将冒号和分号分隔的字符串变成一个数组对象
 * @param string 去掉关键标识的字符串
 */
+ (NSDictionary *)parse:(NSString *)string{
    NSMutableDictionary *oRet = nil;
    NSString *regExStr = @"(([^:]+):(([^;]*)([^a-zA-Z:]*));)";
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regExStr
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    
    
    //oRet = [[[NSMutableDictionary alloc] initWithCapacity:0] autorelease];
    oRet = [NSMutableDictionary dictionary];
    [regex enumerateMatchesInString:string options:0 range:NSMakeRange(0, [string length]) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        NSString *key = [string substringWithRange:[result rangeAtIndex:2]];
        NSString *value = [string substringWithRange:[result rangeAtIndex:3]];
        value = [value replace:@"\\;" withString:@";"];
        value = [value replace:@"\\:" withString:@":"];
        iOSLog(@"key = [%@], value = [%@]", key, value);
        [oRet setObject:value forKey:key];
    }];
    return oRet;
}

/**
 * 编码规则V3版本解析空码, 富媒体业务
 * 
 * @param string
 * @param timeout
 *            超时
 * @return Object 业务实体
 * @remark string必须不为null
 */
+ (id)parseV3Common:(NSString *)string {
    id oRet = nil;
    NSString *input = string;
    if ([input hasPrefix:API_CODE_PREFIX]) {
        // 新的码规则, 取出码的正是内容
        NSString *code = [input substringFromIndex:API_CODE_PREFIX.length];
        if (![code hasPrefix:@"id="]) {
            input = code;
        }
    }
    iOSLog(@"input = %@", input);
    if ([input match:@"^[0][1-9a-fA-F](.*)"]) {
        // 取出码类型
        const char *s = [[input substringToIndex:2] UTF8String];
        Byte type = kModelBASE;
        sscanf(s, "%02X", &type);
        Class clazz = [BaseModel getType:type];
        if (clazz != nil) {
            // 普通业务
            input = [input substringFromIndex:2];
            iOSLog(@"input = %@", input);
            NSDictionary *ko = [self parse:input];
            if (ko != nil) {
                oRet = [ko toObject:clazz];
            }
        }
    }
    return oRet;
}

+ (id)parseV3Kma:(NSString *)string timeout:(int)timeout {
    id oRet = nil;
    if ([string hasPrefix:API_CODE_PREFIX]) {
        // 是码开头的, 截取字符串, 去掉前缀
        NSString *str = [string substringFromIndex:[API_CODE_PREFIX length]];
        if ([str hasPrefix:@"id="]) {
            // 富媒体, 或者空码, 转换地址
            NSString *uuid = nil;
            NSDictionary *dict = [str uriParams];
            if (dict != nil) {
                uuid = [dict objectForKey:@"id"];
            }
            NSString *url = [NSString stringWithFormat:@"%@/apps/getCode.action?%@", API_APPS_SERVER, str];
            NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [NSString valueOf:[Api userId]], @"userid",
                                    nil];
            NSDictionary *map = [Api post:url params:params];
            if (map.count > 0) {
                NSDictionary *data = [map objectForKey:@"data"];
                if([data isKindOfClass:[NSString class]]) {
                    oRet = [self parseV3Common:str];
                } else {
                    RichMedia *rm = [iOSApi assignObject:data class:RichMedia.class];
                    rm.codeId = uuid;
                    oRet = rm;
                }
            }
        } else {
            // 普通业务, 略过
        }
    }
    return oRet;
}

+ (id)parseV2Common:(NSString *)string{
    id oRet = nil;
    if ([string hasPrefix:API_CODE_PREFIX]) {
        // 新的码规则, 取出码的正是内容
        NSString *code = [string substringFromIndex:API_CODE_PREFIX.length];
        if (![code hasPrefix:@"id="]) {
            string = code;
        }
    }
    BusCategory *bc = [BusDecoder classify:string];
    if (bc != nil) {
        BusinessType codeType = bc.codeType;
        switch (codeType) {
            case kModelUrl:
                // 01-URL
                oRet = [BusDecoder decodeUrl:string channel:bc.channel];
                break;
            case kModelBookMark:
                // 02-书签
                oRet = [BusDecoder decodeBookMark:string channel:bc.channel];
                break;
            case kModelAppUrl:
                // 03-应用程序链接地址
                oRet = [BusDecoder decodeAppUrl:string];
                break;
            case kModelWeibo:
                // 04-微博
                oRet = [BusDecoder decodeWeibo:string];
                break;
            case kModelCard:
                // 05-名片
                oRet = [BusDecoder decodeCard:string channel:bc.channel];
                break;
            case kModelPhone:
                // 06-电话号码
                oRet = [BusDecoder decodePhone:string channel:bc.channel];
                break;
            case kModelEmail:
                // 07-电子邮件
                oRet = [BusDecoder decodeEmail:string channel:bc.channel];
                break;
            case kModelText:
                // 08-文本
                oRet = [BusDecoder decodeText:string channel:bc.channel];
                break;
            case kModelEncText:
                // 09-名片
                oRet = [BusDecoder decodeEncText:string key:@""];
                break;
            case kModelShortMessage:
                // 0A-短信
                oRet = [BusDecoder decodeShortmessage:string channel:bc.channel];
                break;
            case kModelWiFiText:
                // 0B-WIFI
                oRet = [BusDecoder decodeWifiText:string];
                break;
            case kModelGMap:
                // 0C-地图
                oRet = [BusDecoder decodeGMap:string];
                break;
            case kModelSchedule:
                // 0D-日程
                oRet = [BusDecoder decodeSchedule:string];
                break;
            case kModelRichMedia:
                // 0E-富媒体
                break;
            case kModelRide:
                // 0F-顺风车
                break;
            default:
                // 默认
                break;
        }
    }
    return oRet;
}

+ (id)parseV2Kma:(NSString *)string timeout:(int)timeout {
    id oRet = nil;
    if ([string hasPrefix:V2CODE_PREFIX] || [string hasPrefix:V2KMA_PREFIX]) {
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                [NSString valueOf:[Api userId]], @"userid",
                                nil];
        NSDictionary *map = [Api post:string params:params];
        if (map.count > 0) {
            NSDictionary *data = [map objectForKey:@"data"];
            if([data isKindOfClass:[NSString class]]) {
                oRet = [self parseV2Common:(NSString *)data];
            } else {
                NSString *codeIsKma = [data objectForKey:@"isKma"];
                int isKma = 0;
                if ([codeIsKma isKindOfClass:NSNumber.class] ) {
                    isKma = codeIsKma.intValue;
                }
                if (isKma > 0) {
                    // 空码
                    RichKma *rk = [[[RichKma alloc] init] autorelease];
                    NSDictionary *dict = [string uriParams];
                    NSString *xcode = [dict objectForKey:@"id"];
                    rk.uuid = xcode;
                } else {
                    oRet = [data toObject:RichMedia.class];
                }
            }
        }
    }
    return oRet;
}

/**
 * 二维码解码
 * 
 * @param string
 * @param timeout 超时
 * @return BaseModel
 */
+ (id)parse:(NSString *)string timeout:(int)timeout {
    id obj = nil;
    NSString *str = string;
    if (str != nil && str.length > 0) {
        str = [str trim];
        // 进行V3版本的富媒体, 空码解码
        obj = [self parseV3Kma:str timeout:timeout];
        // 如果不是V3版本的富媒体和空码, 进行V2版本的富媒体解码
        if (obj == nil) {
            obj = [self parseV2Kma:str timeout:timeout];
        }
        // 如果不是富媒体或者空码, 进行V3版本的一般性解码
        if (obj == nil) {
            obj = [self parseV3Common:str];
        }
        // 如果不是V3版本的一般性解码, 进行V2版本的一版行解码
        if (obj == nil) {
            obj = [self parseV2Common:str];
        }
        if (obj == nil) {
            // 实在没有办法解码了, 不是我们的业务, 按照URL的格式来泛解析
            NSString *exp = @"http://";
            if ([[str lowercaseString] hasPrefix:exp]) {
                Url *url = [[[Url alloc] init] autorelease];
                url.content = string;
                obj = url;
            } else {
                Text *text = [[[Text alloc] init] autorelease];
                text.content = string;
                obj = text;
            }
        }
    }
    return obj;
}

+ (NSString *)encode:(id)obj{
    NSMutableString *buffer = [[[NSMutableString alloc] initWithCapacity:0] autorelease];
    BaseModel *bm = (BaseModel *)obj;
    //判断是不是服媒体；
    if(bm.typeId == kModelRichMedia)
    {
        RichMedia *richObject= obj;  
        NSString *codeid= richObject.codeId;
        [buffer appendString:[NSString stringWithFormat:@"%@id=%@", API_CODE_PREFIX, codeid]];
    } else {
        if(obj == nil){
            return buffer;
        }  
        [buffer appendString:API_CODE_PREFIX];
        NSString *type16 = [NSString stringWithFormat:@"%02X", bm.typeId];
        [buffer appendString:type16];
        
        unsigned int outCount, i = 0;
        objc_property_t *properties = class_copyPropertyList([obj class], &outCount);
        char num = 'A';
        NSString *fieldName = nil;
        NSString *value = nil;
        for (i = 0; i < outCount; i++) {
            [buffer appendFormat:@"%c:", num];
            objc_property_t property = properties[i];
            if (property != NULL) {
                fieldName = [NSString stringWithUTF8String: property_getName(property)];
                id t = [iOSApi classOf:property];
                SEL aSel = NSSelectorFromString(fieldName);
                if ([obj respondsToSelector:aSel]) {
                    IMP func = [obj methodForSelector:aSel];
                    id xxx = func(obj, aSel);
                    value = [iOSApi toString:xxx class:(api_type_t)t];
                    value = [value replace:@";" withString:@"\\;"];
                    value = [value replace:@":" withString:@"\\:"];
                    [buffer appendString:value];
                }
            }
            [buffer appendString:@";"];
            
            num++;
        }
        free(properties);
        properties = NULL;
    }  
    
    return buffer;
}

@end
