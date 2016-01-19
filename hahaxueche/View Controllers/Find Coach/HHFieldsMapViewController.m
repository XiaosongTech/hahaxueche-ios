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

static NSString *const kMapServiceKey = @"b1f6d0a0e2470c6a1145bf90e1cdebe4";
static NSString *const kExplanationCopy = @"图标可多选，请选择地图上的图标，选中后点击下方“查看训练场教练”，可以查看查看训练场教练列表";

@interface HHFieldsMapViewController ()

@property (nonatomic, strong) NSMutableArray *selectedFields;
@property (nonatomic, strong) NSArray *allFields;


@end

@implementation HHFieldsMapViewController


- (instancetype)initWithUserLocation:(CLLocation *)userLocation {
    self = [super init];
    if (self) {
        self.userLocation = userLocation;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [MAMapServices sharedServices].apiKey = kMapServiceKey;
    
    self.title = @"训练场地图";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem buttonItemWithImage:[UIImage imageNamed:@"ic_arrow_back"] action:@selector(dismissVC) target:self];
    
    self.selectedFields = [NSMutableArray array];
    self.allFields = @[@"训练场1"];
    
    [self initSubviews];
}

- (void)initSubviews {
    self.mapView = [[MAMapView alloc] initWithFrame:CGRectZero];
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    [self.view addSubview:self.mapView];
    
    self.explanationView = [[UIView alloc] init];
    self.explanationView.backgroundColor = [UIColor colorWithRed:1 green:0.99 blue:0.99 alpha:1.0f];
    [self.view addSubview:self.explanationView];
    
    self.explanationLabel = [[UILabel alloc] init];
    self.explanationLabel.numberOfLines = 0;
    self.explanationLabel.attributedText = [self generateString];
    [self.explanationLabel sizeToFit];
    //self.explanationLabel.backgroundColor = [UIColor clearColor];
    [self.explanationView addSubview:self.explanationLabel];
    
    self.bottomButton = [[HHButton alloc] init];
    [self.bottomButton setTitle:@"查看训练场教练（已选0个）" forState:UIControlStateNormal];
    [self.bottomButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.bottomButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [self.bottomButton setBackgroundColor:[UIColor HHOrange]];
    [self.view addSubview:self.bottomButton];
    
    [self makeConstraints];
}

- (void)makeConstraints {
    [self.mapView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top);
        make.left.equalTo(self.view.left);
        make.width.equalTo(self.view.width);
        make.height.equalTo(self.view.height).offset(-100.0f);
    }];
    
    [self.explanationView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.left);
        make.top.equalTo(self.mapView.bottom);
        make.width.equalTo(self.view.width);
        make.height.mas_equalTo(50.0f);
    }];
    
    [self.explanationLabel makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.explanationView);
        make.width.equalTo(self.explanationView).offset(-60.0f);
    }];
    
    [self.bottomButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.left);
        make.top.equalTo(self.explanationView.bottom);
        make.width.equalTo(self.view.width);
        make.height.mas_equalTo(50.0f);
    }];
    
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    for (NSString *field in self.allFields) {
        MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
        pointAnnotation.coordinate = CLLocationCoordinate2DMake(39.989631, 116.481018);
        pointAnnotation.title = field;
        [self.mapView addAnnotation:pointAnnotation];
    }
    
    MACoordinateRegion mapRegion;
    mapRegion.center = self.userLocation.coordinate;
    mapRegion.span.latitudeDelta = 0.2;
    mapRegion.span.longitudeDelta = 0.2;
    
    [self.mapView setRegion:mapRegion animated: YES];
    [self.mapView setCenterCoordinate:self.userLocation.coordinate animated:NO];
}


#pragma mark - Button Actions

- (void)dismissVC {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)annotationViewTapped:(UITapGestureRecognizer *)recognizer {
    MAAnnotationView *annotationView = (MAAnnotationView *)recognizer.view;
    if ([self.selectedFields containsObject:self.allFields[annotationView.tag]]) {
        annotationView.image = [UIImage imageNamed:@"ic_map_local_choseoff"];
        [self.selectedFields removeObject:self.allFields[annotationView.tag]];
    } else {
        annotationView.image = [UIImage imageNamed:@"ic_map_local_choseon"];
        [self.selectedFields addObject:self.allFields[annotationView.tag]];
    }
    
    NSString *buttonTitle = [NSString stringWithFormat:@"查看训练场教练（已选%ld个）", self.selectedFields.count];
    [self.bottomButton setTitle:buttonTitle forState:UIControlStateNormal];
}

#pragma mark - Others

- (NSMutableAttributedString *)generateString {
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:kExplanationCopy attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0f], NSForegroundColorAttributeName:[UIColor HHLightTextGray]}];
    NSRange range1 = [kExplanationCopy rangeOfString:@"图标可多选"];
    NSRange range2 = [kExplanationCopy rangeOfString:@"“查看训练场教练”"];
    [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor HHOrange] range:range1];
    [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor HHOrange] range:range2];
    return attrString;
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
        annotationView.image = [UIImage imageNamed:@"ic_map_local_choseoff"];
        annotationView.canShowCallout = YES;
        return annotationView;

    }
}

- (void)mapView:(MAMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    int i = 0;
    for (MAAnnotationView *view in views) {
        if ([view.annotation isKindOfClass:[MAUserLocation class]]) {
            continue;
        }
        [mapView selectAnnotation:view.annotation animated:NO];
        view.tag = i;
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(annotationViewTapped:)];
        [view addGestureRecognizer:tapRecognizer];
        i++;
    }
}

@end
