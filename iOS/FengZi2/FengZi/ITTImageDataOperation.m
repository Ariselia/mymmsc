//
//  ITTImageDataOperation.m
//  AiQiChe
//

//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ITTImageDataOperation.h"
#import "ITTImageCacheManager.h"
#import "UIImageExt.h"
//#import "ITTNetworkTrafficManager.h"

@implementation ITTImageDataOperation

@synthesize imageUrl = _imageUrl;
@synthesize delegate = _delegate;
@synthesize targetSize = _targetSize;
- (void)dealloc {
    [self cancel];
    RELEASE_SAFELY(_delegate);
    RELEASE_SAFELY(_imageUrl);
	[super dealloc];
}

- (id)initWithURL:(NSString *)url delegate:(id<ITTImageDataOperationDelegate>)delegate{
    self = [super init];
	if (self) {
		_imageUrl = [url retain];
		_delegate = [delegate retain];
        _targetSize = CGSizeZero;
	}
	return self;
}

- (void)main{
    UIImage *image = [[ITTImageCacheManager sharedManager] getImageFromCacheWithUrl:_imageUrl];
	if(!image){
        ITTDINFO(@"loading image from web:%@",_imageUrl);
		NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:_imageUrl]];
		if( imageData!=nil){
			image = [UIImage imageWithData:imageData];
            [[ITTImageCacheManager sharedManager] saveImage:[UIImage imageWithData:imageData] withUrl:_imageUrl];
//            [[ITTNetworkTrafficManager sharedManager] logTrafficOut:[_imageUrl lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
//            [[ITTNetworkTrafficManager sharedManager] logTrafficIn:[imageData length]];
		}
	}
    if (image && _delegate && [_delegate respondsToSelector:@selector(imageDataOperation:loadedWithUrl:withImage:)]) {
        if (_targetSize.height > 0 && _targetSize.width > 0) {
            [_delegate imageDataOperation:self 
                            loadedWithUrl:_imageUrl
                                withImage:[image imageByScalingAndCroppingForSize:_targetSize]];
        }else{
            
            [_delegate imageDataOperation:self 
                            loadedWithUrl:_imageUrl
                                withImage:image];
        }
    }
}
@end
