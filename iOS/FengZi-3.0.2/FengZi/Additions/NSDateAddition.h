//
//  NSDateAddition.h
//
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSDate(ITTAdditions)
+ (NSString *)timeStringWithInterval:(NSTimeInterval) time;
- (NSString *)stringWithSeperator:(NSString *)seperator;
- (NSString *)stringWithFormat:(NSString*)format;
+ (NSDate *)dateWithString:(NSString *)str formate:(NSString *)formate;
- (NSString *)stringWithSeperator:(NSString *)seperator includeYear:(BOOL)includeYear;
+ (NSDate *)relativedDateWithInterval:(NSInteger)interval;
- (NSDate *)relativedDateWithInterval:(NSInteger)interval ;
- (NSString *)weekday;
@end