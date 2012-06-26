//
//  Api+Category.m
//  FengZi
//
//  Created by wangfeng on 12-4-22.
//  Copyright (c) 2012年 ifengzi.cn. All rights reserved.
//

#import "Api+Category.h"
#import "Api+RichMedia.h"
// 所有词条
//--------------------< 业务类型 - 对象 - 基础业务模型 >--------------------
@implementation BaseModel

@synthesize typeId, logId;

- (id)init{
    if(!(self = [super init])) {
		return self;
	}
    if (typeId == 0) {
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
        } /*else if (clazz == KMA.class) {
            typeId = kModelKMA;
        }*/ else {
            typeId = kModelText;
        }
    }
	
	return self;
}

+ (Class)getType:(CodeType)codeType{
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
		case kModelKMA:
			// 0F-空码
			//clazz = KMA.class;
			break;
		default:
			// 默认
			break;
    }
    return clazz;
}

- (void)dealloc{
    IOSAPI_RELEASE(logId);
    [super dealloc];
}

@end

@implementation ITTBaseModelObject

-(id)initWithDataDic:(NSDictionary*)data{
	if (self = [super init]) {
		[self setAttributes:data];
	}
	return self;
}
-(NSDictionary*)attributeMapDictionary{
	return nil;
}

-(SEL)getSetterSelWithAttibuteName:(NSString*)attributeName{
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
				//[valueObj release];			
			}else {
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
-(void)setAttributes:(NSDictionary*)dataDic{
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
    RELEASE_SAFELY(_url);
    RELEASE_SAFELY(_title);
    [super dealloc];
}
@end

//--------------------< 业务类型 - 对象 - 书签 >--------------------
@implementation BookMark
@synthesize url=_url;
@synthesize title=_title;

- (void)dealloc {
    RELEASE_SAFELY(_url);
    RELEASE_SAFELY(_title);
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
    RELEASE_SAFELY(_url);
    RELEASE_SAFELY(_name);
    RELEASE_SAFELY(_title);
    RELEASE_SAFELY(_qq);
    RELEASE_SAFELY(_fax);
    RELEASE_SAFELY(_address);
    RELEASE_SAFELY(_msn);
    RELEASE_SAFELY(_email);
    RELEASE_SAFELY(_weibo);
    RELEASE_SAFELY(_zipCode);
    RELEASE_SAFELY(_cellphone);
    RELEASE_SAFELY(_telephone);
    RELEASE_SAFELY(_department);
    RELEASE_SAFELY(_corporation);
    [super dealloc];
}
@end

//--------------------< 业务类型 - 对象 - 电子邮件 >--------------------
@implementation Email
@synthesize mail=_mail;
@synthesize title=_title;
@synthesize contente=_contente;

- (void)dealloc {
    RELEASE_SAFELY(_mail);
    RELEASE_SAFELY(_contente);
    RELEASE_SAFELY(_title);
    [super dealloc];
}
@end

//--------------------< 业务类型 - 对象 - 加密文本 >--------------------
@implementation EncText

@synthesize key=_key;
@synthesize content=_content;
//@synthesize encContent=_encContent;

- (void)dealloc {
    //RELEASE_SAFELY(_encContent);
    RELEASE_SAFELY(_key);
    RELEASE_SAFELY(_content);

    [super dealloc];
}

@end

//--------------------< 业务类型 - 对象 - 位置信息 >--------------------
@implementation GMap
@synthesize url=_url;

- (void)dealloc {
    RELEASE_SAFELY(_url);

    [super dealloc];
}

@end

//--------------------< 业务类型 - 对象 - 电话号码 >--------------------
@implementation Phone
@synthesize telephone=_telephone;

- (void)dealloc {
    RELEASE_SAFELY(_telephone);
    [super dealloc];
}
@end

//--------------------< 业务类型 - 对象 - 日程 >--------------------
@implementation Schedule
@synthesize content=_content;
@synthesize date=_date;
@synthesize title=_title;

- (void)dealloc {
    RELEASE_SAFELY(_title);
    RELEASE_SAFELY(_date);
    RELEASE_SAFELY(_content);
    [super dealloc];
}
@end

//--------------------< 业务类型 - 对象 - 文本 >--------------------
@implementation Text
@synthesize content=_content;

- (void)dealloc {
    RELEASE_SAFELY(_content);

    [super dealloc];
}
@end

//--------------------< 业务类型 - 对象 - 网络地址 >--------------------
@implementation Url
@synthesize content=_content;

- (void)dealloc {
    RELEASE_SAFELY(_content);

    [super dealloc];
}

@end

//--------------------< 业务类型 - 对象 - 短信 >--------------------
@implementation ShortMessage
@synthesize contente=_contente;
@synthesize cellphone=_cellphone;

- (void)dealloc {
    RELEASE_SAFELY(_cellphone);
    RELEASE_SAFELY(_contente);
    
    [super dealloc];
}
@end

//--------------------< 业务类型 - 对象 - 微博 >--------------------
@implementation Weibo
@synthesize title=_title;
@synthesize url=_url;

- (void)dealloc {
    RELEASE_SAFELY(_url);
    RELEASE_SAFELY(_title);
    [super dealloc];
}
@end

//--------------------< 业务类型 - 对象 - WIFI >--------------------
@implementation WiFiText
@synthesize name=_name;
@synthesize password=_password;

- (void)dealloc {
    RELEASE_SAFELY(_name);
    RELEASE_SAFELY(_password);

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

//====================================< 词条 - 接口 >====================================
#import <iOSApi/iOSApi+Reflex.h>

@implementation Api (Category)

#define SEPERATOR_PRE @":"
#define SEPERATOR_POST @";"

/**
 * 将冒号和分号分隔的字符串变成一个数组对象
 */
+ (NSArray *)parseCode:(NSString *)input{
    NSMutableArray *list = nil;
    if(input != nil){
        list = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
        int preFlagPos = 0;
        NSMutableString *sb = [[[NSMutableString alloc] initWithCapacity:0] autorelease];
        for(int i = 0; i < input.length; i ++){
            NSString *c = [input substringWithRange:NSMakeRange(i, 1)];
            NSString *d = nil;
            if (i + 1 < input.length) {
                d = [input substringWithRange:NSMakeRange(i + 1, 1)];
            }
            if(![c isEqualToString:SEPERATOR_PRE]&& ![c isEqualToString:SEPERATOR_POST]){
                [sb appendString:[NSString stringWithFormat:@"%@",c]];
            } else if (d != nil && [c isEqualToString:SEPERATOR_PRE] && [d isEqualToString:SEPERATOR_POST]) {
                [list addObject:@""];
                preFlagPos = 0;
            } else {
                if([c isEqualToString:SEPERATOR_PRE]){
                    if(i == 0){
                        continue; //舍弃：
                    }
                    if([[input substringWithRange:NSMakeRange(i-1, 1)] isEqualToString:@"\\"]){
                        [sb deleteCharactersInRange:NSMakeRange(sb.length - 1, 1)];
                        [sb appendString:[NSString stringWithFormat:@"%@",c]];
                    } else {
                        [sb appendString:[NSString stringWithFormat:@"%@",c]];
                        if(preFlagPos != 0){
                            //删掉不对应的
                            [sb deleteCharactersInRange:NSMakeRange(0, preFlagPos + 1)];
                        }
                        //对应到位置
                        preFlagPos = sb.length - 1;
                    }					
                }
                
                if([c isEqualToString:SEPERATOR_POST]){
                    if(i == 0){
                        continue; //舍弃：
                    }
                    if([[input substringWithRange:NSMakeRange(i-1, 1)] isEqualToString:@"\\"]){
                        [sb deleteCharactersInRange:NSMakeRange(sb.length - 1, 1)];
                        [sb appendString:[NSString stringWithFormat:@"%@",c]];
                    } else {
                        if(preFlagPos != 0){
                            [list addObject:[sb substringFromIndex:preFlagPos+1]];
                        }
                        
                        [sb deleteCharactersInRange:NSMakeRange(0, sb.length)];//清掉内容
                        preFlagPos = 0;
                    }					
                }
            }
        }
    }
    return list;
}

+ (id)decode:(NSArray*)list class:(Class)clazz{
    id obj = [[[clazz alloc] init] autorelease];
    // NSArray *list =[self parse0:content];
    unsigned int outCount, i = 0;
    objc_property_t *properties = class_copyPropertyList([obj class], &outCount);
    int listCount = list.count;
    if (listCount >= outCount) {
        for (i = 0; i < outCount; i++) {
            NSString *value = [list objectAtIndex:i];
            objc_property_t property = properties[i];
            NSString *fieldName = [NSString stringWithUTF8String: property_getName(property)];
            [iOSApi setObject:obj key:fieldName value:value];
        }
    } else {
        for (i = 0; i < listCount; i++) {
            NSString *value = [list objectAtIndex:i];
            objc_property_t property = properties[i];
            NSString *fieldName = [NSString stringWithUTF8String: property_getName(property)];
            [iOSApi setObject:obj key:fieldName value:value];
        }
    }
    free(properties);
    properties = NULL;    
    
    return obj;
}


// 解码
+ (id)decode:(NSString *)string {
    id ret = nil;
    if ([string hasPrefix:API_CODE_PREFIX]) {
        // 新的码规则, 取出码的正是内容
        NSString *code = [string substringFromIndex:API_CODE_PREFIX.length];
        if ([code hasPrefix:@"id="]) {
            // 富媒体, 空码
        } else if (code.length >= 4) {
            // 取出码类型
            const char *s = [[code substringToIndex:2] UTF8String];
            Byte type = kModelBASE;
            sscanf(s, "%02X", &type);
            Class clazz = [BaseModel getType:type];
            // 普通业务
            NSArray *array = [self parseCode:[code substringFromIndex:2]];
            if (array != nil) {
                ret = [self decode:array class:clazz];
                //NSString *xc = [self encode:ret];
                //iOSLog(@"%02X = %@", type, xc);
            }
        }
    }
    return ret;
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
