//
//  MyClass.m
//  hupan
//

//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DataCacheManager.h"
@interface DataCacheManager()
- (void)restore;
- (BOOL)isValidKey:(NSString*)key;
- (void)removeKey:(NSString*)key fromKeyArray:(NSMutableArray*)keyArray;
@end

@implementation DataCacheManager
static DataCacheManager *sharedInst = nil;
#pragma mark - singleton lifecycle
+ (DataCacheManager *)sharedManager{
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
		
	}else if (self) {
		sharedInst = self;
		[self restore];
	}
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

- (void)dealloc{
    RELEASE_SAFELY(_memoryCacheKeys);
    RELEASE_SAFELY(_memoryCachedObjects);
    RELEASE_SAFELY(_keys);
    RELEASE_SAFELY(_cachedObjects);
    [super dealloc];
}
#pragma mark - private methods
- (void)restore{
    if ([USER_DEFAULT objectForKey:UD_KEY_DATA_CACHE_KEYS]) {
        NSArray *keysArray = (NSArray*)[NSKeyedUnarchiver unarchiveObjectWithData:[USER_DEFAULT objectForKey:UD_KEY_DATA_CACHE_KEYS]];
        _keys = [[NSMutableArray alloc] initWithArray:keysArray];
    }else{
        _keys = [[NSMutableArray alloc] init];
    }
    
    if([USER_DEFAULT objectForKey:UD_KEY_DATA_CACHE_OBJECTS]){
        NSDictionary *objDic = (NSDictionary*)[NSKeyedUnarchiver unarchiveObjectWithData:[USER_DEFAULT objectForKey:UD_KEY_DATA_CACHE_OBJECTS]];
        _cachedObjects = [[NSMutableDictionary alloc] initWithDictionary:objDic];
    }else{
        _cachedObjects = [[NSMutableDictionary alloc] init];
    }
    _memoryCacheKeys = [[NSMutableArray alloc] init];
    _memoryCachedObjects = [[NSMutableDictionary alloc] init];
}
- (BOOL)isValidKey:(NSString*)key{
    if (!key || [key length] == 0 || (NSNull*)key == [NSNull null]) {
        return NO;
    }
    return YES;
}
- (void)removeKey:(NSString*)key fromKeyArray:(NSMutableArray*)keyArray{
    int indexInKeys = NSNotFound;
    for (int i=0;i < [keyArray count];i++) {
        if ([[keyArray objectAtIndex:i] isEqualToString:key]) {
            indexInKeys = i;
            break;
        }
    }
    if (indexInKeys != NSNotFound) {
        [keyArray removeObjectAtIndex:indexInKeys];
    }
}
#pragma mark - public methods
- (void)doSave{
    [USER_DEFAULT setObject:[NSKeyedArchiver archivedDataWithRootObject:_keys] forKey:UD_KEY_DATA_CACHE_KEYS];
    [USER_DEFAULT setObject:[NSKeyedArchiver archivedDataWithRootObject:_cachedObjects] forKey:UD_KEY_DATA_CACHE_OBJECTS];
    [USER_DEFAULT synchronize];
}

- (void)clearAllCache{
    [self clearMemoryCache];
    [_keys removeAllObjects];
    [_cachedObjects removeAllObjects];
    [self doSave];
}

- (void)clearMemoryCache{
    [_memoryCacheKeys removeAllObjects];
    [_memoryCachedObjects removeAllObjects];
}

- (void)addObject:(NSObject*)obj forKey:(NSString*)key{
    if (![self isValidKey:key]) {
        return;
    }
    if (!obj || (NSNull*)obj == [NSNull null]) {
        return;
    }
    if ([self hasObjectInCacheByKey:key]) {
        [self removeObjectInCacheByKey:key];
    }
    [_keys addObject:key];
    [_cachedObjects setObject:obj forKey:key];
    [self doSave];
}
- (void)addObjectToMemory:(NSObject*)obj forKey:(NSString*)key{
    if (![self isValidKey:key]) {
        return;
    }
    if (!obj || (NSNull*)obj == [NSNull null]) {
        return;
    }
    if ([self hasObjectInCacheByKey:key]) {
        [self removeObjectInCacheByKey:key];
    }
    [_memoryCacheKeys addObject:key];
    [_memoryCachedObjects setObject:obj forKey:key];
}
- (NSObject*)getCachedObjectByKey:(NSString*)key{
    if (![self isValidKey:key]) {
        return nil;
    }
    if ([_memoryCachedObjects objectForKey:key]) {
        return [_memoryCachedObjects objectForKey:key];
    }else{
        return [_cachedObjects objectForKey:key];
    }
}

- (BOOL)hasObjectInCacheByKey:(NSString*)key{
    return [self getCachedObjectByKey:key] != nil;
}

- (void)removeObjectInCacheByKey:(NSString*)key{
    if (![self isValidKey:key]) {
        return;
    }
    [_cachedObjects removeObjectForKey:key];
    [self removeKey:key fromKeyArray:_keys];
    [_memoryCachedObjects removeObjectForKey:key];
    [self removeKey:key fromKeyArray:_memoryCacheKeys];
}
@end
