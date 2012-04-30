//
//  EncodeScheduleViewController.h
//  FengZi
//

//  Copyright (c) 2011年 iTotemStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EncodeScheduleViewController : UIViewController{
    
    IBOutlet UITextField *_dateText;
    IBOutlet UITextField *_titleText;
    IBOutlet UITextView *_contentText;
    IBOutlet UIView *_pickerView;
    IBOutlet UIDatePicker *_datePicker;
    NSDate *_selectDate;
    NSString *_date;
    UILabel * _discribLabel;
}

@end
