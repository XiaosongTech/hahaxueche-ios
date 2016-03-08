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
    self.bannerView.autoScroll = NO; 
    self.bannerView.delegate = self;
    self.bannerView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
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
    if (index == 0) {
        [self openWebPage:[NSURL URLWithString:kAboutStudentLink]];
    } else if (index == 1) {
        [self openWebPage:[NSURL URLWithString:kAboutCoachLink]];
    }
}

- (void)openWebPage:(NSURL *)url {
    HHWebViewController *webVC = [[HHWebViewController alloc] initWithURL:url];
    webVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webVC animated:YES];
   
}


@end
