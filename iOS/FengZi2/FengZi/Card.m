//
//  Card.m
//  FengZi
//

//  Copyright (c) 2011年 iTotemStudio. All rights reserved.
//

#import "Card.h"

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
