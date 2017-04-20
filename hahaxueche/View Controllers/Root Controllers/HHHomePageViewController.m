//
//  HHHomePageViewController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 1/10/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHHomePageViewController.h"
#import "HHHomePageTapView.h"
#import "Masonry.h"
#import "UIColor+HHColor.h"
#import "HHStudentStore.h"
#import "HHCitySelectView.h"
#import "HHConstantsStore.h"
#import "HHPopupUtility.h"
#import <KLCPopup/KLCPopup.h>
#import "HHCoachService.h"
#import "HHLoadingViewUtility.h"
#import "HHFindCoachViewController.h"
#import "HHCoachDetailViewController.h"
#import "HHWebViewController.h"
#import "NSNumber+HHNumber.h"
#import "HHRootViewController.h"
#import "HHReferFriendsViewController.h"
#import "HHStudentService.h"
#import "HHBanner.h"
#import "HHSupportUtility.h"
#import "HHTestView.h"
#import "HHTestStartViewController.h"
#import "HHReferFriendsViewController.h"
#import "HHGenericOneButtonPopupView.h"
#import "HHIntroViewController.h"
#import "FLAnimatedImage.h"
#import "FLAnimatedImageView.h"
#import "HHQRCodeShareView.h"
#import "HHVoucherPopupView.h"
#import "HHSocialMediaShareUtility.h"
#import <APAddressBook/APAddressBook.h>
#import "HHGuardCardViewController.h"
#import "HHAddressBookUtility.h"
#import <CloudPushSDK/CloudPushSDK.h>
#import "HHInsuranceViewController.h"
#import "HHHomePageItemsView.h"
#import "UIBarButtonItem+HHCustomButton.h"
#import "HHFieldsMapViewController.h"
#import "HHCarouselView.h"
#import "INTULocationManager.h"
#import "HHSearchViewController.h"
#import "HHDrivingSchool.h"
#import "HHCoach.h"
#import "HHHomePageGuideView.h"
#import "HHHomePageGuardView.h"
#import "HHAskLocationPermissionViewController.h"
#import <Appirater.h>


static NSString *const kHomePageVoucherPopupKey = @"kHomePageVoucherPopupKey";

static NSString *const kDrivingSchoolPage = @"https://m.hahaxueche.com/jiaxiao";
static NSString *const kDrivingSchoolPageStaging = @"https://staging-m.hahaxueche.com/jiaxiao";

@interface HHHomePageViewController ()

@property (nonatomic, strong) FLAnimatedImageView *findCoachView;
@property (nonatomic, strong) FLAnimatedImageView *findJiaxiaoView;
@property (nonatomic, strong) HHCitySelectView *citySelectView;
@property (nonatomic, strong) KLCPopup *popup;
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIView *topContainerView;
@property (nonatomic, strong) HHHomePageItemsView *itemsView;

@property (nonatomic, strong) UIImageView *searchImage;
@property (nonatomic, strong) NSArray *drivingSchools;
@property (nonatomic, strong) NSArray *coaches;

@property (nonatomic, strong) HHCarouselView *drivingSchoolsView;
@property (nonatomic, strong) HHCarouselView *coachesView;
@property (nonatomic, strong) HHHomePageGuideView *guideView;
@property (nonatomic, strong) HHHomePageGuardView *guardView;

@property (nonatomic, strong) NSArray *fields;

@property (nonatomic) BOOL popupVoucherShowed;

@end

@implementation HHHomePageViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
    [self.navigationController.interactivePopGestureRecognizer setEnabled:YES];
    
    if([[HHStudentStore sharedInstance].currentStudent isPurchased]) {
        [CloudPushSDK bindTag:1 withTags:@[@"purchased"] withAlias:nil withCallback:nil];

    }
    
    if ([[HHConstantsStore sharedInstance].drivingSchools count] > 0) {
        self.drivingSchools = [HHConstantsStore sharedInstance].drivingSchools;
        [self initSubviews];
    } else {
        [[HHLoadingViewUtility sharedInstance] showLoadingView];
        [[HHConstantsStore sharedInstance] getDrivingSchoolsWithCityId:[HHStudentStore sharedInstance].selectedCityId completion:^(NSArray *schools) {
            [[HHLoadingViewUtility sharedInstance] dismissLoadingView];
            self.drivingSchools = schools;
            [self initSubviews];
        }];
    }
    
    [[INTULocationManager sharedInstance] requestLocationWithDesiredAccuracy:INTULocationAccuracyBlock timeout:2.0f delayUntilAuthorized:YES block:^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status) {
        if (status == INTULocationStatusSuccess) {
            [HHStudentStore sharedInstance].currentLocation = currentLocation;
        
        } else if (status == INTULocationStatusTimedOut) {
            [HHStudentStore sharedInstance].currentLocation = currentLocation;
            
        } else if (status == INTULocationStatusError) {
                [HHStudentStore sharedInstance].currentLocation = nil;
        } else {
            [HHStudentStore sharedInstance].currentLocation = nil;
        }
        
        NSArray *locationArray;
        if ([HHStudentStore sharedInstance].currentLocation) {
            NSNumber *lat = @([HHStudentStore sharedInstance].currentLocation.coordinate.latitude);
            NSNumber *lon = @([HHStudentStore sharedInstance].currentLocation.coordinate.longitude);
            locationArray = @[lat, lon];
        }
        
        [[HHConstantsStore sharedInstance] getFieldsWithCityId:[HHStudentStore sharedInstance].selectedCityId completion:^(NSArray *schools) {
            [[HHCoachService sharedInstance] fetchCoachListWithCityId:[HHStudentStore sharedInstance].selectedCityId filters:nil sortOption:SortOptionDistance userLocation:locationArray fields:nil perPage:nil completion:^(HHCoaches *coaches, NSError *error) {
                if (!error) {
                    self.coaches = coaches.coaches;
                    [self.coachesView updateData:self.coaches type:CarouselTypeCoach];
                    
                }
            }];
        }];
        
        [[HHAddressBookUtility sharedManager] uploadContacts];
        
    }];
    
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    __weak HHHomePageViewController *weakSelf = self;
    if ([HHStudentStore sharedInstance].currentStudent.vouchers.count > 0 && ![[HHStudentStore sharedInstance].currentStudent isPurchased]) {
        if (self.popupVoucherShowed) {
            return;
        }
        [[HHStudentService sharedInstance] getVouchersWithType:@(0) coachId:nil completion:^(NSArray *vouchers) {
            HHVoucher *biggestVoucher = [vouchers firstObject];
            for (HHVoucher *voucher in vouchers) {
                if (biggestVoucher.amount < voucher.amount) {
                    biggestVoucher = voucher;
                }
            }
            HHVoucherPopupView *popupView = [[HHVoucherPopupView alloc] initWithVoucher:biggestVoucher];
            popupView.dismissBlock = ^() {
                [HHPopupUtility dismissPopup:weakSelf.popup];
            };
            popupView.shareBlock = ^() {
                [HHPopupUtility dismissPopup:weakSelf.popup];
                [weakSelf showShareView];
            };
            self.popup = [HHPopupUtility createPopupWithContentView:popupView];
            [HHPopupUtility showPopup:self.popup];
            self.popupVoucherShowed = YES;
        }];
        
    }
#ifdef DEBUG
    [Appirater setDebug:YES];
#endif
    //Appirater
    [Appirater setAppId:@"1011236187"];
    [Appirater setDaysUntilPrompt:2];
    [Appirater setUsesUntilPrompt:0];
    [Appirater setSignificantEventsUntilPrompt:-1];
    [Appirater setTimeBeforeReminding:2];
    [Appirater setDebug:NO];
    [Appirater appLaunched:YES];
    
    
    [[HHEventTrackingManager sharedManager] eventTriggeredWithId:home_page_viewed attributes:nil];
    
    
}

- (void)initSubviews {
    __weak HHHomePageViewController *weakSelf = self;
    self.searchImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sousuokuang"]];
    self.searchImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchTapped)];
    [self.searchImage addGestureRecognizer:tap];
    self.searchImage.contentMode = UIViewContentModeScaleAspectFit;
    self.navigationItem.titleView = self.searchImage;
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem  buttonItemWithImage:[UIImage imageNamed:@"ic_map_firstscreen"] action:@selector(navMapTapped) target:self];
    
    HHCity *city = [[HHConstantsStore sharedInstance] getCityWithId:[HHStudentStore sharedInstance].selectedCityId];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem  buttonItemWithAttrTitle:[self generateAttrStringWithText:city.cityName image:[UIImage imageNamed:@"Triangle"] type:1] action:@selector(cityTapped) target:self isLeft:YES];
    
    
    self.scrollView = [[UIScrollView  alloc] init];
    self.scrollView.backgroundColor = [UIColor HHBackgroundGary];
    self.scrollView.scrollEnabled = YES;
    self.scrollView.bounces = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    
    self.topContainerView = [[UIView alloc] init];
    self.topContainerView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:self.topContainerView];
    
    self.findCoachView = [self buildGifViewWithPath:@"bt_choosecoach"];
    [self.topContainerView addSubview:self.findCoachView];
    UITapGestureRecognizer *tapRec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(findCoachViewTapped)];
    [self.findCoachView addGestureRecognizer:tapRec];
    
    
    self.findJiaxiaoView = [self buildGifViewWithPath:@"bt_chooseschool"];
    [self.topContainerView addSubview:self.findJiaxiaoView];
    UITapGestureRecognizer *tapRec2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(findJiaxiaoViewTapped)];
    [self.findJiaxiaoView addGestureRecognizer:tapRec2];
    
    self.itemsView = [[HHHomePageItemsView alloc] init];
    self.itemsView.itemAction = ^(NSInteger index) {
        switch (index) {
            case 0: {
                [weakSelf showMapView];
            } break;
                
            case 1: {
                [weakSelf openWebPage:[NSURL URLWithString:@"https://m.hahaxueche.com/share/tuan"]];
            } break;
                
            case 2: {
                HHTestStartViewController *vc = [[HHTestStartViewController alloc] init];
                UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:vc];
                [weakSelf presentViewController:navVC animated:YES completion:nil];
            } break;
            case 3: {

                [weakSelf.navigationController pushViewController:[[HHSupportUtility sharedManager] buildOnlineSupportVCInNavVC:weakSelf.navigationController] animated:YES];
            } break;
                
            default:
                break;
        }
    };
    [self.topContainerView addSubview:self.itemsView];

    
    self.drivingSchoolsView = [[HHCarouselView alloc] initWithType:CarouselTypeDrivingSchool data:self.drivingSchools];
    self.drivingSchoolsView.buttonAction = ^() {
        NSString *url;
        #ifdef DEBUG
            url = kDrivingSchoolPageStaging;
        #else
            url = kDrivingSchoolPage;
        #endif
        [weakSelf openWebPage:[NSURL URLWithString:url]];
    };
    self.drivingSchoolsView.itemAction = ^(NSInteger index) {
        HHDrivingSchool *school = weakSelf.drivingSchools[index];
        NSString *url;
        #ifdef DEBUG
            url = kDrivingSchoolPageStaging;
        #else
            url = kDrivingSchoolPage;
        #endif
        [weakSelf openWebPage:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", url, school.schoolId]]];
    };
    [self.scrollView addSubview:self.drivingSchoolsView];
    
    self.coachesView = [[HHCarouselView alloc] initWithType:CarouselTypeCoach data:nil];
    self.coachesView.buttonAction = ^() {
        weakSelf.tabBarController.selectedIndex = TabBarItemCoach;
    };
    self.coachesView.itemAction = ^(NSInteger index) {
        HHCoach *coach = weakSelf.coaches[index];
        HHCoachDetailViewController *vc = [[HHCoachDetailViewController alloc] initWithCoach:coach];
        vc.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    [self.scrollView addSubview:self.coachesView];
    
    self.guideView = [[HHHomePageGuideView alloc] init];
    self.guideView.itemAction = ^(NSInteger index) {
        switch (index) {
            case 0: {
                [weakSelf openWebPage:[NSURL URLWithString:@"https://m.hahaxueche.com/bao-ming-xu-zhi"]];
            } break;
            case 1: {
                [weakSelf openWebPage:[NSURL URLWithString:@"https://m.hahaxueche.com/xue-che-liu-cheng"]];
            } break;
            case 2: {
                [weakSelf openWebPage:[NSURL URLWithString:@"https://m.hahaxueche.com/bao-ming-xu-zhi"]];
            } break;
            case 3: {
                [weakSelf openWebPage:[NSURL URLWithString:@"https://m.hahaxueche.com/jiaxiao"]];
            } break;
                
            default:
                break;
        }
    };
    [self.scrollView addSubview:self.guideView];
    
    self.guardView = [[HHHomePageGuardView alloc] init];
    self.guardView.itemAction = ^(NSInteger index) {
        switch (index) {
            case 0: {
                [weakSelf openWebPage:[NSURL URLWithString:@"https://m.hahaxueche.com/xue-che-bao"]];
            } break;
            case 1: {
                [weakSelf openWebPage:[NSURL URLWithString:@"https://m.hahaxueche.com/pei-fu-bao"]];
            } break;
            case 2: {
                [weakSelf openWebPage:[NSURL URLWithString:@"https://m.hahaxueche.com/fen-qi-bao"]];
            } break;
                
            default:
                break;
        }
    };
    [self.scrollView addSubview:self.guardView];
    
    
    [self makeConstraints];
}


- (void)makeConstraints {
    
    [self.topContainerView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView.top);
        make.left.equalTo(self.scrollView.left);
        make.width.equalTo(self.scrollView.width);
        make.height.mas_equalTo(170.0f);
    }];

    [self.findJiaxiaoView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topContainerView.left).offset(10.0f);
        make.right.equalTo(self.topContainerView.centerX).offset(-5.0f);
        make.top.equalTo(self.topContainerView.top).offset(15.0f);
        make.height.mas_equalTo(55.0f);
    }];
    
    [self.findCoachView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.findJiaxiaoView.right).offset(10.0f);
        make.width.equalTo(self.findJiaxiaoView.width);
        make.top.equalTo(self.topContainerView.top).offset(15.0f);
        make.height.mas_equalTo(55.0f);
    }];
    
    [self.itemsView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topContainerView.left);
        make.width.equalTo(self.topContainerView.width);
        make.top.equalTo(self.findCoachView.bottom);
        make.bottom.equalTo(self.topContainerView.bottom);
    }];
    
    
    [self.drivingSchoolsView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView.left);
        make.width.equalTo(self.scrollView.width);
        make.top.equalTo(self.topContainerView.bottom).offset(10.0f);
        make.height.mas_equalTo(140.0f);
    }];
    
    [self.coachesView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView.left);
        make.width.equalTo(self.scrollView.width);
        make.top.equalTo(self.drivingSchoolsView.bottom).offset(10.0f);
        make.height.mas_equalTo(160.0f);
    }];
    
    [self.guideView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView.left);
        make.width.equalTo(self.scrollView.width);
        make.top.equalTo(self.coachesView.bottom).offset(10.0f);
        make.height.mas_equalTo(200.0f);
    }];
    
    [self.guardView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView.left);
        make.width.equalTo(self.scrollView.width);
        make.top.equalTo(self.guideView.bottom).offset(10.0f);
        make.height.mas_equalTo(200.0f);
    }];
    
    [self.scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top);
        make.width.equalTo(self.view.width);
        make.left.equalTo(self.view.left);
        make.height.equalTo(self.view.height).offset(-1 * CGRectGetHeight(self.tabBarController.tabBar.bounds));
    }];
    

    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:self.guardView
                                                                attribute:NSLayoutAttributeBottom
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.scrollView
                                                                attribute:NSLayoutAttributeBottom
                                                               multiplier:1.0
                                                                 constant:-10.0f]];

}


- (FLAnimatedImageView *)buildGifViewWithPath:(NSString *)path {
    FLAnimatedImageView *view = [[FLAnimatedImageView alloc] init];
    NSString *imgString = [[NSBundle mainBundle] pathForResource:path ofType:@"gif"];
    NSData *imgData = [NSData dataWithContentsOfFile:imgString];
    FLAnimatedImage *img = [FLAnimatedImage animatedImageWithGIFData:imgData];
    view.animationDuration = 0.1f;
    view.animatedImage = img;
    view.userInteractionEnabled = YES;
    view.contentMode = UIViewContentModeScaleAspectFit;
    return view;
    
}

#pragma mark - Button Actions 

- (void)cityTapped {
    __weak HHHomePageViewController *weakSelf = self;
    NSArray *cities = [[HHConstantsStore sharedInstance] getSupporteCities];
    CGFloat height = MAX(300.0f, CGRectGetHeight(self.view.bounds)/2.0f);
    
    HHCitySelectView *view = [[HHCitySelectView alloc] initWithCities:cities frame:CGRectMake(0, 0, 300.0f, height) selectedCity:[[HHConstantsStore sharedInstance] getCityWithId:[HHStudentStore sharedInstance].selectedCityId]];
    view.completion = ^(HHCity *selectedCity) {
        if (selectedCity) {
            [weakSelf cityChangedWithCity:selectedCity];
        }
        [HHPopupUtility dismissPopup:weakSelf.popup];
    };
    
    self.popup = [HHPopupUtility createPopupWithContentView:view];
    [HHPopupUtility showPopup:self.popup];
}

- (void)navMapTapped {
    [[INTULocationManager sharedInstance] requestLocationWithDesiredAccuracy:INTULocationAccuracyBlock timeout:2.0f delayUntilAuthorized:YES block:^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status) {
        if (status == INTULocationStatusSuccess) {
            [HHStudentStore sharedInstance].currentLocation = currentLocation;
            
        } else if (status == INTULocationStatusTimedOut) {
            [HHStudentStore sharedInstance].currentLocation = currentLocation;
            
        } else if (status == INTULocationStatusError) {
            [HHStudentStore sharedInstance].currentLocation = nil;
        } else {
            [HHStudentStore sharedInstance].currentLocation = nil;
        }
        
        if (![HHStudentStore sharedInstance].currentLocation) {
            HHAskLocationPermissionViewController *vc = [[HHAskLocationPermissionViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            [self showMapView];
        }
    }];
    
    
}

- (void)searchTapped {
    HHSearchViewController *vc = [[HHSearchViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:navVC animated:NO completion:nil];
}

- (void)findCoachViewTapped {
    self.tabBarController.selectedIndex = TabBarItemCoach;
}

- (void)findJiaxiaoViewTapped {
    NSString *url;
    #ifdef DEBUG
        url = kDrivingSchoolPageStaging;
    #else
        url = kDrivingSchoolPage;
    #endif
    [self openWebPage:[NSURL URLWithString:url]];
}

- (void)cityChangedWithCity:(HHCity *)city {
    [HHStudentStore sharedInstance].selectedCityId = city.cityId;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem  buttonItemWithAttrTitle:[self generateAttrStringWithText:city.cityName image:[UIImage imageNamed:@"Triangle"] type:1] action:@selector(cityTapped) target:self isLeft:YES];
    [[HHConstantsStore sharedInstance] getDrivingSchoolsWithCityId:city.cityId completion:^(NSArray *schools) {
        [[HHLoadingViewUtility sharedInstance] dismissLoadingView];
        self.drivingSchools = schools;
        [self.drivingSchoolsView updateData:self.drivingSchools type:CarouselTypeDrivingSchool];
    }];
    

    NSArray *locationArray;
    if ([HHStudentStore sharedInstance].currentLocation) {
        NSNumber *lat = @([HHStudentStore sharedInstance].currentLocation.coordinate.latitude);
        NSNumber *lon = @([HHStudentStore sharedInstance].currentLocation.coordinate.longitude);
        locationArray = @[lat, lon];
    }
    [[HHCoachService sharedInstance] fetchCoachListWithCityId:city.cityId filters:nil sortOption:SortOptionReviewCount userLocation:locationArray fields:nil perPage:nil completion:^(HHCoaches *coaches, NSError *error) {
        if (!error) {
            self.coaches = coaches.coaches;
            [self.coachesView updateData:self.coaches type:CarouselTypeCoach];
            
        }
    }];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cityChanged" object:nil];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:city.cityId forKey:@"userSelectedCity"];

}



- (void)openWebPage:(NSURL *)url {
    HHWebViewController *webVC = [[HHWebViewController alloc] initWithURL:url];
    webVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webVC animated:YES];
}


- (void)showTestVC {
    HHTestStartViewController *vc =  [[HHTestStartViewController alloc] init];
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:navVC animated:YES completion:nil];
    
}

- (void)showShareView {
    [[HHEventTrackingManager sharedManager] eventTriggeredWithId:home_page_voucher_popup_share_tapped attributes:nil];
    __weak HHHomePageViewController *weakSelf = self;
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentCenter;
    NSMutableAttributedString *sting = [[NSMutableAttributedString alloc] initWithString:@"爱分享的人运气一定不会差~\n" attributes:@{NSForegroundColorAttributeName:[UIColor HHOrange], NSFontAttributeName:[UIFont systemFontOfSize:15.0f], NSParagraphStyleAttributeName:style}];
    
    NSMutableAttributedString *sting2 = [[NSMutableAttributedString alloc] initWithString:@"邀请好友领取哈哈学车新人大礼包哟" attributes:@{NSForegroundColorAttributeName:[UIColor HHOrange], NSFontAttributeName:[UIFont systemFontOfSize:14.0f], NSParagraphStyleAttributeName:style}];
    [sting appendAttributedString:sting2];
    
    HHQRCodeShareView *shareView = [[HHQRCodeShareView alloc] initWithTitle:sting qrCodeImg:[[HHSocialMediaShareUtility sharedInstance] generateReferQRCode:NO]];
    shareView.dismissBlock = ^() {
        [HHPopupUtility dismissPopup:weakSelf.popup];
    };
    shareView.selectedBlock = ^(SocialMedia selectedIndex) {
        if (selectedIndex == SocialMediaMessage) {
            [HHPopupUtility dismissPopup:weakSelf.popup];
        }
        [[HHSocialMediaShareUtility sharedInstance] shareMyReferPageWithShareType:selectedIndex inVC:weakSelf resultCompletion:^(BOOL succceed) {
            if (succceed) {
                [[HHEventTrackingManager sharedManager] eventTriggeredWithId:home_page_voucher_popup_share_succeed attributes:@{@"channel": [[HHSocialMediaShareUtility sharedInstance] getChannelNameWithType:selectedIndex]}];
            }
        }];
    };
    self.popup = [HHPopupUtility createPopupWithContentView:shareView showType:KLCPopupShowTypeSlideInFromBottom dismissType:KLCPopupDismissTypeSlideOutToBottom];
    [HHPopupUtility showPopup:self.popup layout:KLCPopupLayoutMake(KLCPopupHorizontalLayoutCenter, KLCPopupVerticalLayoutBottom)];
}

- (NSAttributedString *)generateAttrStringWithText:(NSString *)text image:(UIImage *)image type:(NSInteger)type {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    if (type == 0) {
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"   %@", text] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f], NSForegroundColorAttributeName:[UIColor whiteColor], NSParagraphStyleAttributeName:paragraphStyle}];
        
        NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
        textAttachment.image = image;
        textAttachment.bounds = CGRectMake(5, 0, textAttachment.image.size.width, textAttachment.image.size.height);
        
        NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
        
        [attributedString insertAttributedString:attrStringWithImage atIndex:0];
        return attributedString;
    } else {
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f], NSForegroundColorAttributeName:[UIColor whiteColor], NSParagraphStyleAttributeName:paragraphStyle}];
        
        NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
        textAttachment.image = image;
        textAttachment.bounds = CGRectMake(2.0f, 0, textAttachment.image.size.width, textAttachment.image.size.height);
        
        NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
        
        [attributedString appendAttributedString:attrStringWithImage];
        return attributedString;
    }
    
}

- (void)showMapView {
    [[HHConstantsStore sharedInstance] getFieldsWithCityId:[HHStudentStore sharedInstance].selectedCityId completion:^(NSArray *fields) {
        if (fields.count > 0) {
            HHFieldsMapViewController *vc = [[HHFieldsMapViewController alloc] initWithFields:fields selectedField:nil];
            UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:vc];
            [self presentViewController:navVC animated:YES completion:nil];
        }
    }];
}



@end
