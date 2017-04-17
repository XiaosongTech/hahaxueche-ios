//
//  HHFieldsMapViewController.h
//  hahaxueche
//
//  Created by Zixiao Wang on 1/17/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "HHButton.h"
#import "UIColor+HHColor.h"
#import "HHField.h"



@interface HHFieldsMapViewController : UIViewController <MKMapViewDelegate>

@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) CLLocation *userLocation;

- (instancetype)initWithFields:(NSArray *)fields selectedField:(HHField *)selectedField;

@end
