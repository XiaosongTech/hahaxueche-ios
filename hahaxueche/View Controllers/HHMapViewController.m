//
//  HHMapViewController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 7/23/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import "HHMapViewController.h"
#import "HHAutoLayoutUtility.h"
#import "UIColor+HHColor.h"
#import <MapKit/MapKit.h>
#import <MapKit/MKAnnotation.h>

#define kFloatButtonHeight 30.0f

@interface HHMapViewController ()<MKMapViewDelegate, CLLocationManagerDelegate>

@property (nonatomic, strong) UIView *topBarView;
@property (nonatomic, strong) UIButton *doneButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *floatButton;
@property (nonatomic, strong) MKMapView *mapView;
@property(nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation HHMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapView = [[MKMapView alloc] initWithFrame:CGRectZero];
    self.mapView.translatesAutoresizingMaskIntoConstraints = NO;
    self.mapView.delegate = self;
    [self.mapView setShowsUserLocation:YES];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) { // iOS8+
        // Sending a message to avoid compile time error
        [[UIApplication sharedApplication] sendAction:@selector(requestWhenInUseAuthorization)
                                                   to:self.locationManager
                                                 from:self
                                             forEvent:nil];
    }
    [self.locationManager startUpdatingLocation];
    [self.view addSubview:self.mapView];
    
    
    self.topBarView = [[UIView alloc] initWithFrame:CGRectZero];
    self.topBarView.translatesAutoresizingMaskIntoConstraints = NO;
    self.topBarView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"trasparent_view"]];
    [self.mapView addSubview:self.topBarView];
    
    self.doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.doneButton setBackgroundColor:[UIColor clearColor]];
    [self.doneButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.doneButton.titleLabel.font = [UIFont fontWithName:@"SourceHanSansSC-Medium" size:14.0f];
    [self.doneButton setTitle:@"完成" forState:UIControlStateNormal];
    self.doneButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.doneButton addTarget:self action:@selector(doneButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.topBarView addSubview:self.doneButton];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.titleLabel.text = @"选择训练场";
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.font = [UIFont fontWithName:@"SourceHanSansSC-Medium" size:16.0f];
    [self.topBarView addSubview:self.titleLabel];
    
    
    
    self.floatButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.floatButton setTitle:@"全选" forState:UIControlStateNormal];
    [self.floatButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.floatButton.titleLabel.font = [UIFont fontWithName:@"SourceHanSansSC-Medium" size:15];
    self.floatButton.backgroundColor = [UIColor HHOrange];
    self.floatButton.clipsToBounds = YES;
    self.floatButton.layer.cornerRadius = kFloatButtonHeight/2;
    self.floatButton.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    self.floatButton.layer.shadowOpacity = 0.8;
    self.floatButton.layer.shadowRadius = 1.0f;
    self.floatButton.layer.shadowOffset = CGSizeMake(1.0, 1.0f);
    self.floatButton.layer.masksToBounds = NO;
    [self.floatButton setTitleColor:[UIColor HHLightGrayBackgroundColor] forState:UIControlStateHighlighted];
    self.floatButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.mapView addSubview:self.floatButton];

    [self autolayoutSubviews];
}

- (void)autolayoutSubviews {
    NSArray *constraints = @[
                             [HHAutoLayoutUtility verticalAlignToSuperViewTop:self.mapView constant:0],
                             [HHAutoLayoutUtility horizontalAlignToSuperViewLeft:self.mapView constant:0],
                             [HHAutoLayoutUtility setViewWidth:self.mapView multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility setViewHeight:self.mapView multiplier:1.0f constant:0],
                             
                             [HHAutoLayoutUtility verticalAlignToSuperViewTop:self.topBarView constant:0],
                             [HHAutoLayoutUtility horizontalAlignToSuperViewLeft:self.topBarView constant:0],
                             [HHAutoLayoutUtility setViewWidth:self.topBarView multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility setViewHeight:self.topBarView multiplier:0 constant:64.0f],
                             
                             [HHAutoLayoutUtility setCenterY:self.doneButton multiplier:1.0f constant:12.0f],
                             [HHAutoLayoutUtility horizontalAlignToSuperViewRight:self.doneButton constant:-8.0f],
                             
                             [HHAutoLayoutUtility setCenterX:self.titleLabel multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility setCenterY:self.titleLabel multiplier:1.0f constant:12.0f],
                             
                             [HHAutoLayoutUtility setCenterX:self.floatButton multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility verticalAlignToSuperViewBottom:self.floatButton constant:-20.0f],
                             [HHAutoLayoutUtility setViewHeight:self.floatButton multiplier:0 constant:kFloatButtonHeight],
                             [HHAutoLayoutUtility setViewWidth:self.floatButton multiplier:0 constant:120.0f],

                             
                             
                             ];
    [self.view addConstraints:constraints];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.mapView.userLocation.coordinate, 800, 800);
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
    
}

- (void)doneButtonPressed {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {

}

@end
