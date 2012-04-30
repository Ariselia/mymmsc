//
//  EncTextViewController.h
//  FengZi
//

//  Copyright (c) 2011年 iTotemStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EncodeEncTextViewController : UIViewController<UITextFieldDelegate>{
    IBOutlet UITextField *_keyText;
    UILabel * _discribLabel;
    IBOutlet UITextView *_contentText;
}

@end
