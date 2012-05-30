//
//  UCLogin.h
//  FengZi
//
//  Created by  on 11-12-27.
//  Copyright (c) 2011年 iTotemStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
@class iOSActivityIndicator;

@interface UCLogin : UIViewController{
    NSMutableArray *items;
    UIFont         *font;
    UITextBorderStyle _borderStyle;
    IBOutlet UITextField *userId;
    IBOutlet UITextField *passwd;
    UITextField *vailed;
    BOOL         toSave;
    UISwitch    *isSavePasswd;
    IBOutlet UIButton *isSaveBtn;
    IBOutlet UIButton *forgetPwdBtn;
    IBOutlet UIButton *loginBtn;
    IBOutlet UIButton *regBtn;
    UIButton *_btnRight; // 导航条按钮
    UIImage *_curImage;
    
    NSString *srvAuthcode; // 服务器返回的验证码
    UILabel   *lbCode;
    
    BOOL       bDownload;
}
@property (nonatomic, assign) BOOL bModel;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, assign) BOOL bDownload;
- (IBAction)doForget:(id)sender;
- (IBAction)doLogin:(id)sender;
- (IBAction)doReg:(id)sender;
-(IBAction) btnSelectIsSavePasswd:(id)sender;
-(IBAction)doWriteMM:(id)sender;
-(IBAction)doWriteZH:(id)sender;
- (IBAction)textUpdate:(id)sender;
@end
