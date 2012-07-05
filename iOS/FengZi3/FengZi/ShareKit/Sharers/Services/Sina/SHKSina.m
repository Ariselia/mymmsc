//
//  SHKSina.m
//  WSJJ_iPad
//
//  Created by lian jie on 1/18/11.
//  Copyright 2011 2009-2010 Dow Jones & Company, Inc. All rights reserved.
//

#import "SHKSina.h"
#import "PseudoBase64.h"

@implementation SHKSina

@synthesize xAuth;
@synthesize delegate;

- (id)init{
	if ((self = [super init])){	
		// OAUTH		
		self.consumerKey = SHKSinaKey;		
		self.secretKey = SHKSinaSecret;
 		self.authorizeCallbackURL = [NSURL URLWithString:SHKSinaCallbackUrl];// HOW-TO: In your Twitter application settings, use the "Callback URL" field.  If you do not have this field in the settings, set your application type to 'Browser'.
		
		// XAUTH
		self.xAuth = NO;
		
		// You do not need to edit these, they are the same for everyone
	    self.authorizeURL = [NSURL URLWithString:@"http://api.t.sina.com.cn/oauth/authorize"];
	    self.requestURL = [NSURL URLWithString:@"http://api.t.sina.com.cn/oauth/request_token"];
	    self.accessURL = [NSURL URLWithString:@"http://api.t.sina.com.cn/oauth/access_token"]; 
	}	
	return self;
}


#pragma mark -
#pragma mark Configuration : Service Defination

+ (NSString *)sharerTitle{
	return @"新浪微博分享";
}

+ (BOOL)canShareURL{
	return YES;
}

+ (BOOL)canShareText{
	return YES;
}

// TODO use img.ly to support this
//+ (BOOL)canShareImage
//{
//	return YES;
//}


#pragma mark -
#pragma mark Configuration : Dynamic Enable

- (BOOL)shouldAutoShare{
	return NO;
}


#pragma mark -
#pragma mark Authorization

- (BOOL)isAuthorized{		
	return [self restoreAccessToken];
}

- (void)promptAuthorization{		
	if (xAuth){
		[super authorizationFormShow]; // xAuth process
	}else{
		[super promptAuthorization]; // OAuth process		
	}
}


#pragma mark xAuth

+ (NSString *)authorizationFormCaption{
	return @"创建一个新浪微博帐号";
}

+ (NSArray *)authorizationFormFields{
	return [NSArray arrayWithObjects:
			[SHKFormFieldSettings label:@"用户名" key:@"username" type:SHKFormFieldTypeText start:nil],
			[SHKFormFieldSettings label:@"密码" key:@"password" type:SHKFormFieldTypePassword start:nil],		
			nil];
}

- (void)authorizationFormValidate:(SHKFormController *)form{
	self.pendingForm = form;
	[self tokenAccess];
}
- (void)tokenRequestModifyRequest:(OAMutableURLRequest *)oRequest{
	[oRequest setOAuthParameterName:@"oauth_callback" withValue:authorizeCallbackURL.absoluteString];
}
- (void)tokenAccessModifyRequest:(OAMutableURLRequest *)oRequest{	
	[oRequest setOAuthParameterName:@"oauth_verifier" withValue:[self.authorizeResponseQueryVars objectForKey:@"oauth_verifier"]];
}

- (void)tokenAccessTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data {
	/*if (xAuth) 
	{
		if (ticket.didSucceed)
		{
			[item setCustomValue:[[pendingForm formValues] objectForKey:@"followMe"] forKey:@"followMe"];
			[pendingForm close];
		}
		
		else
		{
			[self tokenAccessTicket:ticket didFailWithError:[SHK error:[[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease]]];
			return;
		}
	}
	else
	{
		if (ticket.didSucceed)
		{
			if (delegate){
				[delegate recievedDidSucceed];
			}
		}
	}*/
	[super tokenAccessTicket:ticket didFinishWithData:data];
    [[NSNotificationCenter defaultCenter] postNotificationName:SHARE_AUTH_FINISH object:self
                                                      userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"sina",@"type", nil]];
}


#pragma mark -
#pragma mark UI Implementation

- (void)show{
	if (item.shareType == SHKShareTypeURL){
		[self shortenURL];
	}else if (item.shareType == SHKShareTypeImage){
		[item setCustomValue:item.text forKey:@"status"];
		[self showSinaForm];
	}else if (item.shareType == SHKShareTypeText){
		[item setCustomValue:item.text forKey:@"status"];
		[self showSinaForm];
	}
}

- (void)showSinaForm{
	SHKSinaForm *rootView = [[SHKSinaForm alloc] initWithNibName:nil bundle:nil];	
	rootView.delegate = self;
	
	// force view to load so we can set textView text
	[rootView view];
	
	rootView.textView.text = [item customValueForKey:@"status"];
	rootView.hasAttachment = item.image != nil;
	
	[self pushViewController:rootView animated:NO];
	
	[[SHK currentHelper] showViewController:self];	
}

- (void)sendForm:(SHKSinaForm *)form{	
	[item setCustomValue:form.textView.text forKey:@"status"];
	[self tryToSend];
}


#pragma mark -

- (void)shortenURL{	
	if (![SHK connected]){
		[item setCustomValue:[NSString stringWithFormat:@"%@ %@", item.title, [item.URL.absoluteString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] forKey:@"status"];
		[self showSinaForm];		
		return;
	}
	
	if (!quiet)
		[[SHKActivityIndicator currentIndicator] displayActivity:SHKLocalizedString(@"Shortening URL...")];
	
	self.request = [[[SHKRequest alloc] initWithURL:[NSURL URLWithString:[NSMutableString stringWithFormat:@"http://api.bit.ly/v3/shorten?login=%@&apikey=%@&longUrl=%@&format=txt",
																		  SHKBitLyLogin,
																		  SHKBitLyKey,																		  
																		  SHKEncodeURL(item.URL)
																		  ]]
											 params:nil
										   delegate:self
								 isFinishedSelector:@selector(shortenURLFinished:)
											 method:@"GET"
										  autostart:YES] autorelease];
}

- (void)shortenURLFinished:(SHKRequest *)aRequest{
	[[SHKActivityIndicator currentIndicator] hide];
	
	NSString *result = [[aRequest getResult] stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
	
	if (result == nil || [NSURL URLWithString:result] == nil){
		// TODO - better error message
		[[[[UIAlertView alloc] initWithTitle:SHKLocalizedString(@"Shorten URL Error")
									 message:SHKLocalizedString(@"We could not shorten the URL.")
									delegate:nil
						   cancelButtonTitle:SHKLocalizedString(@"Continue")
						   otherButtonTitles:nil] autorelease] show];
		
		[item setCustomValue:[NSString stringWithFormat:@"%@ %@", item.title, [item.URL.absoluteString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] forKey:@"status"];
	}
	
	else
		[item setCustomValue:[NSString stringWithFormat:@"%@ %@", item.title, result] forKey:@"status"];
	
	[self showSinaForm];
}


#pragma mark -
#pragma mark Share API Methods

- (BOOL)validate{
	NSString *status = [item customValueForKey:@"status"];
	return status != nil && status.length <= 140;
}

- (BOOL)send{	
	
	if (![self validate]){
		[self show];
	}else{	
		if (item.shareType == SHKShareTypeImage && item.image!=nil){
			[self sendImage];
        }else{
            [self sendStatus];        
        }
		
		
		// Notify delegate
		[self sendDidStart];	
		
		return YES;
	}
	
	return NO;
}

- (void)sendImage{
	
	OAMutableURLRequest *oRequest = [[OAMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://api.t.sina.com.cn/statuses/upload.json"]
																	consumer:consumer
																	   token:accessToken
																	   realm:nil
														   signatureProvider:signatureProvider];
	[oRequest setHTTPMethod:@"POST"];
	
	OARequestParameter *statusParam = [[OARequestParameter alloc] initWithName:@"status"
																		 value:[item customValueForKey:@"status"]];
	NSArray *params = [NSArray arrayWithObjects:statusParam, nil];
	[oRequest setParameters:params];
	[statusParam release];
    
    [oRequest prepare];
	
	CGFloat compression = 0.9f;
	NSData *imageData = UIImageJPEGRepresentation([item image], compression);
	
	// TODO
	// Note from Nate to creator of sendImage method - This seems like it could be a source of sluggishness.
	// For example, if the image is large (say 3000px x 3000px for example), it would be better to resize the image
	// to an appropriate size (max of img.ly) and then start trying to compress.
	
	while ([imageData length] > 700000 && compression > 0.1) {
		// NSLog(@"Image size too big, compression more: current data size: %d bytes",[imageData length]);
		compression -= 0.1;
		imageData = UIImageJPEGRepresentation([item image], compression);
		
	}
	
	NSString *boundary = @"0xKhTmLbOuNdArY";
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
	[oRequest setValue:contentType forHTTPHeaderField:@"Content-Type"];
	
	NSMutableData *body = [NSMutableData data];
	NSString *dispKey = @"Content-Disposition: form-data; name=\"pic\"; filename=\"upload.jpg\"\r\n";

	
	
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[dispKey dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[@"Content-Type: image/jpg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:imageData];
	[body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];

    [body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"status\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[item customValueForKey:@"status"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];	
	
	[body appendData:[[NSString stringWithFormat:@"--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	// setting the body of the post to the reqeust
	[oRequest setHTTPBody:body];
	
	// Notify delegate
	[self sendDidStart];
	
	// Start the request
	OAAsynchronousDataFetcher *fetcher = [OAAsynchronousDataFetcher asynchronousFetcherWithRequest:oRequest
																						  delegate:self
																				 didFinishSelector:@selector(sendImageTicket:didFinishWithData:)
																				   didFailSelector:@selector(sendImageTicket:didFailWithError:)];	
	
	[fetcher start];
	
	
	[oRequest release];

    
}

- (void)sendImageTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data {
	// TODO better error handling here
	// NSLog([[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease]);
	
	if (ticket.didSucceed) {
		[self sendDidFinish];
		// Finished uploading Image, now need to posh the message and url in twitter
		NSString *dataString = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
		NSRange startingRange = [dataString rangeOfString:@"<url>" options:NSCaseInsensitiveSearch];
		//NSLog(@"found start string at %d, len %d",startingRange.location,startingRange.length);
		NSRange endingRange = [dataString rangeOfString:@"</url>" options:NSCaseInsensitiveSearch];
		//NSLog(@"found end string at %d, len %d",endingRange.location,endingRange.length);
		
		if (startingRange.location != NSNotFound && endingRange.location != NSNotFound) {
			NSString *urlString = [dataString substringWithRange:NSMakeRange(startingRange.location + startingRange.length, endingRange.location - (startingRange.location + startingRange.length))];
			//NSLog(@"extracted string: %@",urlString);
			[item setCustomValue:[NSString stringWithFormat:@"%@ %@",[item customValueForKey:@"status"],urlString] forKey:@"status"];
			[self sendStatus];
		}
		[[NSNotificationCenter defaultCenter] postNotificationName:SHARE_FINISH object:self
                                                          userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"sina",@"type", nil]];
	} else {
		[self sendDidFailWithError:nil];
	}
}

- (void)sendImageTicket:(OAServiceTicket *)ticket didFailWithError:(NSError*)error {
	[self sendDidFailWithError:error];
}


- (void)sendStatus{
	
	OAMutableURLRequest *oRequest = [[OAMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://api.t.sina.com.cn/statuses/update.json"]
																	consumer:consumer
																	   token:accessToken
																	   realm:nil
														   signatureProvider:nil];
	
	[oRequest setHTTPMethod:@"POST"];
	
	OARequestParameter *statusParam = [[OARequestParameter alloc] initWithName:@"status"
																		 value:[item customValueForKey:@"status"]];
	NSArray *params = [NSArray arrayWithObjects:statusParam, nil];
	[oRequest setParameters:params];
	[statusParam release];
	
	OAAsynchronousDataFetcher *fetcher = [OAAsynchronousDataFetcher asynchronousFetcherWithRequest:oRequest
																						  delegate:self
																				 didFinishSelector:@selector(sendStatusTicket:didFinishWithData:)
																				   didFailSelector:@selector(sendStatusTicket:didFailWithError:)];	
	
	[fetcher start];
	[oRequest release];
    
}

- (void)sendStatusTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data {	
	// TODO better error handling here
	
	
	if (ticket.didSucceed) {
		[self sendDidFinish];
    }
	else
		[self sendDidFailWithError:nil];
}


- (void)sendStatusTicket:(OAServiceTicket *)ticket didFailWithError:(NSError*)error
{
	[self sendDidFailWithError:error];
}


@end