//
//  HHLoginSignupViewController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 7/12/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import "HHLoginSignupViewController.h"
#import "HHAutoLayoutUtility.h"
#import "UIColor+HHColor.h"
#import "HHButton.h"
#import "UIImage+HHImage.h"
#import "HHNavigationController.h"
#import "HHMobilePhoneViewController.h"

@interface HHLoginSignupViewController ()

@property (nonatomic, strong) UIImageView *logoView;
@property (nonatomic, strong) HHButton *signupButton;
@property (nonatomic, strong) HHButton *loginButton;
@property (nonatomic, strong) HHButton *coachButton;

@end

@implementation HHLoginSignupViewController

- (void)viewDidLoad {
    self.view.backgroundColor = [UIColor clearColor];
    [self initSubviews];
}

- (void)initSubviews {
    self.logoView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.logoView.translatesAutoresizingMaskIntoConstraints = NO;
    self.logoView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.logoView];
    
    self.signupButton = [self createBorderButtonWithTitle:@"新用户注册" textColor:[UIColor HHOrange] font:[UIFont fontWithName:@"SourceHanSansSC-Normal" size:18] action:@selector(signup)];
    
    self.loginButton = [self createBorderButtonWithTitle:@"登陆" textColor:[UIColor HHOrange] font:[UIFont fontWithName:@"SourceHanSansSC-Normal" size:18] action:@selector(login)];
    
//    self.coachButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.coachButton setTitle:@"教练注册" forState:UIControlStateNormal];
//    self.coachButton.titleLabel.font = [UIFont fontWithName:@"SourceHanSansSC-Normal" size:12];
//    self.coachButton.translatesAutoresizingMaskIntoConstraints = NO;
//    [self.coachButton sizeToFit];
//    [self.coachButton addTarget:self action:@selector(coachSignup) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:self.coachButton];

    [self autoLayoutSubviews];
    
}

- (HHButton *)createBorderButtonWithTitle:(NSString *)title textColor:(UIColor *)textColor font:(UIFont *)font action:(SEL)action {
    HHButton *button = [[HHButton alloc] initThinBorderButtonWithTitle:title textColor:textColor font:font];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    return button;
}


- (void)autoLayoutSubviews {
    NSArray *constraints = @[
                             [HHAutoLayoutUtility verticalAlignToSuperViewTop:self.logoView constant:80.0f],
                             [HHAutoLayoutUtility setCenterX:self.logoView multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility setViewHeight:self.logoView multiplier:0 constant:100.0f],
                             [HHAutoLayoutUtility setViewWidth:self.logoView multiplier:0 constant:100.0f],
                             
                             [HHAutoLayoutUtility verticalAlignToSuperViewBottom:self.signupButton constant:-100.0f],
                             [HHAutoLayoutUtility setCenterX:self.signupButton multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility setViewHeight:self.signupButton multiplier:0 constant:40.0f],
                             [HHAutoLayoutUtility setViewWidth:self.signupButton multiplier:0 constant:CGRectGetWidth(self.view.bounds)-60.0f],
                             
                             [HHAutoLayoutUtility verticalNext:self.loginButton toView:self.signupButton constant:20.0f],
                             [HHAutoLayoutUtility setCenterX:self.loginButton multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility setViewHeight:self.loginButton multiplier:0 constant:40.0f],
                             [HHAutoLayoutUtility setViewWidth:self.loginButton multiplier:0 constant:CGRectGetWidth(self.view.bounds)-60.0f],
                             
//                             [HHAutoLayoutUtility verticalAlignToSuperViewBottom:self.coachButton constant:-10.0f],
//                             [HHAutoLayoutUtility setCenterX:self.coachButton multiplier:1.0f constant:0],
                             ];
    [self.view addConstraints:constraints];
}

- (void)signup {
    
    HHMobilePhoneViewController *mobilePhoneVC = [[HHMobilePhoneViewController alloc] initWithTitle:@"请输入您的手机号码" subTitle:@"我们绝不会贩卖，滥用你的手机号码"];
    HHNavigationController *navVC = [[HHNavigationController alloc] initWithRootViewController:mobilePhoneVC];
    navVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:navVC animated:YES completion:nil];
}

- (void)login {
    
}

//- (void)coachSignup {
//    
//}


@end
