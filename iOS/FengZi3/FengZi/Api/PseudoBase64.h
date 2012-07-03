//
//  EncryptTools.h
//  FengZi
//
//  Copyright (c) 2011年 fengxiafei.com. All rights reserved.
//

#import "Api.h"

@interface PseudoBase64 : NSObject
+ (NSString *)encode:(NSString *)string;
+ (NSString *)decode:(NSString *)string;
@end
