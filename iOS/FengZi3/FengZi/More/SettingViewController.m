//
//  SettingViewController.m
//  FengZi
//
//  Created by lt ji on 11-12-19.
//  Copyright (c) 2011年 iTotemStudio. All rights reserved.
//

#import "SettingViewController.h"
#import "AppDelegate.h"
#import "SHKSina.h"
#import "SHKTencent.h"
#import "UISwitchButton.h"
@implementation SettingViewController

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

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];

}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    _tableView.backgroundColor = [UIColor clearColor];
    _flashLightSwitch.on = [DATA_ENV getFlashLightStatus];
    _decodeMusicSwitch.on = [DATA_ENV getDecodeMusicStatus];
    _locationSwitch.on = [DATA_ENV getLocationStatus];
}
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section== 1) {
        return 2;
    }
    return 2;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *MyIdentifier = @"MyIdentifiersett";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] init] autorelease]; 
    }    
    
    UIColor * cellColor = CELLCOLOR;
    [cell setBackgroundColor:cellColor];
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    UISwitchButton * _onButton=[UISwitchButton buttonWithType:UIButtonTypeCustom];
    _onButton.frame = CGRectMake(210, 5, 89, 34);
    [_onButton setImage:[UIImage imageNamed:@"more_set_on.png"]forState:UIControlStateNormal];
    _onButton.adjustsImageWhenHighlighted = NO;
    [_onButton addTarget:self action:@selector(goto_offButton:) forControlEvents:UIControlEventTouchUpInside];
    _onButton.tag=[indexPath row];
    [cell addSubview:_onButton];
    
    switch (indexPath.section) {
            
        case 0:{
            switch (indexPath.row) {
                case 0:{
                    cell.textLabel.text = @"自动开启闪光灯";
                    break;
                }
                case 1:{
                    cell.textLabel.text = @"解码完成响铃";
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
                    cell.textLabel.text = @"自动存储";
                    break;
                }
                case 1:{
                    cell.textLabel.text = @"同步定位";
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
-(void)goto_offButton:(UISwitchButton *)sender
{
    if (sender.on) {
        [sender setImage:[UIImage imageNamed:@"more_set_on.png"]forState:UIControlStateNormal];
    }
    else
    {
        [sender setImage:[UIImage imageNamed:@"more_set_off.png"]forState:UIControlStateNormal];
    }
    sender.on = !sender.on;
    
    
    switch (sender.tag) {
        case 0:{
            [DATA_ENV setFlashLightStatus:sender.on];
            break;
        } 
        case 1:{
            [DATA_ENV setDecodeMusicStatus:sender.on];
            break;
        } 
        case 2:{
            break;
        } 
        case 3:{
            [DATA_ENV setLocationStatus:sender.on];
            AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
            [app setLocationStatus];
            break;
        }    
        default:
            break;
    }
    
    
}

//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    if (indexPath.section == 1) {
//        if (indexPath.row == 0) {
//            [SHKSina logout];
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
//                                                            message:@"已经注销新浪微博账号" 
//                                                           delegate:nil
//                                                  cancelButtonTitle:@"取消"
//                                                  otherButtonTitles:nil];
//            [alert show];
//            [alert release];
//        }else{
//            [SHKTencent logout];
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
//                                                            message:@"已经注销腾讯微博账号" 
//                                                           delegate:nil
//                                                  cancelButtonTitle:@"取消"
//                                                  otherButtonTitles:nil];
//            [alert show];
//            [alert release];
//        }
//    }
//}

- (IBAction)flashLightChanged:(UISwitch*)sender {
    [DATA_ENV setFlashLightStatus:sender.on];
}
- (IBAction)decodeMusicChanged:(UISwitch*)sender {
    [DATA_ENV setDecodeMusicStatus:sender.on];
}
- (IBAction)locationChanged:(UISwitch*)sender {
    [DATA_ENV setLocationStatus:sender.on];
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app setLocationStatus];
}

- (void)viewDidUnload
{
    [_tableView release];
    _tableView = nil;
    [_flashLightSwitch release];
    _flashLightSwitch = nil;
    [_decodeMusicSwitch release];
    _decodeMusicSwitch = nil;
    [_locationSwitch release];
    _locationSwitch = nil;
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
    [_tableView release];
    [_flashLightSwitch release];
    [_decodeMusicSwitch release];
    [_locationSwitch release];
    [super dealloc];
}
@end
