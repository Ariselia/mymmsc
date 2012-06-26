//
//  EncryptTools.h
//  FengZi
//
//  Copyright (c) 2011年 iTotemStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EncryptTools : NSObject
+ (NSString*)Base64EncryptString:(NSString*)string;
+ (NSString*)Base64DecryptString:(NSString*)string;
@end
