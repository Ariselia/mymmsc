//
//  iOSApi+eWall.m
//  FengZi
//
//  Created by wangfeng on 12-5-14.
//  Copyright (c) 2012年 ifengzi.cn. All rights reserved.
//

#import "iOSApi+eWall.h"

@implementation EWall

@synthesize num,doorid,ischeck,factoryid;

- (void)dealloc{
    IOSAPI_RELEASE(num);
    IOSAPI_RELEASE(doorid);
    IOSAPI_RELEASE(ischeck);
    IOSAPI_RELEASE(factoryid);
    [super dealloc];
}

@end

// 墙贴
@implementation iOSApi (eWall)

@end
