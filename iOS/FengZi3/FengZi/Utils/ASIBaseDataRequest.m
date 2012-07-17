//
//  ASIBaseDataRequest.m
//  hupan
//

//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ASIBaseDataRequest.h"
#import <iOSApi/ASIFormDataRequest.h>
#import "CJSONDeserializer.h"
//#import "ITTNetworkTrafficManager.h"

@class AllBrandDataRequest;

@interface ASIBaseDataRequest()
- (void)cancelRequest;
- (void)generateRequestWithUrl:(NSString*)url
                withParameters:(NSDictionary*)params;
@end

@implementation ASIBaseDataRequest
#pragma mark -
#pragma mark private method
- (void)cancelRequest{
    [_request cancel];
    if (_delegate && [_delegate respondsToSelector:@selector(requestDidCancelLoad:)]) {
        [_delegate requestDidCancelLoad:self];
    }
    iOSLog(@"cancelling request");
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
    long long postBodySize = 0; 
    
	if ([self getRequestMethod] == ITTRequestMethodGet){
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
        NSString *urlStr = [NSString stringWithFormat:@"%@%@",url,paramString];
        NSURL *nsUrl = [[NSURL alloc] initWithString:urlStr];
        _request = [[ASIFormDataRequest alloc] initWithURL:nsUrl];
        RELEASE_SAFELY(nsUrl);
        
        //postBodySize += [urlStr lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
        [_request setRequestMethod:@"GET"];
    }else{
        //postBodySize += [url lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
        
        NSURL *nsUrl = [[NSURL alloc] initWithString:url];
        _request = [[ASIFormDataRequest alloc] initWithURL:nsUrl];
        RELEASE_SAFELY(nsUrl);
        [_request setRequestMethod:@"POST"];
        ASIPostFormat postFormat = ASIURLEncodedPostFormat;
        for (NSString *key in [allParams allKeys]) {
            if ([[allParams objectForKey:key] isKindOfClass:[NSData class]]) {
                postFormat = ASIMultipartFormDataPostFormat;
                NSData* data = (NSData*)[allParams objectForKey:key];
                [_request addData:data withFileName:@"image.jpg" andContentType:@"image/jpeg" forKey:key];
                postBodySize += [data length];
            }else if ([[allParams objectForKey:key] isKindOfClass:[UIImage class]]) {
                postFormat = ASIMultipartFormDataPostFormat;
                UIImage* image = [allParams objectForKey:key];
                NSData* data = UIImageJPEGRepresentation(image, 0.8);
                [_request addData:data withFileName:@"image.jpg" andContentType:@"image/jpeg" forKey:key];
                postBodySize += [data length];
            }else{
                [_request addPostValue:[allParams objectForKey:key] forKey:key];
                postBodySize += [key lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
                postBodySize += [[allParams objectForKey:key] lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
            }
            
        }
        _request.postFormat = postFormat;
    }
    _request.delegate = self;
    _request.defaultResponseEncoding = [self getResponseEncoding];
    _request.timeOutSeconds = 120;
    _request.allowCompressedResponse = YES;
    _request.shouldCompressRequestBody = NO;
    
//    [[ITTNetworkTrafficManager sharedManager] logTrafficOut:postBodySize];
}

- (void)doRequestWithParams:(NSDictionary*)params{	
    [self generateRequestWithUrl:self.requestUrl withParameters:params];
    
    [_request startAsynchronous];
    iOSLog(@"request %@ is created, URL is: %@", [self class], [_request url]);
}

- (void)dealloc {	
    RELEASE_SAFELY(_request);

	[super dealloc];
}

- (BOOL)onReceivedCacheData:(NSObject*)cacheData{
    // return yes to finish this request, return no to continue request from server
    iOSLog(@"using cache data for request:%@", [self class]);
    if (!cacheData) {
        return NO;
    }
    if ([cacheData isKindOfClass:[NSDictionary class]]) {
        self.resultDic = (NSMutableDictionary *)[cacheData retain];
        _result = [[ITTRequestResult alloc] initWithCode:[self.resultDic objectForKey:@"result"] 
                                             withMessage:@""];
        if(_delegate && [_delegate respondsToSelector:@selector(requestDidFinishLoad:)]){
            [_delegate requestDidFinishLoad:self];
        }
        return YES;
    }else{
        iOSLog(@"request:[%@],cache data should be handled by subclass", [self class]);
        return NO;
    }
}
#pragma mark - request delegate method

- (void)requestStarted:(ASIFormDataRequest*)request {
	[self showIndicator:YES];
	if(_delegate && [_delegate respondsToSelector:@selector(requestDidStartLoad:)]){
		[_delegate requestDidStartLoad:self];
	}
}

- (void)requestFinished:(ASIFormDataRequest*)request {
//    [[ITTNetworkTrafficManager sharedManager] logTrafficIn:request.totalBytesRead];
    [self showIndicator:NO];
	NSString *responseString;
    if (request.allowCompressedResponse) {
        responseString = [[NSString alloc] initWithData:[request responseData] encoding:[self getResponseEncoding]];
    }else{
        responseString = [[NSString alloc] initWithData:[request rawResponseData] encoding:[self getResponseEncoding]];
    }
    
	[self handleResultString:responseString];
    RELEASE_SAFELY(responseString);
    
	[self release];
}

- (void)requestFailed:(ASIFormDataRequest*)request {
	[self showIndicator:NO];
	iOSLog(@"http request error:\n request:%@\n error:%@",[request.url absoluteString],request.error);
	if(_delegate && [_delegate respondsToSelector:@selector(request:didFailLoadWithError:)]){
		[_delegate request:self didFailLoadWithError:request.error];
	}
	
	if (request.error.domain == NetworkRequestErrorDomain) {
		NSString *errorMsg = nil;
		switch ([request.error code]) {
			case ASIConnectionFailureErrorType:
				errorMsg = @"无法连接到网络";
				break;
			case ASIRequestTimedOutErrorType:
				errorMsg = @"访问超时";
				break;
			case ASIAuthenticationErrorType:
				errorMsg = @"服务器身份验证失败";
				break;
			case ASIRequestCancelledErrorType:
				//errorMsg = @"request is cancelled";
				errorMsg = @"服务器请求已取消";
				break;
			case ASIUnableToCreateRequestErrorType:
				//errorMsg = @"ASIUnableToCreateRequestErrorType";
				errorMsg = @"无法创建服务器请求";
				break;
			case ASIInternalErrorWhileBuildingRequestType:
				//errorMsg = @"ASIInternalErrorWhileBuildingRequestType";
				errorMsg = @"服务器请求创建异常";
				break;
			case ASIInternalErrorWhileApplyingCredentialsType:
				//errorMsg = @"ASIInternalErrorWhileApplyingCredentialsType";
				errorMsg = @"服务器请求异常";
				break;
			case ASIFileManagementError:
				//errorMsg = @"ASIFileManagementError";
				errorMsg = @"服务器请求异常";
				break;
			case ASIUnhandledExceptionError:
				//errorMsg = @"ASIUnhandledExceptionError";
				errorMsg = @"未知请求异常异常";
				break;
			default:
				errorMsg = @"服务器故障或网络链接失败！";
				break;
		}
        if ([request.error code] != ASIRequestCancelledErrorType) {
            iOSLog(@"error detail:%@\n",request.error.userInfo);
            iOSLog(@"error code:%d",[request.error code]);
            if (!_useSilentAlert) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                message:errorMsg 
                                                               delegate:nil
                                                      cancelButtonTitle:@"取消"
                                                      otherButtonTitles:nil];
                [alert show];
                [alert release];
            }
        }
	}
	[self release];
}



@end
