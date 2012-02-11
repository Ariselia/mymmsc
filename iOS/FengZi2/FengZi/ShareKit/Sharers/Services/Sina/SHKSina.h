//
//  SHKSina.h
//  WSJJ_iPad
//
//  Created by lian jie on 1/18/11.
//  Copyright 2011 2009-2010 Dow Jones & Company, Inc. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "SHKOAuthSharer.h"
#import "SHKSinaForm.h"
@interface SHKSina : SHKOAuthSharer{	
	BOOL xAuth;
	id delegate;
}

@property BOOL xAuth;
@property(nonatomic, assign) id delegate;

#pragma mark -
#pragma mark UI Implementation

- (void)showSinaForm;

#pragma mark -
#pragma mark Share API Methods

- (void)shortenURL;
- (void)shortenURLFinished:(SHKRequest *)aRequest;

- (void)sendForm:(SHKSinaForm *)form;
- (void)sendImage;
- (void)sendStatus;
- (void)sendStatusTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data;
- (void)sendStatusTicket:(OAServiceTicket *)ticket didFailWithError:(NSError*)error;

@end