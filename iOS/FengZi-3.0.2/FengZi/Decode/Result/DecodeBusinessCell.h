//
//  DecodeBusinessCell.h
//  FengZi
//

//  Copyright (c) 2011年 iTotemStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopButtonsView.h"
#import "FontLabel.h"
#import "FontLabelStringDrawing.h"
#import "FontManager.h"

@protocol DecodeBusinessCellDelegate <NSObject>
- (void)hidePopButton;
- (void)showSms;
- (void)showMail;
@end
@interface DecodeBusinessCell : UITableViewCell<PopButtonsViewDelegate>{
    id<DecodeBusinessCellDelegate> _delegate;
    UILabel *_nameLabel;
    UIButton *textButton;
    IBOutlet UIButton *_moreBtn;
    IBOutlet FontLabel *_contentLabel;
    LinkType _type;
    PopButtonsView *_popView;
}
@property (retain, nonatomic) IBOutlet UILabel *nameLabel;
@property (retain, nonatomic) IBOutlet UIButton *textButton;
@property (retain, nonatomic) FontLabel *contentLabel;
@property (assign, nonatomic) LinkType type;
@property (assign, nonatomic) id<DecodeBusinessCellDelegate> delegate;

+ (DecodeBusinessCell*)cellFromNib;
-(void)initDataWithTitile:(NSString*)title withText:(NSString*)text withType:(LinkType)type;
-(void)removePopButton;
@end
