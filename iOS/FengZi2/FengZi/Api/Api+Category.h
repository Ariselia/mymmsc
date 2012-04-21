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

//--------------------< 业务类型 - 对象 - 书签 >--------------------
//--------------------< 业务类型 - 对象 - 书签 >--------------------
//--------------------< 业务类型 - 对象 - 书签 >--------------------
//--------------------< 业务类型 - 对象 - 书签 >--------------------
//--------------------< 业务类型 - 对象 - 书签 >--------------------
//--------------------< 业务类型 - 对象 - 书签 >--------------------
//--------------------< 业务类型 - 对象 - 书签 >--------------------
//--------------------< 业务类型 - 对象 - 书签 >--------------------

@interface Api (Category)

@end
