//
//  CardTableViewCell.h
//  FengZi
//

//  Copyright (c) 2011年 iTotemStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CardTableViewCellDelegate <NSObject>

- (void)editEnd:(NSString*)value key:(NSString*)k;
- (void)editBegin:(NSIndexPath*)indexPath;
- (void)hideKeyBoard;
- (void)nextCellEdit:(NSIndexPath*)indexPath;

@end

@interface CardTableViewCell : UITableViewCell{
    UITextField *_textField;
    UILabel *_nameField;
    IBOutlet UIImageView *_inputBackView;
    id<CardTableViewCellDelegate> _delegate;
    NSIndexPath *_indexPath;
}
@property (retain, nonatomic) IBOutlet UITextField *textField;
@property (retain, nonatomic) IBOutlet UILabel *nameField;
@property (assign, nonatomic) id<CardTableViewCellDelegate> delegate;
@property (retain, nonatomic) NSIndexPath *indexPath;
+ (CardTableViewCell*)cellFromNib;
-(void)addPhoneButton:(UIButton*)btn;
@end
