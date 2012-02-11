//
//  AppUrl.h
//  FengZi
//
//  Copyright (c) 2011年 iTotemStudio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ITTBaseModelObject.h"
@interface AppUrl : ITTBaseModelObject{
    NSString *_url;
    NSString *_title;
    NSString *_logId;
}

@property (retain, nonatomic) NSString *url;
@property (retain, nonatomic) NSString *title;
@property (retain, nonatomic) NSString *logId;
@end
