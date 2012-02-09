//
//  SHKSinaForm.h
//  WSJJ_iPad
//
//  Created by lian jie on 1/18/11.
//  Copyright 2011 2009-2010 Dow Jones & Company, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SHKSinaForm : UIViewController <UITextViewDelegate>
{
	id delegate;
	UITextView *textView;
	UILabel *counter;
	BOOL hasAttachment;
}

@property (nonatomic, retain) id delegate;
@property (nonatomic, retain) UITextView *textView;
@property (nonatomic, retain) UILabel *counter;
@property BOOL hasAttachment;

- (void)layoutCounter;

@end
