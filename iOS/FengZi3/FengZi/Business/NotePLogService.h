//
//  NotePLogService.h
//  FengZi
//
//  Copyright (c) 2011年 fengxiafei.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CodeAttribute.h"

@interface NotePLogService : NSObject
+(NSString*)encodeEnc:(CodeAttribute*) codeAttr;

/**
 * 从最初的串中，截取，解码、生成对象
 * @param codeSource
 * @return
 */
+(CodeAttribute*)decodeDnc:(NSString*) codeSource;

/**
 * 从最初的串中，截取，解码
 * @param codeSource
 * @return
 */
+(NSString*)decodeDnctoString:(NSString*) codeSource;

/**
 * 针对code属性，返回base64加密后的字符串
 * @param codeAttr
 * @return
 */
+(NSString*)updateNoteP:(NSString*) codeSource log:(NSString*) newlog;
@end
