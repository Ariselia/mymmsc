//
//  UCUpdateNikename.h
//  FengZi
//
//  Created by  on 11-12-31.
//  Copyright (c) 2011年 iTotemStudio. All rights reserved.
//

#import "Api+UserCenter.h"
#import <iOSApi/iOSImageView.h>
//#import "UIViewController+Utils.h"
//#import <iOSApi/UIViewController+KeyBoard.h>

// 修改个人信息
@interface UCUpdateNikename : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate>{
    ucUserInfo        *ucInfo;
    UIImage *_curImage;
    
    NSMutableArray    *items;
    UIFont            *font;
    UITextBorderStyle  _borderStyle;
    
    UITextField *passwd;
    
    UITextField *nikename;
    UITextField *contact;
    UITextField *realname;
    UITextField *birthday;
    UITextField *QQ;
    UITextField *address;
    UITextField *email;
    UITextField *idNumber;
    UISwitch    *isopen;
    UITextField *likes;
    UITextField *modTime;
    UITextField *postCode;
    UITextField *regTime;
    UISwitch    *sex;
    UITextField *userid;
    UITextField *weibo;
    
    NSString *srvAuthcode; // 服务器返回的验证码
    
    UITextField *content;
}

@property (nonatomic, assign) int idDest;
@property (nonatomic, retain) IBOutlet UITableView *tableView;

@end
