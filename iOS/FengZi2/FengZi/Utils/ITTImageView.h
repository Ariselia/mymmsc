//
//  ITTImageView.h
//
//  Copyright 2010 iTotem. All rights reserved.
//
#import "ITTImageDataOperation.h"
typedef enum
{
    ITTImageResizeTypeNone = 0,
    ITTImageResizeTypeScaleByMaxSide,
    ITTImageResizeTypeScaleByMinSide
    
}ITTImageResizeType;

@class ITTImageView;
@protocol ITTImageViewDelegate <NSObject>
@optional
- (void)imageLoaded:(ITTImageView *)imageView;
- (void)imageClicked:(ITTImageView *)imageView;
@end

@interface ITTImageView : UIImageView <ITTImageDataOperationDelegate, UIGestureRecognizerDelegate>{
	id<ITTImageViewDelegate> _delegate;
    UIActivityIndicatorView *_indicator;
    UIActivityIndicatorViewStyle indicatorViewStyle;
    NSString *_imageUrl;
    UIButton *_imageBtn;
    ITTImageDataOperation *_imageDataOperation;
    
    //ImageView缩放填充方式
    ITTImageResizeType _resizeType;
    //响应Tap方法
    BOOL _enableTapEvent;
}
@property (nonatomic,retain) NSString *imageUrl;
@property (nonatomic,assign) id<ITTImageViewDelegate> delegate;
@property (nonatomic,assign) ITTImageResizeType resizeType;
@property (nonatomic,assign) BOOL enableTapEvent;
@property (nonatomic,assign) UIActivityIndicatorViewStyle indicatorViewStyle;

- (void)enableImageBtn;
- (void)disableImageBtn;
- (void)loadImage:(NSString*)url;
- (void)setDefaultImage:(UIImage*)defaultImage;
- (void)cancelImageRequest;
- (void)resizeImage;

@end
