//
//  HHIntroViewController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 1/1/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHIntroViewController.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"
#import "HHButton.h"
#import "HHRegisterViewController.h"
#import "HHLoginViewController.h"
#import "UIView+HHRect.h"
#import "HHRootViewController.h"
#import <SDCycleScrollView/SDCycleScrollView.h>
#import "HHStudentStore.h"


static CGFloat const kButtonHeight = 40.0f;
static CGFloat const kButtonWidth = 235.0f;

@interface HHIntroViewController () <SDCycleScrollViewDelegate>

@property (nonatomic, strong) HHButton *registerButton;
@property (nonatomic, strong) HHButton *loginButton;
@property (nonatomic, strong) HHButton *enterAsGuestButton;
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, strong) SDCycleScrollView *bannerView;

@end

@implementation HHIntroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor HHOrange];
    self.navigationController.navigationBarHidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self initSubviews];
}

- (void)initSubviews {
    self.bannerView = [[SDCycleScrollView alloc] init];
    self.bannerView.delegate = self;
    self.bannerView.imageURLStringsGroup = @[@"http://i.forbesimg.com/media/lists/companies/facebook_416x416.jpg",@"https://upload.wikimedia.org/wikipedia/commons/thumb/1/1b/Facebook_icon.svg/2000px-Facebook_icon.svg.png"];
    self.bannerView.autoScroll = NO;
    [self.view addSubview:self.bannerView];
    
    self.registerButton = [[HHButton alloc] initWithFrame:CGRectZero];
    [self.registerButton HHWhiteBorderButton];
    [self.registerButton setTitle:@"注册" forState:UIControlStateNormal];
    self.registerButton.layer.cornerRadius = kButtonHeight/2.0f;
    [self.registerButton addTarget:self action:@selector(jumpToRegisterVC) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.registerButton];
    
    self.loginButton = [[HHButton alloc] initWithFrame:CGRectZero];
    [self.loginButton HHWhiteBorderButton];
    [self.loginButton setTitle:@"登录" forState:UIControlStateNormal];
    self.loginButton.layer.cornerRadius = kButtonHeight/2.0f;
     [self.loginButton addTarget:self action:@selector(jumpToLoginVC) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.loginButton];
    
    self.bottomLine = [[UIView alloc] initWithFrame:CGRectZero];
    self.bottomLine.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.bottomLine];
    
    
    self.enterAsGuestButton = [[HHButton alloc] initWithFrame:CGRectZero];
    [self.enterAsGuestButton setTitle:@"进去逛逛" forState:UIControlStateNormal];
    self.enterAsGuestButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [self.enterAsGuestButton sizeToFit];
    [self.enterAsGuestButton addTarget:self action:@selector(enterAsGuest) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.enterAsGuestButton];
    
    [self makeConstraints];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

#pragma mark - Auto Layout

- (void)makeConstraints {
    CGFloat height = MIN(CGRectGetHeight(self.view.bounds) - 240.0f, CGRectGetWidth(self.view.bounds));
    [self.bannerView makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(CGRectGetHeight([UIApplication sharedApplication].statusBarFrame));
        make.width.equalTo(self.view.width);
        make.height.mas_equalTo(height);
        make.left.equalTo(self.view.left);
    }];
    
    [self.registerButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.bottom).offset(-180.0f);
        make.width.mas_equalTo(kButtonWidth);
        make.height.mas_equalTo(kButtonHeight);
        make.centerX.equalTo(self.view.centerX);
    }];
    
    [self.loginButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.registerButton.bottom).offset(15.0f);
        make.width.equalTo(self.registerButton.width);
        make.height.equalTo(self.registerButton.height);
        make.centerX.equalTo(self.registerButton.centerX);
    }];
    
    [self.bottomLine makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.loginButton.bottom).offset(35.0f);
        make.width.equalTo(self.registerButton.width);
        make.height.mas_equalTo(2.0f/[UIScreen mainScreen].scale);
        make.centerX.equalTo(self.registerButton.centerX);
    }];
    
    [self.enterAsGuestButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomLine.bottom).offset(5.0f);
        make.width.mas_equalTo(150.0f);
        make.centerX.equalTo(self.view.centerX);
    }];

}


#pragma mark - Button Actions

- (void)jumpToRegisterVC {
    HHRegisterViewController *registerVC = [[HHRegisterViewController alloc] init];
    [self.navigationController pushViewController:registerVC animated:YES];
}

- (void)jumpToLoginVC {
    HHLoginViewController *loginVC = [[HHLoginViewController alloc] init];
    [self.navigationController pushViewController:loginVC animated:YES];
}

- (void)enterAsGuest {
    [[HHStudentStore sharedInstance] createGuestStudent];
    HHRootViewController *rootVC = [[HHRootViewController alloc] init];
    [self presentViewController:rootVC animated:YES completion:nil];
}

#pragma mark - Banner View Delegate Method

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    
}

@end
