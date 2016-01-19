//
//  HHFieldsMapViewController.h
//  hahaxueche
//
//  Created by Zixiao Wang on 1/17/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
#import "HHButton.h"
#import "UIColor+HHColor.h"

@interface HHFieldsMapViewController : UIViewController <MAMapViewDelegate>

@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) UIView *explanationView;
@property (nonatomic, strong) UILabel *explanationLabel;
@property (nonatomic, strong) HHButton *bottomButton;

@property (nonatomic, strong) CLLocation *userLocation;

- (instancetype)initWithUserLocation:(CLLocation *)userLocation;

@end
