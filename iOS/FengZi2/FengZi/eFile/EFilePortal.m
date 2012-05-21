//
//  EBuyPortal.m
//  FengZi
//
//  Created by wangfeng on 12-3-5.
//  Copyright (c) 2012年 iTotemStudio. All rights reserved.
//

#import "EFilePortal.h"
#import "UITableViewCellExt.h"
#import "EFileHYK.h"
#import "EFileDZQ.h"

#import "Api+eFile.h"
#import "Api+DataBase.h"

@implementation EFilePortal

@synthesize tableView = _tableView;
@synthesize group;
@synthesize leftBtn;
@synthesize rightBtn;
@synthesize netBtn;
@synthesize localBtn,noHYK,noDZQ;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        isOnline = NO;
        _isNet = NO;
        _isLocal = YES;
        _isHYK = YES;
        _isDZQ = NO;
        _isnotFirst = NO;
        
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
    
   
    _headers=nil; // 表头显示CELL
    _items=nil;
    _font=nil;
    _tableView=nil;
    group=nil;
    leftBtn=nil;
    rightBtn=nil;
    localBtn=nil;
    netBtn=nil;
    noHYK=nil;
    noDZQ=nil;
    [_headers release];
    [_items release];
    
    [_font release];
    [_tableView release];
    [group release];
    [leftBtn release];
    [rightBtn release];
    [localBtn release];
    
    [netBtn release];
    [noHYK release];
    [noDZQ release];
    
}


- (void)dealloc {
    [_headers release];
    [_items release];
    
    [_font release];
    [_tableView release];
    [group release];
    [leftBtn release];
    [rightBtn release];
    [localBtn release];
    
    [netBtn release];
    [noHYK release];
    [noDZQ release];
    
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



- (void)goBack{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
   
  //设置导航图片    
    _items = [[NSMutableArray alloc] initWithCapacity:0];

    UIImage *image = [[UIImage imageNamed:@"fjtitle.png"] toSize: CGSizeMake(320, 44)];
    Class ios5Class = (NSClassFromString(@"CIImage"));
    if (nil != ios5Class) {
        [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    } else {
        self.navigationController.navigationBar.layer.contents = (id)[UIImage imageNamed:@"fjtitle.png"].CGImage;
    }
    //设置背景颜色
    [self.navigationController.navigationBar setBackgroundColor:[UIColor whiteColor]];
  
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
    
    [noDZQ setHidden:YES];
    [noHYK setHidden:YES];
    
     [iOSApi showAlert:@"正在加载信息..."];
    if ([_items count] == 0) {
        // 预加载项
        
        _page = 1;
        _pageDZQ = 1;
        if(_isHYK)
        {
        NSMutableArray *result = [[DataBaseOperate shareData] loadMember:_page];
        if(result.count<1||result==nil)
        {
            [noHYK setHidden:NO];
        }
        else {
          [_items addObjectsFromArray:result];   
        }
       
        //[result release];
        }
        else {
            NSMutableArray *result = [[DataBaseOperate shareData] loadCard:_pageDZQ];
            
            if(result.count<1||result==nil)
            {
                [noDZQ setHidden:NO];
            }
            else {
                [_items addObjectsFromArray:result];   
            }

            
            [_items addObjectsFromArray:result];

        }
        
    }
    //[iOSApi showCompleted:@"加载完毕"];
    [iOSApi closeAlert];
    _isnotFirst=YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //
}


-(void)gotoDZQ:(id)sender
{
    [noDZQ setHidden:YES];
    [noHYK setHidden:YES];
    if(_isDZQ)
    {
        
    }
    else
    {
    _isHYK=NO;
    _isDZQ=YES;

   // NSLog(@"电子券");
    UIImage *image = [UIImage imageNamed:@"footerh_03.png"];
    [leftBtn setBackgroundImage:image forState:0];
    //[image release];
    
    UIImage *imager = [UIImage imageNamed:@"footerh_02.png"];
    [rightBtn setBackgroundImage:imager forState:0];
    //[imager release];
    
       
    [iOSApi showAlert:@"正在加载信息..."];
    [_items removeAllObjects];
       
     //加载本地电子券
        
        _pageDZQ = 1;
        
        NSMutableArray *result = [[DataBaseOperate shareData] loadCard:_pageDZQ];
        if(result.count<1||result==nil)
        {
            [noDZQ setHidden:NO];
        }
        else {
            [_items addObjectsFromArray:result];   
        }
        //[result release];
        
        [self.tableView reloadData];   
    
    [iOSApi closeAlert];

    }
}

-(void)gotoHYK:(id)sender
{
    [noDZQ setHidden:YES];
    [noHYK setHidden:YES];
    if(_isHYK)
    {
        
    }
    else
    {
    _isHYK=YES;
    _isDZQ=NO;
    //NSLog(@"会员卡");
    UIImage *image = [UIImage imageNamed:@"footerh_01.png"];
    [leftBtn setBackgroundImage:image forState:0];
    //[image release];
    
    UIImage *imager = [UIImage imageNamed:@"footerh_03.png"];
    [rightBtn setBackgroundImage:imager forState:0];
    //[imager release];
   
    [iOSApi showAlert:@"正在加载信息..."];
     [_items removeAllObjects];
    //加载本地会员卡数据
        _page = 1;
        
        NSMutableArray *result = [[DataBaseOperate shareData] loadMember:_page];
        if(result.count<1||result==nil)
        {
            [noHYK setHidden:NO];
        }
        else {
            [_items addObjectsFromArray:result];   
        }

        [self.tableView reloadData];
   
    
    [iOSApi closeAlert];

    }
    
}

-(void)gotoNet:(id)sender
{
    /*
    if(_isNet)
    {
    }
    else
    {
    _isLocal=NO;
    _isNet=YES;
    UIImage *image = [UIImage imageNamed:@"footerh_01.png"];
    [netBtn setBackgroundImage:image forState:0];
    //[image release];
    
    UIImage *imager = [UIImage imageNamed:@"footerh_03.png"];
    [localBtn setBackgroundImage:imager forState:0];
    //[imager release];
    [iOSApi showAlert:@"正在加载信息..."];
    [_items removeAllObjects];
    if(_isHYK)
    {
        
        NSArray *list = [[Api efile_hyk:1] retain];
        [_items addObjectsFromArray:list];
        [list release];
        [self.tableView reloadData];
    }
    else
    {
        NSArray *list = [[Api efile_dzq:1] retain];
        [_items addObjectsFromArray:list];
        [list release];
        [self.tableView reloadData];
        
    }
    
    [iOSApi closeAlert];
    }  
     */
}

-(void)gotoLocal:(id)sender
{
    /*
    if(_isLocal)
    {
        
    }
    else
    {
    _isLocal=YES;
    _isNet=NO;
  
    UIImage *image = [UIImage imageNamed:@"footerh_03.png"];
    [netBtn setBackgroundImage:image forState:0];
    //[image release];
    
    UIImage *imager = [UIImage imageNamed:@"footerh_01.png"];
    [localBtn setBackgroundImage:imager forState:0];
    //[imager release];
    }
     */
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
    
    //lable标题
    
    if(_isHYK)
    {
    EFileMember *obj = [_items objectAtIndex:pos];
    cell.textLabel.text = [iOSApi urlDecode:[obj name]];
    }
    else
    {
    EFileCard *obj = [_items objectAtIndex:pos];
    cell.textLabel.text = [iOSApi urlDecode:[obj name]];   
    }
    
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"module goto...");
    
    int pos = indexPath.row;
   //跳转页面
    
    if(_isHYK)
    {
        EFileMember *obj = [_items objectAtIndex:pos];
        EFileHYK *nextView = [[EFileHYK alloc] init];
        nextView.param = obj;
        [self.navigationController pushViewController:nextView animated:YES];
        [nextView release];
       
    }
    else
    {
        EFileCard *obj = [_items objectAtIndex:pos];
        EFileDZQ *nextView = [[EFileDZQ alloc] init];
        nextView.param = obj;
        [self.navigationController pushViewController:nextView animated:YES];
        [nextView release];

          
    }
    
    
    
     
}

#pragma mark -
#pragma mark UISearchBar



// 界面下方列表切换
- (void)doSwitch:(int)index{
    //
}

// 分类
- (IBAction)doGroup:(id)sender{
    //
}

// 选择
- (IBAction)segmentAction:(UISegmentedControl *)segment{
    NSInteger Index = segment.selectedSegmentIndex;
    NSLog(@"Seg.selectedSegmentIndex:%d", Index);
}

@end
