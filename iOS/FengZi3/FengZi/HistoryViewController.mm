//
//  HistoryViewController.m
//  FengZi
//
//  Created by lt ji on 11-12-12.
//  Copyright (c) 2011年 iTotemStudio. All rights reserved.
//

#import "HistoryViewController.h"
#import "Api+Database.h"
#import "Api+Category.h"
#import "DecodeCardViewControlle.h"
#import "BusDecoder.h"
#import "BusCategory.h"
#import "DecodeBusinessViewController.h"
#import <ZXing/QRCodeReader.h>
#import <ZXing/TwoDDecoderResult.h>
#import "FileUtil.h"
#import <QuartzCore/QuartzCore.h>

#import "UCRichMedia.h"
#import "UCUpdateNikename.h"

@implementation HistoryViewController

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
    NSArray *result;
    if (_isSearch) {
        result = [[DataBaseOperate shareData] searchHistory:_startIndex withKey:_key withType:_isEncodeModel];
    }else{
        result = [[DataBaseOperate shareData] loadHistory:_startIndex withType:_isEncodeModel];
    }
    [_historyArray addObjectsFromArray:result];
    _editbtn.hidden=[_historyArray count]<=0 && !_tableView.editing;
    if (_editbtn.hidden) {
        [_scrollvier bringSubviewToFront: _noResultView];
    }else{
        [_scrollvier sendSubviewToBack: _noResultView];
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
    NSTimeInterval animationDuration = 0.3;
    [UIView beginAnimations:@"pull" context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    if (_tableView.editing) {
        [_editbtn setImage:[UIImage imageNamed:@"done_over_btn.png"] forState:UIControlStateNormal];
        [_editbtn setImage:[UIImage imageNamed:@"done_over_btn_tap.png"] forState:UIControlStateHighlighted];
        _tableView.frame = CGRectMake(0, 0, 320, 459);
        _scrollvier.contentOffset = CGPointMake(0, 0);
    }else {
        [_editbtn setImage:[UIImage imageNamed:@"edit_btn.png"] forState:UIControlStateNormal];
        [_editbtn setImage:[UIImage imageNamed:@"edit_btn_tap.png"] forState:UIControlStateHighlighted];
        _tableView.frame = CGRectMake(0, 84, 320, 339);
    }
    [UIView commitAnimations];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    HistoryObject *object = [_historyArray objectAtIndex:indexPath.row];
    [[DataBaseOperate shareData] deleteHistory:object.uuid];
    if (_isEncodeModel) {
        [FileUtil deleteFile:[FileUtil filePathInEncode:object.image]];
    } else {
        [FileUtil deleteFile:[FileUtil filePathInScan:object.image]];
    }
    [_historyArray removeObjectAtIndex:indexPath.row];
    [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    if ([_historyArray count]<=0 && _tableView.editing) {
        _editbtn.hidden=YES;
        [_editbtn setImage:[UIImage imageNamed:@"edit_btn.png"] forState:UIControlStateNormal];
        [_editbtn setImage:[UIImage imageNamed:@"edit_btn_tap.png"] forState:UIControlStateHighlighted];
        [_tableView setEditing:NO animated:YES];
        _tableView.frame = CGRectMake(0, 128, 320, 339);
        [_scrollvier bringSubviewToFront: _noResultView];
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
    return [_historyArray count];;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *MyIdentifier = @"MyIdentifierHis";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:MyIdentifier] autorelease];  
    }    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    HistoryObject *object = [_historyArray objectAtIndex:indexPath.row];
    cell.textLabel.text = object.content;
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.imageView.image = [DATA_ENV getTableImage:object.type];
    cell.detailTextLabel.text = object.date;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HistoryObject *object = [_historyArray objectAtIndex:indexPath.row];
    NSString *path;
    if (_isEncodeModel) {
        path = [FileUtil filePathInEncode:object.image];
    } else {
        path = [FileUtil filePathInScan:object.image];
    }
    [self decoderWithImage:[UIImage imageWithContentsOfFile:path]];
}

//search Button clicked....  
// called when keyboard search button pressed
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar  
{  
    [searchBar resignFirstResponder];
    if ([searchBar.text isEqualToString:@""]) {
        return;
    }
    _isSearch=YES;
    _key = searchBar.text;
    _startIndex = 0;
    [_historyArray removeAllObjects];
    [self reloadTableData];
}  

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    return YES;
}
- (IBAction)CancelSearchClicked:(id)sender {
    [_searchBar resignFirstResponder]; 
    if (_isSearch) {
        _isSearch= NO;
        [self reloadTableData];
        _searchBar.text = @"";
    }
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImage *image = [UIImage imageNamed:@"navigation_bg.png"];
    Class ios5Class = (NSClassFromString(@"CIImage"));
    if (nil != ios5Class) {
        [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    } else {
        self.navigationController.navigationBar.layer.contents = (id)[UIImage imageNamed:@"navigation_bg.png"].CGImage;
    }
    
    _historyArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    _refreshFooterView = [[RefreshTableFooterView alloc] init];
    _refreshFooterView.delegate = self;
    [_tableView addSubview:_refreshFooterView];
    
    _scanHistoryBtn.selected=YES;
    
    //修改搜索框背景
    _searchBar.backgroundColor=[UIColor clearColor];
    //去掉搜索框背景
    for (UIView *subview in _searchBar.subviews) 
    {
        if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")])
        {
            [subview removeFromSuperview];
            break;
        }
    }
    
    CGSize  size = _scrollvier.size;
    size.height+=44;
    _scrollvier.contentSize =  size;
    _scrollvier.contentOffset = CGPointMake(0, 44);
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (!_isSearch) {
        _startIndex = 0;
        [_historyArray removeAllObjects];
        [self reloadTableData];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (IBAction)selectScanHistory:(id)sender {
    _reloading = NO;
    CGRect rect =  _encodeHistoryBtn.frame;
    rect.size.height-=1;
    _encodeHistoryBtn.frame=rect;
    rect =  _scanHistoryBtn.frame;
    rect.size.height+=1;
    _scanHistoryBtn.frame=rect;
    _scanHistoryBtn.userInteractionEnabled=NO;
    _encodeHistoryBtn.userInteractionEnabled=YES;
    _isSearch=NO;
    _searchBar.text = @"";
    _isEncodeModel = NO;
    _titlelabel.text= @"扫码记录";
    _scanHistoryBtn.selected=YES;
    _encodeHistoryBtn.selected=NO;
    _startIndex = 0;
    [_historyArray removeAllObjects];
    [self reloadTableData];
}
- (IBAction)selectEncodeHistory:(id)sender {
    _reloading = NO;
    CGRect rect =  _encodeHistoryBtn.frame;
    rect.size.height+=1;
    _encodeHistoryBtn.frame=rect;
    rect =  _scanHistoryBtn.frame;
    rect.size.height-=1;
    _scanHistoryBtn.frame=rect;
    _encodeHistoryBtn.userInteractionEnabled=NO;
    _scanHistoryBtn.userInteractionEnabled=YES;
    _isSearch=NO;
    _searchBar.text = @"";
    _isEncodeModel = YES;
    _titlelabel.text= @"生码记录";
    _scanHistoryBtn.selected=NO;
    _encodeHistoryBtn.selected=YES;
    _startIndex = 0;
    [_historyArray removeAllObjects];
    [self reloadTableData];
}

- (void)viewDidUnload
{
    [_searchBar release];
    _searchBar = nil;
    [_scanHistoryBtn release];
    _scanHistoryBtn = nil;
    [_encodeHistoryBtn release];
    _encodeHistoryBtn = nil;
    [_tableView release];
    _tableView = nil;
    [_noResultView release];
    _noResultView = nil;
    [_scrollvier release];
    _scrollvier = nil;
    [_toolBar release];
    _toolBar = nil;
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
    [_historyArray release];
    [_titlelabel release];
    [_searchBar release];
    [_scanHistoryBtn release];
    [_encodeHistoryBtn release];
    [_tableView release];
    [_noResultView release];
    [_scrollvier release];
    [_toolBar release];
    [super dealloc];
}
@end
