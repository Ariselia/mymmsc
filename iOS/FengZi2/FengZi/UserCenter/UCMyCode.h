//
//  UCMyCode.h
//  FengZi
//
//  Created by  on 11-12-31.
//  Copyright (c) 2011年 iTotemStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CodeInfo;

@interface UCMyCode : UIViewController {
    UIButton          *_btnRight; // 导航条按钮
    UIImage           *_curImage;
    
    NSMutableArray    *items;
    UIFont            *font;
    UITextBorderStyle  _borderStyle;
    
    CodeInfo          *xInput;
    
    UIView* sideSwipeView;
    NSArray* buttonData;
    NSMutableArray* buttons;
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;

@end
