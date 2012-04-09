//
//  FZAppDelegate.m
//  FengZi
//
//  Created by  on 11-12-25.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "FZAppDelegate.h"
#import <iOSApi/iOSTabBarController.h>
#import "EXViewController.h"
#import "UserCenter.h"

@implementation FZAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.delegate = self;
	return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

- (NSArray *)pushViewControllers:(iOSAppDelegate *)appDelegate {
    NSMutableArray *list = [[NSMutableArray alloc] initWithCapacity:0];
    [list addObjectsFromArray:[NSArray arrayWithObjects:
            [[[UINavigationController alloc]
             initWithRootViewController:[[EXViewController alloc] init]] autorelease],
            [[[EXViewController alloc] init] autorelease],
            [[[EXViewController alloc] init] autorelease],
            [[[EXViewController alloc] init] autorelease],
            [[[EXViewController alloc] init] autorelease],
            nil]];
    return  [list autorelease];
}

@end
