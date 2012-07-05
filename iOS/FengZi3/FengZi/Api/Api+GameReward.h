//
//  Api+GameReward.h
//  FengZi
//
//  Created by a on 12-5-4.
//  Copyright (c) 2012年 ifengzi.cn. All rights reserved.
//

#import "Api.h"

//====================================< 蜂幸运 - 对象 >====================================

//--------------------< 蜂幸运 - 对象 - 中奖信息 >--------------------

@interface GameReward : NSObject
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

//--------------------< 蜂幸运 - 对象 - 抽奖活动列表信息 >--------------------

@interface GameInfo : NSObject{
    NSString *luckyName;   // 抽奖项目名称
    NSString *luckyId;     // 抽奖项目id
    NSString *activeId;   // 游戏抽奖的形式ID
    NSString *activeName; // 游戏抽奖的形式名称
}

@property (nonatomic, copy) NSString *luckyName;
@property (nonatomic, copy) NSString *luckyId;
@property (nonatomic, copy) NSString *activeName;
@property (nonatomic, copy) NSString *activeId;

@end

//====================================< 蜂幸运 - 接口 >====================================

@interface Api(getReward)

+ (GameReward *)get_reward_info:(NSString*) luckyid shopguid:(NSString*) shopguid;
+ (NSMutableArray *)activeList;

@end
