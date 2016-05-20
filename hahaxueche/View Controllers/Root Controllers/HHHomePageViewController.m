//
//  HHHomePageViewController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 1/10/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHHomePageViewController.h"
#import <SDCycleScrollView/SDCycleScrollView.h>
#import "HHHomePageTapView.h"
#import "Masonry.h"
#import "UIColor+HHColor.h"
#import "HHStudentStore.h"
#import "HHCitySelectView.h"
#include "HHConstantsStore.h"
#import "HHPopupUtility.h"
#import <KLCPopup/KLCPopup.h>
#import "HHCoachService.h"
#import "HHLoadingViewUtility.h"
#import "HHToastManager.h"
#import "INTULocationManager.h"
#import "HHFindCoachViewController.h"
#import "HHCoachDetailViewController.h"
#import "HHWebViewController.h"
#import "HHGenericOneButtonPopupView.h"
#import "NSNumber+HHNumber.h"
#import "HHRootViewController.h"
#import "HHReferFriendsViewController.h"
#import "HHGroupPurchaseView.h"
#import "HHStudentService.h"

static NSString *const kAboutStudentLink = @"http://staging.hahaxueche.net/#/student";
static NSString *const kAboutCoachLink = @"http://staging.hahaxueche.net/#/coach";


@interface HHHomePageViewController () <SDCycleScrollViewDelegate>

@property (nonatomic, strong) SDCycleScrollView *bannerView;
@property (nonatomic, strong) HHHomePageTapView *leftView;
@property (nonatomic, strong) HHHomePageTapView *rightView;
@property (nonatomic, strong) UIButton *oneTapButton;
@property (nonatomic, strong) HHCitySelectView *citySelectView;
@property (nonatomic, strong) KLCPopup *popup;
@property (nonatomic, strong) CLLocation *userLocation;
@property (nonatomic, strong) NSArray *banners;

@end

@implementation HHHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"哈哈学车";
    self.view.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.banners = [[HHConstantsStore sharedInstance] getHomePageBanners];
    [self initSubviews];
    
    __weak HHHomePageViewController *weakSelf = self;
    NSArray *cities = [[HHConstantsStore sharedInstance] getSupporteCities];
    if ([cities count]) {
        // Guest Student
        if (![HHStudentStore sharedInstance].currentStudent.cityId) {
            CGFloat height = MAX(300.0f, CGRectGetHeight(weakSelf.view.bounds)/2.0f);
            weakSelf.citySelectView = [[HHCitySelectView alloc] initWithCities:cities frame:CGRectMake(0, 0, 300.0f, height) selectedCity:nil];
            weakSelf.citySelectView.completion = ^(HHCity *selectedCity) {
                [HHStudentStore sharedInstance].currentStudent.cityId = selectedCity.cityId;
                [HHPopupUtility dismissPopup:weakSelf.popup];
            };
            [HHStudentStore sharedInstance].currentStudent.cityId = @(0);
            weakSelf.popup = [HHPopupUtility createPopupWithContentView:weakSelf.citySelectView];
            [weakSelf.popup show];
        }
    }

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *isShowed = [defaults objectForKey:@"showedBonusPopoup"];

    if (![isShowed boolValue] && [[HHStudentStore sharedInstance].currentStudent.byReferal boolValue] && [HHStudentStore sharedInstance].currentStudent.studentId) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentLeft;
        paragraphStyle.lineSpacing = 8.0f;
        NSNumber *refereeBonus = [[[HHConstantsStore sharedInstance] getAuthedUserCity] getRefereeBonus];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@元已经打进您的账户余额, 在支付过程中, 系统会自动减现%@元报名费.", [refereeBonus generateMoneyString], [refereeBonus generateMoneyString]] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0f], NSForegroundColorAttributeName:[UIColor HHLightTextGray], NSParagraphStyleAttributeName:paragraphStyle}];
        
        __weak HHHomePageViewController *weakSelf = self;
        HHGenericOneButtonPopupView *view = [[HHGenericOneButtonPopupView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds) - 20.0f, 280.0f) title:@"注册成功!" subTitle:[NSString stringWithFormat:@"恭喜您获得%@元学车券!",[refereeBonus generateMoneyString] ] info:attributedString];
        view.cancelBlock = ^() {
            [HHPopupUtility dismissPopup:weakSelf.popup];
        };
        self.popup = [HHPopupUtility createPopupWithContentView:view];
        [HHPopupUtility showPopup:self.popup];
        [defaults setObject:@(1) forKey:@"showedBonusPopoup"];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];   //it hides
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];    // it shows
}

- (void)initSubviews {
    
    __weak HHHomePageViewController *weakSelf = self;
    self.bannerView = [[SDCycleScrollView alloc] init];
    self.bannerView.imageURLStringsGroup = self.banners;
    self.bannerView.autoScroll = YES;
    self.bannerView.autoScrollTimeInterval = 3.0f;
    self.bannerView.delegate = self;
    self.bannerView.bannerImageViewContentMode = UIViewContentModeScaleAspectFit;
    self.bannerView.backgroundColor = [UIColor HHOrange];
    self.bannerView.pageDotColor = [UIColor colorWithWhite:1.0f alpha:0.5f];
    self.bannerView.currentPageDotColor = [UIColor whiteColor];
    [self.view addSubview:self.bannerView];
    
    self.leftView = [[HHHomePageTapView alloc] initWithImage:[UIImage imageNamed:@"ic_homepage_hahahere"] title:@"关于小哈" subTitle:@"点击了解"];
    self.leftView.actionBlock = ^() {
        [weakSelf openWebPage:[NSURL URLWithString:kAboutStudentLink]];
    };
    [self.view addSubview:self.leftView];
    
    self.rightView = [[HHHomePageTapView alloc] initWithImage:[UIImage imageNamed:@"ic_homepage_coachhere"] title:@"关于教练" subTitle:@"点击了解"];
    self.rightView.actionBlock = ^() {
        [weakSelf openWebPage:[NSURL URLWithString:kAboutCoachLink]];
    };
    [self.view addSubview:self.rightView];
    
    self.oneTapButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.oneTapButton setTitle:@"一键选教练" forState:UIControlStateNormal];
    [self.oneTapButton setBackgroundColor:[UIColor HHOrange]];
    [self.oneTapButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.oneTapButton addTarget:self action:@selector(oneTapButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    self.oneTapButton.titleLabel.font = [UIFont systemFontOfSize:30.0f];
    [self.view addSubview:self.oneTapButton];
    
    [self makeConstraints];
}

- (void)makeConstraints {
    [self.bannerView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top);
        make.left.equalTo(self.view.left);
        make.width.equalTo(self.view.width);
        make.height.mas_equalTo(CGRectGetHeight(self.view.bounds) - 300.0f);
    }];
    
    [self.leftView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bannerView.bottom).offset(15.0f);
        make.left.equalTo(self.view.left).offset(15.0f);
        make.width.mas_equalTo((CGRectGetWidth(self.view.bounds) - 15.0f * 3)/2.0f);
        make.height.mas_equalTo(100.0f);
    }];
    
    [self.rightView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bannerView.bottom).offset(15.0f);
        make.left.equalTo(self.leftView.right).offset(15.0f);
        make.width.mas_equalTo((CGRectGetWidth(self.view.bounds) - 15.0f * 3)/2.0f);
        make.height.mas_equalTo(100.0f);
    }];
    
    [self.oneTapButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.leftView.bottom).offset(20.0f);
        make.left.equalTo(self.view.left).offset(15.0f);
        make.width.equalTo(self.view.width).offset(-30.0f);
        make.height.mas_equalTo(75.0f);
    }];
}

#pragma mark - Button Actions 

- (void)oneTapButtonTapped {
    if (self.userLocation) {
        [self getCoach];
        return;
    }
    
    [[INTULocationManager sharedInstance] requestLocationWithDesiredAccuracy:INTULocationAccuracyBlock timeout:10.0f delayUntilAuthorized:YES block:^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status) {
        
        if (status == INTULocationStatusSuccess) {
            self.userLocation = currentLocation;
            [self getCoach];
            
        } else if (status == INTULocationStatusServicesDenied){
            self.userLocation = nil;
            [self showAlertForPermission];
            
        } else if (status == INTULocationStatusError) {
            [[HHToastManager sharedManager] showErrorToastWithText:@"出错了，请重试"];
            self.userLocation = nil;
        }
        
    }];
   
}

- (void)getCoach {
    [[HHLoadingViewUtility sharedInstance] showLoadingViewWithText:@"寻找教练中"];
    
    NSNumber *lat = @(self.userLocation.coordinate.latitude);
    NSNumber *lon = @(self.userLocation.coordinate.longitude);
    NSArray *locationArray = @[lat, lon];
    [[HHCoachService sharedInstance] oneClickFindCoachWithLocation:locationArray completion:^(HHCoach *coach, NSError *error) {
        [[HHLoadingViewUtility sharedInstance] dismissLoadingView];
        if (!error) {
            if (coach.coachId) {
                HHCoachDetailViewController *vc = [[HHCoachDetailViewController alloc] initWithCoach:coach];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            } else {
                [[HHToastManager sharedManager] showErrorToastWithText:@"非常抱歉，没有在您周围找到合适的教练！"];
            }
        } else {
            [[HHToastManager sharedManager] showErrorToastWithText:@"出错了，请重试！"];
        }
    }];
}

- (void)showAlertForPermission {
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"哈哈学车需要您的地理位置信息"
                                          message:@"为了更好的帮助您找到最合适的教练，我们需要您开启地理位置功能。"
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:@"暂时不开"
                                   style:UIAlertActionStyleCancel
                                   handler:nil];
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:@"去开启"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action) {
                                   NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                                   [[UIApplication sharedApplication] openURL:url];
                                   [self.navigationController popViewControllerAnimated:YES];
                               }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    switch (index) {
        case 0: {
            __weak HHHomePageViewController *weakSelf = self;
            HHGroupPurchaseView *view = [[HHGroupPurchaseView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds)-20.0f, 430.0f)];
            view.cancelBlock = ^() {
                [HHPopupUtility dismissPopup:weakSelf.popup];
            };
            
            view.confirmBlock = ^(NSString *name, NSString *number) {
                [[HHStudentService sharedInstance] signupGroupPurchaseWithName:name number:number completion:^(NSError *error) {
                    if (!error) {
                        [HHPopupUtility dismissPopup:weakSelf.popup];
                        [[HHToastManager sharedManager] showSuccessToastWithText:@"恭喜您, 团购抢购成功!"];
                    } else {
                        if ([error.localizedFailureReason isEqual:@(40022)]) {
                            [[HHToastManager sharedManager] showErrorToastWithText:@"已经提交成功, 无需重复提交"];
                        } else {
                            [[HHToastManager sharedManager] showErrorToastWithText:@"出错了, 请重试!"];
                        }
                        
                    }
                }];
                [HHPopupUtility dismissPopup:weakSelf.popup];
            };
            self.popup = [HHPopupUtility createPopupWithContentView:view];
            [HHPopupUtility showPopup:self.popup layout:KLCPopupLayoutMake(KLCPopupHorizontalLayoutCenter, KLCPopupVerticalLayoutCenter)];
        } break;
            
        case 1: {
            self.tabBarController.selectedIndex = TabBarItemCoach;
        } break;
            
        case 2: {
            self.tabBarController.selectedIndex = TabBarItemMyPage;
            if ([HHStudentStore sharedInstance].currentStudent.studentId) {
                HHReferFriendsViewController *vc = [[HHReferFriendsViewController alloc] init];
                UINavigationController *navVC = self.tabBarController.selectedViewController;
                [navVC pushViewController:vc animated:YES];
            }
        } break;
            
        case 3: {
            [self openWebPage:[NSURL URLWithString:kAboutStudentLink]];
        } break;
        
        case 4: {
            [self openWebPage:[NSURL URLWithString:kAboutCoachLink]];
        } break;
            
        default:
            break;
    }
}

- (void)openWebPage:(NSURL *)url {
    HHWebViewController *webVC = [[HHWebViewController alloc] initWithURL:url];
    webVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webVC animated:YES];
   
}


@end
