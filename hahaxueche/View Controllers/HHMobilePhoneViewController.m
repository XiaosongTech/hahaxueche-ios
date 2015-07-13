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


@end

@implementation HHMobilePhoneViewController

- (instancetype)initWithTitle:(NSString *)title subTitle:(NSString *)subTitle {
    self = [super init];
    if (self) {
        self.numberUtil = [[NBPhoneNumberUtil alloc] init];
        self.titleText = title;
        self.subTitleText = subTitle;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubviews];
}

- (void)initSubviews {
    self.titleLabel = [self createLabelWithTitle:self.titleText font:[UIFont fontWithName:@"SourceHanSansSC-Bold" size:20.0f] textColor:[UIColor HHOrange]];
    self.subTitleLabel = [self createLabelWithTitle:self.subTitleText font:[UIFont fontWithName:@"SourceHanSansSC-Normal" size:12.0f] textColor:[UIColor lightTextColor]];
    UIBarButtonItem *cancelButton = [UIBarButtonItem buttonItemWithTitle:@"取消" action:@selector(cancel) target:self isLeft:YES];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    self.numberFieldView = [[HHTextFieldView alloc] initWithPlaceholder:@"手机号码"];
    self.numberFieldView.textField.keyboardType = UIKeyboardTypeNumberPad;
    self.numberFieldView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.numberFieldView.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:self.numberFieldView];
    
    self.sendCodeButton = [[HHButton alloc] initThinBorderButtonWithTitle:@"发送验证码" textColor:[UIColor HHOrange]font:[UIFont fontWithName:@"SourceHanSansSC-Normal" size:10.0f]];
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
    
    self.verifyCodeButton = [[HHButton alloc] initThinBorderButtonWithTitle:@"确认验证码" textColor:[UIColor HHOrange]font:[UIFont fontWithName:@"SourceHanSansSC-Normal" size:10.0f]];
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
    NSArray *constraints = @[
                             [HHAutoLayoutUtility verticalAlignToSuperViewTop:self.titleLabel constant:64.0f],
                             [HHAutoLayoutUtility setCenterX:self.titleLabel multiplier:1.0f constant:0],
                             
                             [HHAutoLayoutUtility verticalNext:self.subTitleLabel toView:self.titleLabel constant:5.0f],
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
    [self.view addConstraints:constraints];
}

- (void)cancel {
    [self dismissViewControllerAnimated:NO completion:nil];
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
    
}



@end
