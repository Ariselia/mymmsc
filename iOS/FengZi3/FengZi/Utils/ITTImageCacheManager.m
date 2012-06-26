//
//  ITTImageCacheManager.m
//  hupan
//
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ITTImageCacheManager.h"
@interface ITTImageCacheManager()
- (NSString*)encodeURL:(NSString *)string;
- (NSString*)getKeyFromUrl:(NSString*)url;
- (NSString*)getPathByFileName:(NSString *)fileName;
- (void)saveToMemory:(UIImage*)image forKey:(NSString*)key;
- (UIImage*)getImageFromMemoryCache:(NSString*)key;
- (BOOL)isImageInMemoryCache:(NSString*)key;
- (NSString *)getImageFolder;
- (BOOL)createDirectorysAtPath:(NSString *)path;
- (void)checkRequestQueueStatus;
@end

@implementation ITTImageCacheManager

static ITTImageCacheManager *sharedInst = nil;
@synthesize imageQueue = _imageQueue;
#pragma mark - singleton lifecycle
+ (ITTImageCacheManager *)sharedManager{
	@synchronized( self ) {
		if ( sharedInst == nil ) {
            [[self alloc] init];
		}
	}
	
	return sharedInst;
}

- (id)init{
    self = [super init];
	if ( sharedInst != nil ) {
		
	} 
    else if (self) {
		sharedInst = self;
		[self restore];
		
	}
    
    [NSTimer scheduledTimerWithTimeInterval:10.0f target:self selector:@selector(checkRequestQueueStatus) userInfo:nil repeats:YES];
	return sharedInst;
}

- (NSUInteger)retainCount{
	return NSUIntegerMax;
}

- (oneway void)release{
}

- (id)retain{
	return sharedInst;
}

- (id)autorelease{
	return sharedInst;
}

- (void)restore{
    _imageQueue = [[NSOperationQueue alloc] init];
    [_imageQueue setMaxConcurrentOperationCount:20];
    RELEASE_SAFELY(_memoryCache);
    _memoryCache = [[NSMutableDictionary alloc] init];
    NSString *path = [self getImageFolder];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [self createDirectorysAtPath:path];
    }
}

- (void)dealloc{
	[super dealloc];
    RELEASE_SAFELY(_memoryCache);
    RELEASE_SAFELY(_imageQueue);
    RELEASE_SAFELY(_lastSuspendedTime);
}

#pragma mark - private methods
- (NSString*)encodeURL:(NSString *)string{
	NSString *newString = [(NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)string, NULL, CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)) autorelease];
	if (newString) {
		return newString;
	}
	return @"";
}

- (BOOL)createDirectorysAtPath:(NSString *)path{
    @synchronized(self){
        NSFileManager* manager = [NSFileManager defaultManager];
        if (![manager fileExistsAtPath:path]) {
            NSError *error = nil;
            if (![manager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error]) {
                ITTDERROR(@"error : %@", error);
                return NO;
            }
        }
    }
    return YES;
}
- (NSString *)getImageFolder{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cacheFolder = [paths objectAtIndex:0];
	return [NSString stringWithFormat:@"%@/images",cacheFolder];
}

- (NSString *)getPathByFileName:(NSString *)fileName{
	return [NSString stringWithFormat:@"%@/%@",[self getImageFolder],fileName];
}

- (NSString*)getKeyFromUrl:(NSString*)url{
    return [self encodeURL:url];
}

- (void)saveToMemory:(UIImage*)image forKey:(NSString*)key{
    if (image) {
        [_memoryCache setObject:image forKey:key];
    }
}

- (UIImage*)getImageFromMemoryCache:(NSString*)key{
    return [_memoryCache objectForKey:key];
}

- (BOOL)isImageInMemoryCacheWithUrl:(NSString*)url{
    return [self isImageInMemoryCache:[self getKeyFromUrl:url]];
}

- (BOOL)isImageInMemoryCache:(NSString*)key{
    return (nil != [self getImageFromMemoryCache:key]);
}
// make sure queue will not suspended for too long
- (void)checkRequestQueueStatus{
    if(!_lastSuspendedTime || [_imageQueue operationCount] == 0 ){
        return;
    }
    if ([[NSDate date] timeIntervalSinceDate:_lastSuspendedTime] > 5.0) {
        [self restoreImageLoading];
    }
}
#pragma mark - public methods
- (void)saveImage:(UIImage*)image withUrl:(NSString*)url{
    [self saveImage:image withKey:[self getKeyFromUrl:url]];
}

- (void)saveImage:(UIImage*)image withKey:(NSString*)key{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    NSData* imageData = UIImagePNGRepresentation(image);
    NSString *imageFilePath = [self getPathByFileName:key];
    [imageData writeToFile:imageFilePath atomically:YES];
    [self saveToMemory:image forKey:key];
    [pool drain];
}

- (UIImage*)getImageFromCacheWithUrl:(NSString*)url{
    return [self getImageFromCacheWithKey:[self getKeyFromUrl:url]];
}

- (UIImage*)getImageFromCacheWithKey:(NSString*)key{
    if ([self isImageInMemoryCache:key]) {
        return [self getImageFromMemoryCache:key];
    }else{
        NSString *imageFilePath = [self getPathByFileName:key];
        UIImage* image = [UIImage imageWithContentsOfFile:imageFilePath];
        if (image) {
            [self saveToMemory:image forKey:key];
        }
        return image;
    }
}

- (void)clearDiskCache{
    NSString *imageFolderPath = [self getImageFolder];
    [[NSFileManager defaultManager] removeItemAtPath:imageFolderPath error:nil];
    [self createDirectorysAtPath:imageFolderPath];
}


- (void)clearMemoryCache{
    RELEASE_SAFELY(_memoryCache);
    _memoryCache = [[NSMutableDictionary alloc] init];
}

- (void)suspendImageLoading{
    if ([_imageQueue isSuspended]) {
        return;
    }
    [_imageQueue setSuspended:YES];
    ITTDINFO(@"image request queue suspended");
    RELEASE_SAFELY(_lastSuspendedTime);
    _lastSuspendedTime = [[NSDate date] retain];
}
- (void)restoreImageLoading{
    [_imageQueue setSuspended:NO];
    RELEASE_SAFELY(_lastSuspendedTime);
    ITTDINFO(@"image request queue restored");
}
@end
