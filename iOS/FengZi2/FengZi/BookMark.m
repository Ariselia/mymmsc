//
//  BookMark.m
//  FengZi
//

//  Copyright (c) 2011年 iTotemStudio. All rights reserved.
//

#import "BookMark.h"

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
