
//
//  Api+GameReward.m
//  FengZi
//
//  Created by a on 12-5-4.
//  Copyright (c) 2012年 ifengzi.cn. All rights reserved.
//

#import "Api+GameReward.h"
//====================================< 蜂幸运 - 对象 >====================================

//--------------------< 蜂幸运 - 对象 - 中奖信息 >--------------------

@implementation GameReward

@synthesize status;	//0接口调用成功，1调用出错
@synthesize info;	//接口调用出错是的错误信息
@synthesize islucky	;//是否中奖。1中奖，0未中奖
@synthesize name;	//中奖物品名
@synthesize luckyimg;//	奖品图片地

- (void)dealloc{
    IOSAPI_RELEASE(info);
    IOSAPI_RELEASE(name);
    IOSAPI_RELEASE(luckyimg);
    
    [super dealloc];
}

@end

//--------------------< 蜂幸运 - 对象 - 抽奖活动列表信息 >--------------------

@implementation GameInfo

@synthesize caseId, caseName, activeId, activeName;

- (void)dealloc{
    IOSAPI_RELEASE(caseId);
    IOSAPI_RELEASE(caseName);
    IOSAPI_RELEASE(activeId);
    IOSAPI_RELEASE(activeName);
    [super dealloc];
}

@end

//====================================< 蜂幸运 - 接口 >====================================

@implementation Api(getReward)

+ (GameReward *)get_reward_info:(NSString*) luckyid shopguid:(NSString*) shopguid
{
    GameReward *iRet = nil;
    NSString *params = [NSString stringWithFormat:@"{\"luckydrawrequest\":{\"userid\":%@,\"luckyid\":\"%@\",\"shopguid\":\"%@\"}}",[NSString valueOf:[Api userId]],luckyid,shopguid];
    NSString *action = API_URL_LUCKY "/fx/luckyfacade/draw";
    NSDictionary *heads = [NSDictionary dictionaryWithObjectsAndKeys:
                           @"application/json", @"Content-Type",
                           nil];
    
    NSDictionary *response = [Api post:action header:heads body:[params dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSDictionary *data = [response objectForKey:@"response"];
    if (data.count > 0) {
        //表数据
        // NSLog(@"go here");
        iRet = [data toObject:GameReward.class];
    }
    return iRet;
}

+ (NSMutableArray *)activeList{
    NSMutableArray *list = nil;
    NSString *params = @"0000";
    NSString *action = API_URL_LUCKY "/fx/luckyfacade/list";
    NSDictionary *heads = [NSDictionary dictionaryWithObjectsAndKeys:
                           @"application/json", @"Content-Type",
                           nil];
    
    NSDictionary *response = [Api post:action header:heads body:[params dataUsingEncoding:NSUTF8StringEncoding]];
    if (response == nil) {
        //NSString *temp = @"{\"response\":[{\"luckyname\":\"轮盘\",\"luckyid\":\"11-111\",\"activename\":\"轮盘1111\",\"activeid\":\"1\"}]}";
        //response = [temp objectFromJSONString];
    }
    if (response.count > 0 && [response isKindOfClass:NSDictionary.class]) {
        NSDictionary *resp = [response objectForKey:@"response"];
        if (resp.count > 0 && [resp isKindOfClass:NSDictionary.class]) {
            NSArray *data = [resp objectForKey:@"datalist"];
            if (data.count > 0 && [data isKindOfClass:NSArray.class]) {
                list = [data toList:GameInfo.class];
            }
        }
    }
    return list;
}

@end
