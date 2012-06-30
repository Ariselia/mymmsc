//
//  EncryptTools.m
//  FengZi
//
//  Copyright (c) 2011年 fengxiafei.com. All rights reserved.
//

#import "EncryptTools.h"
#import <CommonCrypto/CommonCryptor.h>
#import "GTMBase64.h"

@implementation EncryptTools

+ (NSString*)Base64EncryptString:(NSString*)string{
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    data = [GTMBase64 encodeData:data];
    return [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
}

+ (NSString*)Base64DecryptString:(NSString*)string{
    NSData *data = [GTMBase64 decodeString:string];
    return [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
}
@end
