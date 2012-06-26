#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef enum{
    FOOTERPullRefreshPulling = 0,
    FOOTERPullRefreshNormal,
    FOOTERPullRefreshLoading,    
} FOOTERPullRefreshState;

@protocol RefreshTableFooterDelegate;
@interface RefreshTableFooterView : UIView
{
    
    id _delegate;
    FOOTERPullRefreshState _state;
    
    UILabel *_lastUpdatedLabel;
    UILabel *_statusLabel;
    CALayer *_arrowImage;
    UIActivityIndicatorView *_activityView;
    
    
}

@property(nonatomic,assign) id <RefreshTableFooterDelegate> delegate;

- (void)refreshLastUpdatedDate;
- (void)footerRefreshScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)footerRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)footerRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView;

@end
@protocol RefreshTableFooterDelegate
- (void)footerRefreshTableHeaderDidTriggerRefresh:(RefreshTableFooterView*)view;
- (BOOL)footerRefreshTableHeaderDataSourceIsLoading:(RefreshTableFooterView*)view;
@optional
- (NSDate*)footerRefreshTableHeaderDataSourceLastUpdated:(RefreshTableFooterView*)view;
@end
