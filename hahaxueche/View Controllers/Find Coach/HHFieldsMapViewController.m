//
//  HHFieldsMapViewController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 1/17/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHFieldsMapViewController.h"
#import "UIBarButtonItem+HHCustomButton.h"
#import "Masonry.h"
#import "HHConstantsStore.h"
#import "HHStudentStore.h"
#import "HHCoachService.h"
#import "HHMapCoachCardView.h"
#import "HHPointAnnotation.h"


@interface HHFieldsMapViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) HHField *selectedField;
@property (nonatomic, strong) NSArray *fields;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSArray *coaches;
@property (nonatomic, strong) UILabel *indexLabel;
@property (nonatomic, strong) NSMutableArray *cardViews;
@end

@implementation HHFieldsMapViewController

- (void)dealloc {
    self.mapView.showsUserLocation = NO;
    self.mapView.delegate = nil;
    [self.mapView removeFromSuperview];
    self.mapView = nil;
}



- (instancetype)initWithFields:(NSArray *)fields selectedField:(HHField *)selectedField {
    self = [super init];
    if (self) {
        self.userLocation = [HHStudentStore sharedInstance].currentLocation;
        self.selectedField = selectedField;
        self.fields = fields;
        self.cardViews = [NSMutableArray array];

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"训练场/驾校教练";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem buttonItemWithImage:[UIImage imageNamed:@"ic_arrow_back"] action:@selector(dismissVC) target:self];
    
    [self initSubviews];
    if (self.selectedField)  {
        [self getFieldCoach];
    }
    
    
}

- (void)getFieldCoach {
    if ([HHStudentStore sharedInstance].fieldCoachesDic[self.selectedField.fieldId]) {
        self.coaches = [HHStudentStore sharedInstance].fieldCoachesDic[self.selectedField.fieldId];
        [self updateView];
    } else {
        [[HHCoachService sharedInstance] fetchCoachListWithCityId:[HHStudentStore sharedInstance].selectedCityId filters:nil sortOption:0 userLocation:nil fields:@[self.selectedField.fieldId] completion:^(HHCoaches *coaches, NSError *error) {
            if (!error) {
                self.coaches = coaches.coaches;
                [HHStudentStore sharedInstance].fieldCoachesDic[self.selectedField.fieldId] = coaches.coaches;
                [self updateView];
            }
        }];
    }


    
}

- (void)initSubviews {
    self.mapView = [[MKMapView alloc] initWithFrame:CGRectZero];
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    [self.view addSubview:self.mapView];
    
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.delegate = self;
    self.scrollView.backgroundColor = [UIColor clearColor];
    [self.view bringSubviewToFront:self.scrollView];
    [self.view addSubview:self.scrollView];
    
    self.indexLabel = [[UILabel alloc] init];
    [self.view bringSubviewToFront:self.indexLabel];
    [self.view addSubview:self.indexLabel];
    
    [self makeConstraints];
}

- (void)makeConstraints {
    [self.mapView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top);
        make.left.equalTo(self.view.left);
        make.width.equalTo(self.view.width);
        make.height.equalTo(self.view.height);
    }];
    
    [self.scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.bottom);
        make.left.equalTo(self.view.left);
        make.width.equalTo(self.view.width);
        make.height.mas_equalTo(140.0f);
    }];

    
    [self.indexLabel makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.right).offset(-20.0f);
        make.bottom.equalTo(self.scrollView.top).offset(-5.0f);
    }];
    
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    for (HHField *field in self.fields) {
        HHPointAnnotation *pointAnnotation = [[HHPointAnnotation alloc] initWithField:field];
        pointAnnotation.coordinate = CLLocationCoordinate2DMake([field.latitude doubleValue], [field.longitude doubleValue]);
        pointAnnotation.title = field.name;
        pointAnnotation.subtitle = field.address;
        [self.mapView addAnnotation:pointAnnotation];
        
    }
    
    MKCoordinateRegion mapRegion = MKCoordinateRegionMakeWithDistance(self.userLocation.coordinate, 15000, 15000);
    [self.mapView setRegion:mapRegion animated:YES];
}


#pragma mark - Button Actions

- (void)dismissVC {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Others

- (NSMutableAttributedString *)generateStringWithCurrentIndex:(NSInteger)currentIndex {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld", currentIndex] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10.0f], NSForegroundColorAttributeName:[UIColor HHOrange], NSParagraphStyleAttributeName:paragraphStyle}];
    NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"/%ld", self.coaches.count] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10.0f], NSForegroundColorAttributeName:[UIColor HHLightTextGray], NSParagraphStyleAttributeName:paragraphStyle}];

    [attrString appendAttributedString:attrString2];
    
    return attrString;
}

#pragma mark - MapView Delegate Methods 
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    } else {
        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
        MKAnnotationView *annotationView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (!annotationView) {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                          reuseIdentifier:reuseIndetifier];
        }

        annotationView.canShowCallout = YES;
        return annotationView;

    }
}


- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    for (id<MKAnnotation> annotation in mapView.annotations){
        MKAnnotationView *aView = [mapView viewForAnnotation: annotation];
        if (aView){
            aView.image = [UIImage imageNamed:@"ic_map_local_choseoff"];
        }
    }
    view.image = [UIImage imageNamed:@"ic_map_local_choseon"];
    HHPointAnnotation *annotation = view.annotation;
    self.selectedField = annotation.field;
    [self getFieldCoach];
    
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    for (MKAnnotationView *view in views) {
        if ([view.annotation isKindOfClass:[MKUserLocation class]]) {
            continue;
        }
        HHPointAnnotation *annotation = view.annotation;
        HHField *field = annotation.field;

        if ([field.fieldId isEqualToString:self.selectedField.fieldId]) {
            self.selectedField = field;
            view.image = [UIImage imageNamed:@"ic_map_local_choseon"];
        } else {
            view.image = [UIImage imageNamed:@"ic_map_local_choseoff"];
        }
    }
}

- (void)updateView {
    self.indexLabel.attributedText = [self generateStringWithCurrentIndex:1];
    for (HHMapCoachCardView *view in self.cardViews) {
        [view removeFromSuperview];
    }
    [self.cardViews removeAllObjects];
    
    HHMapCoachCardView *preView;
    for (int i = 0; i < self.coaches.count; i++) {
        HHCoach *coach = self.coaches[i];
        HHMapCoachCardView *view = [[HHMapCoachCardView alloc] initWithCoach:coach];
        [self.scrollView addSubview:view];
        [view makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.scrollView.top);
            if (!preView) {
                make.left.equalTo(self.scrollView.left).offset(30.0f);
            } else {
                make.left.equalTo(preView.right).offset(10.0f);
            }
            make.width.equalTo(self.scrollView.width).offset(-60.0f);
            make.height.mas_equalTo(140.0f);
            
        }];
        preView = view;
        [self.cardViews addObject:view];
    }
    
    if (preView) {
        [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:preView
                                                                    attribute:NSLayoutAttributeRight
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.scrollView
                                                                    attribute:NSLayoutAttributeRight
                                                                   multiplier:1.0
                                                                     constant:-30.0f]];
    }
    
    self.scrollView.contentOffset = CGPointMake(0, 0);
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger page = (scrollView.contentOffset.x + (0.5f * CGRectGetWidth(self.scrollView.bounds))) / CGRectGetWidth(self.scrollView.bounds);
    self.indexLabel.attributedText = [self generateStringWithCurrentIndex:page+1];
}

@end
