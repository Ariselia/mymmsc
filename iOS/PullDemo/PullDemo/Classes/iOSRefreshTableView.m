//
//  iOSRefreshTableView.m
//  TableViewPull
//
//  Created by  on 11-11-24.
//  Copyright (c) 2011年 watsy. All rights reserved.
//

#import "iOSRefreshTableView.h"

@interface iOSRefreshTableView()

- (void) initControl;

- (void) initPullDownView;
- (void) initPullUpView;
- (void) initPullAllView;

- (void) updatePullViewFrame;

@end

@implementation iOSRefreshTableView

@synthesize pullTableView = _pullTableView;
@synthesize delegate = _delegate;

- (id) initWithTableView:(UITableView *)tView 
           pullDirection:(iOSRefreshTableViewDirection) cwDirection
{
    if ((self = [super init])) {
        _pullTableView = tView;
        _direction = cwDirection;
        [self initControl];
        
    }
    
    return self;
}

#pragma mark private
- (void) initControl
{
    switch (_direction) {
        case iOSRefreshTableViewDirectionUp:
            [self initPullUpView];
            break;
            
        case iOSRefreshTableViewDirectionDown:
            [self initPullDownView];
            break;
            
        case iOSRefreshTableViewDirectionAll:
            [self initPullAllView];
            break;
    }
}

- (void) initPullDownView
{
    CGFloat fWidth = _pullTableView.frame.size.width;
    
    /*
     CGFloat originY = _pullTableView.contentSize.height;
    if (originY < _pullTableView.frame.size.height) {
        originY = _pullTableView.frame.size.height;
    }
    */
    iOSRefreshTableHeaderView *view = [[iOSRefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, -60.0, fWidth, 60.0) 
                                                                           byDirection:iOSPullRefreshDown];
    view.delegate = self;
    [_pullTableView addSubview:view];
    view.autoresizingMask = _pullTableView.autoresizingMask;
    _headView = view;
    [view release];
    
    [_headView refreshLastUpdatedDate];
}

- (void) initPullUpView
{
    CGFloat fWidth = _pullTableView.frame.size.width;
    if (_pullTableView.style == UITableViewStyleGrouped) {
        //        fWidth = fWidth - 40;
    }
    
    NSLog(@"height : % .0f",_pullTableView.contentSize.height);
    CGFloat originY = _pullTableView.contentSize.height;
    CGFloat originX = _pullTableView.contentOffset.x;
    if (originY < _pullTableView.frame.size.height) {
        originY = _pullTableView.frame.size.height;
    }

    iOSRefreshTableHeaderView *view = [[iOSRefreshTableHeaderView alloc] initWithFrame:CGRectMake(originX, originY, fWidth, 60)
                                       byDirection:iOSPullRefreshUp];
    view.delegate = self;
    [_pullTableView addSubview:view];
    view.autoresizingMask = _pullTableView.autoresizingMask;
    _footerView = view;
    [view release]; 
    
    [_footerView refreshLastUpdatedDate];
}

- (void) initPullAllView
{
    [self initPullUpView];
    [self initPullDownView];
}


- (void) updatePullViewFrame
{
    if (_headView != nil) {
        
    }
    if (_footerView != nil) {
        CGFloat fWidth = _pullTableView.frame.size.width;
        CGFloat originY = _pullTableView.contentSize.height;
        CGFloat originX = _pullTableView.contentOffset.x;
        if (originY < _pullTableView.frame.size.height) {
            originY = _pullTableView.frame.size.height;
        }
        if (!CGRectEqualToRect(_footerView.frame, CGRectMake(originX, originY, fWidth, 60))) {
          _footerView.frame = CGRectMake(originX, originY, fWidth, 60);  
        }
    }
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{	
	
    if (scrollView.contentOffset.y < -60.0f) {
      [_headView refreshScrollViewDidScroll:scrollView];  
    }
    else if (scrollView.contentOffset.y >  60.0f)
    {
        [_footerView refreshScrollViewDidScroll:scrollView];
    }
    
    [self updatePullViewFrame];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
    if (scrollView.contentOffset.y < -60.0f) {
        [_headView refreshScrollViewDidEndDragging:scrollView];  
    }
    else if (scrollView.contentOffset.y > 60.0f)
    {
        [_footerView refreshScrollViewDidEndDragging:scrollView];
    }
}


#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void) DataSourceDidFinishedLoading
{
    _reloading = NO;
    [_headView refreshScrollViewDataSourceDidFinishedLoading:_pullTableView];
    [_footerView refreshScrollViewDataSourceDidFinishedLoading:_pullTableView];
}

#pragma mark -
#pragma mark iOSRefreshTableHeaderDelegate Methods

- (void)refreshTableHeaderDidTriggerRefresh:(iOSRefreshTableHeaderView*)view 
                                  direction:(iOSPullRefreshDirection)direc{

	if (_delegate != nil && [_delegate respondsToSelector:@selector(iOSRefreshTableViewReloadTableViewDataSource:)]) {
        if (direc == iOSPullRefreshUp) {
            _reloading = [_delegate iOSRefreshTableViewReloadTableViewDataSource:iOSRefreshTableViewPullTypeLoadMore]; 
        }
        else if (direc == iOSPullRefreshDown)
        {
            _reloading = [_delegate iOSRefreshTableViewReloadTableViewDataSource:iOSRefreshTableViewPullTypeReload];
        }
    }
}

- (BOOL)refreshTableHeaderDataSourceIsLoading:(iOSRefreshTableHeaderView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}

- (NSDate*)refreshTableHeaderDataSourceLastUpdated:(iOSRefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}

@end
