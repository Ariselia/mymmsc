//
//  iOSApi+eWall.m
//  FengZi
//
//  Created by wangfeng on 12-5-14.
//  Copyright (c) 2012年 ifengzi.cn. All rights reserved.
//

#import "Api+eWall.h"
#import "BusDescKey.h"
#import "BusDecoder.h"

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
@implementation Api (eWall)

+ (EWall *)getWall:(BusCategory *)category content:(NSString *)content{
    EWall *oRet = nil;
    if([category.type isEqualToString:CATEGORY_TEXT]){
        Text *object = [[BusDecoder decodeText:content channel:category.channel] retain];
        NSString *NSjson = object.content;
        NSDictionary *aa = [NSjson objectFromJSONString];
        oRet = [aa toObject:EWall.class];
        //墙贴条件
        if (oRet.factoryid.length < 1 || oRet.doorid.length < 1) {
            oRet = nil;
        }
    }
    return oRet;
}
@end
