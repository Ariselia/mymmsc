//
//  EFileMap.m
//  FengZi
//
//  Created by a on 12-4-20.
//  Copyright (c) 2012年 ifengzi.cn. All rights reserved.
//

#import "EFileMap.h"

#import "EncodeMapViewController.h"
#import "EncodeEditViewController.h"
#import <FengZi/Api+Category.h>

#define ARC4RANDOM_MAX      0x100000000
#define ZoomLevel @"12"

@implementation DisplayMapX
@synthesize coordinate,title,subtitle;
-(void)dealloc{
    [title release];
    [super dealloc];
}
@end

@implementation EFileMap
@synthesize name;
@synthesize add;
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
- (void)goBack{
    [self dismissModalViewControllerAnimated:YES];
   }
/*
-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}
 */
-(void)generateCode{
    GMap *map=[[[GMap alloc] init]autorelease];
    float lat = _mapView.centerCoordinate.latitude;
    float lon = _mapView.centerCoordinate.longitude;
    map.url = [NSString stringWithFormat:@"http://ditu.google.cn/maps?ll=%f,%f&z=%@",lat,lon,ZoomLevel];
    EncodeEditViewController *editView =[[EncodeEditViewController alloc] initWithNibName:@"EncodeEditViewController" bundle:nil];
    /*
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
     */
    [editView release];
}
- (IBAction)locationMap:(id)sender {
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
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    UIImage *image = [UIImage imageNamed:@"navigation_bg.png"];
    Class ios5Class = (NSClassFromString(@"CIImage"));
    if (nil != ios5Class) {
        [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    } else {
        self.navigationController.navigationBar.layer.contents = (id)[UIImage imageNamed:@"navigation_bg.png"].CGImage;
    }
  
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320,44)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = UITextAlignmentCenter;
    label.font = [UIFont fontWithName:@"黑体" size:60];
    label.textColor = [UIColor blackColor];
    label.text= name;
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
  
   // [self locationMap:nil];
    
    [_mapView removeAnnotations:_mapView.annotations];
    [SearchMapDataRequest requestWithDelegate:self withParameters:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@", add],@"address",nil] withIndicatorView:_mapView];

    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (MKAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:(id <MKAnnotation>)annotation
{
    MKPinAnnotationView *pinView = nil;
    
    static NSString *defaultPinID = @"com.invasivecode.pin";
    pinView = (MKPinAnnotationView *)[_mapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
    if ( pinView == nil ) {
        pinView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:defaultPinID] autorelease];
    }
    pinView.pinColor = MKPinAnnotationColorRed;
    pinView.canShowCallout = YES;
    pinView.animatesDrop = YES;
    [_mapView.userLocation setTitle:_locationName];
    return pinView;
}



- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    MKCoordinateSpan theSpan;
    //地图的范围 越小越精确
    theSpan.latitudeDelta=0.05;
    theSpan.longitudeDelta=0.05;
    MKCoordinateRegion theRegion;
    theRegion.center=newLocation.coordinate;
    theRegion.span=theSpan;
    [_mapView setRegion:theRegion];
    RELEASE_SAFELY(_geoCoder);
    _geoCoder= [[MKReverseGeocoder alloc] initWithCoordinate:newLocation.coordinate]; 
    _geoCoder.delegate = self;
    [_geoCoder start];
    [_locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    /*
    NSLog(@"Error: %@", [error description]);
    [_locationManager stopUpdatingLocation];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"定位失败，请检查设备是否开启定位服务！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alertView show];
    RELEASE_SAFELY(alertView);
     */
}

#pragma mark -
- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark{
    _locationName = [NSString stringWithFormat:@"%@ %@",placemark.subLocality,placemark.thoroughfare];
    DisplayMap *ann = [[[DisplayMap alloc] init] autorelease];
    ann.title = _locationName;
    ann.coordinate = _mapView.centerCoordinate;
    [_mapView addAnnotation:ann];
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
