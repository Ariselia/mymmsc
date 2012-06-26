//
//  ITTImageDataOperation.h
//  AiQiChe
//

//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol ITTImageDataOperationDelegate;

@interface ITTImageDataOperation : NSOperation {
    NSString *_imageUrl;
    id<ITTImageDataOperationDelegate> _delegate;
    CGSize _targetSize;
}
@property (nonatomic,retain) id<ITTImageDataOperationDelegate> delegate;
@property (nonatomic,retain) NSString *imageUrl;
@property (nonatomic,assign) CGSize targetSize;

- (id)initWithURL:(NSString *)url delegate:(id<ITTImageDataOperationDelegate>)delegate;

@end
@protocol ITTImageDataOperationDelegate <NSObject>
-(void)imageDataOperation:(ITTImageDataOperation*)operation loadedWithUrl:(NSString*)url withImage:(UIImage*)image;
@end