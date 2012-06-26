//
//  UCRegister.h
//  FengZi
//
//  Created by  on 11-12-27.
//  Copyright (c) 2011年 iTotemStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UCRegister : UIViewController {
    UIButton         *_btnRight; // 导航条按钮
    UIImage          *_curImage;
    BOOL             isShowPwd;
    NSMutableArray   *items;
    UIFont            *font;
    UITextBorderStyle _borderStyle;
    IBOutlet UITextField       *userId;
    IBOutlet UITextField       *passwd;
    UITextField       *passwd2;
    IBOutlet UITextField       *authcode;
    IBOutlet UITextField       *nikename;
    UISwitch          *confirmProto;
    IBOutlet UIButton          *showPwdBtn;
    IBOutlet UIButton          *getYZMBtn;
    IBOutlet UIButton          *regBtn;
    IBOutlet UIButton          *isCheckBtn;
    NSString *srvAuthcode; // 服务器返回的验证码
    BOOL isCheck;
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;

- (IBAction)doRegister:(id)sender;
- (IBAction)getCheckCode:(id)sender event:(id)event;
- (IBAction)readProto:(id)sender event:(id)event;
- (IBAction)showPwd:(id)sender event:(id)event;
- (IBAction)doOK:(id)sender;
@end
