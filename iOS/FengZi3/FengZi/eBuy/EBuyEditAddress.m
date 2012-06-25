//
//  EBuyEditAddress.m
//  FengZi
//
//  Created by wangfeng on 12-4-23.
//  Copyright (c) 2012年 ifengzi.cn. All rights reserved.
//

#import "EBuyEditAddress.h"
#import "EBuyAddress.h"
#import "Api+Ebuy.h"
#import "EBuyOrder.h"

@interface EBuyEditAddress ()

@end

@implementation EBuyEditAddress
@synthesize tableView = _tableView;
@synthesize shopName;
@synthesize param;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    label.text= @"确认订单";
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

- (void)viewWillAppear:(BOOL)animated{
    NSDictionary *carList = [Api ebuy_car_list];
    if (carList.count == 0) {
        [self goBack];
    }
    NSArray *data = [Api ebuy_address_list];
    if (data.count < 1) {
        isEmpty = YES;
    } else {
        BOOL bReload = NO;
        if (_items != nil) {
            [_items release];
            bReload = YES;
        }
        _items = [[NSMutableArray alloc] initWithArray:data];
        if (bReload) {
            [_tableView reloadData];
        }
    }
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_items count] + 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 70.f;
	return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    int pos = [indexPath row];
    [cell.contentView removeSubviews];
    
    if (pos == _items.count) {
        // 下面配文字
        cell.textLabel.text = @"新增收货地址";
        cell.textLabel.font = [UIFont systemFontOfSize:30.0];
        cell.textLabel.lineBreakMode = UILineBreakModeTailTruncation;
        cell.textLabel.numberOfLines = 0;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        // 下面加按钮
        return cell;
    } else if (pos == _items.count + 1) {
        // 表格下方 三个按钮
        CGRect frame = CGRectMake(50, 5, 50, 20);
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btn setTitle:@"选择" forState:UIControlStateNormal];
        btn.frame = frame;
        [btn addTarget:self action:@selector(doSelect) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:btn];
        
        frame.origin.x += 100;
        btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btn setTitle:@"编辑" forState:UIControlStateNormal];
        btn.frame = frame;
        [btn addTarget:self action:@selector(doEdit) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:btn];
        
        frame.origin.x += 100;
        btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btn setTitle:@"删除" forState:UIControlStateNormal];
        btn.frame = frame;
        [btn addTarget:self action:@selector(doDelete) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:btn];
        return cell;
    } else {
        EBAddress *obj = [_items objectAtIndex:pos];
        NSString *str = nil;
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                       reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        cell.textLabel.textColor = [UIColor grayColor];
        cell.textLabel.highlightedTextColor = [UIColor blackColor];
        cell.textLabel.font = [UIFont systemFontOfSize:15.0];
        str = [NSString stringWithFormat:@"省:%@ 市:%@",obj.sheng, obj.chengshi];
        cell.textLabel.text = [iOSApi urlDecode:str];
        
        cell.detailTextLabel.textAlignment = UITextAlignmentCenter;
        cell.detailTextLabel.textColor = [UIColor grayColor];
        cell.detailTextLabel.highlightedTextColor = [UIColor blackColor];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:15.0];
        str = [NSString stringWithFormat:@"%@(%@)",obj.dizhi, obj.youbian];
        cell.detailTextLabel.text = [iOSApi urlDecode:str];
    }
    return cell;
}

static int s_idxAddress = -1;

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    int pos = indexPath.row;
    if (pos < _items.count) {
        UITableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
        if (cell.accessoryType != UITableViewCellAccessoryCheckmark) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            s_idxAddress = pos;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
            s_idxAddress = -1;
        }
    } else if( pos == _items.count) {
        // 跳转 地址簿编辑页面
        EBuyAddress *nextView = [[EBuyAddress alloc] init];
        //nextView.param = param;
        [self.navigationController pushViewController:nextView animated:YES];
        [nextView release];
    }
}

// 按钮点击事件
static int iTimes = -1;

// 选择
- (void)doSelect{
    if (s_idxAddress < 0 || s_idxAddress >= _items.count) {
        [iOSApi Alert:@"提示" message:@"请先选择收货地址"];
    } else {
        EBuyOrder *nextView = [[EBuyOrder alloc] init];
        nextView.param = shopName;
        nextView.addrId = s_idxAddress;
        [self.navigationController pushViewController:nextView animated:YES];
        [nextView release];
    }
}

// 编辑
- (void)doEdit{
    if (s_idxAddress < 0 || s_idxAddress >= _items.count) {
        [iOSApi Alert:@"提示" message:@"请先选择收货地址"];
    } else {
        EBuyAddress *nextView = [[EBuyAddress alloc] init];
        nextView.seqId = s_idxAddress;
        [self.navigationController pushViewController:nextView animated:YES];
        [nextView release];
    }
}

// 删除
- (void)doDelete{
    if (s_idxAddress < 0 || s_idxAddress >= _items.count) {
        [iOSApi Alert:@"提示" message:@"请先选择收货地址"];
    } else {
        iTimes = 0;
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"提示"
                              message:@"确定删除这收货地址?"
                              delegate:self
                              cancelButtonTitle:@"取消"
                              otherButtonTitles:@"确定", nil];
        [alert show];
        [alert release];
    }
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger) buttonIndex {
    if (iTimes == 0) {
		switch (buttonIndex) {
			case 1: // 删除
                [Api ebuy_addess_del:s_idxAddress];
                NSArray *data = [Api ebuy_address_list];
                if (data.count < 1) {
                    isEmpty = YES;
                } else {
                    if (_items != nil) {
                        [_items release];
                    }
                    _items = [[NSMutableArray alloc] initWithArray:data];
                }
                [_tableView reloadData];
				break;
			default: // 取消
                s_idxAddress = -1;
				break;
		}
	} else if (iTimes == 1) {
        //
	}
}

@end
