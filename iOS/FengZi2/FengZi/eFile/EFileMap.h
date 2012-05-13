//
//  EFileMap.h
//  FengZi
//
//  Created by a on 12-4-20.
//  Copyright (c) 2012年 ifengzi.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
// url http://ditu.google.cn/maps?ll=39.904214,116.40741300000002&z=12
#import "ITTDataRequest.h"
#import <MapKit/MKAnnotation.h>


@interface DisplayMapX : NSObject
<MKAnnotation>{
    CLLocationCoordinate2D coordinate;
    NSString *title;
    NSString *subtitle;
}
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@end

@interface EFileMap : UIViewController<MKMapViewDelegate,CLLocationManagerDelegate,DataRequestDelegate,MKReverseGeocoderDelegate>{
    IBOutlet MKMapView *_mapView;
    IBOutlet UISearchBar *_searchBar;
    IBOutlet UIButton *_locationBtn;
    IBOutlet UIButton *_searchBtn;
    CLLocationManager *_locationManager;
    MKReverseGeocoder *_geoCoder;
    NSString *_locationName;
    NSArray *_searchResult;
    NSString *name;
    NSString *add;
}
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *add;

@end
