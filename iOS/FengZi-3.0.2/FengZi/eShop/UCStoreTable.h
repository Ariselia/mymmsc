//
//  UCStoreTable.h
//  FengZi
//
//  Created by WangFeng on 11-12-15.
//  Copyright (c) 2012年 mymmsc.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iOSApi/DropDownList.h>
#import <iOSApi/iOSTableViewController.h>

@interface UCStoreTable : iOSTableViewController<DropDownListDelegate, iOSTableDataDelegate> {
    UIButton           *_btnRight; // 导航条按钮
    UIImage            *_curImage;
    UITextBorderStyle   _borderStyle;
    NSMutableArray     *items;
    UIFont             *font;
    
    DropDownList *ddTypes;
    NSArray *listIsp, *listIType;
    
    int _type;
    int _sorttype;
    int _pricetype;
    int _person;
    int _page;
}

@property (nonatomic, retain) IBOutlet UISegmentedControl *seg;
@property (nonatomic, assign) int person, page;
@property (nonatomic, assign) BOOL bPerson;

- (IBAction)doSelectType:(id)sender;

- (IBAction)gotoSubscribe:(id)sender;

@end
