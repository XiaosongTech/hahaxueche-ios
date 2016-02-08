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

@interface HHHomePageViewController ()

@property (nonatomic, strong) SDCycleScrollView *bannerView;
@property (nonatomic, strong) HHHomePageTapView *leftView;
@property (nonatomic, strong) HHHomePageTapView *rightView;
@property (nonatomic, strong) UIButton *oneTapButton;
@property (nonatomic, strong) HHCitySelectView *citySelectView;
@property (nonatomic, strong) KLCPopup *popup;

@end

@implementation HHHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"哈哈学车";
    self.view.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self initSubviews];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *citySelectShowed = [defaults objectForKey:@"kGuestUserCitySelectShowed"];
    if ([citySelectShowed boolValue]) {
        return;
    }
    __weak HHHomePageViewController *weakSelf = self;
    [[HHConstantsStore sharedInstance] getConstantsWithCompletion:^(HHConstants *constants) {
        if ([constants.cities count]) {
            // Guest Student
            if (![HHStudentStore sharedInstance].currentStudent.studentId) {
                CGFloat height = MAX(300.0f, CGRectGetHeight(weakSelf.view.bounds)/2.0f);
                weakSelf.citySelectView = [[HHCitySelectView alloc] initWithCities:constants.cities frame:CGRectMake(0, 0, 300.0f, height) selectedCity:nil];
                weakSelf.citySelectView.completion = ^(HHCity *selectedCity) {
                    [HHStudentStore sharedInstance].currentStudent.cityId = selectedCity.cityId;
                    [HHPopupUtility dismissPopup:weakSelf.popup];
                };
                weakSelf.popup = [HHPopupUtility createPopupWithContentView:weakSelf.citySelectView];
                [weakSelf.popup show];
                [defaults setObject:@(1) forKey:@"kGuestUserCitySelectShowed"];
            }
        }
    }];
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
    self.bannerView = [[SDCycleScrollView alloc] init];
    self.bannerView.imageURLStringsGroup = @[@"http://i.forbesimg.com/media/lists/companies/facebook_416x416.jpg",@"https://upload.wikimedia.org/wikipedia/commons/thumb/1/1b/Facebook_icon.svg/2000px-Facebook_icon.svg.png"];
    self.bannerView.autoScroll = NO;
    self.bannerView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.bannerView];
    
    self.leftView = [[HHHomePageTapView alloc] initWithImage:[UIImage imageNamed:@"ic_homepage_hahahere"] title:@"关于小哈" subTitle:@"点击了解"];
    self.leftView.actionBlock = ^() {
        
    };
    [self.view addSubview:self.leftView];
    
    self.rightView = [[HHHomePageTapView alloc] initWithImage:[UIImage imageNamed:@"ic_homepage_coachhere"] title:@"关于教练" subTitle:@"点击了解"];
    self.rightView.actionBlock = ^() {
        
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
    
}

@end
