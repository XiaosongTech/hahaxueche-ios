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

@interface HHSingleFieldMapViewController () <MAMapViewDelegate>

@property (nonatomic, strong) HHField *field;
@property (nonatomic, strong) MAMapView *mapView;

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
         view.image = [UIImage imageNamed:@"ic_map_local_choseon"];
        [mapView selectAnnotation:view.annotation animated:YES];
    }
}


@end
