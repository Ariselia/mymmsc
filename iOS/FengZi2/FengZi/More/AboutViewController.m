//
//  AboutViewController.m
//  FengZi
//
//  Created by lt ji on 11-12-19.
//  Copyright (c) 2011年 iTotemStudio. All rights reserved.
//

#import "AboutViewController.h"
#import "FontLabel.h"
#import "FontLabelStringDrawing.h"
#import "FontManager.h"
#import "ZFont.h"
#import <iOSApi/iOSApi.h>

@implementation AboutViewController

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
}

-(void)serviceTel{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",Service_Tel]]];
}

-(void)serviceWeb{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:Service_WebSite]]; 
}

-(void)serviceEmail{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"mailto://%@",Service_Email]]];
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }
    return 3;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *MyIdentifier = @"MyIdentifiersett";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] init] autorelease]; 
    }     
    cell.textLabel.font=[UIFont systemFontOfSize:16];
    cell.accessoryType = UITableViewCellAccessoryNone;
    switch (indexPath.section) {
        case 0:{
            switch (indexPath.row) {
                case 0:{
                    cell.textLabel.text = [NSString stringWithFormat:@"软件版本      V%@",[iOSApi version]];
                    break;
                }
                case 1:{
                    cell.textLabel.text = @"开发商家      北京蜂侠飞科技有限公司";
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
                    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(110, 3, 300, 35)];
                    label.backgroundColor=[UIColor clearColor];
                    label.textColor = [UIColor colorWithRed:85.0/255 green:144.0/255 blue:0 alpha:1];
                    label.text = Service_Tel;
                    UIButton *btn= [UIButton buttonWithType:UIButtonTypeCustom];
                    btn.frame = label.frame;
                    [btn addTarget:self action:@selector(serviceTel) forControlEvents:UIControlEventTouchUpInside];
                    [cell addSubview:label];
                    [label release];
                    [cell addSubview:btn];
                    cell.textLabel.text = @"客服电话";
                    break;
                }
                case 1:{
                    FontLabel *label = [[FontLabel alloc] initWithFrame:CGRectMake(110, 3, 300, 35)];
                    label.backgroundColor=[UIColor clearColor];
                    ZMutableAttributedString *str = [[ZMutableAttributedString alloc] initWithString:Service_Email                                                                                  attributes: nil];
                    [str addAttribute:ZUnderlineStyleAttributeName value:[NSNumber numberWithInt:ZUnderlineStyleSingle] range:NSMakeRange(0, Service_Email.length)];
                    [str addAttribute:ZForegroundColorAttributeName value:[UIColor colorWithRed:0 green:102.0/255 blue:204.0/255 alpha:1] range:NSMakeRange(0, Service_Email.length)];
                    label.zAttributedText = str;
                    [str release];

                    UIButton *btn= [UIButton buttonWithType:UIButtonTypeCustom];
                    btn.frame = label.frame;
                    [btn addTarget:self action:@selector(serviceEmail) forControlEvents:UIControlEventTouchUpInside];
                    [cell addSubview:label];
                    [label release];
                    [cell addSubview:btn];
                    cell.textLabel.text = @"邮箱地址";
                    break;
                }
                case 2:{
                    FontLabel *label = [[FontLabel alloc] initWithFrame:CGRectMake(110, 3, 300, 35)];
                    label.backgroundColor=[UIColor clearColor];
                    ZMutableAttributedString *str = [[ZMutableAttributedString alloc] initWithString:Service_WebSite                                                                                  attributes: nil];
                    [str addAttribute:ZUnderlineStyleAttributeName value:[NSNumber numberWithInt:ZUnderlineStyleSingle] range:NSMakeRange(0, Service_WebSite.length)];
                    [str addAttribute:ZForegroundColorAttributeName value:[UIColor colorWithRed:0 green:102.0/255 blue:204.0/255 alpha:1] range:NSMakeRange(0, Service_WebSite.length)];
                    label.zAttributedText = str;
                    [str release];
                    
                    UIButton *btn= [UIButton buttonWithType:UIButtonTypeCustom];
                    btn.frame = label.frame;
                    [btn addTarget:self action:@selector(serviceWeb) forControlEvents:UIControlEventTouchUpInside];
                    [cell addSubview:label];
                    [label release];
                    [cell addSubview:btn];
                    cell.textLabel.text = @"网站地址";
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

- (void)viewDidUnload
{
    [_tableView release];
    _tableView = nil;
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
    [super dealloc];
}
@end
