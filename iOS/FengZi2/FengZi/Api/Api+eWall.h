//
//  iOSApi+eWall.h
//  FengZi
//
//  Created by wangfeng on 12-5-14.
//  Copyright (c) 2012年 ifengzi.cn. All rights reserved.
//

#import "Api.h"

@interface EWall : NSObject{
    //
}
@property (nonatomic, copy) NSString *num;
@property (nonatomic, copy) NSString *doorid;
@property (nonatomic, copy) NSString *factoryid;
@property (nonatomic, copy) NSString *ischeck;
@end

@interface Api (eWall)

@end
