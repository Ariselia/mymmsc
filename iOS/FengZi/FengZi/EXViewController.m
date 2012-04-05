#import "EXViewController.h"
#import <iOSUtil/iOSTabBarController.h>
#import <iOSUtil/iOSTab.h>
@implementation EXViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.view.backgroundColor = RGBCOLOR(rand() % 255, rand() % 255, rand() % 255);
}

- (NSString *)iconImageName {
	return @"encode.png";
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear");
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"viewDidAppear");
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog(@"viewWillDisappear");
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSLog(@"viewDidDisappear");
}

@end
