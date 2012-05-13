//
//  EBuyPortal.m
//  FengZi
//
//  Created by wangfeng on 12-3-5.
//  Copyright (c) 2012年 iTotemStudio. All rights reserved.
//

#import "EFileDZQ.h"
#import "Api+eFile.h"
#import "EFileHYKInfo.h"
#import "UITableViewCellExt.h"
#import "Api+Database.h"
#import "FileUtil.h"
#import "EFileDZQInfo.h"

@implementation EFileDZQ

@synthesize tableView = _tableView;
@synthesize param;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        isOnline = NO;
        
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
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //设置导航图片    
    
    [super viewWillAppear:animated];
    
    UIImage *image = [[UIImage imageNamed:@"fjtitle.png"] toSize: CGSizeMake(320, 44)];
    Class ios5Class = (NSClassFromString(@"CIImage"));
    if (nil != ios5Class) {
        [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    } else {
        self.navigationController.navigationBar.layer.contents = (id)[UIImage imageNamed:@"fjtitle.png"].CGImage;
    }
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320,44)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = UITextAlignmentCenter;
    label.font = [UIFont fontWithName:@"黑体" size:60];
    label.textColor = [UIColor blackColor];
    label.text= param.name;
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
    
    _borderStyle = UITextBorderStyleNone;
    _font = [UIFont systemFontOfSize:13.0];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    self.tableView.separatorStyle = NO;
    
    [iOSApi showAlert:@"正在加载信息..."];
    if ([_items count] == 0) {
        // 预加载项
        _items = [[NSMutableArray alloc] initWithCapacity:0];
        _page = 1;
        
        NSMutableArray *result = [[DataBaseOperate shareData] loadCardList:_page sid:param.sid];
        [_items addObjectsFromArray:result];         
        
    }
    //[iOSApi showCompleted:@"加载完毕"];
    [iOSApi closeAlert];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //
}



#pragma mark -
#pragma mark UITableViewDataSource

//指定有多少个分区(Section)，默认为1
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return  1;
}
//指定每个分区中有多少行，默认为1
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    return  [_items count];
    
}
//设置cell每行间隔的高度 
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	//CGSize size = [@"123" sizeWithFont:fontInfo constrainedToSize:CGSizeMake(labelWidth, 20000) lineBreakMode:UILineBreakModeWordWrap];
	//return size.height + 10; // 10即消息上下的空间，可自由调整 
	return 44;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // NSLog(@"加载");
    
    tableView.backgroundColor = [UIColor clearColor];
    
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        UIImage *image = [[UIImage imageNamed:@"cellbg.png"] toSize: CGSizeMake(320, 44)];
        [cell setBackgroundImage:image];
    }
    
    int pos = [indexPath row];
    if (pos >= [_items count]) {
        return nil;
    }
    
    EFileCardList *obj = [_items objectAtIndex:pos];
    cell.textLabel.text = [iOSApi urlDecode:[obj name]];
    NSString *picurl = [obj picurl];
    //加载本地图片
    NSString *path;
    path = [FileUtil filePathInEncode:picurl];
    //NSLog(path);//???路径有～～图片没存到本地？？
    //NSString *path2 = [NSString stringWithFormat:@"%@/%@",API_CACHE_FILEPATH,picurl];  
    cell.imageView.image =[UIImage imageWithContentsOfFile:path];

    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //跳转页面
    int pos = indexPath.row;
    //跳转页面
    
    EFileCardList *obj = [_items objectAtIndex:pos];
    EFileDZQInfo *nextView = [[EFileDZQInfo alloc] init];
    nextView.param = obj;
    [self.navigationController pushViewController:nextView animated:YES];
    [nextView release];

    
}


@end
