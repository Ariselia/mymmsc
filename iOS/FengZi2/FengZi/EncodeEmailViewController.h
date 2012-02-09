//
//  EncodeEmailViewController.h
//  FengZi
//

//  Copyright (c) 2011年 iTotemStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EncodeEmailViewController : UIViewController{
    IBOutlet UITextField *_titleText;
    IBOutlet UITextField *_mailText;
    IBOutlet UITextView *_contentText;
    UILabel * _discribLabel;
}

@end
