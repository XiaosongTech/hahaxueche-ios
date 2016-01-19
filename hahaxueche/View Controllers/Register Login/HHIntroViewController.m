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


static CGFloat const kButtonHeight = 40.0f;
static CGFloat const kButtonWidth = 235.0f;
static NSInteger const kBannerImageCount = 4;
static CGFloat const kFloatButtonHeight = 40.0f;

@interface HHIntroViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *bannerScrollView;
@property (nonatomic, strong) HHButton *registerButton;
@property (nonatomic, strong) HHButton *loginButton;
@property (nonatomic, strong) HHButton *enterAsGuestButton;
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, strong) NSMutableArray *bannerImageViews;
@property (nonatomic, strong) UIPageControl * pageControl;


@end

@implementation HHIntroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor HHOrange];
    self.navigationController.navigationBarHidden = YES;
    [self initSubviews];
}

- (void)initSubviews {
    self.bannerScrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    self.bannerScrollView.backgroundColor = [UIColor clearColor];
    self.bannerScrollView.delegate = self;
    self.bannerScrollView.backgroundColor = [UIColor blackColor];
    self.bannerScrollView.scrollEnabled = YES;
    self.bannerScrollView.userInteractionEnabled = YES;
    self.bannerScrollView.pagingEnabled = YES;
    self.bannerScrollView.bounces = NO;
    self.bannerScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.bannerScrollView];
    
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectZero];
    self.pageControl.numberOfPages = kBannerImageCount;
    self.pageControl.currentPage = 0;
    self.pageControl.userInteractionEnabled = NO;
    [self.view addSubview:self.pageControl];
    
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
    
    self.bannerImageViews = [NSMutableArray arrayWithCapacity:kBannerImageCount];
    for (int i = 0; i < kBannerImageCount; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        imageView.backgroundColor = [UIColor clearColor];
        [self.bannerScrollView addSubview:imageView];
        [self.bannerImageViews addObject:imageView];
    }
    
    [self makeConstraints];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

#pragma mark - Auto Layout

- (void)makeConstraints {
    [self.pageControl remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bannerScrollView.bottom).offset(-10.0f);
        make.width.mas_equalTo(80.0f);
        make.height.mas_equalTo(30.0f);
        make.centerX.equalTo(self.view.centerX);
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

    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints {
    for (int i = 0; i < kBannerImageCount; i++) {
        UIImageView *imageView = self.bannerImageViews[i];
        if (i == 0) {
            [imageView makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.bannerScrollView.top);
                make.width.equalTo(self.bannerScrollView.width);
                make.height.equalTo(self.bannerScrollView.height);
                make.left.equalTo(self.bannerScrollView.left);
            }];
        } else {
            UIImageView *preImageView = self.bannerImageViews[i - 1];
            [imageView makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.bannerScrollView.top);
                make.width.equalTo(self.bannerScrollView.width);
                make.height.equalTo(self.bannerScrollView.height);
                make.left.equalTo(preImageView.right);
            }];
        }
    }
    
    CGFloat height = MIN(CGRectGetHeight(self.view.bounds) - 240.0f, CGRectGetWidth(self.view.bounds));
    UIImageView *lastImageView = self.bannerImageViews[kBannerImageCount - 1];
    [self.bannerScrollView remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(CGRectGetHeight([UIApplication sharedApplication].statusBarFrame));
        make.width.equalTo(self.view.width);
        make.height.mas_equalTo(height);
        make.right.equalTo(lastImageView.right);
    }];
    
    [super updateViewConstraints];
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
    HHRootViewController *rootVC = [[HHRootViewController alloc] init];
    [self presentViewController:rootVC animated:YES completion:nil];
}

#pragma mark - UIScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = CGRectGetWidth(self.bannerScrollView.bounds);
    float fractionalPage = self.bannerScrollView.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    self.pageControl.currentPage = page;
}

@end
