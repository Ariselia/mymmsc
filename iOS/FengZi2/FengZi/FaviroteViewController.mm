//
//  FaviroteViewController.m
//  FengZi
//
//  Created by lt ji on 11-12-12.
//  Copyright (c) 2011年 iTotemStudio. All rights reserved.
//

#import "FaviroteViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "Api+Database.h"
#import "DecodeCardViewControlle.h"
#import "BusDecoder.h"
#import "BusCategory.h"
#import "DecodeBusinessViewController.h"
#import <ZXing/QRCodeReader.h>
#import <ZXing/TwoDDecoderResult.h>
#import "FileUtil.h"
#import "UCCell.h"
#import "UITableViewCellExt.h"
#import "UCRichMedia.h"
@implementation FaviroteViewController

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

/*
-(void) chooseShowController:(NSString*)input{
    BusCategory *category = [BusDecoder classify:input];
    if ([category.type isEqualToString:CATEGORY_CARD]) {
        DecodeCardViewControlle *cardView = [[DecodeCardViewControlle alloc] initWithNibName:@"DecodeCardViewControlle" category:category result:input withImage:_curImage withType:HistoryTypeNone withSaveImage:_curImage];
        [self.navigationController pushViewController:cardView animated:YES];
        [cardView release];
    } else if([category.type isEqualToString:CATEGORY_MEDIA]) {
        // 富媒体业务
        UCRichMedia *nextView = [[UCRichMedia alloc] init];
        nextView.urlMedia = input;
        [self.navigationController pushViewController:nextView animated:YES];
        [nextView release];
    } else if([category.type isEqualToString:CATEGORY_KMA]) {
        // 空码
    } else{
        DecodeBusinessViewController *businessView = [[DecodeBusinessViewController alloc] initWithNibName:@"DecodeBusinessViewController" category:category result:input image:_curImage withType:HistoryTypeNone withSaveImage:_curImage];
        [self.navigationController pushViewController:businessView animated:YES];
        [businessView release];
    }
}
*/

-(void)decoderWithImage:(UIImage*)image{
    Decoder *decoder = [[Decoder alloc] init];
    QRCodeReader* qrcodeReader = [[QRCodeReader alloc] init];
    NSSet *readers = [[NSSet alloc ] initWithObjects:qrcodeReader,nil];
    decoder.readers = readers;
    decoder.delegate = self;
    _curImage = image;
    [decoder decodeImage:image];
    [readers release];
    [qrcodeReader release];
    [decoder release];
}

- (void)decoder:(Decoder *)decoder didDecodeImage:(UIImage *)image usingSubset:(UIImage *)subset withResult:(TwoDDecoderResult *)twoDResult {
    [self chooseShowController:twoDResult.text];
    decoder.delegate = nil;
}

-(void)decoder:(Decoder *)decoder failedToDecodeImage:(UIImage *)image usingSubset:(UIImage *)subset reason:(NSString *)reason{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:DECODE_FAIL delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alertView show];
    RELEASE_SAFELY(alertView);
    return;
}

-(void)reloadTableData{
    NSArray *result = [[DataBaseOperate shareData] loadFavirote:_startIndex];
    [_favArray addObjectsFromArray:result];
    _editbtn.hidden=[_favArray count]<=0;
    if (_editbtn.hidden) {
        [self.view bringSubviewToFront: _noResultView];
    }else{
        [self.view sendSubviewToBack: _noResultView];
    }
    _startIndex+= [result count];
    [_tableView reloadData];
    if ([result count]>=TABLE_PAGESIZE) {
        _refreshFooterView.frame = CGRectMake(0.0f, _tableView.contentSize.height, self.view.frame.size.width, 416);
    }else{
        _refreshFooterView.frame = CGRectMake(0.0f, -415, self.view.frame.size.width, 0);
    }
    if (_reloading) {
        [self performSelector:@selector(doneLoadingTableViewData)];
    }
}

- (IBAction)doEdit:(id)sender {
    [_tableView setEditing:!_tableView.editing animated:YES];
    if (!_tableView.editing) {
        [_editbtn setImage:[UIImage imageNamed:@"edit_btn.png"] forState:UIControlStateNormal];
        [_editbtn setImage:[UIImage imageNamed:@"edit_btn_tap.png"] forState:UIControlStateHighlighted];
    }else {
        [_editbtn setImage:[UIImage imageNamed:@"done_over_btn.png"] forState:UIControlStateNormal];
        [_editbtn setImage:[UIImage imageNamed:@"done_over_btn_tap.png"] forState:UIControlStateHighlighted];
    }
}

#pragma mark -
#pragma mark UITableViewDataSource
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    FaviroteObject *object = [_favArray objectAtIndex:indexPath.row];
    [[DataBaseOperate shareData] deleteFavirote:object.uuid];
    [FileUtil deleteFile:[FileUtil filePathInFavirote:object.image]];
    [_favArray removeObjectAtIndex:indexPath.row];
    [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    if ([_favArray count]<=0) {
        _editbtn.hidden=YES;
        [_editbtn setImage:[UIImage imageNamed:@"edit_btn.png"] forState:UIControlStateNormal];
        [_editbtn setImage:[UIImage imageNamed:@"edit_btn_tap.png"] forState:UIControlStateHighlighted];
        [_tableView setEditing:NO animated:YES];
        //[self.view bringSubviewToFront: _noResultView];
    }
 
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return UITableViewCellEditingStyleDelete;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  @"删除";
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
	return YES;
}


-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_favArray count];;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	//CGSize size = [@"123" sizeWithFont:fontInfo constrainedToSize:CGSizeMake(labelWidth, 20000) lineBreakMode:UILineBreakModeWordWrap];
	//return size.height + 10; // 10即消息上下的空间，可自由调整 
	return 60;
}


-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    tableView.backgroundColor = [UIColor clearColor];
    
    
    static NSString *CellIdentifier = @"Cell";
    
    UCCell *cell = [[UCCell alloc]init];
    if (cell == nil) {
        
        cell = [[[UCCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
        
    }
    UIImage *image = [[UIImage imageNamed:@"uc-cell.png"] toSize: CGSizeMake(320, 60)];
    //   UIImage *himage = [UIImage imageNamed:@"uc-cell-h.png"];
    [cell setBackgroundImage:image];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    FaviroteObject *object = [_favArray objectAtIndex:indexPath.row];
    cell.textLabel.text = object.content;
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.imageView.image = [DATA_ENV getTableImage:object.type];
    cell.detailTextLabel.text = object.date;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
    UIImage *himage = [[UIImage imageNamed:@"uc-cell-h.png"] toSize: CGSizeMake(320, 60)];     
    [cell setBackgroundImage:himage];
    
    FaviroteObject *object = [_favArray objectAtIndex:indexPath.row];
    [self decoderWithImage:[UIImage imageWithContentsOfFile:[FileUtil filePathInFavirote:object.image]]];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [_refreshFooterView footerRefreshScrollViewDidEndDragging:scrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_refreshFooterView footerRefreshScrollViewDidScroll:scrollView];
}

#pragma mark RefreshTableHeaderDelegate Methods
- (void)doneLoadingTableViewData{
	_reloading = NO;
	[_refreshFooterView footerRefreshScrollViewDataSourceDidFinishedLoading:_tableView];
}

- (void)reloadTableViewDataSource{
	_reloading = YES;
    [_refreshFooterView footerRefreshScrollViewDidScroll:_tableView];
    [self reloadTableData]; 
}

- (void)footerRefreshTableHeaderDidTriggerRefresh:(RefreshTableFooterView*)view{
	
	[self reloadTableViewDataSource];	
}

- (BOOL)footerRefreshTableHeaderDataSourceIsLoading:(RefreshTableFooterView*)view{
	
	return _reloading; // should return if data source model is reloading
}

#pragma mark - View lifecycle

- (IBAction)goBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    
    
     [super viewDidLoad];
    [_tableView setBackgroundColor:[UIColor clearColor]];
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
     UIImage *image = [UIImage imageNamed:@"navigation_bg.png"];
     Class ios5Class = (NSClassFromString(@"CIImage"));
     if (nil != ios5Class) {
     [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
     } else {
     self.navigationController.navigationBar.layer.contents = (id)[UIImage imageNamed:@"navigation_bg.png"].CGImage;
     }
     
    UIImage *goBackImage = [UIImage imageNamed:@"back_tap.png"];
    [_goBackBtn setImage:goBackImage forState:UIControlStateHighlighted];
    _favArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    _refreshFooterView = [[RefreshTableFooterView alloc] init];
    _refreshFooterView.delegate = self;
    [_tableView addSubview:_refreshFooterView];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [iOSApi showAlert:@"正在获取用户信息..."];
    [_favArray removeAllObjects];
    _startIndex = 0;
    [self reloadTableData];
    [iOSApi closeAlert];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
   
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidUnload
{
    [_tableView release];
    _tableView = nil;
    [_noResultView release];
    _noResultView = nil;
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
    [_editbtn release];
    [_refreshFooterView release];
    [_favArray release];
    [_tableView release];
    [_noResultView release];
    [super dealloc];
}
@end
