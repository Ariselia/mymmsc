//
//  CommonUtils.h
//  LingQ
//

//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#include <ifaddrs.h>
#include <arpa/inet.h>
#import <mach/mach.h>
#import <mach/mach_host.h>
#import <Foundation/Foundation.h>


@interface CommonUtils : NSObject {
    
}
//yyyy-MM-dd hh:mm
+ (NSString *)getDateByInterval:(NSTimeInterval)intervalTime;

//yyyy-MM-dd
+ (NSString *)getDateByIntervalWithLine:(NSTimeInterval)intervalTime;

+ (NSString *)getDateByIntervalFilterToday:(NSTimeInterval)intervalTime;

//MMMM dd, yyyy H:mm zzz
+ (NSString *)getZoneTimeByInterval:(NSTimeInterval)intervalTime;

//%d天前
+ (NSString *)getIntervalString:(NSTimeInterval)intervalTime;

//%d天前
+ (NSString *)getIntervalStringByValue:(long)intervalValue;
+ (BOOL)validateUrl:(NSString *)candidate;
+ (NSString *)getTimeLength:(NSInteger)intervalTime;
+ (NSString *)convertArrayToString:(NSArray *)array;
+ (NSArray *)convertStringToArray:(NSString *)string;
+ (NSString *)getPathByFileName:(NSString *)fileName;
+ (NSString *)getPathByFileNameInBundle:(NSString *)fileName;
+ (NSURL *)getCachePathByFileName:(NSString *)fileName;
+ (BOOL)removeFileByURL:(NSURL *)fileUrl;
+ (BOOL)validateEmail:(NSString *)candidate;
+ (NSString *)base64EncodingStringWithData:(NSData *)data lineLength:(unsigned int)lineLength;
+ (BOOL)validateCellPhone:(NSString *)candidate;
+ (UIImage *)getImageFromUrl:(NSString *)iamgeUrl;
+ (void)storeImageInDocument:(UIImage *)image ImageName:(NSString *)imageName;
+ (void)storeImageDataInDocument:(NSData *)imageData ImageName:(NSString *)imageName;
+ (UIImage *)getImageFromDocument:(NSString *)imageName;
+ (void)deleteImageFromDocument:(NSString *)fileName;
+ (long)getDocumentSize:(NSString *)folderName;
+ (NSArray *)getLetters;
+ (NSArray *)getUpperLetters;
+ (CGFloat)getRGB:(NSInteger)value;
+ (NSString *)md5:(NSString *)str;
+ (NSString *)getIPAddress;
+ (NSString *)getFreeMemory;
+ (NSString *)getDiskUsed;
+ (CGFloat)getDistanceOfPoint1:(CGPoint)point1 Point2:(CGPoint)point2;
+ (NSInteger)getRandomStartNumber:(NSInteger)start EndNumber:(NSInteger)end; 
+ (NSString *)getStringValue:(id)value;
+ (NSString*)encodeURL:(NSString *)string;
+ (NSString *)createUUID;
@end
