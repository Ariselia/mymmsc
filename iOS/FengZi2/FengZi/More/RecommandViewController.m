//
//  RecommandViewController.m
//  FengZi
//
//  Created by lt ji on 11-12-19.
//  Copyright (c) 2011年 iTotemStudio. All rights reserved.
//

#import "RecommandViewController.h"
#import "SHK.h"
#import "SHKMail.h"
@implementation RecommandViewController

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

#pragma mark -
#pragma mark SMS

-(void)launchSmsAppOnDevice
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该设备不支持发送短信！" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
    [alert show];
    [alert release];
}

#pragma mark -

#pragma mark Componse sms

-(void)displaySMSComposerSheet{
    MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
    picker.body = RecommendContent;
    picker.messageComposeDelegate = self;
    [self presentModalViewController:picker animated:YES];
    [picker release];
}

-(void)showSms{
    Class smsClass = NSClassFromString(@"MFMessageComposeViewController");
    if (smsClass != nil) {
        if ([smsClass canSendText]){
            [self displaySMSComposerSheet];
        } else {
            [self launchSmsAppOnDevice];
        }
    } else {
        [self launchSmsAppOnDevice];
    }
    
}

#pragma mark Componse sms
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    _tableview.backgroundColor = [UIColor clearColor];
}
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *MyIdentifier = @"MyIdentifierreco";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] init] autorelease]; 
    }     
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    switch (indexPath.row) {
        case 0:{
            cell.textLabel.text = @"通过短信推荐";
            break;
        }
        case 1:{
            cell.textLabel.text = @"通过邮件推荐";
            break;
        }
        default:
            break;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:{
            [self showSms];
            break;
        }
        case 1:{
            [[SHK currentHelper] setRootViewController:self];
            SHKItem *item = [SHKItem text:RecommendContent];
            item.shareType = SHKShareTypeText;
            item.title = @"蜂子分享";
            [SHKMail  shareItem:item];
            break;
        }
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
