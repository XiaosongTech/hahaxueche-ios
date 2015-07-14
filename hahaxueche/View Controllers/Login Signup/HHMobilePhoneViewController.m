//
//  HHMobilePhoneViewController.m
//  hahaxueche
//
//  Created by Zixiao Wang on 7/12/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import "HHMobilePhoneViewController.h"
#import "HHAutoLayoutUtility.h"
#import "UIColor+HHColor.h"
#import "UIBarButtonItem+HHCustomButton.h"
#import "UIColor+HHColor.h"
#import "HHTextFieldView.h"
#import "NBPhoneNumberUtil.h"
#import "HHButton.h"
#import "UIView+HHRect.h"
#import "HHProfileSetupViewController.h"
#import "HHRootViewController.h"

@interface HHMobilePhoneViewController ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) HHTextFieldView *numberFieldView;
@property (nonatomic, strong) NBPhoneNumberUtil *numberUtil;
@property (nonatomic, strong) HHButton *sendCodeButton;
@property (nonatomic, strong) HHButton *verifyCodeButton;
@property (nonatomic, strong) HHTextFieldView *verificationCodeFieldView;
@property (nonatomic, strong) NSString *titleText;
@property (nonatomic, strong) NSString *subTitleText;
@property (nonatomic)         PageType type;


@end

@implementation HHMobilePhoneViewController

- (instancetype)initWithType:(PageType)type {
    self = [super init];
    if (self) {
        self.numberUtil = [[NBPhoneNumberUtil alloc] init];
        self.type = type;
        if(self.type == PageTypeSignup) {
            self.title = @"1/2";
            self.titleText = @"请输入您的手机号码";
            self.subTitleText = @"我们绝不会贩卖，滥用你的个人信息";
        } else {
            self.title = @"手机号登陆";
        }
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubviews];
}

- (void)initSubviews {
    if (self.type == PageTypeSignup) {
        self.titleLabel = [self createLabelWithTitle:self.titleText font:[UIFont fontWithName:@"SourceHanSansSC-Bold" size:20.0f] textColor:[UIColor HHOrange]];
        self.subTitleLabel = [self createLabelWithTitle:self.subTitleText font:[UIFont fontWithName:@"SourceHanSansSC-Normal" size:12.0f] textColor:[UIColor darkGrayColor]];
    }
    
    UIBarButtonItem *cancelButton = [UIBarButtonItem buttonItemWithTitle:@"取消" action:@selector(cancel) target:self isLeft:YES];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    self.numberFieldView = [[HHTextFieldView alloc] initWithPlaceholder:@"手机号码"];
    self.numberFieldView.textField.keyboardType = UIKeyboardTypeNumberPad;
    self.numberFieldView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.numberFieldView.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:self.numberFieldView];
    
    self.sendCodeButton = [[HHButton alloc] initThinBorderButtonWithTitle:@"发送验证码" textColor:[UIColor HHOrange]font:[UIFont fontWithName:@"SourceHanSansSC-Medium" size:10.0f] borderColor:[UIColor HHOrange] backgroundColor:[UIColor whiteColor]];
    [self.sendCodeButton addTarget:self action:@selector(sendSMSCode) forControlEvents:UIControlEventTouchUpInside];
    [self.sendCodeButton setFrameWithSize:CGSizeMake(60.0f, 30.0f)];
    self.sendCodeButton.hidden = YES;
    self.numberFieldView.textField.rightView = self.sendCodeButton;
    self.numberFieldView.textField.rightViewMode = UITextFieldViewModeWhileEditing;
    [self.numberFieldView.textField becomeFirstResponder];
    
    self.verificationCodeFieldView = [[HHTextFieldView alloc] initWithPlaceholder:@"验证码"];
    self.verificationCodeFieldView.textField.keyboardType = UIKeyboardTypeDefault;
    self.verificationCodeFieldView.translatesAutoresizingMaskIntoConstraints = NO;
    self.verificationCodeFieldView.hidden = YES;
    [self.view addSubview:self.verificationCodeFieldView];
    
    self.verifyCodeButton = [[HHButton alloc] initThinBorderButtonWithTitle:@"确认验证码" textColor:[UIColor HHOrange]font:[UIFont fontWithName:@"SourceHanSansSC-Medium" size:10.0f] borderColor:[UIColor HHOrange] backgroundColor:[UIColor whiteColor]];
    [self.verifyCodeButton addTarget:self action:@selector(verifySMSCode) forControlEvents:UIControlEventTouchUpInside];
    [self.verifyCodeButton setFrameWithSize:CGSizeMake(60.0f, 30.0f)];
    self.verificationCodeFieldView.textField.rightView = self.verifyCodeButton;
    self.verificationCodeFieldView.textField.rightViewMode = UITextFieldViewModeWhileEditing;

    [self autoLayoutSubviews];
}

- (UILabel *)createLabelWithTitle:(NSString *)title font:(UIFont *)font textColor:(UIColor *)textColor {
    UILabel *label = [[UILabel alloc] init];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.text = title;
    label.textColor = textColor;
    label.font = font;
    label.textAlignment = NSTextAlignmentCenter;
    [label sizeToFit];
    [self.view addSubview:label];
    return label;
}

- (void)autoLayoutSubviews {
    
    NSArray *constraints = nil;
    
    if (self.type == PageTypeSignup) {
        constraints = @[
                        [HHAutoLayoutUtility verticalAlignToSuperViewTop:self.titleLabel constant:20.0f],
                        [HHAutoLayoutUtility setCenterX:self.titleLabel multiplier:1.0f constant:0],
                        
                        [HHAutoLayoutUtility verticalNext:self.subTitleLabel toView:self.titleLabel constant:0.0f],
                        [HHAutoLayoutUtility setCenterX:self.subTitleLabel multiplier:1.0f constant:0],
                        
                        [HHAutoLayoutUtility verticalNext:self.numberFieldView toView:self.subTitleLabel constant:10.0f],
                        [HHAutoLayoutUtility setCenterX:self.numberFieldView multiplier:1.0f constant:0],
                        [HHAutoLayoutUtility setViewWidth:self.numberFieldView multiplier:1.0f constant:-80.0f],
                        [HHAutoLayoutUtility setViewHeight:self.numberFieldView multiplier:0 constant:40.0f],
                        
                        [HHAutoLayoutUtility verticalNext:self.verificationCodeFieldView toView:self.numberFieldView constant:10.0f],
                        [HHAutoLayoutUtility setCenterX:self.verificationCodeFieldView multiplier:1.0f constant:0],
                        [HHAutoLayoutUtility setViewWidth:self.verificationCodeFieldView multiplier:1.0f constant:-80.0f],
                        [HHAutoLayoutUtility setViewHeight:self.verificationCodeFieldView multiplier:0 constant:40.0f],
                        
                        ];

    } else {
        constraints = @[
                        [HHAutoLayoutUtility verticalAlignToSuperViewTop:self.numberFieldView constant:20.0f],
                         [HHAutoLayoutUtility setCenterX:self.numberFieldView multiplier:1.0f constant:0],
                         [HHAutoLayoutUtility setViewWidth:self.numberFieldView multiplier:1.0f constant:-80.0f],
                         [HHAutoLayoutUtility setViewHeight:self.numberFieldView multiplier:0 constant:40.0f],
                         
                         [HHAutoLayoutUtility verticalNext:self.verificationCodeFieldView toView:self.numberFieldView constant:10.0f],
                         [HHAutoLayoutUtility setCenterX:self.verificationCodeFieldView multiplier:1.0f constant:0],
                         [HHAutoLayoutUtility setViewWidth:self.verificationCodeFieldView multiplier:1.0f constant:-80.0f],
                         [HHAutoLayoutUtility setViewHeight:self.verificationCodeFieldView multiplier:0 constant:40.0f],
                         
                         ];

    }
    [self.view addConstraints:constraints];
}

- (void)cancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)isValidMobileNumber:(NSString *)number {
    NSError *anError = nil;
    NBPhoneNumber *mobileNumber = [self.numberUtil parse:number
                                 defaultRegion:@"CN" error:&anError];
    return [self.numberUtil isValidNumber:mobileNumber];
}

- (void)textFieldDidChange:(UITextField *)textField {
    if ([self isValidMobileNumber:textField.text]) {
        self.sendCodeButton.hidden = NO;
    } else {
        self.sendCodeButton.hidden = YES;
    }
   
}

- (void)sendSMSCode {
    self.verificationCodeFieldView.hidden = NO;
    [self.verificationCodeFieldView.textField becomeFirstResponder];
}

- (void)verifySMSCode {
    if (self.type == PageTypeSignup) {
        HHProfileSetupViewController *profileSetupVC = [[HHProfileSetupViewController alloc] init];
        [self.navigationController pushViewController:profileSetupVC animated:YES];
    } else {
        HHRootViewController *rootVC = [[HHRootViewController alloc] init];
        [self presentViewController:rootVC animated:YES completion:nil];

    }
}



@end