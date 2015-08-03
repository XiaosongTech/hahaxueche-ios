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
#import "HHTrainingFieldService.h"
#import "HHPointAnnotation.h"

#define kFloatButtonHeight 30.0f
#define kNearestFieldCount 5

@interface HHMapViewController ()<MKMapViewDelegate, CLLocationManagerDelegate>

@property (nonatomic, strong) UIView *topBarView;
@property (nonatomic, strong) UIButton *doneButton;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *floatButton;
@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSMutableArray *fields;
@property (nonatomic, strong) NSMutableArray *selectedField;
@property (nonatomic, strong) NSMutableArray *nearestFields;
@property (nonatomic)         BOOL shouldCenterUserLocation;

@end

@implementation HHMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.shouldCenterUserLocation = YES;
    self.fields = [self sortFieldsByDistance:[[HHTrainingFieldService sharedInstance].supportedFields mutableCopy]];
    if ([HHTrainingFieldService sharedInstance].nearestFields.count == 0) {
        self.nearestFields = [NSMutableArray array];
        NSInteger count = MIN(kNearestFieldCount, self.fields.count);
        for (int i = 0; i < count; i++){
            [self.nearestFields addObject:self.fields[i]];
        }
        [HHTrainingFieldService sharedInstance].nearestFields = self.nearestFields;

    } else {
        self.nearestFields = [HHTrainingFieldService sharedInstance].nearestFields;
    }
    
    self.selectedField = [HHTrainingFieldService sharedInstance].selectedFields;
    
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
    
    
    for (int i = 0; i < self.fields.count; i++) {
        HHTrainingField *field = self.fields[i];
        HHPointAnnotation *point = [[HHPointAnnotation alloc] initWithTag:i];
        point.coordinate = CLLocationCoordinate2DMake([field.latitude doubleValue], [field.longitude doubleValue]);
        point.title = field.name;
        point.subtitle = field.address;
        [self.mapView addAnnotation:point];        
    }
    
    self.topBarView = [[UIView alloc] initWithFrame:CGRectZero];
    self.topBarView.translatesAutoresizingMaskIntoConstraints = NO;
    self.topBarView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"trasparent_view"]];
    [self.mapView addSubview:self.topBarView];
    
    self.doneButton = [self createTopButtonWithTitle:NSLocalizedString(@"完成",nil) action:@selector(doneButtonPressed)];
    self.cancelButton = [self createTopButtonWithTitle:NSLocalizedString(@"取消",nil) action:@selector(cancelButtonPressed)];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.titleLabel.text = NSLocalizedString(@"选择训练场", nil);
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.font = [UIFont fontWithName:@"SourceHanSansCN-Medium" size:16.0f];
    [self.topBarView addSubview:self.titleLabel];
    
    
    
    self.floatButton = [UIButton buttonWithType:UIButtonTypeCustom];
    if (self.selectedField.count == self.fields.count) {
        [self.floatButton setTitle:NSLocalizedString(@"周边训练场",nil) forState:UIControlStateNormal];
    } else {
        [self.floatButton setTitle:NSLocalizedString(@"全选",nil) forState:UIControlStateNormal];
    }
    
    [self.floatButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.floatButton.titleLabel.font = [UIFont fontWithName:@"SourceHanSansCN-Medium" size:15];
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
    [self.floatButton addTarget:self action:@selector(floatButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.mapView addSubview:self.floatButton];

    [self autolayoutSubviews];
}

- (NSMutableArray *)sortFieldsByDistance:(NSArray *)array {
    NSMutableArray *fieldArray = [NSMutableArray array];
    CLLocation *userLocation = [[CLLocation alloc]
                                initWithLatitude:self.mapView.userLocation.coordinate.latitude
                                longitude:self.mapView.userLocation.coordinate.longitude];
    for (int i = 0; i < array.count; i++) {
        
        HHTrainingField *field = array[i];
        CLLocation *fieldLocation = [[CLLocation alloc]
                                     initWithLatitude:[field.latitude doubleValue]
                                     longitude:[field.longitude doubleValue]];
        CLLocationDistance distance = [userLocation distanceFromLocation:fieldLocation];
        NSDictionary *dic = @{@"field":field, @"dis":[NSNumber numberWithDouble:distance]};
        [fieldArray addObject:dic];
    }
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"dis"  ascending:YES];
    NSMutableArray *dicArray = [NSMutableArray arrayWithArray:[fieldArray sortedArrayUsingDescriptors:[NSArray arrayWithObjects:descriptor,nil]]];
    NSMutableArray *finalArray = [NSMutableArray array];
    for (int i = 0; i < dicArray.count; i++) {
        HHTrainingField *field = dicArray[i];
        [finalArray addObject:field[@"field"]];
    }
    return finalArray;
}

- (UIButton *)createTopButtonWithTitle:(NSString *)title action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundColor:[UIColor clearColor]];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont fontWithName:@"SourceHanSansCN-Medium" size:14.0f];
    [button setTitle:title forState:UIControlStateNormal];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [self.topBarView addSubview:button];
    return button;
}

- (void)floatButtonPressed {
    [self selectOrDeselectAll];
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
                             
                             [HHAutoLayoutUtility setCenterY:self.cancelButton multiplier:1.0f constant:12.0f],
                             [HHAutoLayoutUtility horizontalAlignToSuperViewLeft:self.cancelButton constant:8.0f],
                             
                             [HHAutoLayoutUtility setCenterX:self.titleLabel multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility setCenterY:self.titleLabel multiplier:1.0f constant:12.0f],
                             
                             [HHAutoLayoutUtility setCenterX:self.floatButton multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility verticalAlignToSuperViewBottom:self.floatButton constant:-20.0f],
                             [HHAutoLayoutUtility setViewHeight:self.floatButton multiplier:0 constant:kFloatButtonHeight],
                             [HHAutoLayoutUtility setViewWidth:self.floatButton multiplier:0 constant:120.0f],

                             
                             
                             ];
    [self.view addConstraints:constraints];
}

- (void)doneButtonPressed {
    [HHTrainingFieldService sharedInstance].selectedFields = self.selectedField;
    [self dismissViewControllerAnimated:YES completion:self.selectedCompletion];
}
- (void)cancelButtonPressed {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    if (!self.shouldCenterUserLocation) {
        return;
    }
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.05;
    span.longitudeDelta = 0.05;
    CLLocationCoordinate2D location;
    location.latitude = self.mapView.userLocation.coordinate.latitude;
    location.longitude = self.mapView.userLocation.coordinate.longitude;
    region.span = span;
    region.center = location;
    [self.mapView setRegion:region animated:YES];
    self.shouldCenterUserLocation = NO;
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    MKAnnotationView *pinView = nil;
    HHPointAnnotation *hhAnotation = (HHPointAnnotation *)annotation;
    if(annotation != self.mapView.userLocation)
    {
        static NSString *defaultPinID = @"HHPinID";
        pinView = (MKAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
        if (!pinView) {
            pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:defaultPinID];
        }
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(annotationTapped:)];
        [pinView addGestureRecognizer:tap];
        
        if ([self.selectedField containsObject:self.fields[hhAnotation.tag]]){
            pinView.image = [UIImage imageNamed:@"car_icon_solid"];
        } else {
            pinView.image = [UIImage imageNamed:@"car_icon"];
        }
        pinView.canShowCallout = YES;
    }    
    return pinView;
}


- (void)annotationTapped:(UITapGestureRecognizer *)tapRecognizer {
    MKAnnotationView *annotationView = tapRecognizer.view;
    HHPointAnnotation *annotation = annotationView.annotation;
    HHTrainingField *field = self.fields[annotation.tag];
    if ([self.selectedField containsObject:field]) {
        [self.selectedField removeObject:field];
        annotationView.image = [UIImage imageNamed:@"car_icon"];
    } else {
        annotationView.image = [UIImage imageNamed:@"car_icon_solid"];
        [self.selectedField addObject:field];
    }
}

- (void)selectOrDeselectAll {
    if ([self.floatButton.titleLabel.text isEqualToString:NSLocalizedString(@"全选",nil)]) {
        for (HHPointAnnotation *annotation in self.mapView.annotations){
            MKAnnotationView *annotationView = [self.mapView viewForAnnotation: annotation];
            if (annotationView){
                annotationView.image = [UIImage imageNamed:@"car_icon_solid"];
            }
            self.selectedField = [NSMutableArray arrayWithArray:self.fields];
        }
        [self.floatButton setTitle:NSLocalizedString(@"周边训练场",nil) forState:UIControlStateNormal];
        self.selectedField = self.fields;
    } else {
        for (HHPointAnnotation *annotation in self.mapView.annotations){
            MKAnnotationView *annotationView = [self.mapView viewForAnnotation: annotation];
            if (annotationView){
                if ([self.nearestFields containsObject:self.fields[annotation.tag]]) {
                    annotationView.image = [UIImage imageNamed:@"car_icon_solid"];
                } else {
                    annotationView.image = [UIImage imageNamed:@"car_icon"];
                }
                
            }
        }
        [self.floatButton setTitle:NSLocalizedString(@"全选",nil) forState:UIControlStateNormal];
        self.selectedField = self.nearestFields;

    }
}




@end
