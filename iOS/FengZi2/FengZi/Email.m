//
//  Email.m
//  FengZi
//

//  Copyright (c) 2011年 iTotemStudio. All rights reserved.
//

#import "Email.h"

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
