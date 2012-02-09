//
//  ITTBaseDataRequest.m
//  
//

//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ITTBaseDataRequest.h"
#import "CJSONDeserializer.h"
#import "DataCacheManager.h"

@implementation ITTBaseDataRequest
@synthesize requestUrl = _requestUrl;
@synthesize result = _result;
@synthesize resultDic=_resultDic;
@synthesize resultString=_resultString;
@synthesize isLoading = _isLoading;
@synthesize indicatorView = _indicatorView;
@synthesize delegate = _delegate;
@synthesize parameters = _parameters;

#pragma mark - lifecycle methods

+ (id)silentRequestWithDelegate:(id<DataRequestDelegate>)delegate{
    return [[[self class] alloc] initWithDelegate:delegate
                            withParameters:nil
                         withIndicatorView:nil
                         withCancelSubject:nil
                           withSilentAlert:YES
                              withCacheKey:nil
                             withCacheType:DataCacheManagerCacheTypeMemory];
}
+ (id)requestWithDelegate:(id<DataRequestDelegate>)delegate{
	return [[[self class] alloc] initWithDelegate:delegate 
                            withParameters:nil 
                         withIndicatorView:nil
                         withCancelSubject:nil
                           withSilentAlert:NO
                              withCacheKey:nil
                             withCacheType:DataCacheManagerCacheTypeMemory];
}
+ (id)requestWithDelegate:(id<DataRequestDelegate>)delegate
          withCancelSubject:(NSString*)cancelSubject{
	return [[[self class] alloc] initWithDelegate:delegate 
                            withParameters:nil 
                         withIndicatorView:nil 
                         withCancelSubject:cancelSubject 
                           withSilentAlert:NO
                              withCacheKey:nil
                             withCacheType:DataCacheManagerCacheTypeMemory];
}
+ (id)silentRequestWithDelegate:(id<DataRequestDelegate>)delegate 
                   withParameters:(NSDictionary*)params{
    return [[[self class] alloc] initWithDelegate:delegate
                            withParameters:params
                         withIndicatorView:nil
                         withCancelSubject:nil
                           withSilentAlert:YES
                              withCacheKey:nil
                             withCacheType:DataCacheManagerCacheTypeMemory];
}
+ (id)requestWithDelegate:(id<DataRequestDelegate>)delegate 
             withParameters:(NSDictionary*)params{
	return [[[self class] alloc] initWithDelegate:delegate 
                            withParameters:params 
                         withIndicatorView:nil 
                         withCancelSubject:nil
                           withSilentAlert:NO
                              withCacheKey:nil
                             withCacheType:DataCacheManagerCacheTypeMemory];
}
+ (id)requestWithDelegate:(id<DataRequestDelegate>)delegate 
             withParameters:(NSDictionary*)params
               withCacheKey:(NSString*)cache
              withCacheType:(DataCacheManagerCacheType)cacheType{
    
	return [[[self class] alloc] initWithDelegate:delegate 
                            withParameters:params 
                         withIndicatorView:nil 
                         withCancelSubject:nil
                           withSilentAlert:NO
                              withCacheKey:cache
                             withCacheType:cacheType];
}

+ (id)requestWithDelegate:(id<DataRequestDelegate>)delegate 
             withParameters:(NSDictionary*)params
          withCancelSubject:(NSString*)cancelSubject{
	return [[[self class] alloc] initWithDelegate:delegate 
                            withParameters:params 
                         withIndicatorView:nil 
                         withCancelSubject:cancelSubject 
                           withSilentAlert:NO
                              withCacheKey:nil
                             withCacheType:DataCacheManagerCacheTypeMemory];
}
+ (id)requestWithDelegate:(id<DataRequestDelegate>)delegate
          withIndicatorView:(UIView*)indiView
          withCancelSubject:(NSString*)cancelSubject{
	return [[[self class] alloc] initWithDelegate:delegate 
                            withParameters:nil 
                         withIndicatorView:indiView 
                         withCancelSubject:cancelSubject 
                           withSilentAlert:NO
                              withCacheKey:nil
                             withCacheType:DataCacheManagerCacheTypeMemory];
}
+ (id)requestWithDelegate:(id<DataRequestDelegate>)delegate
          withIndicatorView:(UIView*)indiView{
	return [[[self class] alloc] initWithDelegate:delegate 
                            withParameters:nil 
                         withIndicatorView:indiView
                         withCancelSubject:nil
                           withSilentAlert:NO
                              withCacheKey:nil
                             withCacheType:DataCacheManagerCacheTypeMemory];
}
+ (id)requestWithDelegate:(id<DataRequestDelegate>)delegate 
             withParameters:(NSDictionary*)params
          withIndicatorView:(UIView*)indiView{
	return [[[self class] alloc] initWithDelegate:delegate 
                            withParameters:params 
                         withIndicatorView:indiView
                         withCancelSubject:nil
                           withSilentAlert:NO
                              withCacheKey:nil
                             withCacheType:DataCacheManagerCacheTypeMemory];
}
+ (id)requestWithDelegate:(id<DataRequestDelegate>)delegate 
             withParameters:(NSDictionary*)params
          withIndicatorView:(UIView*)indiView
               withCacheKey:(NSString*)cache
              withCacheType:(DataCacheManagerCacheType)cacheType{
	return [[[self class] alloc] initWithDelegate:delegate 
                            withParameters:params 
                         withIndicatorView:indiView
                         withCancelSubject:nil
                           withSilentAlert:NO
                              withCacheKey:cache
                             withCacheType:DataCacheManagerCacheTypeMemory];
    
}
+ (id)requestWithDelegate:(id<DataRequestDelegate>)delegate 
             withParameters:(NSDictionary*)params
          withIndicatorView:(UIView*)indiView
          withCancelSubject:(NSString*)cancelSubject{
	return [[[self class] alloc] initWithDelegate:delegate 
                            withParameters:params 
                         withIndicatorView:indiView 
                         withCancelSubject:cancelSubject 
                           withSilentAlert:NO
                              withCacheKey:nil
                             withCacheType:DataCacheManagerCacheTypeMemory];
}

- (id)initWithDelegate:(id<DataRequestDelegate>)delegate
        withParameters:(NSDictionary*)params
     withIndicatorView:(UIView*)indiView
     withCancelSubject:(NSString*)cancelSubject
       withSilentAlert:(BOOL)silent
          withCacheKey:(NSString*)cacheKey
         withCacheType:(DataCacheManagerCacheType)cacheType{
    
	return [self initWithDelegate:delegate 
                   withRequestUrl:nil
                   withParameters:params 
                withIndicatorView:indiView 
                withCancelSubject:cancelSubject 
                  withSilentAlert:silent 
                     withCacheKey:cacheKey 
                    withCacheType:cacheType];
}

- (id)initWithDelegate:(id<DataRequestDelegate>)delegate
        withRequestUrl:(NSString*)url
        withParameters:(NSDictionary*)params
     withIndicatorView:(UIView*)indiView
     withCancelSubject:(NSString*)cancelSubject
       withSilentAlert:(BOOL)silent
          withCacheKey:(NSString*)cache
         withCacheType:(DataCacheManagerCacheType)cacheType{
    
    self = [super init];
	if(self) {
        _requestUrl = [url retain];
        if (!_requestUrl) {
            _requestUrl = [[self getRequestUrl] retain];
        }
		_indicatorView = [indiView retain];
		_isLoading = NO;
		_delegate = [delegate retain];
		_resultDic = nil;
        _result = nil;
        _useSilentAlert = silent;
        _cacheKey = [cache retain];
        if (_cacheKey && [_cacheKey length] > 0) {
            _usingCacheData = YES;
        }
        _cacheType = cacheType;
        if (cancelSubject && cancelSubject.length > 0) {
            _cancelSubject = [cancelSubject retain];
        }
        
        if (_cancelSubject && _cancelSubject) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelRequest) name:_cancelSubject object:nil];
        }
        
        _requestStartTime = [[NSDate date] retain];
        _parameters = [params retain];
        BOOL useCurrentCache = NO;
        
        NSObject *cacheData = [[DataCacheManager sharedManager] getCachedObjectByKey:_cacheKey];
        if (cacheData) {
            useCurrentCache = [self onReceivedCacheData:cacheData];
        }
        
        if (!useCurrentCache) {
            _usingCacheData = NO;
            [self doRequestWithParams:params];
            ITTDINFO(@"request %@ is created", [self class]);
        }else{
            _usingCacheData = YES;
            [self performSelector:@selector(release) withObject:nil afterDelay:0.1f];
        }
	}
	return self;
}
- (void)dealloc {	
    if (_indicatorView) {
        //make sure indicator is closed
        [self showIndicator:NO];
    }
    if (_cancelSubject && _cancelSubject) {
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:_cancelSubject
                                                      object:nil];
    }
    
    ITTDINFO(@"request %@ is released,time spend on this request:%f seconds", [self class],[[NSDate date] timeIntervalSinceDate:_requestStartTime]);
    RELEASE_SAFELY(_requestUrl);
    RELEASE_SAFELY(_cacheKey);
    RELEASE_SAFELY(_delegate);
    RELEASE_SAFELY(_result);
    RELEASE_SAFELY(_cancelSubject);
    RELEASE_SAFELY(_resultDic);
    RELEASE_SAFELY(_resultString);
    RELEASE_SAFELY(_indicatorView);
    RELEASE_SAFELY(_requestStartTime);
    RELEASE_SAFELY(_parameters);
	[super dealloc];
}

#pragma mark - util methods

+ (NSDictionary*)getDicFromString:(NSString*)cachedResponse{
	NSData *jsonData = [cachedResponse dataUsingEncoding:NSUTF8StringEncoding];
	return [[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:nil];
}

+ (NSString *)EncodeGB2312Str:(NSString *)encodeStr{  
    CFStringRef nonAlphaNumValidChars = CFSTR("![        DISCUZ_CODE_1        ]’()*+,-./:;=?@_~");          
    NSString *preprocessedString = (NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault, (CFStringRef)encodeStr, CFSTR(""), kCFStringEncodingGB_18030_2000);          
    NSString *newStr = [(NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)preprocessedString,NULL,nonAlphaNumValidChars,kCFStringEncodingGB_18030_2000) autorelease];  
    [preprocessedString release];  
    return newStr;          
}

- (BOOL)onReceivedCacheData:(NSObject*)cacheData{
    // handle cache data in subclass
    // return yes to finish request, return no to continue request from server
    return NO;
}

- (void)processResult{
    NSDictionary *resultDic = [self.resultDic objectForKey:@"result"];
    _result = [[ITTRequestResult alloc] initWithCode:[resultDic objectForKey:@"code"] 
                                         withMessage:@""];
    if (![_result isSuccess]) {
        ITTDERROR(@"request[%@] failed with message %@",self,_result.code);
    }else {
        ITTDINFO(@"request[%@] :%@" ,self ,@"success");
    }
}

- (BOOL)isSuccess{
    if (_result && [_result isSuccess]) {
        return YES;
    }
    return NO;
}

- (NSString*)encodeURL:(NSString *)string{
	NSString *newString = [(NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)string, NULL, CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)) autorelease];
	if (newString) {
		return newString;
	}
	return @"";
}

- (void)showIndicator:(BOOL)bshow{
	_isLoading = bshow;
	if (_indicatorView) {
		[UIUtil showIndicatorWithMask:bshow
                           atPosition:CGPointMake(_indicatorView.bounds.size.width/2 -15, _indicatorView.bounds.size.height/2-15)
                              forView:_indicatorView];
	}
}

- (BOOL)handleResultString:(NSString*)resultString{
    NSString *trimmedString = [resultString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    RELEASE_SAFELY(_resultString)
	_resultString = [trimmedString retain];
	if (!_resultString || [_resultString length] == 0) {
		ITTDERROR(@"!empty response error with Request:%@",[self class]);
		return NO;
	}
	//ITTDINFO(@"raw response:%@",_resultString);
    
	NSData *jsonData;
	if ([[_resultString  substringWithRange:NSMakeRange(0,1)] isEqualToString: @"["] ) {
		jsonData = [[[@"{\"data\":" stringByAppendingString:self.resultString ] stringByAppendingString:@"}"] dataUsingEncoding:NSUTF8StringEncoding];
	}else {
		jsonData = [self.resultString  dataUsingEncoding:NSUTF8StringEncoding];
	}
    NSError *error;
    NSDictionary *resultDic = [[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:&error];
    
	if(!resultDic) { 
		if( _delegate && [_delegate respondsToSelector:@selector(request:didFailLoadWithError:)]){
			[_delegate request:self 
          didFailLoadWithError:[NSError errorWithDomain:NSURLErrorDomain
                                                   code:0
                                               userInfo:nil]];
		}
        ITTDERROR(@"http request:%@\n with error:%@\n raw result:%@",[self class],error,_resultString);
        return NO;
	}else{
        RELEASE_SAFELY(_resultDic);
        _resultDic = [[NSMutableDictionary alloc] initWithDictionary:resultDic];
        [self processResult];
        if ([self.result isSuccess] && _cacheKey) {
            if (_cacheType == DataCacheManagerCacheTypeMemory) {
                [[DataCacheManager sharedManager] addObjectToMemory:self.resultDic forKey:_cacheKey];
            }else{
                [[DataCacheManager sharedManager] addObject:self.resultDic forKey:_cacheKey];
            }
        }
        if(_delegate && [_delegate respondsToSelector:@selector(requestDidFinishLoad:)]){
            [_delegate requestDidFinishLoad:self];
        }
        return YES;
    }
}
#pragma mark - hook methods
- (void)doRequestWithParams:(NSDictionary*)params{
    ITTDERROR(@"should implement request logic here!");
}
- (NSStringEncoding)getResponseEncoding{
    return NSUTF8StringEncoding;
    //return CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
}

- (NSDictionary*)getStaticParams{
	return [NSDictionary dictionaryWithObjectsAndKeys:nil];
}

- (ITTRequestMethod)getRequestMethod{
	return ITTRequestMethodGet;
}

- (NSString*)getRequestUrl{
	return @"";
}

- (NSString*)getRequestHost{
	return DATA_ENV.urlRequestHost;
}

@end
