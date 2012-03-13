//
//  eShopProducerInfo.h
//  FengZi
//
//  Created by wangfeng on 12-3-5.
//  Copyright (c) 2012年 iTotemStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Api+eShop.h"
#import <iOSApi/ImageView.h>
#import <iOSApi/iOSTableViewController.h>
#import <iOSApi/HttpDownload.h>

@interface eShopProducerInfo : UITableViewCell<HttpDownloadDelegate>{
    ProductInfo *info;
    ImageView *infoImage;
    UILabel    *infoType;
    UILabel    *infoName;
    UILabel    *infoWriter;
    UILabel    *infoUploader;
    UILabel    *infoPrice;
    UITextView *infoInfo;
    ProductInfo2 *info2;
    BOOL          bRead;
}

@property (nonatomic, retain) ProductInfo *info;
@property (nonatomic, retain) IBOutlet ImageView *infoImage;
@property (nonatomic, retain) IBOutlet UILabel *infoType;
@property (nonatomic, retain) IBOutlet UILabel *infoName;
@property (nonatomic, retain) IBOutlet UILabel *infoWriter;
@property (nonatomic, retain) IBOutlet UILabel *infoUploader;
@property (nonatomic, retain) IBOutlet UILabel *infoPrice;
@property (nonatomic, retain) IBOutlet UITextView *infoInfo;
@property (nonatomic, retain) IBOutlet UIButton *btnAction;
@property (nonatomic, assign) id idInfo;

- (void)loadData:(ProductInfo *)pInfo;

- (IBAction)doShare:(id)sender;
- (IBAction)doPinglun:(id)sender;
- (IBAction)doDownload:(id)sender;

@end
