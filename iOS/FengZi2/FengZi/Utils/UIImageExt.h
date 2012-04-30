//
//  UIImage(UIImageExt).h
//  hupan
//
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIImage(UIImageExt)
- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize;
- (UIImage *)scaleAndRotateToMaxResolution:(int)maxResolution;
@end
