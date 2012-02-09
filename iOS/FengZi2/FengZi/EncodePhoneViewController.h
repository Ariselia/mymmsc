//
//  EncodePhoneViewController.h
//  FengZi
//

//  Copyright (c) 2011年 iTotemStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
@interface EncodePhoneViewController : UIViewController<ABPeoplePickerNavigationControllerDelegate>{
    ABPeoplePickerNavigationController *_peoplepicker;
    IBOutlet UITextField *_phoneText;
}

@end
