//
//  EBMessageList.m
//  FengZi
//
//  Created by wangfeng on 12-4-10.
//  Copyright (c) 2012年 ifengzi.cn. All rights reserved.
//

#import "EBMessageList.h"
#import "Api+Ebuy.h"

@interface EBMessageList ()

@end

@implementation EBMessageList
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

- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
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
    label.text= @"站内消息";
    self.navigationItem.titleView = label;
    [label release];
    
    UIButton *backbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backbtn.frame =CGRectMake(0, 0, 60, 32);
    
    [backbtn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backbtn setImage:[UIImage imageNamed:@"back_tap.png"] forState:UIControlStateHighlighted];
    [backbtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backitem = [[UIBarButtonItem alloc] initWithCustomView:backbtn];
    self.navigationItem.leftBarButtonItem = backitem;
    [backitem release];
    
    _borderStyle = UITextBorderStyleNone;
    //font = [UIFont systemFontOfSize:13.0];
    if ([_items count] == 0) {
        // 预加载项
        _items = [[NSMutableArray alloc] initWithCapacity:0];
        _page = 1;
    }
    if (_items != nil) {
        [iOSApi showAlert:@"读取收件箱..."];
        //NSArray *list = [[Api ebuy_push:_page++] retain];
        NSArray *list = [[Api ebuy_message_recv:_page] retain];
        [_items addObjectsFromArray:list];
        [list release];
        [iOSApi closeAlert];
    }
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //return 0;
    return [_items count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 60.f;
	return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    [cell.contentView removeSubviews];
    int pos = [indexPath row];
    EBSiteMessage *obj = [_items objectAtIndex:pos];
    NSString *tmpTitle = @"";
    if (_selected == 0) {
        // 收件箱
        tmpTitle = [NSString stringWithFormat:@"%@: %@", obj.sendName, obj.sendTime];
    } else {
        // 发件箱
        tmpTitle = [NSString stringWithFormat:@"%@: %@", obj.recvName, obj.sendTime];
    }
     
    cell.textLabel.text = [iOSApi urlDecode:tmpTitle];
    cell.textLabel.font = [UIFont systemFontOfSize:15.0];
    cell.detailTextLabel.text = [iOSApi urlDecode:obj.content];
    cell.detailTextLabel.lineBreakMode = 0;
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14.0];
    if (_selected == 0) {
        CGRect frame = CGRectMake(269, 10, 50, 20);
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btn setTitle:@"回复" forState:UIControlStateNormal];
        btn.frame = frame;
        [btn addTarget:self action:@selector(doReply:event:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:btn];
    }
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#if 0
- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellAccessoryDetailDisclosureButton;
    //return UITableViewCellAccessoryDisclosureIndicator;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    //
}
#endif

// 选择
- (IBAction)segmentAction:(UISegmentedControl *)segment{
    [iOSApi showAlert:@"读取消息列表..."];
    
    NSArray *list = nil;
    _page = 1;
    _selected = segment.selectedSegmentIndex;
    if (segment.selectedSegmentIndex == 0) {
        list = [[Api ebuy_message_recv:_page] retain];
    } else {
        list = [[Api ebuy_message_send:_page] retain];
    }
    if (_items.count > 0) {
        [_items removeAllObjects];
    }
    [_items addObjectsFromArray:list];
    [list release];
    [iOSApi closeAlert];
    [_tableView reloadData];
}

static EBSiteMessage *theObj = nil;

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger) buttonIndex{
    if (buttonIndex == 1) {
        NSString *msg = [content.text trim];
        if (msg.length < 1) {
            [iOSApi Alert:@"站内消息 提示" message:@"内容不能为空"];
            return;
        } else {
            msg = [iOSApi urlEncode:msg];
            //ApiResult *iRet = [[Api ebuy_message_reply:theObj.id content:msg] retain];
            ApiResult *iRet = [[Api ebuy_message_new:[NSString valueOf:theObj.senderId] baseId:theObj.id content:msg] retain];
            [iOSApi Alert:@"站内消息 提示" message:iRet.message];
            [iRet release];
        }
    }
}

- (void)doReply:(id)sender event:(id)event{
    NSSet *touches = [event allTouches];
	UITouch *touch = [touches anyObject];
	CGPoint currentTouchPosition = [touch locationInView: _tableView];
	NSIndexPath *indexPath = [_tableView indexPathForRowAtPoint: currentTouchPosition];
    theObj = [_items objectAtIndex:indexPath.row];
    
    UIAlertView *alert = [[UIAlertView alloc]
						  initWithTitle: [NSString stringWithFormat:@"对 %@ 说点什么吧", [iOSApi urlDecode:theObj.sendName]]
						  message:[NSString stringWithFormat:@"\n\n"]
						  delegate:self
						  cancelButtonTitle:@"取消"
						  otherButtonTitles:@"发表", nil];
    content = [[UITextField alloc] initWithFrame:CGRectMake(12, 60, 260, 25)];
	[content setTag:1001];
	CGAffineTransform mytrans = CGAffineTransformMakeTranslation(-0, -150);
	[alert setTransform:mytrans];
	[content setBackgroundColor:[UIColor whiteColor]];
	[alert addSubview:content];
	[alert show];
	[alert release];
}

@end
