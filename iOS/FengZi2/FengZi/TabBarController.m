//
//  TabBarController.h
//
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TabBarController.h"
#import "EncodeViewController.h"
#import "HistoryViewController.h"
#import "FaviroteViewController.h"
#import "MoreViewController.h"
#import "DecodeViewController.h"

#define TAB_CONTROLLER_TAB_HIDDEN_Y 480.0f
#define TAB_CONTROLLER_TAB_VISIBLE_Y 433.0f
#define TAB_CONTROLLER_TAB_HEIGHT 47.0f

@interface TabBarController()
- (void)hideTabBar;
- (void)addCustomElements;
- (void)hide:(BOOL)hidden withAnimation:(BOOL)isAnimation;
@end 


@implementation TabBarController

static TabBarController *_tabBarInstance;
+ (TabBarController*)sharedTabBarController{
	return _tabBarInstance;
}
+ (void)hide:(BOOL)bHide animated:(BOOL)bAnimated{
    [_tabBarInstance hide:bHide withAnimation:bAnimated];
}

#pragma mark - CustomTabBarDelegate
- (void)customTabbar:(CustomTabbar*)customTabbar didSelectTab:(int)tabIndex{
    [customTabbar selectTabAtIndex:tabIndex];
    self.selectedIndex = tabIndex;
    [(UINavigationController*)[self.viewControllers objectAtIndex:tabIndex] popToRootViewControllerAnimated:YES];
}

#pragma mark - private methods

- (void)hideTabBar{
	if ([[self.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]] ) {
		_contentView = [self.view.subviews objectAtIndex:1];
	}
	else {
		_contentView = [self.view.subviews objectAtIndex:0];
	}
	_contentView.frame = CGRectMake(0, 0, 320, 480);
	for(UIView *view in self.view.subviews){
		if([view isKindOfClass:[UITabBar class]]){
			view.alpha = 0;
			break;
		}
	}
}

- (void)addCustomElements{
    _customView = [[[NSBundle mainBundle] loadNibNamed:@"CustomTabbar" owner:self options:nil] objectAtIndex:0];
    _customView.delegate = self;
    _customView.frame = CGRectMake(0, TAB_CONTROLLER_TAB_VISIBLE_Y, 320, TAB_CONTROLLER_TAB_HEIGHT);
    [self.view addSubview:_customView];
    [self selectTab:0];
}

-(void)hide:(BOOL)hidden withAnimation:(BOOL)isAnimation{
	CGFloat durTime = 0;
	if (isAnimation) {
		durTime = 0.5f;
	}
    
	if (hidden) {
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:durTime];
        _customView.frame = CGRectMake(_customView.frame.origin.x, TAB_CONTROLLER_TAB_HIDDEN_Y, _customView.frame.size.width, _customView.frame.origin.y);
		[UIView commitAnimations];
	}else {
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:durTime];        
        _customView.frame = CGRectMake(_customView.frame.origin.x, TAB_CONTROLLER_TAB_VISIBLE_Y, _customView.frame.size.width, _customView.frame.origin.y);
		[UIView commitAnimations];
	}
}
#pragma mark - public methods
- (void)selectTab:(int)tabID{
    if (self.selectedIndex == tabID) {
		UINavigationController *navController = (UINavigationController *)[self selectedViewController];
		[navController popToRootViewControllerAnimated:YES];
	} else {
		self.selectedIndex = tabID;
        [_customView selectTabAtIndex:tabID];
	}
}
#pragma mark - lifecycle methods
- (id)init{
    self =[super init];
    _tabBarInstance = self;
	if (self) {
		self.delegate = self;
        EncodeViewController *encodeViewController = [[[EncodeViewController alloc] init] autorelease];
        encodeViewController.title = @"生码";
        UINavigationController *naviEncodeViewController = [[[UINavigationController alloc] initWithRootViewController:encodeViewController] autorelease];
        
        DecodeViewController *decodeViewController = [[[DecodeViewController alloc] init] autorelease];
        decodeViewController.title = @"解码";
        UINavigationController *naviImageDecodeViewController = [[[UINavigationController alloc] initWithRootViewController:decodeViewController] autorelease];
        
        FaviroteViewController *favViewController = [[[FaviroteViewController alloc] init] autorelease];
        favViewController.title = @"收藏";
        UINavigationController *naviFavViewController = [[[UINavigationController alloc] initWithRootViewController:favViewController] autorelease];
        
        HistoryViewController *hisViewController = [[[HistoryViewController alloc] init] autorelease];
        hisViewController.title = @"历史";
        UINavigationController *naviHisViewController = [[[UINavigationController alloc] initWithRootViewController:hisViewController] autorelease];
        
        MoreViewController *moreViewController = [[[MoreViewController alloc] init] autorelease];
        moreViewController.title = @"更多";
        UINavigationController *naviMoreViewController = [[[UINavigationController alloc] initWithRootViewController:moreViewController] autorelease];
        
        [self setViewControllers:[NSArray arrayWithObjects:naviImageDecodeViewController,naviEncodeViewController, naviFavViewController,naviHisViewController,naviMoreViewController,nil]];}
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	[self hideTabBar];	
	[self addCustomElements];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

}
- (void)dealloc{
    RELEASE_SAFELY(_customView);
    [super dealloc];
}
@end
