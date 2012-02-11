//
//  UCUpdateNikename.h
//  FengZi
//
//  Created by  on 11-12-31.
//  Copyright (c) 2011年 iTotemStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UCUpdateNikename : UIViewController{
    UIButton *_btnRight; // 导航条按钮
    UIImage *_curImage;
    
    NSMutableArray *items;
    UIFont         *font;
    UITextBorderStyle _borderStyle;
    //UITextField *userId;
    UITextField *passwd;
    UITextField *nikename;
    //UITextField *authcode;
    
    NSString *srvAuthcode; // 服务器返回的验证码
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;

- (IBAction)doAction:(id)sender;

@end
