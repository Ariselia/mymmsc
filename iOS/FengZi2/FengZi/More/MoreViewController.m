//
//  MoreViewController.m
//  FengZi
//
//  Created by lt ji on 11-12-12.
//  Copyright (c) 2011年 iTotemStudio. All rights reserved.
//

#import "MoreViewController.h"
#import "MoreViewCell.h"
#import "FeedbackViewController.h"
#import "RecommandViewController.h"
#import "SettingViewController.h"
#import "AboutViewController.h"
#import "SHKSina.h"
#import "SHKTencent.h"
#import <QuartzCore/QuartzCore.h>
#import "HelpView.h"
#import "HelpViewController.h"
@implementation MoreViewController

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


-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 3;
    }else if(section==1){
        return 3;
    }
    return 2;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *MyIdentifier = @"MyIdentifierHis";
	MoreViewCell *cell = (MoreViewCell*)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [MoreViewCell cellFromNib]; 
    }     
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    switch (indexPath.section) {
        case 0:{
            switch (indexPath.row) {
                case 0:{
                    [cell initDataWithTitile:@"推荐好友" withImage:@"more_recommend.png"];
                    break;
                }
                case 1:{
                    [cell initDataWithTitile:@"新浪微博" withImage:@"more_sina.png"];
                    break;
                }
                case 2:{
                    [cell initDataWithTitile:@"腾讯微博" withImage:@"more_tecent.png"];
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case 1:{
            switch (indexPath.row) {
                case 0:{
                    [cell initDataWithTitile:@"设置" withImage:@"more_setting.png"];
                    break;
                }
                case 1:{
                    [cell initDataWithTitile:@"操作帮助" withImage:@"more_help.png"];
                    break;
                }
                case 2:{
                    [cell initDataWithTitile:@"更新软件" withImage:@"more_update.png"];
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case 2:{
            switch (indexPath.row) {
                case 0:{
                    [cell initDataWithTitile:@"意见反馈" withImage:@"more_feedback.png"];
                    break;
                }
                case 1:{
                    [cell initDataWithTitile:@"关于我们" withImage:@"more_about.png"];
                    break;
                }
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0:{
            switch (indexPath.row) {
                case 0:{
                    RecommandViewController *feedview = [[RecommandViewController alloc] initWithNibName:@"RecommandViewController" bundle:nil];
                    [self.navigationController pushViewController:feedview animated:YES];
                    [feedview release];
                    break;
                }
                case 1:{
                    if (!DATA_ENV.hasNetWork) {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                        message:@"无法连接到网络" 
                                                                       delegate:nil
                                                              cancelButtonTitle:@"取消"
                                                              otherButtonTitles:nil];
                        [alert show];
                        [alert release];
                        return;
                    }
                    [[SHK currentHelper] setRootViewController:self];
                    SHKItem *item = [SHKItem text:RecommendContent];
                    item.shareType = SHKShareTypeText;
                    item.title = @"一个好玩的客户端分享";
                    [SHKSina shareItem:item];
                    break;
                }
                case 2:{
                    if (!DATA_ENV.hasNetWork) {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                        message:@"无法连接到网络" 
                                                                       delegate:nil
                                                              cancelButtonTitle:@"取消"
                                                              otherButtonTitles:nil];
                        [alert show];
                        [alert release];
                        return;
                    }
                    [[SHK currentHelper] setRootViewController:self];
                    SHKItem *item = [SHKItem text:RecommendContent];
                    item.shareType = SHKShareTypeText;
                    item.title = @"一个好玩的客户端分享";
                    [SHKTencent shareItem:item];
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case 1:{
            switch (indexPath.row) {
                case 0:{
                    SettingViewController *feedview = [[SettingViewController alloc] initWithNibName:@"SettingViewController" bundle:nil];
                    [self.navigationController pushViewController:feedview animated:YES];
                    [feedview release];

                    break;
                }
                case 1:{
                    HelpViewController *help = [[HelpViewController alloc] initWithNibName:@"HelpViewController" bundle:nil];
                    [self.navigationController pushViewController:help animated:YES];
                    [help release];
//                    HelpView *helpView = (HelpView*)[[[NSBundle mainBundle] loadNibNamed:@"HelpView" owner:self options:nil] objectAtIndex:0];
//                    [helpView startHelp];
                    break;
                }
                case 2:{
                    if (!DATA_ENV.hasNetWork) {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                        message:@"无法连接到网络" 
                                                                       delegate:nil
                                                              cancelButtonTitle:@"取消"
                                                              otherButtonTitles:nil];
                        [alert show];
                        [alert release];
                        return;
                    }
                    [LastVersionDataRequest requestWithDelegate:self];
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case 2:{
            switch (indexPath.row) {
                case 0:{
                    FeedbackViewController *feedview = [[FeedbackViewController alloc] initWithNibName:@"FeedbackViewController" bundle:nil];
                    [self.navigationController pushViewController:feedview animated:YES];
                    [feedview release];
                    break;
                }
                case 1:{
                    AboutViewController *feedview = [[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:nil];
                    [self.navigationController pushViewController:feedview animated:YES];
                    [feedview release];
                    break;
                }
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
}

-(void)requestDidFinishLoad:(ITTBaseDataRequest *)request{
    if([request isKindOfClass:[LastVersionDataRequest class]]){
        if ([[request.resultDic objectForKey:@"status"] intValue]==0) {
            NSDictionary *dic = [request.resultDic objectForKey:@"data"];
            if (dic && [iOSApi isNeedUpload:[dic objectForKey:@"version"]]) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"当前有新版本，是否要更新？" message:nil delegate:self cancelButtonTitle:@"确认" otherButtonTitles: @"取消", nil];
                [alertView show];
                RELEASE_SAFELY(alertView);
            }else{
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"当前已是最新版本！" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
                [alertView show];
                RELEASE_SAFELY(alertView);
            }
        }
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:APPSTORE_URL]];
    }
}

-(void)request:(ITTBaseDataRequest *)request didFailLoadWithError:(NSError *)error{
    NSLog(@"%@",error);
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络连接失败！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alertView show];
    RELEASE_SAFELY(alertView);
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImage *image = [UIImage imageNamed:@"navigation_bg.png"];
    Class ios5Class = (NSClassFromString(@"CIImage"));
    if (nil != ios5Class) {
        [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    }else
    {
        self.navigationController.navigationBar.layer.contents = (id)image.CGImage;
    }
    
    _tableview.backgroundColor = [UIColor clearColor];
}

- (void)viewDidUnload
{
    [_tableview release];
    _tableview = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [_tableview release];
    [super dealloc];
}
@end
