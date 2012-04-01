//
//  UCMyComments.m
//  FengZi
//
//  Created by wangfeng on 12-3-31.
//  Copyright (c) 2012年 iTotemStudio. All rights reserved.
//

#import "UCMyComments.h"
#import "Api+UserCenter.h"

@interface UCMyComments ()

@end

@implementation UCMyComments
@synthesize tableView = _tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewWillAppear:(BOOL)animated {
    [iOSApi showAlert:@"正在获取用户信息..."];
    [iOSApi closeAlert];
}
@end
