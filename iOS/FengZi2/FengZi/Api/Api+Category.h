//
//  Api+Category.h
//  FengZi
//
//  Created by wangfeng on 12-4-22.
//  Copyright (c) 2012年 ifengzi.cn. All rights reserved.
//

#import "Api.h"

//--------------------< 业务类型 - 对象 - 基础业务模型 >--------------------
@interface ITTBaseModelObject :NSObject <NSCoding> {
    
}
-(id)initWithDataDic:(NSDictionary*)data;
- (NSDictionary*)attributeMapDictionary;
- (void)setAttributes:(NSDictionary*)dataDic;
- (NSString *)customDescription;
- (NSString *)description;
- (NSData*)getArchivedData;
@end

//--------------------< 业务类型 - 对象 - 收藏 >--------------------
@interface FaviroteObject : NSObject{
    int _uuid;
    NSString *_content;
    NSString *_image;
    NSString *_date;
    BusinessType _type;
}

@property (nonatomic,retain) NSString *image;
@property (nonatomic,retain) NSString *date;
@property (nonatomic,retain) NSString *content;
@property (nonatomic,assign) int uuid;
@property (nonatomic,assign) BusinessType type;
@end

//--------------------< 业务类型 - 对象 - 历史记录 >--------------------
@interface HistoryObject : NSObject{
    int _uuid;
    NSString *_content;
    NSString *_image;
    NSString *_date;
    BusinessType _type;
    BOOL _isEncode;
}

@property (nonatomic,retain) NSString *image;
@property (nonatomic,retain) NSString *date;
@property (nonatomic,retain) NSString *content;
@property (nonatomic,assign) int uuid;
@property (nonatomic,assign) BusinessType type;
@property (nonatomic,assign) BOOL isEncode;
@end

//--------------------< 业务类型 - 对象 - 应用程序 >--------------------
@interface AppUrl : ITTBaseModelObject{
    NSString *_url;
    NSString *_title;
    NSString *_logId;
}

@property (retain, nonatomic) NSString *url;
@property (retain, nonatomic) NSString *title;
@property (retain, nonatomic) NSString *logId;
@end

//--------------------< 业务类型 - 对象 - 书签 >--------------------
@interface BookMark : ITTBaseModelObject{
    NSString *_title;
	NSString *_url;
	NSString *_logId;	
}

@property (retain, nonatomic) NSString *title;
@property (retain, nonatomic) NSString *url;
@property (retain, nonatomic) NSString *logId;
@end

//--------------------< 业务类型 - 对象 - 通讯录 >--------------------
@interface Card : ITTBaseModelObject{
    NSString* _name;
	NSString* _title;
	NSString* _department;
	NSString* _corporation;
	NSString* _cellphone;
	NSString* _telephone;
	NSString* _fax;
	NSString* _email;
	NSString* _url;
	NSString* _address;
	NSString* _zipCode;
	NSString* _qq;
	NSString* _msn;
	NSString* _weibo;
	//标示身份的id，用作记录传递
	NSString* _logId;
}
@property (retain, nonatomic) NSString *name;
@property (retain, nonatomic) NSString *title;
@property (retain, nonatomic) NSString *department;
@property (retain, nonatomic) NSString *corporation;
@property (retain, nonatomic) NSString *cellphone;
@property (retain, nonatomic) NSString *telephone;
@property (retain, nonatomic) NSString *fax;
@property (retain, nonatomic) NSString *email;
@property (retain, nonatomic) NSString *url;
@property (retain, nonatomic) NSString *address;
@property (retain, nonatomic) NSString *zipCode;
@property (retain, nonatomic) NSString *qq;
@property (retain, nonatomic) NSString *msn;
@property (retain, nonatomic) NSString *weibo;
@property (retain, nonatomic) NSString *logId;
@end

//--------------------< 业务类型 - 对象 - 电子邮件 >--------------------
@interface Email : ITTBaseModelObject{
    NSString* _mail;	
	NSString* _title;	
	NSString* _contente;	
	//标示身份的id，用作记录传递
	NSString* _logId;	
}
@property (retain, nonatomic) NSString *mail;
@property (retain, nonatomic) NSString *title;
@property (retain, nonatomic) NSString *contente;
@property (retain, nonatomic) NSString *logId;
@end

//--------------------< 业务类型 - 对象 - 加密文本 >--------------------
@interface EncText : ITTBaseModelObject{
    NSString* _content;
	NSString* _encContent;
	NSString* _key;	
	
	//标示身份的id，用作记录传递
	NSString* _logId;
}
@property (retain, nonatomic) NSString *content;
@property (retain, nonatomic) NSString *encContent;
@property (retain, nonatomic) NSString *key;
@property (retain, nonatomic) NSString *logId;
@end

//--------------------< 业务类型 - 对象 - 位置信息 >--------------------
@interface GMap : ITTBaseModelObject{
    NSString* _url;	
    
	//标示身份的id，用作记录传递
	NSString* _logId;
}
@property (retain, nonatomic) NSString *url;
@property (retain, nonatomic) NSString *logId;
@end

//--------------------< 业务类型 - 对象 - 电话号码 >--------------------
@interface Phone : ITTBaseModelObject{
    NSString* _telephone;
	
	//标示身份的id，用作记录传递
	NSString* _logId;
}
@property (retain, nonatomic) NSString *telephone;
@property (retain, nonatomic) NSString *logId;
@end

//--------------------< 业务类型 - 对象 - 日程 >--------------------
@interface Schedule : ITTBaseModelObject{
    NSString* _date;
	NSString* _title;
	NSString* _content;	
	//标示身份的id，用作记录传递
	NSString* _logId;	
}
@property (retain, nonatomic) NSString *date;
@property (retain, nonatomic) NSString *title;
@property (retain, nonatomic) NSString *content;
@property (retain, nonatomic) NSString *logId;

@end

//--------------------< 业务类型 - 对象 - 文本 >--------------------
@interface Text : ITTBaseModelObject{	
	NSString* _content;	
	
	//标示身份的id，用作记录传递
	NSString* _logId;	
}
@property (retain, nonatomic) NSString *content;
@property (retain, nonatomic) NSString *logId;

@end

//--------------------< 业务类型 - 对象 - 网络地址 >--------------------
@interface Url : ITTBaseModelObject{	
	NSString* _content;	
	
	//标示身份的id，用作记录传递
	NSString* _logId;	
}
@property (retain, nonatomic) NSString *content;
@property (retain, nonatomic) NSString *logId;

@end

//--------------------< 业务类型 - 对象 - 短信 >--------------------
@interface Shortmessage : ITTBaseModelObject{
    NSString* _cellphone;
	
	NSString* _contente;	
	
	//标示身份的id，用作记录传递
	NSString* _logId;	
}
@property (retain, nonatomic) NSString *cellphone;
@property (retain, nonatomic) NSString *contente;
@property (retain, nonatomic) NSString *logId;

@end

//--------------------< 业务类型 - 对象 - 微博 >--------------------
@interface Weibo : ITTBaseModelObject{	
	NSString* _title;
    
    NSString* _url;	
    
    //标示身份的id，用作记录传递
    NSString* _logId;	
}
@property (retain, nonatomic) NSString *title;
@property (retain, nonatomic) NSString *logId;
@property (retain, nonatomic) NSString *url;

@end

//--------------------< 业务类型 - 对象 - WIFI >--------------------
@interface WifiText : ITTBaseModelObject{	
	NSString* _name;
    
    NSString* _password;	
    
    //标示身份的id，用作记录传递
    NSString* _logId;	
}
@property (retain, nonatomic) NSString *name;
@property (retain, nonatomic) NSString *logId;
@property (retain, nonatomic) NSString *password;

@end

//====================================< 词条 - 接口 >====================================
@interface Api (Category)

@end
