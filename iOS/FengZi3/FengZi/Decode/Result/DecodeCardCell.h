//
//  DecodeCardCell.h
//  FengZi
//
//  Copyright (c) 2011年 iTotemStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopButtonsView.h"
@protocol DecodeCardCellDelegate <NSObject>
- (void)hidePopButton;
@end
@interface DecodeCardCell : UITableViewCell{
    id<DecodeCardCellDelegate> _delegate;
    UILabel *_nameLabel;
    UILabel *_contentLabel;
    UIButton *_moreButton;
    IBOutlet UIImageView *_moreVIew;
    LinkType _type;
    PopButtonsView *_popView;
}
@property (retain, nonatomic) IBOutlet UILabel *contentLabel;
@property (retain, nonatomic) IBOutlet UIButton *moreButton;
@property (retain, nonatomic) IBOutlet UILabel *nameLabel;
@property (assign, nonatomic) id<DecodeCardCellDelegate> delegate;
+ (DecodeCardCell*)cellFromNib;
-(void)addPhoneButton:(UIButton*)btn withFavirote:(UIButton*)favrBtn;
-(void)initDataWithTitile:(NSString*)title withName:(NSString*)name withType:(LinkType)type;
-(void)removePopButton;
@end
