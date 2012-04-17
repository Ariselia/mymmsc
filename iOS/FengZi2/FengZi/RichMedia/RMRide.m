//
//  RMRide.m
//  FengZi
//
//  Created by wangfeng on 12-4-15.
//  Copyright (c) 2012年 ifengzi.cn. All rights reserved.
//

#import "RMRide.h"

@interface RMRide ()

@end

@implementation RMRide
@synthesize maId;
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
    UIImage *image = [UIImage imageNamed:@"navigation_bg.png"];
    Class ios5Class = (NSClassFromString(@"CIImage"));
    if (nil != ios5Class) {
        [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    } else {
        self.navigationController.navigationBar.layer.contents = (id)[UIImage imageNamed:@"navigation_bg.png"].CGImage;
    }
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(110, 0, 150,44)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = UITextAlignmentCenter;
    label.font = [UIFont fontWithName:@"黑体" size:60];
    label.textColor = [UIColor blackColor];
    label.text= @"顺风车";
    self.navigationItem.titleView = label;
    [label release];
    
    UIButton *backbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backbtn.frame = CGRectMake(0, 0, 60, 32);
    
    [backbtn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backbtn setImage:[UIImage imageNamed:@"back_tap.png"] forState:UIControlStateHighlighted];
    [backbtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backitem = [[UIBarButtonItem alloc] initWithCustomView:backbtn];
    self.navigationItem.leftBarButtonItem = backitem;
    [backitem release];
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

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int count = 0;
    if (maId != nil) {
        count = 5;
        //return [_items count];
    }
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 50;
	//CGSize size = [@"123" sizeWithFont:fontInfo constrainedToSize:CGSizeMake(labelWidth, 20000) lineBreakMode:UILineBreakModeWordWrap];
	//return size.height + 10; // 10即消息上下的空间，可自由调整 
    if (indexPath.row == 0) {
        height = 90.0f;
    }
	return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    int pos = [indexPath row];
    /*
     if (pos >= [_items count] + 1) {
     return nil;
     }*/
    if (pos == 0) {
        RidePath *path = [ride.drvList objectAtIndex:0];
        cell.textLabel.text = path.drvpath;
        NSString *drvpath = [NSString stringWithFormat:@"%8@: %@", @"类型", @"车找人"];
        cell.detailTextLabel.text = drvpath;
        cell.detailTextLabel.lineBreakMode = 0;
    } else if (pos == 1) {
        RidePath *path = [ride.drvList objectAtIndex:0];
        cell.textLabel.text = path.drvpath;
        NSString *drvpath = [NSString stringWithFormat:@"%8@: %@\n%8@: %@\n%8@: %@\n",
                             @"类型", @"车找人",
                             @"发车时间", @"早07：30",
                             @"", @""];
        cell.detailTextLabel.text = drvpath;
        cell.detailTextLabel.lineBreakMode = 0;
    } else if (pos == 2) {
        RidePath *path = [ride.drvList objectAtIndex:0];
        cell.textLabel.text = path.drvpath;
        NSString *drvpath = [NSString stringWithFormat:@"%8@: %@\n", @"类型", @"车找人"];
        cell.detailTextLabel.text = drvpath;
        cell.detailTextLabel.lineBreakMode = 0;
    } else if (pos == 3) {
        RidePath *path = [ride.drvList objectAtIndex:0];
        cell.textLabel.text = path.drvpath;
        NSString *drvpath = [NSString stringWithFormat:@"%8@: %@", @"类型", @"车找人"];
        cell.detailTextLabel.text = drvpath;
        cell.detailTextLabel.lineBreakMode = 0;
    } else if (pos == 4) {
        RidePath *path = [ride.drvList objectAtIndex:0];
        cell.textLabel.text = path.drvpath;
        NSString *drvpath = [NSString stringWithFormat:@"%8@: %@", @"类型", @"车找人"];
        cell.detailTextLabel.text = drvpath;
        cell.detailTextLabel.lineBreakMode = 0;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    //NSLog(@"module goto...");
    int pos = indexPath.row;
    if (pos < 4) {
        return;
    }
    // 跳转 评论页面
    //EBuyComments *nextView = [[EBuyComments alloc] init];
    //nextView.param = param;
    //[self.navigationController pushViewController:nextView animated:YES];
    //[nextView release];
}

@end
