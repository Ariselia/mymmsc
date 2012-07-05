//
//  CommonUtils.m
//  LingQ
//

//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CommonUtils.h"
#import <CommonCrypto/CommonDigest.h>

static char encodingTable[64] = {
	'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P',
	'Q','R','S','T','U','V','W','X','Y','Z','a','b','c','d','e','f',
	'g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v',
	'w','x','y','z','0','1','2','3','4','5','6','7','8','9','+','/' };

@implementation CommonUtils


+(NSString *)getDateByInterval:(NSTimeInterval)intervalTime
{
	NSDate *date = [NSDate dateWithTimeIntervalSince1970:intervalTime];
	NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
	[formatter setDateFormat:@"yyyy-MM-dd hh:mm"];
	[formatter setTimeZone:[NSTimeZone localTimeZone]];
	NSString *stringFromDate = [formatter stringFromDate:date];
	return stringFromDate;
}

+(NSString *)getDateByIntervalWithLine:(NSTimeInterval)intervalTime
{
	NSDate *date = [NSDate dateWithTimeIntervalSince1970:intervalTime];
	NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
	[formatter setDateFormat:@"yyyy-MM-dd"];
	[formatter setTimeZone:[NSTimeZone localTimeZone]];
	NSString *stringFromDate = [formatter stringFromDate:date];
	return stringFromDate;
}

+ (NSString *)getDateByIntervalFilterToday:(NSTimeInterval)intervalTime
{
	NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
	[formatter setDateFormat:@"yyyy-MM-dd"];
	[formatter setTimeZone:[NSTimeZone localTimeZone]];
    
    NSString *stringOfToday = [formatter stringFromDate:[NSDate date]];

    NSDate *date = [NSDate dateWithTimeIntervalSince1970:intervalTime];
	NSString *stringFromDate = [formatter stringFromDate:date];
    
    if ([stringOfToday isEqualToString:stringFromDate]) {
        [formatter setDateFormat:@"hh:mm:ss"];
        NSString *stringFromDate = [formatter stringFromDate:date];
        return stringFromDate;
    }
    else
    {
        [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
        NSString *stringFromDate = [formatter stringFromDate:date];
        return stringFromDate;
    }
}

+ (NSString *)getZoneTimeByInterval:(NSTimeInterval)intervalTime
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:intervalTime];
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:@"MMMM dd, yyyy H:mm zzz"];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    NSString *stringFromDate = [formatter stringFromDate:date];
    return stringFromDate;
}

+(NSString *)getIntervalString:(NSTimeInterval)intervalTime
{
	NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
	double interval = currentTime - intervalTime;
	NSInteger day = interval/(3600*24);
	if (day >=  1) {
		return [NSString stringWithFormat:@"%d天前", day];
	}
	NSInteger hour = interval/3600 ;
	if (hour >= 1) {
		return [NSString stringWithFormat:@"%d小时前", hour];
	}
	NSInteger minutes = interval/60 + 1;
	return [NSString stringWithFormat:@"%d分钟前", minutes];
}


+ (NSString *)getIntervalStringByValue:(long)intervalValue
{
    NSInteger day = intervalValue/(3600*24);
	if (day >=  1) {
		return [NSString stringWithFormat:@"%d天前", day];
	}
	NSInteger hour = intervalValue/3600 ;
	if (hour >= 1) {
		return [NSString stringWithFormat:@"%d小时前", hour];
	}
	NSInteger minutes = intervalValue/60 + 1;
	return [NSString stringWithFormat:@"%d分钟前", minutes];
}

+ (NSString *)getTimeLength:(NSInteger)intervalTime
{
    NSString *timeLength = nil;
    if (intervalTime > 0) {
        timeLength = [NSString stringWithFormat:@"%d”", intervalTime%60];
    }
    if (intervalTime >= 60) {
        NSString *minutesStr = [NSString stringWithFormat:@"%d‘", intervalTime/60];
        timeLength = [minutesStr stringByAppendingString:timeLength];
    }
    return timeLength;
}

+ (NSString *)convertArrayToString:(NSArray *)array{
	NSMutableString *string = [NSMutableString stringWithCapacity:0];
	for( NSInteger i=0;i<[array count];i++ ){
		[string appendFormat:@"%@%@",(NSString *)[array objectAtIndex:i], (i<([array count]-1))?@",":@""];
	}
	return string;
}

+ (NSArray *)convertStringToArray:(NSString *)string{
	return [string componentsSeparatedByString:@","];
}

+ (NSString *)getPathByFileName:(NSString *)fileName{
	return [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"/Documents/%@",fileName]];
}

+ (NSString *)getPathByFileNameInBundle:(NSString *)fileName{
	return [NSString stringWithFormat:@"%@/%@",[[NSBundle mainBundle] bundlePath],fileName];
}

+ (NSURL *)getCachePathByFileName:(NSString *)fileName{
    NSArray *searchPaths = NSSearchPathForDirectoriesInDomains 
    (NSCachesDirectory, NSUserDomainMask, YES);  
    NSString *cachePath = [searchPaths objectAtIndex:0];
    NSString *destinationString = [cachePath stringByAppendingPathComponent:fileName];
    NSURL *destinationURL = [NSURL fileURLWithPath: destinationString];
    return destinationURL;
}

+ (BOOL)removeFileByURL:(NSURL *)fileUrl
{
	NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
	[fileManager removeItemAtURL:fileUrl error:&error];
    if (error != nil) {
        iOSLog(@"remove file failed: %@", [error description]);
        return NO;
    }
    return YES;
}

+ (BOOL)validateEmail:(NSString *)candidate{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"; 
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex]; 
    return [emailTest evaluateWithObject:candidate];
}

+ (BOOL)validateUrl:(NSString *)candidate{
    NSString *urlRegex = @"[a-zA-z]+://[^\\s]*"; 
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegex]; 
    return [urlTest evaluateWithObject:candidate];
}

+ (NSString *)base64EncodingStringWithData:(NSData *)data lineLength:(unsigned int)lineLength{
	const unsigned char *bytes = [data bytes];
	NSMutableString *result = [NSMutableString stringWithCapacity:[data length]];
	unsigned long ixtext = 0;
	unsigned long lentext = [data length];
	long ctremaining = 0;
	unsigned char inbuf[3], outbuf[4];
	short i = 0;
	short charsonline = 0, ctcopy = 0;
	unsigned long ix = 0;
	
	while( YES ) {
		ctremaining = lentext - ixtext;
		if( ctremaining <= 0 ) break;
		
		for( i = 0; i < 3; i++ ) {
			ix = ixtext + i;
			if( ix < lentext ) inbuf[i] = bytes[ix];
			else inbuf [i] = 0;
		}
		
		outbuf [0] = (inbuf [0] & 0xFC) >> 2;
		outbuf [1] = ((inbuf [0] & 0x03) << 4) | ((inbuf [1] & 0xF0) >> 4);
		outbuf [2] = ((inbuf [1] & 0x0F) << 2) | ((inbuf [2] & 0xC0) >> 6);
		outbuf [3] = inbuf [2] & 0x3F;
		ctcopy = 4;
		
		switch( ctremaining ) {
			case 1:
				ctcopy = 2;
				break;
			case 2:
				ctcopy = 3;
				break;
		}
		
		for( i = 0; i < ctcopy; i++ )
			[result appendFormat:@"%c", encodingTable[outbuf[i]]];
		
		for( i = ctcopy; i < 4; i++ )
			[result appendString:@"="];
		
		ixtext += 3;
		charsonline += 4;
		
		if( lineLength > 0 ) {
			if (charsonline >= lineLength) {
				charsonline = 0;
				[result appendString:@"\n"];
			}
		}
	}
	return [NSString stringWithString:result];
}

+ (BOOL)validateCellPhone:(NSString *)candidate{
	NSString *phoneRegex = @"^[\\+|\\-|\\(|\\)|0-9]+$"; 
	NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex]; 
	return [phoneTest evaluateWithObject:candidate];
}

+(UIImage *)getImageFromUrl:(NSString *)imageUrl
{
	NSURL *url = [NSURL URLWithString:imageUrl];
	NSData *imageData = [NSData dataWithContentsOfURL:url];
	UIImage *image = [UIImage imageWithData:imageData];
	return image;
}

+(void)storeImageInDocument:(UIImage *)image ImageName:(NSString *)imageName
{	

    NSData *imageData = UIImageJPEGRepresentation(image,0);
    [self storeImageDataInDocument:imageData ImageName:imageName];

}

+ (void)storeImageDataInDocument:(NSData *)imageData ImageName:(NSString *)imageName
{
    long documentSize = [self getDocumentSize:@"images"];
    if (documentSize > 1048576) {
        [self deleteImageFromDocument:@"images"];
    }
	NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *imagePath = [paths objectAtIndex:0];
    //	NSString *imagePath = [NSHomeDirectory() stringByAppendingFormat:@"/Documents",imageName];
	NSArray *pathArray = [imageName componentsSeparatedByString:@"_"];
	NSError *error = nil;
	for (int i = 0; i<[pathArray count] - 1; i++) {
        if (![fileManager fileExistsAtPath:imagePath]) {
            iOSLog(@"%@ is not exsit", imagePath);
        }
		imagePath = [imagePath stringByAppendingFormat:@"/%@",[pathArray objectAtIndex:i]];
		if (![fileManager fileExistsAtPath:imagePath]) {
			[fileManager createDirectoryAtPath:imagePath withIntermediateDirectories:NO attributes:nil error:&error];
            iOSLog(@"Create Directory:%@ \nError: %@",imagePath, error);
		}
	}
    
	imagePath = [imagePath stringByAppendingFormat:@"/%@",[pathArray objectAtIndex:[pathArray count] - 1]];
	iOSLog(@"IMAGE SAVED PATH %@",imagePath);
	if (![fileManager fileExistsAtPath:imagePath]) 
	{
		BOOL state = [imageData writeToFile:imagePath atomically:YES];
		if(!state)
		{
			iOSLog(@"SAVE IMAGE FAILED!");
		}
	}
}


+(UIImage *)getImageFromDocument:(NSString *)imageName
{
	NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *imagePath = [paths objectAtIndex:0];
    //	NSString *imagePath = [NSHomeDirectory() stringByAppendingFormat:@"/Documents",imageName];
	NSArray *pathArray = [imageName componentsSeparatedByString:@"_"];
	for (int i = 0; i<[pathArray count] - 1; i++) {
		imagePath = [imagePath stringByAppendingFormat:@"/%@",[pathArray objectAtIndex:i]];
		if (![fileManager fileExistsAtPath:imagePath]) {
            return nil;
		}
	}
	imagePath = [imagePath stringByAppendingFormat:@"/%@",[pathArray objectAtIndex:[pathArray count] - 1]];
	BOOL success = [fileManager fileExistsAtPath:imagePath];
	NSData *dataToWrite = nil;
	UIImage *image = nil;
	if (!success) {
		return nil;
	}
	else {
		dataToWrite = [[NSData alloc] initWithContentsOfFile:imagePath];
		image = [UIImage imageWithData:dataToWrite];
        [dataToWrite release];
        dataToWrite = nil;
	}
	return image;
}
+(void)deleteImageFromDocument:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *imagePath = [paths objectAtIndex:0];
	imagePath = [imagePath stringByAppendingPathComponent:[NSString stringWithFormat: @"/%@", fileName]];
    iOSLog(@"DELETE:%@",imagePath);
	NSFileManager *fileManager = [NSFileManager defaultManager];
	[fileManager removeItemAtPath:imagePath error:nil];
}

+ (long)getDocumentSize:(NSString *)folderName
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
	documentsDirectory = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat: @"/%@/", folderName]];
    //	NSDictionary *fileAttributes = [fileManager attributesOfFileSystemForPath:documentsDirectory error:nil];
    NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:documentsDirectory error:nil];
    
    long size = 0;
	if(fileAttributes != nil)
	{
		NSNumber *fileSize = [fileAttributes objectForKey:NSFileSize];
        size = [fileSize longValue];
	}
    return size;
}

+ (NSArray *)getLetters
{
	return [NSArray arrayWithObjects:@"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h",@"i",@"j",@"k",@"l",@"m",@"n",@"o",@"p",@"q",@"r",@"s",@"t",@"u",@"v",@"w",@"x",@"y",@"z",nil];
}

+ (NSArray *)getUpperLetters
{
	return [NSArray arrayWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",nil];
}

+ (CGFloat)getRGB:(NSInteger)value
{
	return value/255.0f;
}

+ (NSString *)md5:(NSString *)str{
	const char *concat_str = [str UTF8String];
	unsigned char result[CC_MD5_DIGEST_LENGTH];
	CC_MD5(concat_str, strlen(concat_str), result);
	NSMutableString *hash = [NSMutableString string];
	for (int i = 0; i < 16; i++){
		[hash appendFormat:@"%02X", result[i]];
	}
	return [hash lowercaseString];
	
}


+ (NSString *)getIPAddress
{
	NSString *address = @"Unknown";
	struct ifaddrs *interfaces = NULL;
	struct ifaddrs *temp_addr = NULL;
	int success = 0;
    
	// retrieve the current interfaces - returns 0 on success
	success = getifaddrs(&interfaces);
	if (success == 0)
	{
		// Loop through linked list of interfaces
		temp_addr = interfaces;
		while(temp_addr != NULL)
		{
			if(temp_addr->ifa_addr->sa_family == AF_INET)
			{
				// Check if interface is en0 which is the wifi connection on the iPhone
                //                address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                //                NSLog(@"address: %@", [NSString stringWithUTF8String:temp_addr->ifa_name]);
				if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"])
				{
					// Get NSString from C String
					address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
				}
			}
            
			temp_addr = temp_addr->ifa_next;
		}
	}
    
	// Free memory
	freeifaddrs(interfaces);
    
	return address;
    
    //    char iphone_ip[255];
    //    strcpy(iphone_ip,"127.0.0.1"); // if everything fails
    //    NSHost* myhost =[NSHost currentHost];
    //    if (myhost)
    //    {
    //        NSString *ad = [myhost address];
    //        if (ad)
    //            strcpy(iphone_ip,[ad cStringUsingEncoding: NSISOLatin1StringEncoding]);
    //    }
    //    return [NSString stringWithFormat:@"%s",iphone_ip];
}

+ (NSString *)getFreeMemory{
    mach_port_t host_port;
    mach_msg_type_number_t host_size;
    vm_size_t pagesize;
    
    host_port = mach_host_self();
    host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    host_page_size(host_port, &pagesize);        
    
    vm_statistics_data_t vm_stat;
    
    if (host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size) != KERN_SUCCESS)
        NSLog(@"Failed to fetch vm statistics");
    
    /* Stats in bytes */ 
    natural_t mem_used = (vm_stat.active_count +
                          vm_stat.inactive_count +
                          vm_stat.wire_count) * pagesize;
    natural_t mem_free = vm_stat.free_count * pagesize;
    //  natural_t mem_total = mem_used + mem_free;
    return [NSString stringWithFormat:@"%0.1f MB used/%0.1f MB free", mem_used/1048576.f, mem_free/1048576.f];
    //    NSLog(@"used: %u free: %u total: %u", mem_used, mem_free, mem_total);
}

+ (NSString *)getDiskUsed
{
    NSDictionary *fsAttr = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    float diskSize = [[fsAttr objectForKey:NSFileSystemSize] doubleValue] / 1073741824.f;
    float diskFreeSize = [[fsAttr objectForKey:NSFileSystemFreeSize] doubleValue] / 1073741824.f;
    float diskUsedSize = diskSize - diskFreeSize;
    return [NSString stringWithFormat:@"%0.1f GB of %0.1f GB", diskUsedSize, diskSize];
}

+ (CGFloat)getDistanceOfPoint1:(CGPoint)point1 Point2:(CGPoint)point2
{
    return sqrtf(powf(point1.x - point2.x, 2) + powf(point1.y - point2.y, 2));
}

+ (NSInteger)getRandomStartNumber:(NSInteger)start EndNumber:(NSInteger)end
{
    return arc4random()%(end - start) + start; 
}

+ (NSString *)getStringValue:(id)value
{
    if ([value isKindOfClass:[NSNull class]]) {
        return nil;
    }
    
    if ([value isKindOfClass:[NSString class]]) {
        if ([@"" isEqualToString:value]) {
            return nil;
        }
        return value;
    }
    else
    {
        return [value stringValue];
    }
}

+ (NSString*)encodeURL:(NSString *)string{
	NSString *newString = [(NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)string, NULL, CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)) autorelease];
	if (newString) {
		return newString;
	}
	return @"";
}
+ (NSString *)createUUID{
    CFUUIDRef uuidObject = CFUUIDCreate(kCFAllocatorDefault);
    NSString *uuidStr = [(NSString *)CFUUIDCreateString(kCFAllocatorDefault, uuidObject) autorelease];
    CFRelease(uuidObject);
    return uuidStr;
}

@end
