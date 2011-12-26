//
//  iOSRefreshTableHeaderView.h
//  Demo
//
//  Created by Devin Doty on 10/14/09October14.
//  Copyright 2009 enormego. All rights reserved.
//
//修改人：禚来强 iphone开发qq群：79190809 邮箱：zhuolaiqiang@gmail.com
//


#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef enum{
	iOSPullRefreshPulling = 0,
	iOSPullRefreshNormal,
	iOSPullRefreshLoading,	
} iOSPullRefreshState;

typedef enum {
    iOSPullRefreshUp,
    iOSPullRefreshDown
}iOSPullRefreshDirection;

@protocol iOSRefreshTableHeaderDelegate;

@interface iOSRefreshTableHeaderView : UIView {
	
	id _delegate;
	iOSPullRefreshState _state;
    iOSPullRefreshDirection _direction;
    
	UILabel *_lastUpdatedLabel;
	UILabel *_statusLabel;
	CALayer *_arrowImage;
	UIActivityIndicatorView *_activityView;
	
}

@property(nonatomic,assign) id <iOSRefreshTableHeaderDelegate> delegate;
@property(nonatomic,assign) iOSPullRefreshDirection direction;

- (id) initWithFrame:(CGRect)frame byDirection:(iOSPullRefreshDirection) direc;

- (void)refreshLastUpdatedDate;
- (void)refreshScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)refreshScrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)refreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView;

@end

//----------------------------------------
@protocol iOSRefreshTableHeaderDelegate

@optional
- (void)refreshTableHeaderDidTriggerRefresh:(iOSRefreshTableHeaderView*)view
                                     direction:(iOSPullRefreshDirection) direc;
- (BOOL)refreshTableHeaderDataSourceIsLoading:(iOSRefreshTableHeaderView*)view;

@optional
- (NSDate*)refreshTableHeaderDataSourceLastUpdated:(iOSRefreshTableHeaderView*)view;

@end
