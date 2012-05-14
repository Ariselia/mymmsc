
//
//  Api+GameReward.m
//  FengZi
//
//  Created by a on 12-5-4.
//  Copyright (c) 2012年 ifengzi.cn. All rights reserved.
//

#import "Api+GameReward.h"

@implementation Api_GameReward

@synthesize  status;	//0接口调用成功，1调用出错
@synthesize info;	//接口调用出错是的错误信息
@synthesize islucky	;//是否中奖。1中奖，0未中奖
@synthesize name;	//中奖物品名
@synthesize luckyimg;//	奖品图片地

@end


@implementation  Api(getReward)

+ (Api_GameReward *)get_reward_info:(NSString*) luckyid shopguid:(NSString*) shopguid
{
    Api_GameReward *iRet = nil;
        
    
   NSString *params = [NSString stringWithFormat:@"{luckydrawrequest:{userid:%@,luckyid:%@,shopguid:%@}}",[NSString valueOf:[Api userId]],luckyid,shopguid];

    
    NSString *action = @"http://devp.ifengzi.cn:38090/lucky/fx/luckyfacade/draw";
    
    NSDictionary *heads = [NSDictionary dictionaryWithObjectsAndKeys:
                           @"application/json", @"Content-Type",
                           nil];
    
    NSDictionary *response = [Api post:action header:heads body:[params dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSDictionary *data = [response objectForKey:@"response"];
      
        if (data.count > 0) {
            //表数据
           // NSLog(@"go here");
            iRet = [data toObject:Api_GameReward.class];
            
        }
    
    return iRet;
    
}

@end
