//
//  HHMapViewController.h
//  hahaxueche
//
//  Created by Zixiao Wang on 16/05/2017.
//  Copyright © 2017 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "HHField.h"
#import "HHDrivingSchool.h"


@interface HHMapViewController : UIViewController <MKMapViewDelegate>

@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) CLLocation *userLocation;

- (instancetype)initWithSelectedSchool:(HHDrivingSchool *)school selectedZone:(NSString *)selectedZone;


@end
