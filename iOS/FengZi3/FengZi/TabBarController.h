//
//  TabBarController.h
//  
//
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CustomTabbar.h"

@interface TabBarController : UITabBarController<UITabBarControllerDelegate,CustomTabbarDelegate> {
	UIView *_contentView;
    CustomTabbar *_customView;
    BOOL _isHide;
}

+ (TabBarController*)sharedTabBarController;
- (void)selectTab:(int)tabID;

+ (void)hide:(BOOL)bHide animated:(BOOL)bAnimated;

@end
