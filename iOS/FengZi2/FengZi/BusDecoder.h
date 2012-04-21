//
//  BusDecoder.h
//  FengZi
//

//  Copyright (c) 2011年 iTotemStudio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BusChannele.h"
#import "BusDescKey.h"
#import "BusCategory.h"
#import "Api+Category.h"
#import "Phone.h"
#import "Shortmessage.h"
#import "Email.h"
#import "Schedule.h"
#import "Url.h"
#import "Weibo.h"
#import "WifiText.h"
#import "Text.h"
#import "GMap.h"
#import "EncText.h"
@interface BusDecoder : NSObject
+(BOOL)isUrl:(NSString*)input;
+(NSString*)transCode:(NSString *)input;
+ (NSMutableDictionary*)parser:(NSString *)input;
+(BusCategory*)classify:(NSString*)input;
+(Card*) decodeCard:(NSString*)input channel:(int)channele;
+(Card*) decodeVCARD:(NSString*) input;
+(NSMutableDictionary*) parserVCARD:(NSString *)input;
+(NSMutableDictionary*) parserMECARD:(NSString *)input;
+(Card*)decodeMECard:(NSString *)input;
+(Card*) decodeCardOnly:(NSString *)input;
+(Shortmessage*) decodeShortmessage:(NSString *)input channel:(int)channele;
+(Phone*) decodePhone:(NSString *)input channel:(int)channele;
+(EncText*)decodeEncText:(NSString *)input key:(NSString *)key;
+(WifiText*) decodeWifiText:(NSString *)input;
+(Email*) decodeEmail:(NSString *)input channel:(int) channele;
+(Schedule*) decodeSchedule:(NSString *)input;
+(BookMark*) decodeBookMark:(NSString *)input channel:(int) channele;
+(Url*) decodeUrl:(NSString *)input channel:(int) channele;
+(Weibo*) decodeWeibo:(NSString *)input;
+(GMap*) decodeGMap:(NSString *)input;
+(AppUrl*) decodeAppUrl:(NSString *)input;
+(Text*) decodeText:(NSString *)input channel:(int) channele;
@end
