//
//  ArcScrollView.h
//  FengZi
//
//  Copyright (c) 2011年 iTotemStudio. All rights reserved.
//

#import <FengZi/Api+Category.h>
#import "CONSTS.h"

@protocol ArcScrollViewDelegate <NSObject>

- (void)gotoEditController:(BusinessType)type;

@end

@interface ArcScrollView : UIView{
    int _startIndex;
    int _startIndex2;
    int _offsetX;
    float _paramA;
    float _paramB;
    float _paramC;
    float _offsetWidth;
    float _offsetHeight;
    int _curSelectedIndex;
    int _lastSelectedIndex;
    IBOutlet UIScrollView *_scrollView;
    id<ArcScrollViewDelegate> _delegate;
    IBOutlet UIButton *_goBtn;
}

@property (assign, nonatomic) id<ArcScrollViewDelegate> delegate;
- (void)resetScrollContent:(BOOL)animation;

@end
