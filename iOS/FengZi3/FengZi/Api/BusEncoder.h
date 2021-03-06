//
//  BusEncoder.h
//  FengZi
//
//  Copyright (c) 2011年 fengxiafei.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BusChannel.h"
#import "BusDescKey.h"
#import "BusCategory.h"
#import "Api+Category.h"

@interface BusEncoder : NSObject

+(NSString*) filterQRBusiness:(NSString*)src;

//普通二维码编码
+(NSString*)encode:(id) obj type:(int)type;

/**
 * 富媒体编码
 * @remark 王锋增加
 */
+ (NSString *)encodeRichMedia:(RichMedia *)media;

/**
 * 对名片编码
 * @param card
 * @return
 */
+(NSString*)encodeCard:(Card*) card;

/**
 * 对邮件编码
 * @param card
 * @return
 */
+(NSString*)encodeEmail:(Email*)email;

/**
 * 对电话编码
 * @param card
 * @return
 */
+(NSString*)encodePhone:(Phone*) phone;

/**
 * 对日程编码
 * @param card
 * @return
 */
+(NSString*)encodeSchedule:(Schedule*) schedule;

/**
 * 对短信编码
 * @param card
 * @return
 */
+(NSString*)encodeShortmessage:(ShortMessage*) shortmessage;
/**
 * 对文本编码
 * @param card
 * @return
 */
+(NSString*)encodeText:(Text*) text;


/**
 * 对书签编码
 * @param card
 * @return
 */
+(NSString*)encodeBookMark:(BookMark*) bookMark;

/**
 * 对微薄编码
 * @param card
 * @return
 */
+(NSString*)encodeWeibo:(Weibo*) weibo;

/**
 * 对网址编码
 * @param card
 * @return
 */
+(NSString*)encodeUrl:(Url*) url;

/**
 * 对地图编码
 * @param card
 * @return
 */
+(NSString*)encodeGMap:(GMap*) gmap;

/**
 * 对应用程序编码
 * @param card
 * @return
 */
+(NSString*)encodeAppUrl:(AppUrl*) appUrl;


/**
 * 对加密文本编码
 * @param card
 * @return
 */
+(NSString*)encodeEncText:(EncText*) encText;

/**
 * 对wifi文本编码
 * @param card
 * @return
 */
+(NSString*)encodeWifiText:(WiFiText*) wifiText;
@end
