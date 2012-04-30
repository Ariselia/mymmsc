//
//  ITTBaseDataRequest.h
//  
//

//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import "ITTRequestResult.h"
#import "DataCacheManager.h"

typedef enum{
	ITTRequestMethodGet = 0,
	ITTRequestMethodPost = 1,           // content type = @"application/x-www-form-urlencoded"
	ITTRequestMethodMultipartPost = 2  // content type = @"multipart/form-data"
} ITTRequestMethod;

@class ITTBaseDataRequest;

@protocol DataRequestDelegate <NSObject>
@optional
- (void)requestDidStartLoad:(ITTBaseDataRequest*)request;
- (void)requestDidFinishLoad:(ITTBaseDataRequest*)request;
- (void)requestDidCancelLoad:(ITTBaseDataRequest*)request;
- (void)request:(ITTBaseDataRequest*)request didFailLoadWithError:(NSError*)error;
@end

@interface ITTBaseDataRequest : NSObject {
	id<DataRequestDelegate>	_delegate;
    NSString *_requestUrl;
	NSMutableDictionary	 *_resultDic;
	NSString *_resultString;
    NSString *_cancelSubject;
	BOOL _isLoading;
	UIView *_indicatorView;
    ITTRequestResult *_result;
    BOOL _useSilentAlert;
    
    NSDate *_requestStartTime;
    NSDictionary *_parameters;
    BOOL _usingCacheData;
    NSString *_cacheKey;
    DataCacheManagerCacheType _cacheType;
}

@property (nonatomic, retain) id<DataRequestDelegate> delegate;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, retain) NSString *requestUrl;
@property (nonatomic, retain) UIView *indicatorView;
@property (nonatomic, retain) NSMutableDictionary *resultDic;
@property (nonatomic, retain) NSString *resultString;
@property (nonatomic, retain) ITTRequestResult *result;
@property (nonatomic, retain,readonly) NSDictionary *parameters;

+ (id)silentRequestWithDelegate:(id<DataRequestDelegate>)delegate;
+ (id)requestWithDelegate:(id<DataRequestDelegate>)delegate;

+ (id)requestWithDelegate:(id<DataRequestDelegate>)delegate
          withCancelSubject:(NSString*)cancelSubject;

+ (id)silentRequestWithDelegate:(id<DataRequestDelegate>)delegate 
                   withParameters:(NSDictionary*)params;
+ (id)requestWithDelegate:(id<DataRequestDelegate>)delegate 
             withParameters:(NSDictionary*)params;

+ (id)requestWithDelegate:(id<DataRequestDelegate>)delegate 
             withParameters:(NSDictionary*)params
               withCacheKey:(NSString*)cache
              withCacheType:(DataCacheManagerCacheType)cacheType;

+ (id)requestWithDelegate:(id<DataRequestDelegate>)delegate 
             withParameters:(NSDictionary*)params
          withCancelSubject:(NSString*)cancelSubject;

+ (id)requestWithDelegate:(id<DataRequestDelegate>)delegate
          withIndicatorView:(UIView*)indiView;

+ (id)requestWithDelegate:(id<DataRequestDelegate>)delegate
          withIndicatorView:(UIView*)indiView
          withCancelSubject:(NSString*)cancelSubject;

+ (id)requestWithDelegate:(id<DataRequestDelegate>)delegate 
             withParameters:(NSDictionary*)params
          withIndicatorView:(UIView*)indiView;

+ (id)requestWithDelegate:(id<DataRequestDelegate>)delegate 
             withParameters:(NSDictionary*)params
          withIndicatorView:(UIView*)indiView
               withCacheKey:(NSString*)cache
              withCacheType:(DataCacheManagerCacheType)cacheType;

+ (id)requestWithDelegate:(id<DataRequestDelegate>)delegate 
             withParameters:(NSDictionary*)params
          withIndicatorView:(UIView*)indiView
          withCancelSubject:(NSString*)cancelSubject;

- (id)initWithDelegate:(id<DataRequestDelegate>)delegate
        withParameters:(NSDictionary*)params
     withIndicatorView:(UIView*)indiView
     withCancelSubject:(NSString*)cancelSubject
       withSilentAlert:(BOOL)silent
          withCacheKey:(NSString*)cache
         withCacheType:(DataCacheManagerCacheType)cacheType;
- (id)initWithDelegate:(id<DataRequestDelegate>)delegate
        withRequestUrl:(NSString*)url
        withParameters:(NSDictionary*)params
     withIndicatorView:(UIView*)indiView
     withCancelSubject:(NSString*)cancelSubject
       withSilentAlert:(BOOL)silent
          withCacheKey:(NSString*)cache
         withCacheType:(DataCacheManagerCacheType)cacheType;

+ (NSDictionary*)getDicFromString:(NSString*)cachedResponse;
+ (NSString *)EncodeGB2312Str:(NSString *)encodeStr;
- (void)doRequestWithParams:(NSDictionary*)params;
- (NSStringEncoding)getResponseEncoding;
- (NSDictionary*)getStaticParams;
- (ITTRequestMethod)getRequestMethod;
- (NSString*)getRequestUrl;
- (NSString*)getRequestHost;
- (void)processResult;
- (BOOL)isSuccess;
- (NSString*)encodeURL:(NSString *)string;
- (void)showIndicator:(BOOL)bshow;
- (BOOL)handleResultString:(NSString*)resultString;
- (BOOL)onReceivedCacheData:(NSObject*)cacheData;
@end
