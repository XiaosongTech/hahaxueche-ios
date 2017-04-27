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
#import "HHSupportUtility.h"
#import "HHWebViewController.h"
#import "HHCoachDetailViewController.h"
#import "HHAnnotationView.h"
#import "HHCalloutView.h"
#import "HHSupportUtility.h"
#import "HHGenericPhoneView.h"
#import "HHStudentService.h"
#import "HHToastManager.h"
#import "HHEventTrackingManager.h"
#import "iCarousel.h"


@interface HHFieldsMapViewController () <UIScrollViewDelegate, iCarouselDelegate, iCarouselDataSource>

@property (nonatomic, strong) HHField *selectedField;
@property (nonatomic, strong) NSArray *fields;
@property (nonatomic, strong) iCarousel *carousel;
@property (nonatomic, strong) NSArray *coaches;
@property (nonatomic, strong) UILabel *indexLabel;
@property (nonatomic, strong) NSMutableArray *cardViews;
@property (nonatomic, strong) KLCPopup *popup;


@end

@implementation HHFieldsMapViewController

- (void)dealloc {
    switch (self.mapView.mapType) {
        case MKMapTypeHybrid: {
            self.mapView.mapType = MKMapTypeStandard;
        }break;
            
        case MKMapTypeStandard: {
            self.mapView.mapType = MKMapTypeHybrid;
        } break;
            
        default:
            break;
    }
    self.mapView.mapType = MKMapTypeStandard;
    self.mapView.showsUserLocation = NO;
    [self.mapView.layer removeAllAnimations];
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView removeOverlays:self.mapView.overlays];
    [self.mapView removeFromSuperview];
    self.mapView.delegate = nil;
    self.mapView = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidReceiveMemoryWarningNotification object:[UIApplication sharedApplication] queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        self.mapView.mapType = MKMapTypeHybrid;
        self.mapView.mapType = MKMapTypeStandard;
    }];
   
}

- (void)getFieldCoach {
    if ([HHStudentStore sharedInstance].fieldCoachesDic[self.selectedField.fieldId]) {
        self.coaches = [HHStudentStore sharedInstance].fieldCoachesDic[self.selectedField.fieldId];
        [self updateView];
    } else {
        [[HHCoachService sharedInstance] fetchCoachListWithCityId:[HHStudentStore sharedInstance].selectedCityId filters:nil sortOption:0 userLocation:nil fields:@[self.selectedField.fieldId] perPage:@(100) completion:^(HHCoaches *coaches, NSError *error) {
            if (!error) {
                self.coaches = coaches.coaches;
                [HHStudentStore sharedInstance].fieldCoachesDic[self.selectedField.fieldId] = coaches.coaches;
                [self updateView];
            }
        }];
    }


    
}

- (void)initSubviews {
    self.mapView = [[MKMapView alloc] init];
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    [self.view addSubview:self.mapView];
    
    [self makeConstraints];
}

- (void)makeConstraints {
    [self.mapView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top);
        make.left.equalTo(self.view.left);
        make.width.equalTo(self.view.width);
        make.height.equalTo(self.view.height);
    }];
    
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    for (HHField *field in self.fields) {
        HHPointAnnotation *pointAnnotation = [[HHPointAnnotation alloc] initWithField:field];
        pointAnnotation.coordinate = CLLocationCoordinate2DMake([field.latitude doubleValue], [field.longitude doubleValue]);
        pointAnnotation.title = @" ";
        [self.mapView addAnnotation:pointAnnotation];
        
    }
    
    if (self.selectedField)  {
        [self getFieldCoach];
        
        CLLocationCoordinate2D fieldLocationCoordinate = CLLocationCoordinate2DMake([self.selectedField.latitude doubleValue], [self.selectedField.longitude doubleValue]);
        MKCoordinateRegion mapRegion = MKCoordinateRegionMakeWithDistance(fieldLocationCoordinate, 15000, 15000);
        [self.mapView setRegion:mapRegion animated:YES];
    } else {
        MKMapRect zoomRect = MKMapRectNull;
        for (id <MKAnnotation> annotation in self.mapView.annotations) {
            MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
            MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.1, 0.1);
            zoomRect = MKMapRectUnion(zoomRect, pointRect);
        }
        [self.mapView setVisibleMapRect:zoomRect animated:YES];
    }
    
}


#pragma mark - Button Actions

- (void)dismissVC {
    if ([[self.navigationController.viewControllers firstObject] isEqual:self]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
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
    __weak HHFieldsMapViewController *weakSelf = self;
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    } else {
        
        HHPointAnnotation *anno = (HHPointAnnotation *)annotation;
        
        UIImageView *pinView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_map_local_choseoff"]];
        HHCalloutView *calloutView = [[HHCalloutView alloc] initWithField:anno.field];
        calloutView.sendAction = ^(HHField *field) {
            HHGenericPhoneView *view = [[HHGenericPhoneView alloc] initWithTitle:@"轻松定位训练场" placeHolder:@"输入手机号, 立即接收详细地址" buttonTitle:@"发我定位"];
            view.buttonAction = ^(NSString *number) {
                [[HHStudentService sharedInstance] getPhoneNumber:number completion:^(NSError *error) {
                    if (error) {
                        [[HHToastManager sharedManager] showErrorToastWithText:@"提交失败, 请重试!"];
                    } else {
                        [HHPopupUtility dismissPopup:weakSelf.popup];
                        [[HHEventTrackingManager sharedManager] eventTriggeredWithId:map_view_page_locate_confirmed attributes:nil];
                    }
                }];
            };
            weakSelf.popup = [HHPopupUtility createPopupWithContentView:view];
            [HHPopupUtility showPopup:weakSelf.popup layout:KLCPopupLayoutMake(KLCPopupHorizontalLayoutCenter, KLCPopupVerticalLayoutAboveCenter)];
            [[HHEventTrackingManager sharedManager] eventTriggeredWithId:map_view_page_locate_tapped attributes:nil];
        };
        
        HHAnnotationView *annotationView = (HHAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:NSStringFromClass([HHAnnotationView class])];
        if (!annotationView) {
            annotationView = [[HHAnnotationView alloc] initWithAnnotation:annotation
                                                          reuseIdentifier:NSStringFromClass([HHAnnotationView class])
                                                                  pinView:pinView
                                                              calloutView:calloutView
                                                                 selected:[anno.field.fieldId isEqualToString:self.selectedField.fieldId]];
        }
        
        annotationView.enabled = NO;
        annotationView.pinCompletion = ^(HHField *field) {
            for (id<MKAnnotation> annotation in mapView.annotations){
                HHAnnotationView *aView = (HHAnnotationView *)[mapView viewForAnnotation: annotation];
                if (aView){
                    if ([annotation isKindOfClass:[MKUserLocation class]]) {
                        continue;
                    }
                    HHPointAnnotation *annotation = (HHPointAnnotation *)aView.annotation;
                    if (![annotation.field.fieldId isEqualToString:field.fieldId]) {
                        aView.pinView.image = [UIImage imageNamed:@"ic_map_local_choseoff"];
                        [aView hideCalloutView];
                    } else {
                        [weakSelf.mapView bringSubviewToFront:aView];
                    }
                }
            }

            if (![weakSelf.selectedField.fieldId isEqualToString:field.fieldId]) {
                weakSelf.selectedField = field;
                [weakSelf getFieldCoach];
            }
            
        };
        return annotationView;

    }
}


- (void)updateView {
    
    if (!self.carousel) {
        self.carousel = [[iCarousel alloc] init];
        self.carousel.delegate = self;
        self.carousel.dataSource = self;
        self.carousel.bounces = NO;
        [self.view addSubview:self.carousel];
        
        [self.carousel makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view.bottom);
            make.left.equalTo(self.view.left);
            make.width.equalTo(self.view.width);
            make.height.mas_equalTo(140.0f);
        }];
        
        self.indexLabel = [[UILabel alloc] init];
        [self.view addSubview:self.indexLabel];
        [self.indexLabel makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.carousel.top).offset(-5.0f);
            make.right.equalTo(self.view.right).offset(-30.0f);
        }];
    
    }
    
    [self.carousel reloadData];
    self.indexLabel.attributedText = [self generateStringWithCurrentIndex:1];
}


#pragma mark iCarousel methods

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel {
    return self.coaches.count;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view {
    __weak HHFieldsMapViewController *weakSelf = self;
    HHCoach *coach = self.coaches[index];
    HHMapCoachCardView *coachView = [[HHMapCoachCardView alloc] initWithCoach:coach];
    coachView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame)-60.0f, 140.0f);
    coachView.checkFieldBlock = ^(HHCoach *coach) {
        HHGenericPhoneView *view = [[HHGenericPhoneView alloc] initWithTitle:@"看过训练场才放心" placeHolder:@"输入手机号, 教练立即带你看场地" buttonTitle:@"预约看场地"];
        view.buttonAction = ^(NSString *number) {
            [[HHStudentService sharedInstance] getPhoneNumber:number completion:^(NSError *error) {
                if (error) {
                    [[HHToastManager sharedManager] showErrorToastWithText:@"提交失败, 请重试!"];
                } else {
                    [HHPopupUtility dismissPopup:weakSelf.popup];
                    [[HHEventTrackingManager sharedManager] eventTriggeredWithId:map_view_page_check_site_confirmed attributes:nil];
                }
            }];
        };
        weakSelf.popup = [HHPopupUtility createPopupWithContentView:view];
        [HHPopupUtility showPopup:weakSelf.popup layout:KLCPopupLayoutMake(KLCPopupHorizontalLayoutCenter, KLCPopupVerticalLayoutAboveCenter)];
        [[HHEventTrackingManager sharedManager] eventTriggeredWithId:map_view_page_check_site_tapped attributes:nil];
    };
    
    coachView.supportBlock = ^(HHCoach *coach) {
        [weakSelf.navigationController pushViewController:[[HHSupportUtility sharedManager] buildOnlineSupportVCInNavVC:weakSelf.navigationController] animated:YES];
        [[HHEventTrackingManager sharedManager] eventTriggeredWithId:map_view_page_online_support_tapped attributes:nil];
    };
    
    coachView.callBlock = ^(HHCoach *coach) {
        [[HHSupportUtility sharedManager] callSupportWithNumber:coach.consultPhone];
        [[HHEventTrackingManager sharedManager] eventTriggeredWithId:map_view_page_contact_coach_tapped attributes:nil];
    };
    
    coachView.schoolBlock = ^(HHDrivingSchool *school) {
        HHWebViewController *webVC = [[HHWebViewController alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://m.hahaxueche.com/jiaxiao/%@", [school.schoolId stringValue]]]];
        webVC.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:webVC animated:YES];
        [[HHEventTrackingManager sharedManager] eventTriggeredWithId:map_view_page_check_school_tapped attributes:nil];
    };
    
    coachView.coachBlock = ^(HHCoach *coach) {
        HHCoachDetailViewController *vc = [[HHCoachDetailViewController alloc] initWithCoach:coach];
        vc.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:vc animated:YES];
        [[HHEventTrackingManager sharedManager] eventTriggeredWithId:map_view_page_check_coach_tapped attributes:nil];
    };
    
    
    return coachView;
}

- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel {
    self.indexLabel.attributedText = [self generateStringWithCurrentIndex:carousel.currentItemIndex + 1];
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value {
    if (option == iCarouselOptionSpacing) {
        return value * 1.04;
    }
    return value;
}


@end
