//
//  HistoryViewController.h
//  FengZi
//
//  Created by lt ji on 11-12-12.
//  Copyright (c) 2011年 iTotemStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ZXing/Decoder.h>
#import "RefreshTableFooterView.h"

@interface HistoryViewController : UIViewController<DecoderDelegate,RefreshTableFooterDelegate>{
    RefreshTableFooterView *_refreshFooterView;
    IBOutlet UITableView *_tableView;
    IBOutlet UIButton *_encodeHistoryBtn;
    IBOutlet UISearchBar *_searchBar;
    IBOutlet UIButton *_scanHistoryBtn;
    IBOutlet UILabel *_titlelabel;
    IBOutlet UIButton *_editbtn;
    NSMutableArray *_historyArray;
    UIImage *_curImage;
    int _startIndex;
    BOOL _isEncodeModel;
    BOOL _reloading;
    BOOL _isSearch;
    NSString *_key;
    IBOutlet UIView *_noResultView;
    IBOutlet UIScrollView *_scrollvier;
}
- (void)doneLoadingTableViewData;
@end
