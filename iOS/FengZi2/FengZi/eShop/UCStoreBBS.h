//
//  UCStoreBBS.h
//  FengZi
//
//  Created by  on 12-1-4.
//  Copyright (c) 2012年 iTotemStudio. All rights reserved.
//

#import <iOSApi/UIViewController+KeyBoard.h>
#import "Api+AppStore.h"
#import <iOSApi/iOSTableViewController.h>

@interface UCStoreBBS : iOSTableViewController<iOSTableDataDelegate>{
    ProductInfo *info;
    
    UITextField *nikename;
    UITextView *content;
    
    NSMutableArray *items;
    int             _page;
}
@property (nonatomic, retain) ProductInfo *info;

@property (nonatomic, retain) IBOutlet UITextField *nikename;
@property (nonatomic, retain) IBOutlet UITextView *content;

- (IBAction)bbsSubmit:(id)sender;
- (IBAction)textFieldShouldReturn:(id)sender;
@end
