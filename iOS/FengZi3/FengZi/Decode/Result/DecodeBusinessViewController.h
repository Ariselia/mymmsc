//
//  DecodeBusinessViewController.h
//  FengZi
//

//  Copyright (c) 2011年 iTotemStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BusCategory.h"
#import <MessageUI/MessageUI.h>
#import "DecodeBusinessCell.h"
#import "ITTDataRequest.h"
#import "ITTImageView.h"
@interface DecodeBusinessViewController : UIViewController<UIAlertViewDelegate,DecodeBusinessCellDelegate,MFMessageComposeViewControllerDelegate,DataRequestDelegate>{
    IBOutlet UIView *_headerView;
    
    IBOutlet ITTImageView *_imageView;
    IBOutlet UITableView *_tableView;
    BusCategory *_category;
    NSString *_content;
    UIImage *_image;
    UIImage *_saveImage;
    UILabel *_titleLabel;
    IBOutlet UIButton *_favBtn;
    NSMutableArray *_titleArray;
    NSMutableArray *_contentArray;
    NSMutableArray *_typeArray;
    UITextField *_passwordField;
    NSString *_showInfo;
    HistoryType _historyType;// 是否扫码 排除从收藏和历史记录
    
    int _hideContentIndex;
}
-(id)initWithNibName:(NSString *)nibNameOrNil category:(BusCategory *)cate  result:(NSString *)input image:(UIImage*)img withType:(HistoryType)type withSaveImage:(UIImage*)sImage;
-(NSString*)getString16:(int)type;
@property(nonatomic,assign)BOOL returnFlag;
@end
