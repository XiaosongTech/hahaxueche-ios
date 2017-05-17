//
//  HHMapViewController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 16/05/2017.
//  Copyright © 2017 Zixiao Wang. All rights reserved.
//

#import "HHMapViewController.h"
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
#import "HHLoadingViewUtility.h"
#import "UIBarButtonItem+HHCustomButton.h"
#import "HHSearchViewController.h"
#import "DOPDropDownMenu.h"
#import "UIColor+HHColor.h"
#import "HHClusterAnnotionView.h"

@interface HHMapViewController () <UIScrollViewDelegate, iCarouselDelegate, iCarouselDataSource, DOPDropDownMenuDelegate, DOPDropDownMenuDataSource>

@property (nonatomic, strong) HHField *selectedField;
@property (nonatomic, strong) NSArray *fields;
@property (nonatomic, strong) NSMutableArray *filteredFields;
@property (nonatomic, strong) iCarousel *carousel;
@property (nonatomic, strong) NSArray *coaches;
@property (nonatomic, strong) UILabel *indexLabel;
@property (nonatomic, strong) NSMutableArray *cardViews;
@property (nonatomic, strong) KLCPopup *popup;
@property (nonatomic, strong) DOPDropDownMenu *filterMenu;
@property (nonatomic, strong) NSMutableArray *areas;
@property (nonatomic, strong) NSMutableArray *distances;
@property (nonatomic, strong) NSMutableArray *schools;
@property (nonatomic, strong) HHCity *userCity;
@property (nonatomic, strong) NSMutableDictionary *groupDic;

@property (nonatomic, strong) HHDrivingSchool *selectedSchool;
@property (nonatomic, strong) NSString *selectedZone;
@property (nonatomic, strong) NSNumber *selectedDistance;

@property (nonatomic) BOOL showCluster;
@property (nonatomic) BOOL doneLoadingMap;

@end

@implementation HHMapViewController

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



- (instancetype)initWithSelectedSchool:(HHDrivingSchool *)school selectedZone:(NSString *)selectedZone {
    self = [super init];
    if (self) {
        self.userLocation = [HHStudentStore sharedInstance].currentLocation;
        [[HHConstantsStore sharedInstance] getFieldsWithCityId:[HHStudentStore sharedInstance].selectedCityId completion:^(NSArray *data) {
            self.selectedSchool = school;
            self.selectedZone = selectedZone;
            self.fields = [NSArray arrayWithArray:data];
            self.filteredFields = [self filterArray];
        }];
        
        self.cardViews = [NSMutableArray array];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.showCluster = YES;
    self.title = @"地图找驾校";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem buttonItemWithImage:[UIImage imageNamed:@"ic_arrow_back"] action:@selector(dismissVC) target:self];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem buttonItemWithImage:[UIImage imageNamed:@"icon_search"] action:@selector(jumpToSearchVC) target:self];
    
    [self initSubviews];
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidReceiveMemoryWarningNotification object:[UIApplication sharedApplication] queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        self.mapView.mapType = MKMapTypeHybrid;
        self.mapView.mapType = MKMapTypeStandard;
    }];
    
    [[HHLoadingViewUtility sharedInstance] showLoadingView];
    
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
    
    [self addClusters];
    [self initFilterMenu];
    [self makeConstraints];
}
- (void)addClusters {
    [self.mapView removeAnnotations:self.mapView.annotations];
    self.selectedField = nil;
    self.coaches = nil;
    [self.carousel removeFromSuperview];
    self.carousel = nil;
    
    self.groupDic = [self groupFieldsWithBaseFields:self.filteredFields];
    for (NSString *key in self.groupDic) {
        NSArray *fields = self.groupDic[key];
        if (fields.count > 0) {
            HHField *field = [fields firstObject];
            HHPointAnnotation *pointAnnotation = [[HHPointAnnotation alloc] initWithField:field];
            pointAnnotation.coordinate = CLLocationCoordinate2DMake([field.latitude doubleValue], [field.longitude doubleValue]);
            [self.mapView addAnnotation:pointAnnotation];
        }
        
    }
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.mapView.annotations];
    for (HHPointAnnotation *view in array) {
        if ([view isKindOfClass:[MKUserLocation class]]) {
            [array removeObject:view];
            break;
        }
    }
    [self.mapView showAnnotations:array animated:NO];

}

- (void)initFilterMenu {
    __weak HHMapViewController *weakSelf = self;
    [[HHConstantsStore sharedInstance] getCityWithCityId:[HHStudentStore sharedInstance].selectedCityId completion:^(HHCity *city) {
        if (!city) {
            return ;
        }
        self.userCity = city;
        self.schools = [NSMutableArray arrayWithObject:@"不限"];
        for (HHDrivingSchool *school in self.userCity.drivingSchools) {
            [self.schools addObject:school.schoolName];
        }
        
        self.areas = [NSMutableArray arrayWithObject:@"附近"];
        [self.areas addObjectsFromArray:self.userCity.zones];
        
        self.distances = [NSMutableArray array];
        for (NSNumber *num in self.userCity.distanceRanges) {
            [self.distances addObject:[NSString stringWithFormat:@"%@km", [num stringValue]]];
        }
        [self.distances addObject:@"全城"];
        self.filterMenu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, 0) andHeight:44];
        self.filterMenu.delegate = self;
        self.filterMenu.dataSource = self;
        self.filterMenu.textColor = [UIColor HHLightTextGray];
        self.filterMenu.tintColor = [UIColor HHOrange];
        self.filterMenu.textSelectedColor = [UIColor HHOrange];
        self.filterMenu.indicatorColor = [UIColor HHLightestTextGray];
        [self.view addSubview:self.filterMenu];
        [self.filterMenu selectIndexPath:[DOPIndexPath indexPathWithCol:0 row:0 item:self.distances.count-1]];
        
        self.filterMenu.finishedBlock=^(DOPIndexPath *indexPath){
            if (indexPath.column == 0) {
                if (indexPath.row == 0) {
                    if (indexPath.item >= weakSelf.userCity.distanceRanges.count) {
                        weakSelf.selectedZone = nil;
                        weakSelf.selectedDistance = nil;
                        
                    } else {
                        weakSelf.selectedDistance = weakSelf.userCity.distanceRanges[indexPath.item];
                        weakSelf.selectedZone = nil;
                        
                    }
                } else {
                    weakSelf.selectedZone = weakSelf.userCity.zones[indexPath.row -1];
                    weakSelf.selectedDistance = nil;
                    
                }
            }  else {
                if (indexPath.row > 0) {
                    weakSelf.selectedSchool = weakSelf.userCity.drivingSchools[indexPath.row-1];
                } else {
                    weakSelf.selectedSchool = nil;
                }
                
            }
            if (!weakSelf.selectedZone) {
                weakSelf.showCluster = YES;
            } else {
                weakSelf.showCluster = NO;
            }
            [weakSelf updateMapView];
            
        };
        
    }];
    
}

- (void)makeConstraints {
    [self.mapView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top);
        make.left.equalTo(self.view.left);
        make.width.equalTo(self.view.width);
        make.height.equalTo(self.view.height);
    }];
    
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
    __weak HHMapViewController *weakSelf = self;
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    } else {
        if (self.showCluster) {
            HHPointAnnotation *anno = (HHPointAnnotation *)annotation;
            HHClusterAnnotionView *clusterView = [[HHClusterAnnotionView alloc] initWithAnnotation:annotation reuseIdentifier:@"clusterView"];
            clusterView.canShowCallout = NO;
            clusterView.zoneLabel.text = anno.field.district;
            NSArray *fieldsArray = self.groupDic[anno.field.district];
            clusterView.countLabel.text = [NSString stringWithFormat:@"%ld", fieldsArray.count];
            clusterView.tapBlock = ^{
                weakSelf.selectedZone = anno.field.district;
                [weakSelf.filterMenu selectIndexPath:[DOPIndexPath indexPathWithCol:0 row:[weakSelf.areas indexOfObject:weakSelf.selectedZone]]];
                [weakSelf updateMapView];
            };
            return clusterView;
        } else {
            HHPointAnnotation *anno = (HHPointAnnotation *)annotation;
            
            UIImage *img = [UIImage imageNamed:@"ic_map_local_choseon"];
            UIImageView *pinView = [[UIImageView alloc] initWithImage:img];
            HHCalloutView *calloutView = [[HHCalloutView alloc] initWithField:anno.field];
            calloutView.sendAction = ^(HHField *field) {
                HHGenericPhoneView *view = [[HHGenericPhoneView alloc] initWithTitle:@"轻松定位训练场" placeHolder:@"输入手机号, 立即接收详细地址" buttonTitle:@"发我定位"];
                view.buttonAction = ^(NSString *number) {
                    NSString *link = [NSString stringWithFormat:@"https://m.hahaxueche.com/ditu?field_id=%@", field.fieldId];
                    [[HHStudentService sharedInstance] getPhoneNumber:number coachId:nil schoolId:nil fieldId:field.fieldId eventType:@(1) eventData:@{@"field_id":field.fieldId, @"link":link} completion:^(NSError *error) {
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
            [annotationView hideCalloutView];
            annotationView.pinView.image = [UIImage imageNamed:@"ic_map_local_choseon"];
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
                            aView.pinView.image = [UIImage imageNamed:@"ic_map_local_choseon"];;
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
    __weak HHMapViewController *weakSelf = self;
    HHCoach *coach = self.coaches[index];
    HHMapCoachCardView *coachView = [[HHMapCoachCardView alloc] initWithCoach:coach];
    coachView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame)-60.0f, 140.0f);
    coachView.checkFieldBlock = ^(HHCoach *coach) {
        HHGenericPhoneView *view = [[HHGenericPhoneView alloc] initWithTitle:@"看过训练场才放心" placeHolder:@"输入手机号, 教练立即带你看场地" buttonTitle:@"预约看场地"];
        view.buttonAction = ^(NSString *number) {
            [[HHStudentService sharedInstance] getPhoneNumber:number coachId:coach.coachId schoolId:[coach getCoachDrivingSchool].schoolId fieldId:[coach getCoachField].fieldId eventType:nil eventData:nil completion:^(NSError *error) {
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

- (void)mapViewDidFinishRenderingMap:(MKMapView *)mapView fullyRendered:(BOOL)fullyRendered  {
    [[HHLoadingViewUtility sharedInstance] dismissLoadingView];
    self.doneLoadingMap = YES;
    
}

- (void)jumpToSearchVC {
    HHSearchViewController *vc = [[HHSearchViewController alloc] initWithType:0];
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:navVC animated:YES completion:nil];
}

#pragma -mark DOPDropDownMenu Delegate & Datasource

- (NSInteger)numberOfColumnsInMenu:(DOPDropDownMenu *)menu {
    return 2;
}

- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column {
    if (column == 0) {
        return self.areas.count;
    }  else {
        return self.schools.count;
    }
}

- (NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath {
    if (indexPath.column == 0) {
        return self.areas[indexPath.row];
        
    } else {
        return self.schools[indexPath.row];
    }
}

- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfItemsInRow:(NSInteger)row column:(NSInteger)column {
    if (column == 0) {
        if (row == 0) {
            return self.distances.count;
        }
    }
    return 0;
}

- (NSString *)menu:(DOPDropDownMenu *)menu titleForItemsInRowAtIndexPath:(DOPIndexPath *)indexPath {
    if (indexPath.column == 0) {
        if (indexPath.row == 0) {
            return self.distances[indexPath.item];
        }
    }
    return nil;
}

- (NSMutableArray *)filterArray {
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.fields];
    NSMutableArray *schoolArray = [NSMutableArray array];
    NSMutableArray *zoneArray = [NSMutableArray array];
    NSMutableArray *disArray = [NSMutableArray array];
    if (self.selectedSchool) {
        for (HHField *field in array) {
            if ([field.drivingSchoolIds containsObject:self.selectedSchool.schoolId]) {
                [schoolArray addObject:field];
            }
        }
    } else {
        [schoolArray addObjectsFromArray:array];
    }
    
    if (self.selectedZone) {
        for (HHField *field in schoolArray) {
            if ([field.district isEqualToString:self.selectedZone]) {
                [zoneArray addObject:field];
            }
            
        }
        return zoneArray;
    } else if (self.selectedDistance) {
        
        return disArray;
    }
    return schoolArray;
}

- (NSMutableDictionary *)groupFieldsWithBaseFields:(NSArray *)fields {
    NSMutableDictionary *groupFieldDic = [NSMutableDictionary dictionary];
    for (HHField *field in fields) {
        if (groupFieldDic[field.district]) {
            NSMutableArray *array = groupFieldDic[field.district];
            [array addObject:field];
        } else {
            NSMutableArray *array = [NSMutableArray arrayWithObject:field];
            groupFieldDic[field.district] = array;
        }
    }
    return groupFieldDic;
}

- (void)showMarkers {
    [self.mapView removeAnnotations:self.mapView.annotations];
    self.selectedField = nil;
    self.filteredFields = [self filterArray];
    for (HHField *field in self.filteredFields) {
        HHPointAnnotation *pointAnnotation = [[HHPointAnnotation alloc] initWithField:field];
        pointAnnotation.coordinate = CLLocationCoordinate2DMake([field.latitude doubleValue], [field.longitude doubleValue]);
        pointAnnotation.title = @" ";
        [self.mapView addAnnotation:pointAnnotation];
    }
    
    if (self.selectedZone) {
        NSMutableArray *zoneMarkers = [NSMutableArray array];
        for (HHPointAnnotation *view in self.mapView.annotations) {
            if ([view isKindOfClass:[MKUserLocation class]]) {
                continue;
            }
            
            if ([view isKindOfClass:[HHPointAnnotation class]]) {
                if ([view.field.district isEqualToString:self.selectedZone]) {
                    [zoneMarkers addObject:view];
                }
            }
            
        }
        [self.mapView showAnnotations:zoneMarkers animated:YES];
    }
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    if (!self.doneLoadingMap) {
        return;
    }
    if (mapView.region.span.longitudeDelta > 0.32f) {
        if (!self.showCluster) {
            self.showCluster = YES;
            self.selectedZone = nil;
            [self.filterMenu selectIndexPath:[DOPIndexPath indexPathWithCol:0 row:0 item:self.distances.count-1]];
            [self updateMapView];
        }
    } else {
        if (self.showCluster) {
            self.showCluster = NO;
            [self updateMapView];
            
        }
    }
    
}

- (void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath {
    return;
}


- (void)updateMapView {
    self.filteredFields = [self filterArray];
    if (self.showCluster) {
        [self addClusters];
    } else {
        [self showMarkers];
    }
}
    

@end