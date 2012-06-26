//
//  SHKTwitterAuthView.m
//  ShareKit
//
//  Created by Nathan Weiner on 6/21/10.

//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//
//

#import "SHKOAuthView.h"
#import "SHK.h"
#import "SHKOAuthSharer.h"

@implementation SHKOAuthView

@synthesize webView, delegate, spinner;

- (void)dealloc
{
	[webView release];
	[delegate release];
	[spinner release];
	[super dealloc];
}

- (id)initWithURL:(NSURL *)authorizeURL delegate:(id)d
{
    if ((self = [super initWithNibName:nil bundle:nil])) 
	{
		[self.navigationItem setLeftBarButtonItem:[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
																								 target:self
																								 action:@selector(cancel)] autorelease] animated:NO];
		
		self.delegate = d;
		
		self.webView = [[UIWebView alloc] initWithFrame:CGRectZero];
		webView.delegate = self;
		webView.scalesPageToFit = YES;
		webView.dataDetectorTypes = UIDataDetectorTypeNone;
		[webView release];
		
		[webView loadRequest:[NSURLRequest requestWithURL:authorizeURL]];		
		
    }
    return self;
}

- (void)loadView 
{ 	
	self.view = webView;
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
	
	// Remove the SHK view wrapper from the window
	[[SHK currentHelper] viewWasDismissed];
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{	
	if(delegate == nil){return YES;}
	/*
	 NSLog(@"request.URL.absoluteString:%@",request.URL.absoluteString);
	 NSLog(@"authorizeCallbackURL:%@",[delegate authorizeCallbackURL].absoluteString);
	 if ([request.URL.absoluteString rangeOfString:[delegate authorizeCallbackURL].absoluteString].location != NSNotFound)
	 {
	 // Get query
	 NSMutableDictionary *queryParams = nil;
	 if (request.URL.query != nil)
	 {
	 queryParams = [NSMutableDictionary dictionaryWithCapacity:0];
	 NSArray *vars = [request.URL.query componentsSeparatedByString:@"&"];
	 NSArray *parts;
	 for(NSString *var in vars)
	 {
	 parts = [var componentsSeparatedByString:@"="];
	 if (parts.count == 2)
	 [queryParams setObject:[parts objectAtIndex:1] forKey:[parts objectAtIndex:0]];
	 }
	 }
	 
	 [delegate tokenAuthorizeView:self didFinishWithSuccess:YES queryParams:queryParams error:nil];
	 self.delegate = nil;
	 
	 return NO;
	 }*/
	
	return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
	[self startSpinner];
}

- (void)webViewDidFinishLoad:(UIWebView *)aWebView{	
	[self stopSpinner];
	
    NSLog(@"request.URL.absoluteString:%@",webView.request.URL.absoluteString);
    NSLog(@"webView.request.URL.host:%@",webView.request.URL.host);
    NSLog(@"authorizeCallbackURL:%@",[delegate authorizeCallbackURL].absoluteString);
	if ([webView.request.URL.host isEqualToString:@"api.t.sina.com.cn"]) {
		NSString *pinText = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByClassName('getCodeWrap')[0].getElementsByTagName('span')[0].innerHTML"];
		if (pinText && [pinText length] > 0){
			// Get query
			//NSLog(@"pin:%@",pinText);
            NSString *oauth_verifier = pinText;
            NSMutableDictionary *queryParams = [NSMutableDictionary dictionaryWithCapacity:0];
            /*
             if (webView.request.URL.query != nil){
             queryParams = [NSMutableDictionary dictionaryWithCapacity:0];
             NSArray *vars = [webView.request.URL.query componentsSeparatedByString:@"&"];
             NSArray *parts;
             for(NSString *var in vars){
             parts = [var componentsSeparatedByString:@"="];
             if (parts.count == 2)
             [queryParams setObject:[parts objectAtIndex:1] forKey:[parts objectAtIndex:0]];
             }
             }*/
            [queryParams setObject:oauth_verifier forKey:@"oauth_verifier"];
            [delegate tokenAuthorizeView:self didFinishWithSuccess:YES queryParams:queryParams error:nil];
            self.delegate = nil;
			//return NO;
		}		// Extra sanity check for Twitter OAuth users to make sure they are using BROWSER with a callback instead of pin based auth
		if ([webView.request.URL.host isEqualToString:@"api.t.sina.com"] && [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('B')[0].innerHTML"].length)
			[delegate tokenAuthorizeView:self didFinishWithSuccess:NO queryParams:nil error:[SHK error:@"用户名密码有误！"]];
	}else if ([webView.request.URL.host isEqualToString:@"api.t.sohu.com"]) {
		if ([webView.request.URL.absoluteString rangeOfString:@"oauth_verifier"].location != NSNotFound){
			NSMutableDictionary *queryParams = nil;
			if (webView.request.URL.query != nil){
				queryParams = [NSMutableDictionary dictionaryWithCapacity:0];
				NSArray *vars = [webView.request.URL.query componentsSeparatedByString:@"&"];
				NSArray *parts;
				for(NSString *var in vars){
					parts = [var componentsSeparatedByString:@"="];
					if (parts.count == 2)
						[queryParams setObject:[parts objectAtIndex:1] forKey:[parts objectAtIndex:0]];
				}
			}
			[delegate tokenAuthorizeView:self didFinishWithSuccess:YES queryParams:queryParams error:nil];
			self.delegate = nil;
			//return NO;
		}
		
	}
    else if ([webView.request.URL.host isEqualToString:@"open.t.qq.com"])
    {
        if ([webView.request.URL.absoluteString rangeOfString:@"oauth_verifier"].location != NSNotFound)
        {
            NSMutableDictionary *queryParams = nil;
            if (webView.request.URL.query != nil){
                queryParams = [NSMutableDictionary dictionaryWithCapacity:0];
                NSArray *vars = [webView.request.URL.query componentsSeparatedByString:@"&"];
                NSArray *parts;
                for(NSString *var in vars){
                    parts = [var componentsSeparatedByString:@"="];
                    if (parts.count == 2)
                        [queryParams setObject:[parts objectAtIndex:1] forKey:[parts objectAtIndex:0]];
                }
            }
            [delegate tokenAuthorizeView:self didFinishWithSuccess:YES queryParams:queryParams error:nil];
            self.delegate = nil;
        }

    }
    else if([webView.request.URL.absoluteString rangeOfString:@"access_token"].length > 0)
    {
        NSMutableDictionary *queryParams = nil;
        if (webView.request.URL.absoluteString != nil) {
            queryParams = [NSMutableDictionary dictionaryWithCapacity:0];
            NSArray *vars = [webView.request.URL.absoluteString componentsSeparatedByString:@"&"];
            NSString *cutedStr = [vars objectAtIndex:0];
            NSArray *parts = [cutedStr componentsSeparatedByString:@"="];
            [queryParams setObject:[parts objectAtIndex:1] forKey:@"access_token"];
            [delegate tokenAuthorizeView:self didFinishWithSuccess:YES queryParams:queryParams error:nil];
            self.delegate = nil;
        }
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{	
	if ([error code] != NSURLErrorCancelled && [error code] != 102 && [error code] != NSURLErrorFileDoesNotExist)
	{
		[self stopSpinner];
		[delegate tokenAuthorizeView:self didFinishWithSuccess:NO queryParams:nil error:error];
	}
}

- (void)startSpinner
{
	if (spinner == nil)
	{
		self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
		[self.navigationItem setRightBarButtonItem:[[[UIBarButtonItem alloc] initWithCustomView:spinner] autorelease] animated:NO];
		spinner.hidesWhenStopped = YES;
		[spinner release];
	}
	
	[spinner startAnimating];
}

- (void)stopSpinner
{
	[spinner stopAnimating];	
}


#pragma mark -

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)cancel
{
	[delegate tokenAuthorizeCancelledView:self];
	[[SHK currentHelper] hideCurrentViewControllerAnimated:YES];
}

@end
