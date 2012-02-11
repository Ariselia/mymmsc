//
//  AppUrl.m
//  FengZi
//
//  Copyright (c) 2011年 iTotemStudio. All rights reserved.
//

#import "AppUrl.h"

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
