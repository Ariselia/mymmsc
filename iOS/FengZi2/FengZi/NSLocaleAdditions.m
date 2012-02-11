//
//  NSLocaleAdditions.m
//  AiTuPianPad
//
// on 11-9-19.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "NSLocaleAdditions.h"

@implementation NSLocale(ITTAdditions)
+ (NSString *)getCountryCode
{
    NSLocale *currentLocale = [NSLocale currentLocale];
    return [currentLocale objectForKey:NSLocaleCountryCode];
}

+ (NSString *)getLanguageCode
{
    NSLocale *currentLocale = [NSLocale currentLocale];
    return [currentLocale objectForKey:NSLocaleLanguageCode];
}
@end
