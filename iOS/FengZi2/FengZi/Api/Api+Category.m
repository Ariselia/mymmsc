//
//  Api+Category.m
//  FengZi
//
//  Created by wangfeng on 12-4-22.
//  Copyright (c) 2012年 ifengzi.cn. All rights reserved.
//

#import "Api+Category.h"

// 所有词条
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








@implementation Api (Category)

@end
