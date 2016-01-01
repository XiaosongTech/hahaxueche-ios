//
//  HHRegisterViewController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 1/1/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHRegisterViewController.h"
#import "UIColor+HHColor.h"
#import "HHTextFieldView.h"
#import "Masonry.h"
#import "HHButton.h"

static CGFloat const kFieldViewHeight = 40.0f;
static CGFloat const kFieldViewWidth = 280.0f;

@interface HHRegisterViewController ()

@property (nonatomic, strong) HHTextFieldView *phoneNumberField;
@property (nonatomic, strong) HHButton *nextButton;

@end

@implementation HHRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    self.title = @"注册";
    self.view.backgroundColor = [UIColor HHOrange];
    
    [self initSubviews];
}

- (void)initSubviews {
    self.phoneNumberField = [[HHTextFieldView alloc] initWithPlaceHolder:@"请输入手机号"];
    self.phoneNumberField.layer.cornerRadius = kFieldViewHeight/2.0f;
    [self.view addSubview:self.phoneNumberField];
    
    self.nextButton = [[HHButton alloc] initWithFrame:CGRectZero];
    [self.nextButton HHWhiteBorderButton];
    self.nextButton.layer.cornerRadius = kFieldViewHeight/2.0f;
    [self.nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [self.nextButton addTarget:self action:@selector(verifyPhoneNumber) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.nextButton];
    
    [self makeConstraints];
}

#pragma mark - Auto Layout

- (void)makeConstraints {
    [self.phoneNumberField makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top).offset(30.0f);
        make.centerX.equalTo(self.view.centerX);
        make.width.mas_equalTo(kFieldViewWidth);
        make.height.mas_equalTo(kFieldViewHeight);
        
    }];
    
    [self.nextButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneNumberField.bottom).offset(15.0f);
        make.centerX.equalTo(self.view.centerX);
        make.width.mas_equalTo(kFieldViewWidth);
        make.height.mas_equalTo(kFieldViewHeight);
    }];
}

#pragma mark - Button Actions

- (void)verifyPhoneNumber {
    
}

@end
