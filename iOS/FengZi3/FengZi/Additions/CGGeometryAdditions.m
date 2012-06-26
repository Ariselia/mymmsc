//
//  CGGeometryAdditions.m
//  AiTuPianPad
//
// on 11-9-23.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "CGGeometryAdditions.h"
CGFloat distanceBetweenPoints(CGPoint p1,CGPoint p2){
    return sqrtf((p1.x-p2.x)*(p1.x-p2.x)+(p1.y-p2.y)*(p1.y-p2.y));
}

CGFloat angleOfPointFromCenter(CGPoint p,CGPoint center){
    CGFloat angle = -1;
    CGFloat r = distanceBetweenPoints(p, center);
    CGFloat cos = (p.x-center.x)/r;
    CGFloat y = p.y - center.y;
    if(y < 0){
        angle = acosf(cos);
    }else if(y > 0){
        angle = 2*M_PI - acosf(cos);
    }
    return angle;
}

CGPoint CGRectGetCenter(CGRect rect){
    return CGPointMake(rect.origin.x+(rect.size.width/2), rect.origin.y+(rect.size.height/2));
}

CGPoint getCenterOfView(UIView* view){
    CGPoint p;
    p.x = view.frame.size.width/2;
    p.y = view.frame.size.height/2;
    return p;
}

CGRect  rectToFillView(UIView * view){
    CGRect r;
    r = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
    return r;
}

