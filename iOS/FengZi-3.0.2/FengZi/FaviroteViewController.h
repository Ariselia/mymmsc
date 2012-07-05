//
//  FaviroteViewController.h
//  FengZi
//
//  Created by lt ji on 11-12-12.
//  Copyright (c) 2011年 iTotemStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ZXing/Decoder.h>
#import "RefreshTableFooterView.h"

@interface FaviroteViewController : UIViewController<DecoderDelegate,RefreshTableFooterDelegate>{
    RefreshTableFooterView *_refreshFooterView;
    IBOutlet UITableView *_tableView;
    IBOutlet UIButton *_editbtn;
    NSMutableArray *_favArray;
    UIImage *_curImage;
    int _startIndex;
    BOOL _reloading;
    IBOutlet UIView *_noResultView;
    IBOutlet UIButton *_goBackBtn;
}
- (void)doneLoadingTableViewData;
- (IBAction)goBack:(id)sender;
@end
