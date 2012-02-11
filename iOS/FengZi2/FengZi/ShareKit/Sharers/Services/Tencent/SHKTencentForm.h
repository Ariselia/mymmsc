//
//  SHKTencentForm.h
//  AsiaScene
//
//  Created by Rainbow on 5/4/11.
//  Copyright 2011 iTotemStudio. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SHKTencentForm : UIViewController <UITextViewDelegate> {
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