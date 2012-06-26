//
//  FeedbackViewController.h
//  FengZi
//
//  Created by lt ji on 11-12-19.
//  Copyright (c) 2011年 iTotemStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ITTDataRequest.h"
@interface FeedbackViewController : UIViewController<DataRequestDelegate>{
    IBOutlet UITextField *_titleField;
    IBOutlet UITextField *_telField;
    UILabel * _discribLabel;
    IBOutlet UIView *_mainView;
    IBOutlet UITextView *_contentTextView;
    IBOutlet UIButton *_submitBtn;
}

@end
