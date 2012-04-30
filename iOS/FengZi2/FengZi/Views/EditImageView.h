//
//  EditImageView.h
//  FengZi
//

//  Copyright (c) 2011年 iTotemStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol EditImageViewDelegate <NSObject>
- (void)doneEdit:(UIImage*)image frame:(CGRect)rect;
- (void)cancelEdit;
@end

@interface EditImageView : UIView<UIGestureRecognizerDelegate>{
    id<EditImageViewDelegate> _delegate;
    IBOutlet UIImageView *_centerImageView;
    CGFloat lastScale;
}
@property(nonatomic, assign) id<EditImageViewDelegate> delegate;
-(void)setImageWithFrame:(UIImage*)image frame:(CGRect)rect;
@end
