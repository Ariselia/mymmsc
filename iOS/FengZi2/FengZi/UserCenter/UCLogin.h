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
    UITextField *userId;
    UITextField *passwd;
    UITextField *vailed;
    BOOL         toSave;
    UISwitch    *isSavePasswd;
    
    UIButton *_btnRight; // 导航条按钮
    UIImage *_curImage;
    
    NSString *srvAuthcode; // 服务器返回的验证码
    UILabel   *lbCode;
    
    BOOL       bDownload;
}
@property (nonatomic, assign) BOOL bModel;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, assign) BOOL bDownload;

- (IBAction)doLogin:(id)sender;
-(IBAction) btnSelectIsSavePasswd:(id)sender;
@end
