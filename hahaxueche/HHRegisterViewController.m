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
#import "HHPhoneNumberUtility.h"
#import "UIBarButtonItem+HHCustomButton.h"
#import "HHToastManager.h"
#import "HHAccountSetupViewController.h"


static CGFloat const kFieldViewHeight = 40.0f;
static CGFloat const kFieldViewWidth = 280.0f;
static NSInteger const kSendCodeGap = 60;
static NSInteger const pwdLimit = 20;

@interface HHRegisterViewController () <UITextFieldDelegate>

@property (nonatomic, strong) HHTextFieldView *phoneNumberField;
@property (nonatomic, strong) HHTextFieldView *verificationCodeField;
@property (nonatomic, strong) HHTextFieldView *pwdField;
@property (nonatomic, strong) HHButton *nextButton;
@property (nonatomic, strong) HHButton *sendCodeButton;
@property (nonatomic, strong) UIImageView *bachgroudImageView;

@property (nonatomic) NSInteger countDown;
@property (nonatomic) NSTimer *timer;

@end

@implementation HHRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    self.title = @"注册";
    self.view.backgroundColor = [UIColor HHOrange];
    self.countDown = kSendCodeGap;
    
    UIBarButtonItem *backBarButton = [UIBarButtonItem buttonItemWithImage:[UIImage imageNamed:@"ic_arrow_back"] action:@selector(popupVC) target:self];
    self.navigationItem.leftBarButtonItem = backBarButton;
    
    [self initSubviews];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.phoneNumberField.textField becomeFirstResponder];
}

- (void)initSubviews {
    self.phoneNumberField = [[HHTextFieldView alloc] initWithPlaceHolder:@"请输入手机号"];
    self.phoneNumberField.layer.cornerRadius = kFieldViewHeight/2.0f;
    self.phoneNumberField.textField.returnKeyType = UIReturnKeyDone;
    self.phoneNumberField.textField.keyboardType = UIKeyboardTypeNumberPad;
    self.phoneNumberField.textField.delegate = self;
    [self.view addSubview:self.phoneNumberField];
    
    self.nextButton = [[HHButton alloc] initWithFrame:CGRectZero];
    [self.nextButton HHWhiteBorderButton];
    self.nextButton.layer.cornerRadius = kFieldViewHeight/2.0f;
    [self.nextButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.nextButton addTarget:self action:@selector(verifyPhoneNumber) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.nextButton];
    
    self.bachgroudImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"onboard_bg"]];
    [self.view addSubview:self.bachgroudImageView];
    [self.view sendSubviewToBack:self.bachgroudImageView];
    
    [self makeConstraints];
}

- (void)showMoreFields {
    
    [self.nextButton setTitle:@"完成" forState:UIControlStateNormal];
    [self.nextButton removeTarget:self action:@selector(verifyPhoneNumber) forControlEvents:UIControlEventTouchUpInside];
    [self.nextButton addTarget:self action:@selector(doneButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    
    self.sendCodeButton = [[HHButton alloc] init];
    NSString *countDownString = [NSString stringWithFormat:@"%ld 秒", self.countDown];
    [self.sendCodeButton setTitle:countDownString forState:UIControlStateNormal];
    self.sendCodeButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    [self.sendCodeButton setTitleColor:[UIColor HHLightOrange] forState:UIControlStateNormal];
    [self.sendCodeButton addTarget:self action:@selector(sendCode) forControlEvents:UIControlEventTouchUpInside];
    self.verificationCodeField = [[HHTextFieldView alloc] initWithPlaceHolder:@"请输入短信验证码" rightView:self.sendCodeButton showSeparator:YES];
    self.timer = [NSTimer scheduledTimerWithTimeInterval: 1.0 target:self selector:@selector(updateCountdown) userInfo:nil repeats: YES];
    self.verificationCodeField.layer.cornerRadius = kFieldViewHeight/2.0f;
    self.verificationCodeField.textField.returnKeyType = UIReturnKeyNext;
    self.verificationCodeField.textField.keyboardType = UIKeyboardTypeNumberPad;
    self.verificationCodeField.textField.delegate = self;
    [self.view addSubview:self.verificationCodeField];

    
    self.pwdField = [[HHTextFieldView alloc] initWithPlaceHolder:@"请设置6-20位密码"];
    self.pwdField.layer.cornerRadius = kFieldViewHeight/2.0f;
    self.pwdField.textField.returnKeyType = UIReturnKeyDone;
    self.pwdField.textField.delegate = self;
    [self.view addSubview:self.pwdField];

    [self updateConstraintsAfterMoreFields];
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
    
    [self.bachgroudImageView makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view.centerY);
        make.centerX.equalTo(self.view.centerX);
        make.width.equalTo(self.view);
        make.height.equalTo(self.view);
    }];
}


- (void)updateConstraintsAfterMoreFields {
    [self.verificationCodeField makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneNumberField.bottom).offset(15.0f);
        make.centerX.equalTo(self.phoneNumberField.centerX);
        make.width.mas_equalTo(kFieldViewWidth);
        make.height.mas_equalTo(kFieldViewHeight);
        
    }];
    
    [self.pwdField makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.verificationCodeField.bottom).offset(15.0f);
        make.centerX.equalTo(self.verificationCodeField.centerX);
        make.width.mas_equalTo(kFieldViewWidth);
        make.height.mas_equalTo(kFieldViewHeight);
        
    }];
    
    [self.nextButton remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.pwdField.bottom).offset(15.0f);
        make.centerX.equalTo(self.view.centerX);
        make.width.mas_equalTo(kFieldViewWidth);
        make.height.mas_equalTo(kFieldViewHeight);
    }];
    
}

#pragma mark - Button Actions

- (void)verifyPhoneNumber {
    if ([[HHPhoneNumberUtility sharedInstance] isValidPhoneNumber:self.phoneNumberField.textField.text]) {
        [self showMoreFields];
        [self.phoneNumberField.textField resignFirstResponder];
        [self.verificationCodeField.textField becomeFirstResponder];
    } else {
        [[HHToastManager sharedManager] showErrorToastWithText:@"无效手机号，请自己核对！"];
    }
}

- (void)doneButtonTapped {
    HHAccountSetupViewController *setupVC = [[HHAccountSetupViewController alloc] init];
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:setupVC];
    [self presentViewController:navVC animated:YES completion:nil];
}

- (void)updateCountdown {
    self.countDown--;
    if (self.countDown == 0) {
        self.sendCodeButton.enabled = YES;
        [self.sendCodeButton setTitle:@"重发" forState:UIControlStateNormal];
        [self.sendCodeButton setTitleColor:[UIColor HHOrange] forState:UIControlStateNormal];
        self.countDown = kSendCodeGap;
        [self.timer invalidate];
        self.timer = nil;
    } else {
        NSString *countDownString = [NSString stringWithFormat:@"%ld 秒", self.countDown];
        [self.sendCodeButton setTitle:countDownString forState:UIControlStateNormal];
    }
    
}

- (void)sendCode {
    NSString *countDownString = [NSString stringWithFormat:@"%ld 秒", self.countDown];
    [self.sendCodeButton setTitle:countDownString forState:UIControlStateNormal];
    [self.sendCodeButton setTitleColor:[UIColor HHLightOrange] forState:UIControlStateNormal];
    self.timer = [NSTimer scheduledTimerWithTimeInterval: 1.0 target:self selector:@selector(updateCountdown) userInfo:nil repeats: YES];
    self.sendCodeButton.enabled = NO;
}

#pragma mark - TextField Delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField isEqual:self.phoneNumberField.textField]) {
        [self verifyPhoneNumber];
    } else if ([textField isEqual:self.verificationCodeField.textField]) {
        [self.verificationCodeField.textField resignFirstResponder];
        [self.pwdField.textField becomeFirstResponder];
    } else if ([textField isEqual:self.pwdField.textField]) {
        [self doneButtonTapped];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([textField isEqual:self.pwdField.textField]) {
        if(range.length + range.location > textField.text.length) {
            return NO;
        }
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return newLength <= pwdLimit;
    }
    return YES;
}

- (void)popupVC {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
