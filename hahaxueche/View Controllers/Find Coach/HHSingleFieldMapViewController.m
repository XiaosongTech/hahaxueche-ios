//
//  HHSingleFieldMapViewController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 2/14/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHSingleFieldMapViewController.h"
#import "UIBarButtonItem+HHCustomButton.h"
#import "Masonry.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <MapKit/MapKit.h>
#import "INTULocationManager.h"
#import "HHLoadingViewUtility.h"
#import "HHToastManager.h"
#import "HHAskLocationPermissionViewController.h"

@interface HHSingleFieldMapViewController () <MAMapViewDelegate>

@property (nonatomic, strong) HHField *field;
@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) CLLocation *userLocation;

@end

@implementation HHSingleFieldMapViewController

- (void)dealloc {
    self.mapView.delegate = nil;
}

- (instancetype)initWithField:(HHField *)field {
    self = [super init];
    if (self) {
        self.field = field;
        self.mapView = [[MAMapView alloc] initWithFrame:CGRectZero];
        self.mapView.delegate = self;
        self.mapView.showsUserLocation = YES;
        [self.view addSubview:self.mapView];
        
        [self.mapView makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.view);
            make.width.equalTo(self.view.width);
            make.height.equalTo(self.view.height);
        }];

    }
    return self;
}

- (void)viewDidLoad {
    self.title = @"训练场地址";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem buttonItemWithImage:[UIImage imageNamed:@"ic_arrow_back"] action:@selector(dismissVC) target:self];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem buttonItemWithTitle:@"导航" titleColor:[UIColor whiteColor] action:@selector(routeInMapApp) target:self isLeft:NO];
    
    [[HHLoadingViewUtility sharedInstance] showLoadingView];
    [[INTULocationManager sharedInstance] requestLocationWithDesiredAccuracy:INTULocationAccuracyBlock timeout:2.0f delayUntilAuthorized:YES block:^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status) {
        [[HHLoadingViewUtility sharedInstance] dismissLoadingView];
        if (status == INTULocationStatusSuccess) {
            self.userLocation = currentLocation;
            
        } else if (status == INTULocationStatusTimedOut) {
            self.userLocation = currentLocation;
            
        } else if (status == INTULocationStatusError) {
            [[HHToastManager sharedManager] showErrorToastWithText:@"出错了，请重试"];
            self.userLocation = nil;
        } else {
            HHAskLocationPermissionViewController *vc = [[HHAskLocationPermissionViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            self.userLocation = nil;
            
        }
        
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
    pointAnnotation.coordinate = CLLocationCoordinate2DMake([self.field.latitude doubleValue], [self.field.longitude doubleValue]);
    pointAnnotation.title = self.field.name;
    pointAnnotation.subtitle = self.field.address;
    [self.mapView addAnnotation:pointAnnotation];
    
    MACoordinateRegion mapRegion;
    mapRegion.span.latitudeDelta = 0.08;
    mapRegion.span.longitudeDelta = 0.08;
    mapRegion.center = pointAnnotation.coordinate;
    [self.mapView setRegion:mapRegion animated: YES];
    [self.mapView setCenterCoordinate:pointAnnotation.coordinate animated:NO];
}

#pragma mark - Button Actions

- (void)dismissVC {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - MapView Delegate Methods
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation {
    if ([annotation isKindOfClass:[MAUserLocation class]]) {
        return nil;
    } else {
        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
        MAAnnotationView *annotationView = (MAAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (!annotationView) {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation
                                                          reuseIdentifier:reuseIndetifier];
        }
        
        annotationView.canShowCallout = YES;
        return annotationView;
        
    }
}

- (void)mapView:(MAMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    for (MAAnnotationView *view in views) {
        if ([view.annotation isKindOfClass:[MAUserLocation class]]) {
            continue;
        }
         view.image = [UIImage imageNamed:@"ic_map_local_choseon"];
        [mapView selectAnnotation:view.annotation animated:YES];
    }
}

- (void)routeInMapApp {
    if (!self.userLocation) {
        HHAskLocationPermissionViewController *vc = [[HHAskLocationPermissionViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"导航"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *aMapButton;
    UIAlertAction *baiduMapButton;
    NSString *urlStr = [NSString stringWithFormat:@"iosamap://"];
    if ([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:urlStr]]) {
        aMapButton = [UIAlertAction actionWithTitle:@"高德地图" style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * action) {
                                                            [self openAMap];
                                                        }];
        [alert addAction:aMapButton];

    }
    
    urlStr = [NSString stringWithFormat:@"baidumap://map/"];
    if ([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:urlStr]]) {
        baiduMapButton = [UIAlertAction actionWithTitle:@"百度地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self openInBaiduMap];
        }];
        [alert addAction:baiduMapButton];
    }
    
    UIAlertAction *appleMapButton = [UIAlertAction actionWithTitle:@"iPhone自带地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self openAppleMap];
    }];
    [alert addAction:appleMapButton];
    
    UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancelButton];
    
    
    [self presentViewController:alert animated:YES completion:nil];

}

- (void)openAMap {
    AMapRouteConfig *config = [AMapRouteConfig new];
    config.appScheme = @"hhxc://";
    config.appName = @"哈哈学车";
    config.startCoordinate = self.userLocation.coordinate;
    config.destinationCoordinate = CLLocationCoordinate2DMake([self.field.latitude doubleValue], [self.field.longitude doubleValue]);
    config.routeType = AMapRouteSearchTypeDriving;
    [AMapURLSearch openAMapRouteSearch:config];

}

- (void)openAppleMap {
    
    MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
    MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake([self.field.latitude doubleValue], [self.field.longitude doubleValue]) addressDictionary:nil]];
    
    [MKMapItem openMapsWithItems:@[currentLocation, toLocation]
                   launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,
                                   MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]}];
}

- (void)openInBaiduMap {
    NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name=目的地&mode=driving&coord_type=gcj02",[self.field.latitude floatValue], [self.field.longitude floatValue]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
}


@end
