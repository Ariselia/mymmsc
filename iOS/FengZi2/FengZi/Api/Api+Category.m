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
@implementation Api (Category)

@end
