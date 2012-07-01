//
//  DecodeCardViewControlle.h
//  FengZi
//
//  Copyright (c) 2011年 iTotemStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FengZi/Api+Category.h>
#import <FengZi/BusCategory.h>
#import "DecodeCardCell.h"
#import "AddressBookUtils.h"
#import "ITTDataRequest.h"


@interface DecodeCardViewControlle : UIViewController<DecodeCardCellDelegate, DataRequestDelegate> {
    Card *_card;
    BusCategory *_category;
    NSString *_content;
    IBOutlet UITableView *_tableView;
    UIImage *_curImage;
    UIImage *_saveImage;
    UIButton *_phoneBtn;
    UIButton *_favBtn;
    HistoryType _historyType;
}

- (id)initWithNibName:(NSString *)nibNameOrNil
             category:(BusCategory *)cate
               result:(NSString *)input
            withImage:(UIImage *)image
             withType:(HistoryType)type
        withSaveImage:(UIImage*)sImage;

@end
