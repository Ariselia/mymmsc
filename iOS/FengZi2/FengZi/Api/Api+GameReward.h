//
//  Api+GameReward.h
//  FengZi
//
//  Created by a on 12-5-4.
//  Copyright (c) 2012年 ifengzi.cn. All rights reserved.
//

#import "Api.h"
#import <iOSApi/NSArray+Utils.h>
#import <iOSApi/NSObject+Utils.h>

@interface Api_GameReward : NSObject
{
    int        status;   // 0接口调用成功，1调用出错
    NSString  *info;     // 接口调用出错是的错误信息
    int        islucky;  // 是否中奖。1中奖，0未中奖
    NSString  *name;     // 中奖物品名
    NSString  *luckyimg; // 奖品图片地址
}

@property (nonatomic, copy) NSString *info;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *luckyimg;
@property (nonatomic, assign) int islucky;
@property (nonatomic, assign) int status;

@end


@interface Api(getReward)

+ (Api_GameReward *)get_reward_info:(NSString*) luckyid shopguid:(NSString*) shopguid;

@end
