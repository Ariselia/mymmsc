//
//  Api+Category.m
//  FengZi
//
//  Created by wangfeng on 12-4-22.
//  Copyright (c) 2012年 ifengzi.cn. All rights reserved.
//

#import "Api+Category.h"

// 所有词条
//--------------------< 业务类型 - 对象 - 基础业务模型 >--------------------
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
@synthesize logId=_logId;
@synthesize title=_title;

- (void)dealloc {
    RELEASE_SAFELY(_url);
    RELEASE_SAFELY(_logId);
    RELEASE_SAFELY(_title);
    [super dealloc];
}
@end

//--------------------< 业务类型 - 对象 - 书签 >--------------------
@implementation BookMark
@synthesize url=_url;
@synthesize logId=_logId;
@synthesize title=_title;

- (void)dealloc {
    RELEASE_SAFELY(_url);
    RELEASE_SAFELY(_logId);
    RELEASE_SAFELY(_title);
    [super dealloc];
}
@end

//--------------------< 业务类型 - 对象 - 通讯录 >--------------------
@implementation Card
@synthesize name=_name;
@synthesize title=_title;
@synthesize url=_url;
@synthesize logId = _logId;
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
    RELEASE_SAFELY(_logId);
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
@synthesize logId =_logId;
- (void)dealloc {
    RELEASE_SAFELY(_mail);
    RELEASE_SAFELY(_logId);
    RELEASE_SAFELY(_contente);
    RELEASE_SAFELY(_title);
    [super dealloc];
}
@end

//--------------------< 业务类型 - 对象 - 加密文本 >--------------------
@implementation EncText
@synthesize content=_content;
@synthesize encContent=_encContent;
@synthesize logId=_logId;
@synthesize key=_key;

- (void)dealloc {
    RELEASE_SAFELY(_encContent);
    RELEASE_SAFELY(_key);
    RELEASE_SAFELY(_logId);
    RELEASE_SAFELY(_content);
    [super dealloc];
}
@end

//--------------------< 业务类型 - 对象 - 位置信息 >--------------------
@implementation GMap
@synthesize url=_url;
@synthesize logId=_logId;

- (void)dealloc {
    RELEASE_SAFELY(_url);
    RELEASE_SAFELY(_logId);
    [super dealloc];
}

@end

//--------------------< 业务类型 - 对象 - 电话号码 >--------------------
@implementation Phone
@synthesize telephone=_telephone;
@synthesize logId=_logId;

- (void)dealloc {
    RELEASE_SAFELY(_telephone);
    RELEASE_SAFELY(_logId);
    [super dealloc];
}
@end

//--------------------< 业务类型 - 对象 - 日程 >--------------------
@implementation Schedule
@synthesize content=_content;
@synthesize logId=_logId;
@synthesize date=_date;
@synthesize title=_title;

- (void)dealloc {
    RELEASE_SAFELY(_title);
    RELEASE_SAFELY(_date);
    RELEASE_SAFELY(_content);
    RELEASE_SAFELY(_logId);
    [super dealloc];
}
@end

//--------------------< 业务类型 - 对象 - 文本 >--------------------
@implementation Text
@synthesize content=_content;
@synthesize logId=_logId;

- (void)dealloc {
    RELEASE_SAFELY(_content);
    RELEASE_SAFELY(_logId);
    [super dealloc];
}
@end

//--------------------< 业务类型 - 对象 - 网络地址 >--------------------
@implementation Url
@synthesize content=_content;
@synthesize logId=_logId;

- (void)dealloc {
    RELEASE_SAFELY(_content);
    RELEASE_SAFELY(_logId);
    [super dealloc];
}

@end

//--------------------< 业务类型 - 对象 - 短信 >--------------------
@implementation Shortmessage
@synthesize contente=_contente;
@synthesize logId=_logId;
@synthesize cellphone=_cellphone;

- (void)dealloc {
    RELEASE_SAFELY(_cellphone);
    RELEASE_SAFELY(_contente);
    RELEASE_SAFELY(_logId);
    [super dealloc];
}
@end

//--------------------< 业务类型 - 对象 - 微博 >--------------------
@implementation Weibo
@synthesize title=_title;
@synthesize logId=_logId;
@synthesize url=_url;

- (void)dealloc {
    RELEASE_SAFELY(_url);
    RELEASE_SAFELY(_title);
    RELEASE_SAFELY(_logId);
    [super dealloc];
}
@end

//--------------------< 业务类型 - 对象 - WIFI >--------------------
@implementation WifiText
@synthesize name=_name;
@synthesize logId=_logId;
@synthesize password=_password;

- (void)dealloc {
    RELEASE_SAFELY(_name);
    RELEASE_SAFELY(_password);
    RELEASE_SAFELY(_logId);
    [super dealloc];
}
@end

//====================================< 词条 - 接口 >====================================
#import <objc/runtime.h>
#import <CommonCrypto/CommonDigest.h> // Need to import for CC_MD5 access

#include <stdlib.h>
#include <stdio.h>
#include <time.h> // for time_t
#include <regex.h>

#define SEPERATOR_PRE @":"
#define SEPERATOR_POST @";"

@implementation Api (Category)

/**
 * 将冒号和分号分隔的字符串变成一个map对象
 */
+ (NSArray *)parse0:(NSString *)input{
    NSMutableArray *list = nil;
    if(input != nil){
        list = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
        int preFlagPos = 0;
        NSMutableString *sb = [[[NSMutableString alloc] initWithCapacity:0] autorelease];
        for(int i = 0; i < input.length; i ++){
            NSString *c = [input substringWithRange:NSMakeRange(i, 1)];
            if(![c isEqualToString:SEPERATOR_PRE]&& ![c isEqualToString:SEPERATOR_POST]){
                [sb appendString:[NSString stringWithFormat:@"%@",c]];
            }else{
                if([c isEqualToString:SEPERATOR_PRE]){
                    if(i == 0){
                        continue; //舍弃：
                    }
                    if([[input substringWithRange:NSMakeRange(i-1, 1)] isEqualToString:@"\\"]){
                        [sb deleteCharactersInRange:NSMakeRange(sb.length - 1, 1)];
                        [sb appendString:[NSString stringWithFormat:@"%@",c]];
                        //preFlagPos = i - 1;
                    }else{
                        [sb appendString:[NSString stringWithFormat:@"%@",c]];
                        if(preFlagPos != 0){
                            [sb deleteCharactersInRange:NSMakeRange(0, preFlagPos + 1)];//删掉不对应的：
                        }
                        preFlagPos = sb.length - 1; //对应到位置
                    }					
                }
                
                if([c isEqualToString:SEPERATOR_POST]){
                    if(i == 0){
                        continue; //舍弃：
                    }
                    if([[input substringWithRange:NSMakeRange(i-1, 1)] isEqualToString:@"\\"]){
                        [sb deleteCharactersInRange:NSMakeRange(sb.length - 1, 1)];
                        [sb appendString:[NSString stringWithFormat:@"%@",c]];
                    }else{
                        if(preFlagPos != 0){
                            //[result setObject:[sb substringFromIndex:preFlagPos+1] forKey:key];
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

// 解码
+ (id)parse:(NSString *)input {
    //首先判断是不是新的编码规则
    id oRet = nil;
    if (input != nil) {
        if ([input hasSuffix:API_CODE_PREFIX]) {
            // 是码开头的, 截取字符串, 去掉前缀
            NSString *str = [input substringFromIndex:[API_CODE_PREFIX length]];
            if ([str hasPrefix:@"id="]) {
                // 富媒体, 或者空码, 转换地址
                NSString *url = [NSString stringWithFormt:@"http://f.ifengzi.cn/apps/getCode.action?%@", str];
                // 请求服务器
            } else {
                // 普通码规则, 前两位是十六进制串
                const char *s = [[str substringToIndex:2] UTF8String];
                int type = -1;
                sscanf(s, "%02X", &type);
                if (type > 0) {
                    // 已经取到类型了, 进一步剥离类型, 取的编码串
                    str = [str substringFromIndex:2];
                    // 下面的这个数组的内容, 就是从A开始的连续的值
                    NSArray *list = [self parse0:str];
                    if (type == 1) {
                        AppUrl *obj = [[[AppUrl alloc] init] autorelease];
                        // 开始反射, 遍历类型
                        unsigned int outCount, i = 0;
                        objc_property_t *properties = class_copyPropertyList([obj class], &outCount);
                        for (i = 0; i < outCount; i++) {
                            NSString *value = [list objectAtIndex:i];
                            objc_property_t property = properties[i];
                            NSString *fieldName = [NSString stringWithUTF8String: property_getName(property)];
                                [iOSApi setObject:obj key:fieldName value:value];
                        }
                        free(properties);
                        properties = NULL;
                    }
                }
            }
        } else {
            // 不是, 咋办?
            if ([input hasPrefix:@"http://"]) {
                // 网址类型
                Url *u = [[[Url alloc] init] autorelease];
                [u setContent:input];
                oRet = u;
            } else {
                // 文本类型
                Text *t = [[[Text alloc] init] autorelease];
                [t setContent:input];
                oRet = t;
            }
        }
    }
    return oRet;
}

@end
