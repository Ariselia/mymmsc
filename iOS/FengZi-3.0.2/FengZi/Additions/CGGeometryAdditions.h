//
//  CGGeometryAdditions.h
//  AiTuPianPad
//
// on 11-9-23.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
CGPoint CGRectGetCenter(CGRect rect);
CGPoint getCenterOfView(UIView* view);
CGRect  rectToFillView(UIView * view);

CGFloat distanceBetweenPoints(CGPoint p1,CGPoint p2);
CGFloat angleOfPointFromCenter(CGPoint p,CGPoint center);
