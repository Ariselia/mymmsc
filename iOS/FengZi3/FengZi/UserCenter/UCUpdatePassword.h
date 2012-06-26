//
//  UCUpdatePassword.h
//  FengZi
//
//  Created by  on 11-12-31.
//  Copyright (c) 2011年 iTotemStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UCUpdatePassword : UIViewController{
    UIButton *_btnRight; // 导航条按钮
    UIImage *_curImage;
    
    NSMutableArray *items;
    UIFont         *font;
    UITextBorderStyle _borderStyle;
    IBOutlet UITextField *passwd;
    IBOutlet UITextField *newpasswd;
    UITextField *newpasswd2;
    //UITextField *authcode;
    IBOutlet UIButton *doBtn;
    
    BOOL             isShowPwd;
    IBOutlet UIButton          *showPwdBtn;
    NSString *srvAuthcode; // 服务器返回的验证码
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;
- (IBAction)showPwd:(id)sender event:(id)event;
- (IBAction)doAction:(id)sender;

@end
