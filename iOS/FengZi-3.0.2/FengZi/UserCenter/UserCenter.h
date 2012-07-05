//
//  UserCenter.h
//  FengZi
//
//  Created by WangFeng on 11-12-27.
//  Copyright (c) 2011年 iTotemStudio. All rights reserved.
//
// 記得在 header 檔裡引入 QuartzCore
#import <QuartzCore/QuartzCore.h>

// 个人中心
@interface UserCenter : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    //UITableView *tableView; // 表格
    UILabel     *message; // 用户状态信息
    NSMutableArray *items;
    UIButton *_btnRight; // 导航条按钮
    UIButton *_btnLeft; // 导航条按钮
    UIImage *_curImage;
    IBOutlet UILabel *pictxt;    //????
    UIButton *picBtn;
    IBOutlet UIButton *changePwdBtn; //????
    BOOL isInit;
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UILabel *message;
//@property (nonatomic, retain) IBOutlet UILabel *nkName;
@property (nonatomic, retain) IBOutlet UILabel *numAccess;
@property (nonatomic, retain) IBOutlet UILabel *numScan;
@property (nonatomic, retain) IBOutlet UIImageView *photo;

- (IBAction)doEditor:(id)sender;
- (IBAction)changePwd:(id)sender;
@end
