
#import <Foundation/Foundation.h>
#define DIRECTORY_Favirote @"favirote"
#define DIRECTORY_EncodeHistory @"encodehistory"
#define DIRECTORY_ScanHistory @"Scanhistory"
@interface FileUtil : NSObject {

}
+(BOOL)addSkipBackupAttributeToItemAtURL:(NSString *)url;
+(BOOL)setupDirectories;
+(NSString *)fileNameForPath:(NSString *)path;
+(NSString *)filePathInFavirote:(NSString *)fileName;
+(NSString *)filePathInEncode:(NSString *)fileName;
+(NSString *)filePathInScan:(NSString *)fileName;
+(void)deleteFile:(NSString *)path;
+(BOOL)copyFile:(NSString *)filepath toFile:(NSString *)toFilepath;
+ (BOOL)writeImage:(UIImage*)image toFileAtPath:(NSString*)aPath;
@end
