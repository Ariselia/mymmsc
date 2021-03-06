//
//  UCStoreBBS.h
//  FengZi
//
//  Created by  on 12-1-4.
//  Copyright (c) 2012年 iTotemStudio. All rights reserved.
//

#import <iOSApi/UIViewController+KeyBoard.h>
#import "Api+eShop.h"
#import <iOSApi/iOSTableViewController.h>

@interface UCStoreBBS : iOSTableViewController<iOSTableDataDelegate>{
    UITextField     *nikename;
    UITextView      *content;
    
    NSMutableArray *items;
    int             _page;
}
@property (nonatomic, assign) ProductInfo2 *info;

@property (nonatomic, retain) IBOutlet UITextField *nikename;
@property (nonatomic, retain) IBOutlet UITextView *content;

- (IBAction)bbsSubmit:(id)sender;
- (IBAction)textFieldShouldReturn:(id)sender;
@end
