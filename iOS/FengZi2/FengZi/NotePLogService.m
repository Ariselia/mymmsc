//
//  NotePLogService.m
//  FengZi
//

//  Copyright (c) 2011年 iTotemStudio. All rights reserved.
//

#import "NotePLogService.h"
#import "EncryptTools.h"
@implementation NotePLogService
/**
 * 针对code属性，返回base64加密后的字符串
 * @param codeAttr
 * @return
 */
+(NSString*)encodeEnc:(CodeAttribute*) codeAttr{
    
    if(codeAttr == nil){
        return nil;
    }
    
    NSString *source = [codeAttr codeToString];
    
    return [EncryptTools Base64EncryptString:source];
} 

/**
 * 从最初的串中，截取，解码、生成对象
 * @param codeSource
 * @return
 */
+(CodeAttribute*)decodeDnc:(NSString*) codeSource{
    
    if(codeSource == nil){
        return nil;
    }
    
    int prePositon = [codeSource rangeOfString:@"NOTE:"].location;
    
    if(prePositon == NSNotFound){
        return nil;
    }
    prePositon = [codeSource rangeOfString:@"P:" options:NSCaseInsensitiveSearch range:NSMakeRange(prePositon+5, codeSource.length-prePositon-5)].location;
    if(prePositon == NSNotFound){
        return nil;
    }
    int postPosition = [codeSource rangeOfString:@";" options:NSCaseInsensitiveSearch range:NSMakeRange(prePositon, codeSource.length-prePositon)].location;
    
    if(postPosition == NSNotFound){
        return nil;
    }
    
    NSString *encSource = [codeSource substringWithRange:NSMakeRange(prePositon+2, postPosition-prePositon-2)];
    
    NSString *souce = [EncryptTools Base64DecryptString:encSource];
    
    return [[[CodeAttribute alloc] initWithCode:souce] autorelease];
} 
/**
 * 从最初的串中，截取
 * @param codeSource
 * @return
 */
+(NSString*)getNoteP:(NSString*)codeSource{
    
    if(codeSource == nil){
        return nil;
    }
    
    int prePositon = [codeSource rangeOfString:@"NOTE:"].location;
    
    if(prePositon == NSNotFound){
        return nil;
    }
    prePositon = [codeSource rangeOfString:@"P:" options:NSCaseInsensitiveSearch range:NSMakeRange(prePositon+5, codeSource.length-prePositon-5)].location;
    if(prePositon == NSNotFound){
        return nil;
    }
    
    int postPosition = [codeSource rangeOfString:@";" options:NSCaseInsensitiveSearch range:NSMakeRange(prePositon, codeSource.length-prePositon)].location;
    
    if(postPosition == NSNotFound){
        return nil;
    }
    
    NSString *encSource = [codeSource substringWithRange:NSMakeRange(prePositon+2, postPosition-prePositon-2)];
    
    return encSource;
} 
/**
 * 从最初的串中，截取，解码
 * @param codeSource
 * @return
 */
+(NSString*)decodeDnctoString:(NSString*) codeSource{
    
    if(codeSource == nil){
        return nil;
    }
    
    int prePositon = [codeSource rangeOfString:@"NOTE:"].location;
    
    if(prePositon == NSNotFound){
        return nil;
    }
    prePositon = [codeSource rangeOfString:@"P:" options:NSCaseInsensitiveSearch range:NSMakeRange(prePositon+5, codeSource.length-prePositon-5)].location;
    if(prePositon == NSNotFound){
        return nil;
    }

    int postPosition = [codeSource rangeOfString:@";" options:NSCaseInsensitiveSearch range:NSMakeRange(prePositon, codeSource.length-prePositon)].location;
    
    if(postPosition == NSNotFound){
        return nil;
    }
    
    NSString *encSource = [codeSource substringWithRange:NSMakeRange(prePositon+2, postPosition-prePositon-2)];
    
    return [EncryptTools Base64DecryptString:encSource];
} 

/**
 * 针对code属性，返回base64加密后的字符串
 * @param codeAttr
 * @return
 */
+(NSString*)updateNoteP:(NSString*) codeSource log:(NSString*) newlog{
    
    NSMutableString *buffer = [[[NSMutableString alloc]initWithCapacity:0] autorelease];
    
    if(codeSource == nil){
        return nil;
    }
    
    if(newlog == nil){
        return codeSource;
    }
    
    int prePositon = [codeSource rangeOfString:@"NOTE:"].location;
    
    if(prePositon == NSNotFound){
        return codeSource;
    }
    prePositon = [codeSource rangeOfString:@"P:" options:NSCaseInsensitiveSearch range:NSMakeRange(prePositon+5, codeSource.length-prePositon-5)].location;
    if(prePositon == NSNotFound){
        return nil;
    }
    int postPosition = [codeSource rangeOfString:@";" options:NSCaseInsensitiveSearch range:NSMakeRange(prePositon, codeSource.length-prePositon)].location;
    
    if(postPosition == NSNotFound){
        return codeSource;
    }
    
    [buffer appendString:[codeSource substringToIndex:prePositon+2]];
    [buffer appendString:newlog];
    [buffer appendString:[codeSource substringFromIndex:postPosition]];
    
    
    return buffer;
} 
@end
