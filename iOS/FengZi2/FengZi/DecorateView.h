//
//  DecorateView.h
//  FengZi
//

//  Copyright (c) 2011年 iTotemStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataEnvironment.h"
typedef enum{
    EditImageTypeNone = 0,
    EditImageTypeSkin,
    EditImageTypeColor,
    EditImageTypeIcon
} EditImageType;
@protocol DecorateViewDelegate <NSObject>

- (void)imageSelected:(int)index;
- (void)iconSelected:(UIImage*)icon;
- (void)colorSelect:(UIColor*)color withIndex:(int)index;
@end

@interface DecorateView : UIView{
    id<DecorateViewDelegate> _delegate;
    IBOutlet UIScrollView *_scrollView;
    NSMutableArray *_contentArray;
    IBOutlet UIImageView *_backGroundView;
}
@property(nonatomic,assign) id<DecorateViewDelegate> delegate;
-(void)initDataWithType:(EditImageType)Type;
@end
