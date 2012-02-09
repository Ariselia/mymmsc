//
//  ITTImageManager.m
// 
//  Copyright 2010 iTotem. All rights reserved.
//

#import "ITTImageView.h"
#import "UIUtil.h"
#import "DataEnvironment.h"
#import "ITTImageCacheManager.h"
@interface ITTImageView()
-(void)showLoading;
-(void)hideLoading;

-(void)imageBtnClicked;
@end

@implementation ITTImageView
@synthesize delegate = _delegate;
@synthesize imageUrl = _imageUrl;
@synthesize resizeType = _resizeType;
@synthesize enableTapEvent = _enableTapEvent;
@synthesize indicatorViewStyle;

- (void)dealloc{
    [self cancelImageRequest];
    _delegate = nil;
    _imageDataOperation.delegate = nil;
    RELEASE_SAFELY(_imageDataOperation);
    RELEASE_SAFELY(_indicator);
    RELEASE_SAFELY(_imageUrl);
    RELEASE_SAFELY(_imageBtn);
	[super dealloc];
}

- (id)init{
    self = [super init];
	if (self) {
        self.indicatorViewStyle = UIActivityIndicatorViewStyleGray;
	}
	return self;
}

- (void)setDefaultImage:(UIImage*)defaultImage{
	self.image = defaultImage;
    [self resizeImage];
}

- (void)cancelImageRequest{
    if (_imageDataOperation && ([_imageDataOperation isExecuting] || [_imageDataOperation isReady])) {
        [_imageDataOperation cancel];
        ITTDINFO(@"image request is canceled,url:%@", _imageUrl);
    }
    [self hideLoading];
}

- (void)loadImage:(NSString*)url{
	if( url==nil || [url isEqualToString:@""] ){
		return;	
    }
	RELEASE_SAFELY(_imageUrl);
    _imageUrl = [url retain];
    [self cancelImageRequest];
    if ([[ITTImageCacheManager sharedManager] isImageInMemoryCacheWithUrl:_imageUrl]) {
        self.image = [[ITTImageCacheManager sharedManager] getImageFromCacheWithUrl:_imageUrl];
        [self hideLoading];
        [self resizeImage];
    }else{
        
        BOOL showShowLoading = YES;
        if (self.image) {
            showShowLoading = NO;
        }
        if (showShowLoading) {
            [self showLoading];
        }
        RELEASE_SAFELY(_imageDataOperation);
        _imageDataOperation = [[ITTImageDataOperation alloc] initWithURL:_imageUrl delegate:self];
        
        [[ITTImageCacheManager sharedManager].imageQueue addOperation:_imageDataOperation];
    }
    if (_enableTapEvent) {
        [self setUserInteractionEnabled:YES];
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        tapGestureRecognizer.cancelsTouchesInView = NO;
        [self addGestureRecognizer:tapGestureRecognizer];
        [tapGestureRecognizer release];
    }
    
}

-(void)setIndicatorViewStyle:(UIActivityIndicatorViewStyle)style{
    indicatorViewStyle = style;
    [_indicator setActivityIndicatorViewStyle:style];
}

-(void)showLoading{

    if (!_indicator) {
        _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:indicatorViewStyle];
        _indicator.center = CGRectGetCenter(self.bounds);
        [_indicator setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin];
    }
    _indicator.hidden = NO;
    if(!_indicator.superview){
        [self addSubview:_indicator];
    }
    [_indicator startAnimating];
    if (_imageBtn) {
        //[self bringSubviewToFront:_imageBtn];
    }
}
-(void)hideLoading{
    if (_indicator) {
        [_indicator stopAnimating];
        _indicator.hidden = YES;
    }
    if (_imageBtn) {
        //[self bringSubviewToFront:_imageBtn];
    }
}

-(void)imageBtnClicked{
	if (_delegate && [_delegate respondsToSelector:@selector(imageClicked:)]) {
        [_delegate imageClicked:self];
	}
}
- (void)enableImageBtn{
    if (!_imageBtn) {
        _imageBtn = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        _imageBtn.frame = self.bounds;
        _imageBtn.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [_imageBtn addTarget:self action:@selector(imageBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_imageBtn];
    }
    self.userInteractionEnabled = YES;
    //[self bringSubviewToFront:_imageBtn];
}
- (void)disableImageBtn{
    [_imageBtn removeFromSuperview];
    RELEASE_SAFELY(_imageBtn);
}

- (void)resizeImage
{
    if (_resizeType == ITTImageResizeTypeScaleByMaxSide) {
        CGSize imageSize = self.image.size;
        CGFloat scaleValue = 0;
        if (imageSize.width/imageSize.height > self.width/self.height) {
            scaleValue = self.width/imageSize.width;
        }
        else
        {
            scaleValue = self.height/imageSize.height;
        }
        self.frame = CGRectMake(self.left + self.width/2 - imageSize.width * scaleValue / 2, self.top + self.height/2 - imageSize.height * scaleValue / 2, imageSize.width * scaleValue, imageSize.height * scaleValue);
        
    }else if(_resizeType == ITTImageResizeTypeScaleByMinSide){
        CGSize imageSize = self.image.size;
        if (imageSize.width/imageSize.height == self.width/self.height) {
            return;
        }
        CGRect clipRect = CGRectZero;
        if (imageSize.width/imageSize.height > self.width/self.height) {
            NSInteger scaledWidth = imageSize.height/self.height*self.width;
            clipRect = CGRectMake(imageSize.width/2 - scaledWidth/2, 0, scaledWidth, imageSize.height);
        }
        else
        {
            NSInteger scaledHeight = imageSize.width/self.width*self.height;
            clipRect = CGRectMake(0, imageSize.height/2 - scaledHeight/2, imageSize.width, scaledHeight);
        }
        CGImageRef imageRef = self.image.CGImage;
        CGImageRef newImageRef;
        newImageRef = CGImageCreateWithImageInRect(imageRef,clipRect);
        UIImage *newImage = [[UIImage alloc] initWithCGImage:newImageRef];
        CGImageRelease(newImageRef);
        self.image = newImage;
        [newImage release];
    }
}

- (void)handleTapGesture:(UITapGestureRecognizer *)recognizer
{
    if (_delegate && [_delegate respondsToSelector:@selector(imageClicked:)]) {
        [_delegate imageClicked:self];
	}
}

#pragma mark - ITTImageDataOperationDelegate

-(void)imageDataOperation:(ITTImageDataOperation*)operation loadedWithUrl:(NSString*)url withImage:(UIImage *)image{
    if (operation.imageUrl == _imageUrl) {
        [self performSelectorOnMainThread:@selector(imageLoaded:) withObject:image waitUntilDone:YES];
    }
}

- (void)imageLoaded:(UIImage *)image{
    [self hideLoading];
    self.image = image;
    [self resizeImage];
	if (_delegate && [_delegate respondsToSelector:@selector(imageLoaded:)]) {
        [_delegate imageLoaded:self];
	}
}
@end

