//
//  UCStoreBBS.m
//  FengZi
//
//  Created by  on 12-1-4.
//  Copyright (c) 2012年 iTotemStudio. All rights reserved.
//

#import "UCStoreBBS.h"
#import "Api+eShop.h"

@implementation UCStoreBBS
@synthesize info;
@synthesize nikename, content;

- (IBAction)textFieldShouldReturn:(id)sender;
{
	[sender resignFirstResponder];
    [content resignFirstResponder];
    [nikename resignFirstResponder];
}

- (IBAction)bbsSubmit:(id)sender {
    [self textFieldShouldReturn:sender];
    NSString *nk = [nikename.text trim];
    NSString *msg = [content.text trim];
    if (msg.length < 1) {
        [iOSApi toast:@"请输入评论内容!"];
        return;
    } else if(msg.length > 140) {
        [iOSApi toast:@"字数超出限制，请控制在140字以内!"];
        return;
    }
    if (nk.length < 1) {
        nk = @"匿名";
    }
    [iOSApi showAlert:@"提交评论中"];
    ApiResult *iRet = [Api conmment:info.id username:nk msg:msg];
    msg = nil;
    if (iRet.status == 0) {
        msg = @"评论信息提交成功";
    } else {
        msg = @"评论信息提交失败";
    }
    //[iOSToast show:msg];
    [iOSApi showCompleted:msg];
    [iOSApi closeAlert];
    [self reloadData];    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.proxy = self;
        _page = 1;
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

- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
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
    label.text= [NSString stringWithFormat:@"%@ 的评论", info.shopname];
    UIButton *backbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backbtn.frame = label.frame;
    [backbtn addTarget:self action:@selector(textFieldShouldReturn:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:backbtn];
    self.navigationItem.titleView = label;
    [label release];
    
    backbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backbtn.frame =CGRectMake(0, 0, 60, 32);
    [backbtn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backbtn setImage:[UIImage imageNamed:@"back_tap.png"] forState:UIControlStateHighlighted];
    [backbtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backitem = [[UIBarButtonItem alloc] initWithCustomView:backbtn];
    self.navigationItem.leftBarButtonItem = backitem;
    [backitem release];
    
    content.text = @"";
    nikename.placeholder = [[Api user] nikeName];
    // 处理所有文本输入框的被键盘挡住问题
    [super registerForKeyboardNotifications];
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

- (void)viewWillAppear:(BOOL)animated {
    if ([items count] == 0) {
        // 预加载项
        items = [[NSMutableArray alloc] initWithCapacity:0];
    }
}

- (UITableViewCell *)configure:(UITableViewCell *)cell withObject:(id)object {
    ESContentInfo *obj = object;
    // 设置字体
    UIFont *textFont = [UIFont systemFontOfSize:15.0];
    UIFont *detailFont = [UIFont systemFontOfSize:10.0];
    //cell.imageView.image = [[iOSApi imageNamed:[Api typeIcon:obj.type]] scaleToSize:CGSizeMake(36, 36)];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ 的评论", obj.username];
    cell.textLabel.font = textFont;
    cell.detailTextLabel.text = obj.content;
    cell.detailTextLabel.font = detailFont;
    cell.accessoryType = UITableViewCellAccessoryNone;
    return cell;
}

- (NSArray *)reloadData:(iOSTableViewController *)tableView {
    return [Api bbsList:info.id page:_page];
}

- (NSArray *)arrayOfHeader:(iOSTableViewController *)tableView {
    return nil;
}

- (NSArray *)arrayOfFooter:(iOSTableViewController *)tableView {
    NSArray *list = [Api bbsList:info.id page:_page + 1];
    if (list.count > 0) {
        _page += 1;
    }
    return list;
}

@end
