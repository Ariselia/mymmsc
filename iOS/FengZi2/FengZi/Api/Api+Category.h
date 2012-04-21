//
//  Api+Category.h
//  FengZi
//
//  Created by wangfeng on 12-4-22.
//  Copyright (c) 2012年 ifengzi.cn. All rights reserved.
//

#import "Api.h"

#import "ITTBaseModelObject.h"

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

//--------------------< 业务类型 - 对象 - 书签 >--------------------
//--------------------< 业务类型 - 对象 - 书签 >--------------------
//--------------------< 业务类型 - 对象 - 书签 >--------------------
//--------------------< 业务类型 - 对象 - 书签 >--------------------

@interface Api (Category)

@end
