//
//  PopButtonsView.h
//  FengZi
//
//  Copyright (c) 2011年 iTotemStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PopButtonsViewDelegate <NSObject>
- (void)showSms;
- (void)showMail;
@end
@interface PopButtonsView : UIView{
    id<PopButtonsViewDelegate> _delegate;
    IBOutlet UIImageView *_backImageView;
    IBOutlet UIButton *_dialBtn;
    IBOutlet UIButton *_emailBtn;
    IBOutlet UIButton *_netWorkBtn;
    IBOutlet UIButton *_locationBtn;
    IBOutlet UIButton *_searchBtn;
    IBOutlet UIButton *_smsBtn;
    IBOutlet UIButton *_weiboBtn;
    IBOutlet UIButton *_favBtn;
    LinkType _type;
    NSString *_content;
    
}
@property (retain, nonatomic) id<PopButtonsViewDelegate> delegate;
+ (PopButtonsView*)viewFromNib;

-(void)initDataWithType:(LinkType)type withText:(NSString*)text;
@end
