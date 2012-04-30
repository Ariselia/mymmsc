//
//  EncodeCardViewController.h
//  FengZi
//

//  Copyright (c) 2011年 iTotemStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "CardTableViewCell.h"
@interface EncodeCardViewController : UIViewController<ABPeoplePickerNavigationControllerDelegate,CardTableViewCellDelegate>{
    ABPeoplePickerNavigationController *_peoplepicker;
    IBOutlet UITableView *_tableview;
    NSMutableDictionary *dic;
}

@end
