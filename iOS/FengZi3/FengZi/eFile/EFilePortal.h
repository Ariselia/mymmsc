//
//  EBuyPortal.h
//  FengZi
//
//  Created by wangfeng on 12-3-5.
//  Copyright (c) 2012年 iTotemStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

// 电子蜂夹 入口
@interface EFilePortal : UIViewController{
    //UIButton           *_btnRight; // 导航条按钮
    //UIImage            *_curImage;
    UITextBorderStyle   _borderStyle;
    NSMutableArray     *_headers; // 表头显示CELL
    NSMutableArray     *_items; // 数据CELL
    UIFont             *_font;
    int                 _page;
    int                 _pageDZQ;
    
    BOOL                isOnline;
    BOOL                _isNet;
    BOOL                _isLocal;
    BOOL                _isDZQ;
    BOOL                _isHYK;
    BOOL                _isnotFirst;
}
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UISegmentedControl *group;

@property (nonatomic, retain) IBOutlet UIButton *leftBtn;
@property (nonatomic, retain) IBOutlet UIButton *rightBtn;
@property (nonatomic, retain) IBOutlet UIButton *localBtn;
@property (nonatomic, retain) IBOutlet UIButton *netBtn;
@property (nonatomic, retain) IBOutlet UIImageView *noHYK;
@property (nonatomic, retain) IBOutlet UIImageView *noDZQ;

@property (nonatomic, retain) IBOutlet UIImageView *tableBg;
// 分类
- (IBAction)doGroup:(id)sender;

// 选择
- (IBAction)segmentAction:(UISegmentedControl *)segment;

//电子券
-(IBAction)gotoDZQ:(id)sender;
//会员卡
-(IBAction)gotoHYK:(id)sender;

//本地
-(IBAction)gotoLocal:(id)sender;
//网络
-(IBAction)gotoNet:(id)sender;
@end
