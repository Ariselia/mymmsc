//
//  UCMyComments.m
//  FengZi
//
//  Created by wangfeng on 12-3-31.
//  Copyright (c) 2012年 iTotemStudio. All rights reserved.
//

#import "UCMyComments.h"
#import "Api+UserCenter.h"
#import "UCUpdateNikename.h"
#import "UCCell.h"
#import "UITableViewCellExt.h"
@interface UCMyComments ()

@end

@implementation UCMyComments
@synthesize tableView = _tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.proxy = self;
        _page = 0;
        _size = 8;
    }
    return self;
}

- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // Do any additional setup after loading the view from its nib.
    UIImage *image = [UIImage imageNamed:@"navigation_bg.png"];
    Class ios5Class = (NSClassFromString(@"CIImage"));
    if (nil != ios5Class) {
        [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    } else {
        self.navigationController.navigationBar.layer.contents = (id)[UIImage imageNamed:@"navigation_bg.png"].CGImage;
    }
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(110, 0, 140, 44)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = UITextAlignmentCenter;
    label.font = [UIFont fontWithName:@"黑体" size:60];
    label.textColor = [UIColor blackColor];
    label.text= @"蜂巢留言板";
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
    
    /*
    UIButton *_btnRight = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnRight.frame = CGRectMake(0, 0, 60, 32);
    [_btnRight setImage:[UIImage imageNamed:@"uc-save.png"] forState:UIControlStateNormal];
    [_btnRight setImage:[UIImage imageNamed:@"uc-save.png"] forState:UIControlStateHighlighted];
    [_btnRight addTarget:self action:@selector(doSave) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:_btnRight];
    self.navigationItem.rightBarButtonItem = rightItem;
    [rightItem release];
     */
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
    [iOSApi showAlert:@"正在获取留言信息..."];

    [self.tableView setBackgroundColor:[UIColor clearColor]];
    self.tableView.separatorStyle = NO;
    
    if ([_items count] == 0) {
        // 预加载项
        _items = [[NSMutableArray alloc] initWithCapacity:0];
    }
    //[iOSApi showAlert:@"正在获取留言信息..."];
    [iOSApi closeAlert];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	//CGSize size = [@"123" sizeWithFont:fontInfo constrainedToSize:CGSizeMake(labelWidth, 20000) lineBreakMode:UILineBreakModeWordWrap];
	//return size.height + 10; // 10即消息上下的空间，可自由调整 
	return 60;
}

- (UITableViewCell *)configure:(UITableViewCell *)cell withObject:(id)object {
    ucComment *obj = object;
    // 设置字体
    UIFont *textFont = [UIFont systemFontOfSize:15.0];
    UIFont *detailFont = [UIFont systemFontOfSize:10.0];
    
    // 加载照片
    UIImage *im = nil;
    BOOL bDown = NO;
    // 取得照片文件名
    NSString *photoName = [Api uc_photo_name:obj.commentUserId];
    // 组织照片本地文件路径
    NSString *filePath = [iOSFile path:[Api filePath:photoName]];
    iOSLog(@"filePath = %@", filePath);
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    if (![Api fileIsExists:photoName] || data.length == 0) {
        bDown = YES;
    } else {
        im = [UIImage imageWithData:data];
        if (im == nil) {
            [iOSFile remove:[Api filePath:photoName]];
            bDown = YES;
        } else {
            bDown = NO;
        }
    }
    if (bDown) {
        // 如果照片不存在, 进行下载
        [Api uc_photo_down:obj.commentUserId];
    }
    
    CGRect frame = CGRectMake(0.00f, 5.00f, 45, 45);
    cell.imageView.frame = frame;
    if ([Api fileIsExists:photoName]) {
        data = [NSData dataWithContentsOfFile:filePath];
        if (data.length > 0) {
            im = [[UIImage imageWithData:data]toSize: CGSizeMake(40, 40)];
        } else {
            im = [[UIImage imageNamed:@"uc-unkonw.png"]toSize: CGSizeMake(40, 40)];
        }
    } else {
        im = [[UIImage imageNamed:@"uc-unkonw.png"]toSize:CGSizeMake(40, 40)];
    }
    [cell.imageView loadImage:im]; 
    
    //cell.textLabel.text = [NSString stringWithFormat:@"%@ 的评论", obj.username];
    /*
    static NSString *CellIdentifier = @"Cell";
    
    cell = [[UCCell alloc]init];
    if (cell == nil) {
        
        cell = [[[UCCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
        
    }
     */
    
    UIImage *image = [[UIImage imageNamed:@"uc-cell.png"] toSize: CGSizeMake(320, 60)];
    
    [cell setBackgroundImage:image];
    
   // cell.imageView.image = [[iOSApi imageNamed:[Api typeIcon:obj.type]] scaleToSize:CGSizeMake(36, 36)];
    cell.textLabel.text = obj.commentName;
    cell.textLabel.font = textFont;
    
    UILabel *dt = [[UILabel alloc] initWithFrame:CGRectMake(170, 20, 105, 10)];
    dt.font = detailFont;
    dt.text = obj.commentDate;
    dt.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:dt];
    [dt release];
    cell.detailTextLabel.text = obj.commentContent;
    cell.detailTextLabel.font = detailFont;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
}

- (NSArray *)reloadData:(iOSTableViewController *)tableView {
    NSArray *list = [Api uc_comments_get:_page size:_size];
    return list;
}

- (NSArray *)arrayOfHeader:(iOSTableViewController *)tableView {
    return nil;
}

- (NSArray *)arrayOfFooter:(iOSTableViewController *)tableView {
    NSArray *list = [Api uc_comments_get:_page + 1 size:_size];
    if (list.count > 0) {
        _page += 1;
    }
    return list;
}

/*
- (void)tableView:(UITableViewCell *)cell onCustomAccessoryTapped:(id)object {
    
   // UIImage *himage = [UIImage imageNamed:@"uc-cell-h.png"];
    //[cell setBackgroundImage:himage];
    ucComment *obj = object;
    UCUpdateNikename *nextView = [[UCUpdateNikename alloc] init];
    nextView.idDest = obj.commentUserId;
    [self.navigationController pushViewController:nextView animated:YES];
    [nextView release];
}
*/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    // Navigation logic may go here. Create and push another view controller.
    //NSLog(@"module goto...");
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    UIImage *himage = [[UIImage imageNamed:@"uc-cell-h.png"] toSize: CGSizeMake(320, 60)];
    [cell setBackgroundImage:himage];
    
    ucComment *obj = [self objectForIndexPath:indexPath];

    UCUpdateNikename *nextView = [[UCUpdateNikename alloc] init];
    nextView.idDest = obj.commentUserId;
    [self.navigationController pushViewController:nextView animated:YES];
    [nextView release];
}

@end
