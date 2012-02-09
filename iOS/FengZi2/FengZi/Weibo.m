//
//  Weibo.m
//  FengZi
//

//  Copyright (c) 2011年 iTotemStudio. All rights reserved.
//

#import "Weibo.h"

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
