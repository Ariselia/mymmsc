//
//  ITTDataRequest.m
//
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ITTDataRequest.h"
#pragma mark - SearchMapDataRequest
@implementation SearchMapDataRequest
- (NSString*)getRequestUrl{
    return @"http://maps.google.com/maps/api/geocode/json?";
}

- (void)generateRequestWithUrl:(NSString*)url
                withParameters:(NSDictionary*)params{
    
	// process params
	NSMutableDictionary *allParams = [NSMutableDictionary dictionaryWithCapacity:10];
	[allParams addEntriesFromDictionary: params];
	NSDictionary *staticParams = [self getStaticParams];
	if (staticParams != nil) {
		[allParams addEntriesFromDictionary:staticParams];
	}
    // used to monitor network traffic , this is not accurate number.
//    long long postBodySize = 0; 
    
    NSString *paramString = @"";
    if (allParams) {
        NSArray *allKeys = [allParams allKeys];
        NSInteger count = [allKeys count];
        NSString *value = nil;
        for (NSUInteger i=0; i<count; i++) {
            id key = [allKeys objectAtIndex:i];
            value = (NSString *)[allParams objectForKey:key];
            value = [self encodeURL:value];
            paramString = [paramString stringByAppendingString:(i == 0)?@"":@"&"];
            paramString = [paramString stringByAppendingFormat:@"%@=%@",key,value];
        }
    }
    paramString = [paramString stringByAppendingString:@"&sensor=false"];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",url,paramString];
    NSURL *nsUrl = [[NSURL alloc] initWithString:urlStr];
    _request = [[ASIFormDataRequest alloc] initWithURL:nsUrl];
    RELEASE_SAFELY(nsUrl);
    
//    postBodySize += [urlStr lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    [_request setRequestMethod:@"GET"];
    _request.delegate = self;
    _request.defaultResponseEncoding = [self getResponseEncoding];
    _request.timeOutSeconds = 120;
    _request.allowCompressedResponse = YES;
    _request.shouldCompressRequestBody = NO;
}


- (void)doRequestWithParams:(NSDictionary*)params{	
    [self generateRequestWithUrl:self.requestUrl withParameters:params];
    
    [_request startAsynchronous];
    ITTDINFO(@"request %@ is created, URL is: %@", [self class], [_request url]);
}
- (void)processResult{
    self.result = [[[ITTRequestResult alloc] initWithCode:@"0" withMessage:@""]autorelease];
    ITTDINFO(@"processed result:%@",self.resultDic);
}
@end

#pragma mark - MobileInfoDataRequest
@implementation MobileInfoDataRequest
- (NSString*)getRequestUrl{
    return API_URL_LOGGER "/log/mobInfo.action?";
}
- (void)processResult{
    self.result = [[[ITTRequestResult alloc] initWithCode:@"0" withMessage:@""] autorelease];
    ITTDINFO(@"processed result:%@",self.resultDic);
}
@end

#pragma mark - ScanLogDataRequest
@implementation ScanLogDataRequest
- (NSString*)getRequestUrl{
    return API_URL_LOGGER "/log/scanLog.action?";
}
- (void)processResult{
    self.result = [[[ITTRequestResult alloc] initWithCode:@"0" withMessage:@""]autorelease];
    ITTDINFO(@"processed result:%@",self.resultDic);
}
@end

#pragma mark - MakeLogDataRequest
@implementation MakeLogDataRequest
- (NSString*)getRequestUrl{
    return API_URL_LOGGER "/log/makeLog.action?";
}
- (void)processResult{
    self.result = [[[ITTRequestResult alloc] initWithCode:@"0" withMessage:@""]autorelease];
    ITTDINFO(@"processed result:%@",self.resultDic);
}
@end

#pragma mark - LastVersionDataRequest
@implementation LastVersionDataRequest
- (NSString*)getRequestUrl{
    return API_URL_LOGGER "/vs/lastVersion.action?type=1";
}
- (void)processResult{
    self.result = [[[ITTRequestResult alloc] initWithCode:@"0" withMessage:@""]autorelease];
    ITTDINFO(@"processed result:%@",self.resultDic);
}
@end


#pragma mark - ShareLogDataRequest
//使用t（type）=0/1来表示短信分享，还是邮件分享。0表示短信，1表示邮件。
//人的标示，采用Imei和version号码，进行base64加密，即a参数部署
@implementation ShareLogDataRequest
- (NSString*)getRequestUrl{
    return API_URL_LOGGER "/log/shareLog.action?";
}
- (void)processResult{
    self.result = [[[ITTRequestResult alloc] initWithCode:@"0" withMessage:@""]autorelease];
    ITTDINFO(@"processed result:%@",self.resultDic);
}
@end

#pragma mark - FeedBackDataRequest
@implementation FeedBackDataRequest
- (NSString*)getRequestUrl{
    return API_URL_LOGGER "/fb/fb.action";
}

-(ITTRequestMethod)getRequestMethod{
    return ITTRequestMethodPost;
}
- (void)processResult{
    self.result = [[[ITTRequestResult alloc] initWithCode:@"0" withMessage:@""]autorelease];
    ITTDINFO(@"processed result:%@",self.resultDic);
}
@end

@implementation AuthorizeLogDataRequest
- (NSString*)getRequestUrl{
    return API_URL_LOGGER "/log/authorizeLog.action?";
}

- (void)processResult{
    self.result = [[[ITTRequestResult alloc] initWithCode:@"0" withMessage:@""]autorelease];
    ITTDINFO(@"processed result:%@",self.resultDic);
}
@end

@implementation WeiboShareLogDataRequest
- (NSString*)getRequestUrl{
    return API_URL_LOGGER "/log/weiboShareLog.action?";
}

- (void)processResult{
    self.result = [[[ITTRequestResult alloc] initWithCode:@"0" withMessage:@""] autorelease];
    ITTDINFO(@"processed result:%@",self.resultDic);
}
@end