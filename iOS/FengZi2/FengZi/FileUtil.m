//
//  FileUtil.m
//  ePubTest
//
//  Created by Eric on 11-1-13.
//  Copyright 2011 jilutao@gmail.com. All rights reserved.
//

#import "FileUtil.h"
#include <sys/xattr.h>

@implementation FileUtil

+(BOOL)addSkipBackupAttributeToItemAtURL:(NSString *)url
{
    const char* filePath = [url fileSystemRepresentation];
    const char* attrName = "com.apple.MobileBackup";
    u_int8_t attrValue = 1;
    int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
    return result == 0;
}


+(BOOL)setupDirectories{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path1 = [documentsDirectory stringByAppendingPathComponent:DIRECTORY_Favirote];
	NSString *path2 = [documentsDirectory stringByAppendingPathComponent:DIRECTORY_EncodeHistory];
	NSString *path3 = [documentsDirectory stringByAppendingPathComponent:DIRECTORY_ScanHistory];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	BOOL isDir;
	if (![fileManager fileExistsAtPath:path1 isDirectory:&isDir]) {
		NSError *err;
		BOOL succeed = [fileManager createDirectoryAtPath:path1 withIntermediateDirectories:YES attributes:nil error:&err];
		if (!succeed ) {
			NSLog(@"Can not create directory: %@",[err	localizedDescription]);
			return NO;
		}
        [FileUtil addSkipBackupAttributeToItemAtURL:path1];
	}
	if (![fileManager fileExistsAtPath:path2 isDirectory:&isDir]) {
		NSError *err;
		BOOL succeed = [fileManager createDirectoryAtPath:path2 withIntermediateDirectories:YES attributes:nil error:&err];
		if (!succeed) {
			NSLog(@"Can not create directory: %@",[err localizedDescription]);
			return NO;
		}
        [FileUtil addSkipBackupAttributeToItemAtURL:path2];
	}
    if (![fileManager fileExistsAtPath:path3 isDirectory:&isDir]) {
		NSError *err;
		BOOL succeed = [fileManager createDirectoryAtPath:path3 withIntermediateDirectories:YES attributes:nil error:&err];
		if (!succeed) {
			NSLog(@"Can not create directory: %@",[err localizedDescription]);
			return NO;
		}
        [FileUtil addSkipBackupAttributeToItemAtURL:path3];
	}
    return YES;
}

+(NSString *)fileNameForPath:(NSString *)path{
    [FileUtil setupDirectories];
	NSString *lastCompontent = [path lastPathComponent];
	return	[[lastCompontent componentsSeparatedByString:@"."] objectAtIndex:0];

}
+(NSString *)filePathInFavirote:(NSString *)fileName{
    [FileUtil setupDirectories];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [[documentsDirectory stringByAppendingPathComponent:DIRECTORY_Favirote] stringByAppendingPathComponent:fileName];
	return path;
}
+(NSString *)filePathInScan:(NSString *)fileName{
    [FileUtil setupDirectories];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [[documentsDirectory stringByAppendingPathComponent:DIRECTORY_ScanHistory] stringByAppendingPathComponent:fileName];
	return path;
}
+(NSString *)filePathInEncode:(NSString *)fileName{
    [FileUtil setupDirectories];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
	return [[documentsDirectory stringByAppendingPathComponent:DIRECTORY_EncodeHistory] stringByAppendingPathComponent:fileName];
}

+(void)deleteFile:(NSString *)path{
    BOOL isDir = NO;  
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path isDirectory:(&isDir)]) {
        NSError *err;
        if (isDir) { 
            NSArray *fileList = [fileManager contentsOfDirectoryAtPath:path error:&err]; 
            for (NSString *file in fileList) {
                [FileUtil deleteFile:[path stringByAppendingPathComponent:file]];
            }
        }else{
            BOOL succeed = [fileManager removeItemAtPath:path error:&err];
            if (!succeed ) {
                NSLog(@"Can not delete file: %@",[err localizedDescription]);
            }
        }
	}
}

+(BOOL)copyFile:(NSString *)filepath toFile:(NSString *)toFilepath{
	BOOL success = [[NSFileManager defaultManager]copyItemAtPath:filepath  toPath:toFilepath error:NULL];
	return success;
}

+ (BOOL)writeImage:(UIImage*)image toFileAtPath:(NSString*)aPath
{
    if ((image == nil) || (aPath == nil) || ([aPath isEqualToString:@""]))
        return NO;
    @try
    {
        NSData *imageData = nil;
        NSString *ext = [aPath pathExtension];
        if ([ext isEqualToString:@"png"]){
            imageData = UIImagePNGRepresentation(image);
        }
        else
        {
            imageData = UIImageJPEGRepresentation(image, 0);
        }
        if ((imageData == nil) || ([imageData length] <= 0))
            return NO;        
        [imageData writeToFile:aPath atomically:YES];
        [FileUtil addSkipBackupAttributeToItemAtURL:aPath];
        return YES;
    }
    @catch (NSException *e)
    {
        NSLog(@"create thumbnail exception.");
    }
    return NO;
}
@end
