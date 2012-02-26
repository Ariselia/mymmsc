//
//  UCStoreInfo.h
//  FengZi
//
//  Created by  on 12-1-3.
//  Copyright (c) 2012年 iTotemStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Api+AppStore.h"
#import <iOSApi/iOSTableViewController.h>

@interface UCStoreInfo : iOSTableViewController<iOSTableDataDelegate>{
    ProductInfo *info;
    UIImageView *infoImage;
    UILabel    *infoType;
    UILabel    *infoName;
    UILabel    *infoWriter;
    UILabel    *infoUploader;
    UILabel    *infoPrice;
    UITextView *infoInfo;
    
    NSMutableArray     *items;
    UIFont             *font;
    int _page;
}

@property (nonatomic, retain) ProductInfo *info;
@property (nonatomic, retain) IBOutlet UIImageView *infoImage;
@property (nonatomic, retain) IBOutlet UILabel *infoType;
@property (nonatomic, retain) IBOutlet UILabel *infoName;
@property (nonatomic, retain) IBOutlet UILabel *infoWriter;
@property (nonatomic, retain) IBOutlet UILabel *infoUploader;
@property (nonatomic, retain) IBOutlet UILabel *infoPrice;
@property (nonatomic, retain) IBOutlet UITextView *infoInfo;
//@property (nonatomic, retain) IBOutlet UITableView *tableView;

@property (nonatomic, assign) int page;

- (IBAction)doShare:(id)sender;
- (IBAction)doPinglun:(id)sender;
- (IBAction)doDownload:(id)sender;

@end
