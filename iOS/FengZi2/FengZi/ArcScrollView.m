//
//  ArcScrollView.m
//  FengZi
//

//  Copyright (c) 2011年 iTotemStudio. All rights reserved.
//

#import "ArcScrollView.h"

@implementation ArcScrollView
@synthesize delegate = _delegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(NSArray*)getParamsWithArray:(NSArray*)arr{
    CGPoint startPoint = CGPointFromString([arr objectAtIndex:0]);
    CGPoint endPoint = CGPointFromString([arr objectAtIndex:1]);
    CGPoint midPoint = CGPointFromString([arr objectAtIndex:2]);
    float x1 =  startPoint.x; //起始点
    float y1 = startPoint.y;
    float x3 = endPoint.x;//终点
    float y3 = endPoint.y;
    float x2 = midPoint.x;
    float y2 = midPoint.y;
    
    //根据抛物线方程ax^2+bx+c=y，得方程组 //ax1^2+bx1+c=y1 //ax2^2+bx2+c=y2 //ax3^2+bx3+c=y3 //解方程组得抛物线的a,b,c
    float paramB = ((y1-y3)*(x1*x1-x2*x2)-(y1-y2)*(x1*x1-x3*x3))/((x1-x3)*(x1*x1-x2*x2)-(x1-x2)*(x1*x1-x3*x3)); 
    float paramA = ((y1-y2)-paramB*(x1-x2))/(x1*x1-x2*x2);
    float paramC = y1-paramA*x1*x1-paramB*x1;
    return [[[NSArray alloc] initWithObjects:[NSNumber numberWithFloat:paramA],[NSNumber numberWithFloat:paramB],[NSNumber numberWithFloat:paramC], nil] autorelease];
}

-(void)awakeFromNib{
    [super awakeFromNib];
    _offsetWidth = 320.0/5;
    _offsetHeight = 50;
    _curSelectedIndex = BUSINESS_NUM/2;
    _lastSelectedIndex = _curSelectedIndex;
    _scrollView.contentSize = CGSizeMake(4000, _scrollView.bounds.size.height);
    CGFloat contentWidth = [_scrollView contentSize].width;
    _offsetX = (contentWidth - [_scrollView bounds].size.width) / 2.0;
    CGFloat leftOffsetX= _offsetX-_offsetWidth*(_curSelectedIndex-3);
    
    CGPoint startPoint = CGPointMake(_offsetWidth*(_curSelectedIndex-3)+_offsetWidth/2+leftOffsetX-5,90);
    CGPoint endPoint = CGPointMake(_offsetWidth*(_curSelectedIndex+1)+_offsetWidth/2+leftOffsetX+5,90);
    CGPoint midPoint = CGPointMake(_offsetWidth*(_curSelectedIndex-1)+_offsetWidth/2+leftOffsetX, 24);
    NSArray *parr = [self getParamsWithArray:[[[NSArray alloc] initWithObjects:NSStringFromCGPoint(startPoint),NSStringFromCGPoint(endPoint),NSStringFromCGPoint(midPoint), nil] autorelease]];
    _paramA = [[parr objectAtIndex:0] floatValue];
    _paramB = [[parr objectAtIndex:1] floatValue];
    _paramC = [[parr objectAtIndex:2] floatValue];
    _startIndex = 0;
    _startIndex2 = 0;
    for (int i=0; i<BUSINESS_NUM; i++) {
        float offsetX = i*_offsetWidth+_offsetWidth/2+leftOffsetX;
        float offsetY = _paramA*offsetX*offsetX + _paramB*offsetX + _paramC;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake(0, 0, _offsetWidth-4, _offsetHeight);
        btn.center = CGPointMake(offsetX, fabsf(offsetY));
        btn.tag = 2000+i;
        [btn addTarget:self action:@selector(thumbDidClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn setImage:[DATA_ENV getBusinessImage:i select:NO]  forState:UIControlStateNormal];
        [btn setImage:[DATA_ENV getBusinessImage:i select:NO]  forState:UIControlStateHighlighted];
        [btn setImage:[DATA_ENV getBusinessImage:i select:YES]  forState:UIControlStateSelected];
        [_scrollView addSubview:btn];
        btn.selected = i == _lastSelectedIndex-1;
    }
    _scrollView.contentOffset=CGPointMake(_offsetX, 0);
    _goBtn.enabled = YES;
}

-(void)endAnimation{
    _goBtn.enabled = YES;
}

-(void)resetScrollContent:(BOOL)animation{
    _startIndex = _startIndex2;
    CGFloat leftOffsetX= _offsetX-_offsetWidth*(BUSINESS_NUM/2-3);
    if (animation) {
        NSTimeInterval animationDuration = 0.3;
        [UIView beginAnimations:@"pull" context:nil];
        [UIView setAnimationDuration:animationDuration];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        [UIView setAnimationDelegate:self];
        if (_lastSelectedIndex != _curSelectedIndex) {
            [UIView setAnimationDidStopSelector:@selector(goNextAnimation)];
        }else{
            [UIView setAnimationDidStopSelector:@selector(endAnimation)];
        }
    }
    for (int i = 0; i<BUSINESS_NUM; i++) {
        int offsetTmp = 0;
        if(i==BUSINESS_NUM/2-2){
            offsetTmp = -10;
        }else if(i==BUSINESS_NUM/2){
            offsetTmp = 10;
        }
        float offsetX = i*_offsetWidth+_offsetWidth/2+leftOffsetX+offsetTmp;
        float offsetY = _paramA*offsetX*offsetX + _paramB*offsetX + _paramC;
        int temp = _startIndex2+i;
        if (temp>=BUSINESS_NUM) {
            temp = temp - BUSINESS_NUM;
        }
        int tag = 2000+temp;
        UIButton *btn = (UIButton*)[self viewWithTag:tag];
        btn.selected = NO;
        btn.userInteractionEnabled = YES;
        [btn setImage:[btn imageForState:UIControlStateNormal]  forState:UIControlStateHighlighted];
        btn.center = CGPointMake(offsetX, fabsf(offsetY));
    }
    if (animation) {
        [UIView commitAnimations];
    }
    UIButton *selectBtn = (UIButton*)[self viewWithTag:2000+_curSelectedIndex];
    selectBtn.selected = YES;
    selectBtn.userInteractionEnabled=NO;
    [selectBtn setImage:[selectBtn imageForState:UIControlStateNormal]  forState:UIControlStateHighlighted];
    _scrollView.contentOffset=CGPointMake(_offsetX, 0);
    if (!animation) {
        _goBtn.enabled = YES;
    }
}

-(void)goNextAnimation{
    _goBtn.enabled = NO;
    _curSelectedIndex = _lastSelectedIndex;
    _startIndex2 = _curSelectedIndex -BUSINESS_NUM/2+1;
    if (_startIndex2<0) {
        _startIndex2 = BUSINESS_NUM+_startIndex2;
    }
    [self resetScrollContent:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    _goBtn.enabled = NO;
    CGPoint currentOffset = [_scrollView contentOffset];
    CGFloat distanceFromCenter = fabs(currentOffset.x - _offsetX);
    CGFloat leftOffsetX= _offsetX-_offsetWidth*(BUSINESS_NUM/2-3);
    CGFloat sub= scrollView.contentOffset.x - _offsetX;
    int j = 0;
    j = _startIndex2-_startIndex;
    if (sub<0) {
        j = j>0?j-BUSINESS_NUM:j;
    }else if(sub>0){
        j = j<0?BUSINESS_NUM +j:j;
    }
    if (distanceFromCenter > 3*_offsetWidth) {
        int moveNum = fabsf(sub)/_offsetWidth;
        if (sub>0) {
            _scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x-moveNum*_offsetWidth, 0);
            sub = sub - moveNum*_offsetWidth;
        }else{
             _scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x+moveNum*_offsetWidth, 0);
            sub = sub + moveNum*_offsetWidth;
        }
    }
    CGPoint startPoint = CGPointMake(_offsetWidth*(BUSINESS_NUM/2-3)+_offsetWidth/2+leftOffsetX+sub-5,90);
    CGPoint endPoint = CGPointMake(_offsetWidth*(BUSINESS_NUM/2+1)+_offsetWidth/2+leftOffsetX+sub+5,90);
    CGPoint midPoint = CGPointMake(_offsetWidth*(BUSINESS_NUM/2-1)+_offsetWidth/2+leftOffsetX+sub, 24);
    NSArray *parr = [self getParamsWithArray:[[[NSArray alloc] initWithObjects:NSStringFromCGPoint(startPoint),NSStringFromCGPoint(endPoint),NSStringFromCGPoint(midPoint), nil] autorelease]];
    float paramA = [[parr objectAtIndex:0] floatValue];
    float paramB = [[parr objectAtIndex:1] floatValue];
    float paramC = [[parr objectAtIndex:2] floatValue];
    float pointY=1000000;
    for (int i = j;i<BUSINESS_NUM+j; i++) {
        int offsetTmp = 0;
        if(i==BUSINESS_NUM/2-2){
            offsetTmp = -10;
        }else if(i==BUSINESS_NUM/2){
            offsetTmp = 10;
        }
        int k = i;
        if (i<0) {
            k= BUSINESS_NUM+i;
        }else if(i>=BUSINESS_NUM){
            k = i-BUSINESS_NUM;
        }
        int temp = _startIndex+k;
        if (temp>=BUSINESS_NUM) {
            temp = temp - BUSINESS_NUM;
        }
        int tag = 2000+temp;
        UIButton *btn = (UIButton*)[self viewWithTag:tag];
        float offsetX = i*_offsetWidth+_offsetWidth/2 - sub+leftOffsetX + offsetTmp;
        float offsetY = paramA*offsetX*offsetX + paramB*offsetX + paramC;
        if (offsetY < pointY) {
            pointY = offsetY;
            _curSelectedIndex = temp;
        }
        btn.center = CGPointMake(offsetX, fabsf(offsetY));
        btn.selected = NO;
    }
    _startIndex2 = _curSelectedIndex-BUSINESS_NUM/2+1;
    if (_startIndex2<0) {
        _startIndex2 = BUSINESS_NUM+_startIndex2;
    }
    UIButton *selectBtn = (UIButton*)[self viewWithTag:2000+_curSelectedIndex];
    selectBtn.selected = YES;
    selectBtn.userInteractionEnabled=NO;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self resetScrollContent:NO];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self resetScrollContent:NO];
}
- (IBAction)gotoEdit:(id)sender {
    if (_delegate&&[_delegate respondsToSelector:@selector(gotoEditController:)]) {
        [_delegate gotoEditController:_curSelectedIndex];
    }
}

#pragma mark -
#pragma mark ThumbButtonViewDelegate
-(void)thumbDidClick:(UIButton*)btn{
    _goBtn.enabled = NO;
    _lastSelectedIndex = btn.tag-2000;
    int tmp = _lastSelectedIndex-_curSelectedIndex;
    if (abs(tmp) < 2) {
        _curSelectedIndex = _lastSelectedIndex;
    }else{
        if(tmp>0){
            if (tmp>2) {
                if (_curSelectedIndex==0) {
                    _curSelectedIndex = BUSINESS_NUM-1;
                }else{
                    _curSelectedIndex--;
                }
            }else{
                _curSelectedIndex++;
            }
        }else{
            if (tmp<-2) {
                if (_curSelectedIndex == BUSINESS_NUM-1) {
                    _curSelectedIndex=0;
                }else{
                    _curSelectedIndex++;
                }
            }else{
                _curSelectedIndex--;
            }
        }
    }
    _startIndex2 = _curSelectedIndex -BUSINESS_NUM/2+1;
    if (_startIndex2<0) {
        _startIndex2 = BUSINESS_NUM+_startIndex2;
    }
    [self resetScrollContent:YES];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc {
    [_scrollView release];
    [_goBtn release];
    [super dealloc];
}
@end
