//
//  EditImageView.m
//  FengZi
//

//  Copyright (c) 2011年 iTotemStudio. All rights reserved.
//

#import "EditImageView.h"
#import <QuartzCore/QuartzCore.h>
@implementation EditImageView
@synthesize delegate = _delegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(UIImage*)scaleToSize:(CGSize)size image:(UIImage*)image 
{ 
    UIGraphicsBeginImageContext(size); 
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)]; 
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext(); 
    UIGraphicsEndImageContext(); 
    return scaledImage; 
}

-(void)setImageWithFrame:(UIImage *)image frame:(CGRect)rect{
    _centerImageView.image = image;
    _centerImageView.frame = rect;
}

// adds a set of gesture recognizers to one of our piece subviews
- (void)addGestureRecognizersToPiece:(UIView *)piece
{    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panPiece:)];
    [panGesture setMaximumNumberOfTouches:2];
    [panGesture setDelegate:self];
    [piece addGestureRecognizer:panGesture];
    [panGesture release];
}

- (void)awakeFromNib
{
    [self addGestureRecognizersToPiece:_centerImageView];
    //拧的手势
    UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc] 
                                                 initWithTarget:self action:@selector(scale:)];
    [pinchRecognizer setDelegate:self];
    [_centerImageView addGestureRecognizer:pinchRecognizer];
    [pinchRecognizer release];
}


#pragma mark -
#pragma mark === Utility methods  ===
#pragma mark
-(void)scale:(UIPinchGestureRecognizer*)sender {
    //当手指离开屏幕时,将lastscale设置为1.0
    if([(UIPinchGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
        lastScale = 1.0;
        return;
    }
    CGFloat scale = 1.0 - (lastScale - [(UIPinchGestureRecognizer*)sender scale]);
    CGAffineTransform currentTransform = [(UIPinchGestureRecognizer*)sender view].transform;
    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, scale, scale);
    
    [[sender view] setTransform:newTransform];
    lastScale = [(UIPinchGestureRecognizer*)sender scale];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    return ![gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]];
}
// scale and rotation transforms are applied relative to the layer's anchor point
// this method moves a gesture recognizer's view's anchor point between the user's fingers
- (void)adjustAnchorPointForGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        UIView *piece = gestureRecognizer.view;
        CGPoint locationInView = [gestureRecognizer locationInView:piece];
        CGPoint locationInSuperview = [gestureRecognizer locationInView:piece.superview];
        
        piece.layer.anchorPoint = CGPointMake(locationInView.x / piece.bounds.size.width, locationInView.y / piece.bounds.size.height);
        piece.center = locationInSuperview;
    }
}

#pragma mark -
#pragma mark === Touch handling  ===
#pragma mark

// shift the piece's center by the pan amount
// reset the gesture recognizer's translation to {0, 0} after applying so the next callback is a delta from the current position
- (void)panPiece:(UIPanGestureRecognizer *)gestureRecognizer
{
    UIView *piece = [gestureRecognizer view];
    
    [self adjustAnchorPointForGestureRecognizer:gestureRecognizer];
    
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan || [gestureRecognizer state] == UIGestureRecognizerStateChanged) {
        CGPoint translation = [gestureRecognizer translationInView:[piece superview]];
        
        [piece setCenter:CGPointMake([piece center].x + translation.x, [piece center].y + translation.y)];
        [gestureRecognizer setTranslation:CGPointZero inView:[piece superview]];
    }
}

- (IBAction)doneClick:(id)sender {
    if (_delegate) {
        [_delegate doneEdit:_centerImageView.image frame:_centerImageView.frame];
        [self removeFromSuperview];
    }
}
- (IBAction)cancelClick:(id)sender {
    if (_delegate) {
        [_delegate cancelEdit];
        [self removeFromSuperview];
    }
}

- (void)dealloc {
    [_centerImageView release];
    [super dealloc];
}
@end
