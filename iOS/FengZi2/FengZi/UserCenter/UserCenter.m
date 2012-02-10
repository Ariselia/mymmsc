//
//  UserCenter.m
//  FengZi
//
//  Created by  on 11-12-27.
//  Copyright (c) 2011年 iTotemStudio. All rights reserved.
//

#import "UserCenter.h"
#import "Api.h"

#import "UCLogin.h"
#import "UCRegister.h"

#define ALERT_TITLE @"个人中心 提示"

@implementation UserCenter
@synthesize tableView=_tableView, message;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)doReg:(id)sender{
    UCRegister *nextView = [[UCRegister alloc] init];
    [self.navigationController pushViewController:nextView animated:YES];
    [nextView release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIImage *image = [UIImage imageNamed:@"navigation_bg.png"];
    Class ios5Class = (NSClassFromString(@"CIImage"));
    if (nil != ios5Class) {
        [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    }else
    {
        self.navigationController.navigationBar.layer.contents = (id)[UIImage imageNamed:@"navigation_bg.png"].CGImage;
    }
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(110, 0, 100,44)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = UITextAlignmentCenter;
    label.font = [UIFont fontWithName:@"黑体" size:60];
    label.textColor = [UIColor blackColor];
    label.text= @"个人中心";
    self.navigationItem.titleView = label;
    [label release];
    
    if (![Api isOnLine]) {
        _btnRight = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnRight.frame = CGRectMake(0, 0, 60, 32);
        [_btnRight setImage:[UIImage imageNamed:@"uc-reg2.png"] forState:UIControlStateNormal];
        [_btnRight setImage:[UIImage imageNamed:@"uc-reg2.png"] forState:UIControlStateHighlighted];
        [_btnRight addTarget:self action:@selector(doReg:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:_btnRight];
        self.navigationItem.rightBarButtonItem = rightItem;
        [rightItem release];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) onLogin:(id)sender {
    //[iOSApi Alert:@"登录" message:@"请稍候..."];
    //id nextView = [[[cls alloc] initWithNibName:nil bundle:nil] autorelease];
    UCLogin *nextView = [[UCLogin new] autorelease];
    //[nextView retain];
    [self.navigationController pushViewController:nextView animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    if (items != nil) {
        [items removeAllObjects];
    }
    if ([items count] == 0) {
        // 预加载项
        iOSAction *action = nil;
        items = [[NSMutableArray alloc] initWithCapacity:0];
        if ([Api isOnLine]) {
            message.text = [NSString stringWithFormat: @"Hi, %@", [Api nikeName]];
            action = [iOSAction initWithName: @"修改昵称" class: @"UCUpdateNikename"];
            [action setIcon: @"Images/usercenter/uc-edit"];
            //[action setNib: @"TableView"];
            [items addObject: action];
            //[action release];
            
            action = [iOSAction initWithName: @"修改密码" class: @"UCUpdatePassword"];
            [action setIcon: @"Images/usercenter/uc-passwd"];
            //[action setNib: @"MoneyTrans"];
            [items addObject: action];
            //[action release];
        } else {
            // 没有登录
            message.text = @"您还未登录，请登录！";
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = message.frame;
            btn.backgroundColor = [UIColor clearColor];
            [btn addTarget:self action:@selector(onLogin:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:btn];
        }
        
        action = [iOSAction initWithName: @"我的码" class: @"UCMyCode"];
        [action setIcon: @"Images/usercenter/uc-coder"];
        //[action setNib: @"MoneyTrans"];
        [items addObject: action];
        //[action release];
        
        action = [iOSAction initWithName: @"收藏" class: @"FaviroteViewController"];
        [action setIcon: @"Images/usercenter/uc-star"];
        //[action setNib: @"MoneyTrans"];
        [items addObject: action];
        //[action release];
        [self.tableView reloadData];
    }
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //return 2;
    return [items count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	//CGSize size = [@"123" sizeWithFont:fontInfo constrainedToSize:CGSizeMake(labelWidth, 20000) lineBreakMode:UILineBreakModeWordWrap];
	//return size.height + 10; // 10即消息上下的空间，可自由调整 
	return 36;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    // Configure the cell.
    int pos = [indexPath row];
    if (pos >= [items count]) {
        //[cell release];
        return nil;
    }
    iOSAction *info = [items objectAtIndex: pos];
    // 设定左边图标
    cell.imageView.image = [[UIImage imageNamed:@"unknown3.png"] scaleToSize:CGSizeMake(kCellIconHeight, kCellIconHeight)];
    if ([info icon] != nil) {
        cell.imageView.image = [[UIImage imageNamed:[info icon]] scaleToSize:CGSizeMake(kCellIconHeight, kCellIconHeight)];
    }
    // 设定标题
    cell.textLabel.text = [info title];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    // 设定右边按钮
    [cell setBackgroundColor: [UIColor clearColor]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    NSLog(@"module goto...");
    iOSAction *action = [items objectAtIndex:indexPath.row];
    //Class cls = NSClassFromString(action.action);
    //id nextView = [[[cls alloc] initWithNibName:nil bundle:nil] autorelease];
    id nextView = [action newInstance];
    //[nextView retain];
    [self.navigationController pushViewController:nextView animated:YES];
    [nextView release];
}

@end
