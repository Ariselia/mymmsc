//
//  GMap.m
//  FengZi
//

//  Copyright (c) 2011年 iTotemStudio. All rights reserved.
//

#import "GMap.h"

@implementation GMap
@synthesize url=_url;
@synthesize logId=_logId;

- (void)dealloc {
    RELEASE_SAFELY(_url);
    RELEASE_SAFELY(_logId);
    [super dealloc];
}

@end
