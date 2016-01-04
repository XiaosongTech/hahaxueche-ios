//
//  HHLoginViewController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 1/3/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHLoginViewController.h"
#import "UIColor+HHColor.h"
#import "UIBarButtonItem+HHCustomButton.h"
#import "Masonry.h"
#import "HHTextFieldView.h"
#import "HHButton.h"
#import "HHPhoneNumberUtility.h"
#import "HHToastManager.h"

typedef NS_ENUM(NSInteger, LoginMode) {
    LoginModeVerificationCode,
    LoginModePWD
};

static CGFloat const kFieldViewHeight = 40.0f;
static CGFloat const kFieldViewWidth = 280.0f;
static NSInteger const kSendCodeGap = 5;
static NSInteger const pwdLimit = 20;

@interface HHLoginViewController () <UITextFieldDelegate>

@property (nonatomic, strong) HHTextFieldView *phoneNumberField;
@property (nonatomic, strong) HHTextFieldView *verificationCodeField;
@property (nonatomic, strong) HHTextFieldView *pwdField;
@property (nonatomic, strong) HHButton *finishButton;
@property (nonatomic, strong) HHButton *swichLoginModeButton;
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic) LoginMode currentLoginMode;
@property (nonatomic, strong) HHButton *sendCodeButton;
@property (nonatomic) NSInteger countDown;
@property (nonatomic) NSTimer *timer;

@end

@implementation HHLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    self.view.backgroundColor = [UIColor HHOrange];
    self.countDown = kSendCodeGap;
    
    UIBarButtonItem *backBarButton = [UIBarButtonItem buttonItemWithImage:[UIImage imageNamed:@"ic_arrow_back"] action:@selector(popupVC) target:self];
    self.navigationItem.leftBarButtonItem = backBarButton;
    
    [self initSubviews];
    
    self.currentLoginMode = LoginModeVerificationCode;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.phoneNumberField.textField becomeFirstResponder];
}

- (void)setCurrentLoginMode:(LoginMode)currentLoginMode {
    _currentLoginMode = currentLoginMode;
    switch (currentLoginMode) {
        case LoginModeVerificationCode: {
            self.navigationItem.rightBarButtonItem = nil;
            self.title = @"验证码登陆";
            self.pwdField.hidden = YES;
            self.verificationCodeField.hidden = NO;
            [self.swichLoginModeButton setTitle:@"使用密码登陆" forState:UIControlStateNormal];
            self.verificationCodeField.hidden = YES;
            [self.finishButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        } break;

        case LoginModePWD: {
            self.pwdField.hidden = NO;
            self.verificationCodeField.hidden = YES;
            UIBarButtonItem *forgetPWDButton = [UIBarButtonItem buttonItemWithTitle:@"忘记密码" titleColor:[UIColor colorWithRed:1 green:0.89 blue:0.75 alpha:1] action:@selector(forgetPWD) target:self isLeft:NO];
            self.navigationItem.rightBarButtonItem = forgetPWDButton;
            self.title = @"密码登陆";
            [self.swichLoginModeButton setTitle:@"使用验证码登陆" forState:UIControlStateNormal];
            [self.finishButton setTitle:@"登录" forState:UIControlStateNormal];
        } break;
            
        default:
            break;
    }
}

- (void)initSubviews {
    self.phoneNumberField = [[HHTextFieldView alloc] initWithPlaceHolder:@"请输入手机号"];
    self.phoneNumberField.layer.cornerRadius = kFieldViewHeight/2.0f;
    self.phoneNumberField.textField.returnKeyType = UIReturnKeyDone;
    self.phoneNumberField.textField.keyboardType = UIKeyboardTypeNumberPad;
    self.phoneNumberField.textField.delegate = self;
    [self.view addSubview:self.phoneNumberField];
    
    self.finishButton = [[HHButton alloc] init];
    [self.finishButton HHWhiteBorderButton];
    [self.finishButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    self.finishButton.layer.cornerRadius = kFieldViewHeight/2.0f;
    self.finishButton.layer.masksToBounds = YES;
    [self.finishButton addTarget:self action:@selector(finishButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.finishButton];
    
    self.bottomLine = [[UIView alloc] initWithFrame:CGRectZero];
    self.bottomLine.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.bottomLine];
    
    self.swichLoginModeButton = [[HHButton alloc] init];
    [self.swichLoginModeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.swichLoginModeButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [self.swichLoginModeButton addTarget:self action:@selector(swithMode) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.swichLoginModeButton];
    
    self.sendCodeButton = [[HHButton alloc] init];
    NSString *countDownString = [NSString stringWithFormat:@"%ld 秒", self.countDown];
    [self.sendCodeButton setTitle:countDownString forState:UIControlStateNormal];
    self.sendCodeButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    [self.sendCodeButton setTitleColor:[UIColor HHLightOrange] forState:UIControlStateNormal];
    [self.sendCodeButton addTarget:self action:@selector(sendCode) forControlEvents:UIControlEventTouchUpInside];
    self.verificationCodeField = [[HHTextFieldView alloc] initWithPlaceHolder:@"请输入短信验证码" rightView:self.sendCodeButton showSeparator:YES];
    self.verificationCodeField.layer.cornerRadius = kFieldViewHeight/2.0f;
    self.verificationCodeField.textField.returnKeyType = UIReturnKeyNext;
    self.verificationCodeField.textField.keyboardType = UIKeyboardTypeNumberPad;
    self.verificationCodeField.textField.delegate = self;
    [self.view addSubview:self.verificationCodeField];
    
    
    self.pwdField = [[HHTextFieldView alloc] initWithPlaceHolder:@"请输入密码"];
    self.pwdField.layer.cornerRadius = kFieldViewHeight/2.0f;
    self.pwdField.textField.returnKeyType = UIReturnKeyDone;
    self.pwdField.textField.delegate = self;
    [self.view addSubview:self.pwdField];

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
    
    [self.finishButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneNumberField.bottom).offset(15.0f);
        make.centerX.equalTo(self.view.centerX);
        make.width.mas_equalTo(kFieldViewWidth);
        make.height.mas_equalTo(kFieldViewHeight);
    }];
    
    [self.bottomLine makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.finishButton.bottom).offset(35.0f);
        make.width.equalTo(self.finishButton.width);
        make.height.mas_equalTo(2.0f/[UIScreen mainScreen].scale);
        make.centerX.equalTo(self.finishButton.centerX);
    }];
    
    [self.swichLoginModeButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomLine.bottom).offset(5.0f);
        make.centerX.equalTo(self.view.centerX);
    }];

}

- (void)updateConstraints {
    switch (self.currentLoginMode) {
        case LoginModeVerificationCode: {
            if (self.verificationCodeField.hidden) {
                [self.finishButton remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.phoneNumberField.bottom).offset(15.0f);
                    make.centerX.equalTo(self.view.centerX);
                    make.width.mas_equalTo(kFieldViewWidth);
                    make.height.mas_equalTo(kFieldViewHeight);
                }];

            } else {
                [self.verificationCodeField remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.phoneNumberField.bottom).offset(15.0f);
                    make.centerX.equalTo(self.phoneNumberField.centerX);
                    make.width.mas_equalTo(kFieldViewWidth);
                    make.height.mas_equalTo(kFieldViewHeight);
                    
                }];
                
                [self.finishButton remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.verificationCodeField.bottom).offset(15.0f);
                    make.centerX.equalTo(self.view.centerX);
                    make.width.mas_equalTo(kFieldViewWidth);
                    make.height.mas_equalTo(kFieldViewHeight);
                }];

            }
            
           
            
        } break;
        case LoginModePWD: {
            [self.pwdField remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.phoneNumberField.bottom).offset(15.0f);
                make.centerX.equalTo(self.phoneNumberField.centerX);
                make.width.mas_equalTo(kFieldViewWidth);
                make.height.mas_equalTo(kFieldViewHeight);
                
            }];
            
            [self.finishButton remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.pwdField.bottom).offset(15.0f);
                make.centerX.equalTo(self.view.centerX);
                make.width.mas_equalTo(kFieldViewWidth);
                make.height.mas_equalTo(kFieldViewHeight);
            }];
        } break;
            
        default:
            break;
    }
    
   

}

#pragma mark Button Actions

- (void)popupVC {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)forgetPWD {
    
}

- (void)finishButtonTapped {
    switch (self.currentLoginMode) {
        case LoginModePWD: {
            [self login];
        } break;
        
        case LoginModeVerificationCode: {
            if (self.verificationCodeField.hidden) {
                [self verifyPhoneNumber];
            } else {
                [self login];
            }
            
        } break;
            
        default:
            break;
    }
}

- (void)verifyPhoneNumber{
    if ([[HHPhoneNumberUtility sharedInstance] isValidPhoneNumber:self.phoneNumberField.textField.text]) {
        [self showVerificationCodeField];
        [self updateConstraints];
        [self.phoneNumberField.textField resignFirstResponder];
        [self.verificationCodeField.textField becomeFirstResponder];
        [self sendCode];
    } else {
        [[HHToastManager sharedManager] showErrorToastWithText:@"无效手机号，请自己核对！"];
    }
}

- (void)showVerificationCodeField {
    [self.finishButton setTitle:@"登录" forState:UIControlStateNormal];
    self.verificationCodeField.hidden = NO;
    self.timer = [NSTimer scheduledTimerWithTimeInterval: 1.0 target:self selector:@selector(updateCountdown) userInfo:nil repeats: YES];
}

- (void)login {
    
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
        self.sendCodeButton.enabled = NO;
        NSString *countDownString = [NSString stringWithFormat:@"%ld 秒", self.countDown];
        [self.sendCodeButton setTitle:countDownString forState:UIControlStateNormal];
    }
    
}

- (void)sendCode {
    NSString *countDownString = [NSString stringWithFormat:@"%ld 秒", self.countDown];
    [self.sendCodeButton setTitle:countDownString forState:UIControlStateNormal];
    [self.sendCodeButton setTitleColor:[UIColor HHLightOrange] forState:UIControlStateNormal];
    if (!self.timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval: 1.0 target:self selector:@selector(updateCountdown) userInfo:nil repeats: YES];
    }
    self.sendCodeButton.enabled = NO;
}

- (void)swithMode {
    if (self.currentLoginMode == LoginModePWD) {
        self.currentLoginMode = LoginModeVerificationCode;
    } else {
        self.currentLoginMode = LoginModePWD;
    }
    [self updateConstraints];
}


#pragma mark - UITextField Delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField isEqual:self.phoneNumberField.textField]) {
        [self verifyPhoneNumber];
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

@end
