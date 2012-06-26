//
//  EncodeMapViewController.m
//  FengZi
//

//  Copyright (c) 2011年 iTotemStudio. All rights reserved.
//

#import "EncodeMapViewController.h"
#import "EncodeEditViewController.h"
#import "Api+Category.h"

#define ARC4RANDOM_MAX      0x100000000
#define ZoomLevel @"12"

@implementation DisplayMap
@synthesize coordinate,title,subtitle;
-(void)dealloc{
    [title release];
    [super dealloc];
}
@end

@implementation EncodeMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        isLocation = NO;   
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)generateCode{
    GMap *map=[[[GMap alloc] init]autorelease];
    float lat = _mapView.centerCoordinate.latitude;
    float lon = _mapView.centerCoordinate.longitude;
    map.url = [NSString stringWithFormat:@"http://ditu.google.cn/maps?ll=%f,%f&z=%@",lat,lon,ZoomLevel];
    EncodeEditViewController *editView =[[EncodeEditViewController alloc] initWithNibName:@"EncodeEditViewController" bundle:nil];
    if (![Api kma]) {
        [self.navigationController pushViewController:editView animated:YES];
        [editView loadObject:map];
    } else {
        [editView viewDidLoad];
        [editView loadObject:map];
        NSString *ss = editView.content;
        [Api uploadKma:ss];
        //[editView tapOnSaveBtn:nil];
    }
    [editView release];
}
- (IBAction)locationMap:(id)sender {
    isLocation = YES;
    [_mapView removeAnnotations:_mapView.annotations];
    _mapView.showsUserLocation=YES;
    _searchBar.hidden=YES;
    _searchBtn.selected= NO;
    _locationBtn.selected=YES;
    if (_locationManager == nil) {
        _locationManager = [[CLLocationManager alloc] init];//创建位置管理器
        _locationManager.delegate=self;//设置代理
        _locationManager.desiredAccuracy=kCLLocationAccuracyBest;//指定需要的精度级别
        _locationManager.distanceFilter=1000.0f;//设置距离筛选器
    }
    [_locationManager startUpdatingLocation];//启动位置管理器
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320,44)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = UITextAlignmentCenter;
    label.font = [UIFont fontWithName:@"黑体" size:60];
    label.textColor = [UIColor blackColor];
    label.text= @"地图生码";
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
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 60, 32);
    if ([Api kma]) {
        [btn setImage:[UIImage imageNamed:@"uc-save.png"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"uc-save.png"] forState:UIControlStateHighlighted];
    } else {
        [btn setImage:[UIImage imageNamed:@"generate_code.png"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"generate_code_tap.png"] forState:UIControlStateHighlighted];
    }
    [btn addTarget:self action:@selector(generateCode) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = item;
    [item release];    
    
    _locationBtn.selected=YES;
    _searchBar.hidden = YES;
    _mapView.showsUserLocation=YES;
    _searchBar.hidden=YES;
    _searchBtn.selected= NO;
    _locationBtn.selected=YES;
    if (_locationManager == nil) {
        _locationManager = [[CLLocationManager alloc] init];//创建位置管理器
        _locationManager.delegate=self;//设置代理
        _locationManager.desiredAccuracy=kCLLocationAccuracyBest;//指定需要的精度级别
        _locationManager.distanceFilter=1000.0f;//设置距离筛选器
    }
    [_locationManager startUpdatingLocation];//启动位置管理器
}

- (MKAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:(id <MKAnnotation>)annotation
{
    //判断是不是当前位置
    if ([annotation isKindOfClass:[MKUserLocation class]])
    {
        //[self.navigationItem.rightBarButtonItem setEnabled:YES];//导航栏右边回到当前位置的按钮可用
        return nil;
    }
    
    
    
    static NSString* AnnotationIdentifier = @"AnnotationIdentifier";
    MKPinAnnotationView* customPinView = (MKPinAnnotationView *)[_mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationIdentifier];
    
    if (!customPinView) {
        customPinView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationIdentifier] autorelease];
        
        customPinView.pinColor = MKPinAnnotationColorRed;//设置大头针的颜色
        customPinView.animatesDrop = YES;
        customPinView.canShowCallout = YES;
        customPinView.draggable = YES;//可以拖动
        
        //添加tips上的按钮
        /*
         UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
         [rightButton addTarget:self action:@selector(showDetails:) forControlEvents:UIControlEventTouchUpInside];
         customPinView.rightCalloutAccessoryView = rightButton;
         */
    }else{
        customPinView.annotation = annotation;
    }
    return customPinView;
}



- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    //判断用户当前位置是否可见（只读属性）：
    //得到用户位置坐标：当userLocationVisible为YES时
    //得到无线网的坐标//五道口华联坐标--用户坐标,(39.990410,116.332237)
    CLLocationCoordinate2D userLocation =[[_locationManager location] coordinate]; 
    float lat = userLocation.latitude;
    float lng = userLocation.longitude;
    NSLog(@"%@,(%f,%f)",@"用户坐标",lat,lng);
    //得到gps的坐标
    CLLocationCoordinate2D coords = _mapView.userLocation.location.coordinate;
    float lat1 = coords.latitude;
    float lng1 = coords.longitude;
    NSLog(@"%@,(%f,%f)",@"用户坐标",lat1,lng1);
    
    
    
    //地图的范围 越小越精确
    MKCoordinateSpan theSpan;
    theSpan.latitudeDelta=0.01;
    theSpan.longitudeDelta=0.01;
    MKCoordinateRegion theRegion ;
    //判断是否开启gps
    if(lat1==0.000000)
    {
        theRegion.center = newLocation.coordinate;
        
    }
    else {
        theRegion.center=coords;   
    }
    theRegion.span=theSpan;
    
    MKCoordinateRegion adjustedRegion = [_mapView regionThatFits:theRegion]; 
    //以上代码创建出来一个符合MapView横纵比例的区域
    [_mapView setRegion:adjustedRegion animated:YES];
    
    
    
    RELEASE_SAFELY(_geoCoder);
    if(lat1==0.000000)
    {
        _geoCoder= [[MKReverseGeocoder alloc] initWithCoordinate:newLocation.coordinate];
    }
    else {
        
        _geoCoder= [[MKReverseGeocoder alloc] initWithCoordinate:coords]; 
        
    }
    _geoCoder.delegate = self;
    [_geoCoder start];
    
    [_locationManager stopUpdatingLocation];
    
    
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Error: %@", [error description]);
    [_locationManager stopUpdatingLocation];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"定位失败，请检查设备是否开启定位服务！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alertView show];
    RELEASE_SAFELY(alertView);
}

#pragma mark -
- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark{
    
    
    _locationName = [NSString stringWithFormat:@"%@ %@",placemark.subLocality,placemark.thoroughfare];
    if(!isLocation)
    {
        _mapView.userLocation.title=_locationName;
    }
    else {
        DisplayMap *ann = [[[DisplayMap alloc] init] autorelease];
        ann.title = _locationName;
        ann.coordinate = _mapView.centerCoordinate;
        [_mapView addAnnotation:ann];   
    }
    
    [_geoCoder cancel];
}
- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error{
    //NSLog(@"Error: %@", [error description]);
    [_geoCoder cancel];
}


- (IBAction)searchMap:(id)sender {
    [_mapView removeAnnotations:_mapView.annotations];
    _searchBtn.selected= YES;
    _locationBtn.selected=NO;
    _searchBar.hidden=NO;
}

#pragma uisearchbardelegate
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    if ([searchBar.text isEqualToString:@""]) {
        return;
    }
    [_mapView removeAnnotations:_mapView.annotations];
    [SearchMapDataRequest requestWithDelegate:self withParameters:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@", searchBar.text],@"address",nil] withIndicatorView:_mapView];
    [searchBar resignFirstResponder];
}

-(void)requestDidFinishLoad:(ITTBaseDataRequest *)request{
    if ([[request.resultDic objectForKey:@"status"] isEqualToString:@"OK"]) {
        if (_searchResult) {
            RELEASE_SAFELY(_searchResult);
        }
        _searchResult = [[request.resultDic objectForKey:@"results"] retain];
        for (int i = 0; i<[_searchResult count]; i++) {
            NSDictionary *result1 = [_searchResult objectAtIndex:i];
            NSDictionary *geometry = [result1 objectForKey:@"geometry"];
            NSDictionary *location = [geometry objectForKey:@"location"];
            CLLocationCoordinate2D loca2D = CLLocationCoordinate2DMake([[location objectForKey:@"lat"] doubleValue], [[location objectForKey:@"lng"] doubleValue]);
            if (i==0) {
                _locationName = [result1 objectForKey:@"formatted_address"];
                MKCoordinateSpan theSpan;
                //地图的范围 越小越精确
                theSpan.latitudeDelta=0.05;
                theSpan.longitudeDelta=0.05;
                MKCoordinateRegion theRegion;
                theRegion.center= loca2D;
                theRegion.span=theSpan;
                [_mapView setRegion:theRegion];
            }
            DisplayMap *ann = [[[DisplayMap alloc] init] autorelease];
            ann.title = [result1 objectForKey:@"formatted_address"];
            ann.coordinate = loca2D;
            [_mapView addAnnotation:ann];
        }
    }
}

-(void)request:(ITTBaseDataRequest *)request didFailLoadWithError:(NSError *)error{
    
}
- (void)viewDidUnload
{
    [_mapView release];
    _mapView = nil;
    [_searchBar release];
    _searchBar = nil;
    [_locationBtn release];
    _locationBtn = nil;
    [_searchBtn release];
    _searchBtn = nil;
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
    [_geoCoder release];
    [_searchResult release];
    [_locationManager release];
    [_mapView release];
    [_searchBar release];
    [_locationBtn release];
    [_searchBtn release];
    [super dealloc];
}
@end