//
//  Url.m
//  FengZi
//

//  Copyright (c) 2011年 iTotemStudio. All rights reserved.
//

#import "Url.h"

@implementation Url
@synthesize content=_content;
@synthesize logId=_logId;

- (void)dealloc {
    RELEASE_SAFELY(_content);
    RELEASE_SAFELY(_logId);
    [super dealloc];
}

@end
