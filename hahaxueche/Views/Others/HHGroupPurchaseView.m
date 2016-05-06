//
//  HHGroupPurchaseView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 5/6/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHGroupPurchaseView.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"
#import "HHToastManager.h"
#import "NSNumber+HHNumber.h"
#import <MMNumberKeyboard/MMNumberKeyboard.h>
#import "HHStudentStore.h"
#import "HHPhoneNumberUtility.h"

static CGFloat const kRadius = 25.0f;

@interface HHGroupPurchaseView () <UITextFieldDelegate>

@end

@implementation HHGroupPurchaseView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    self.topView = [[UIView alloc] init];
    self.topView.backgroundColor = [UIColor HHOrange];
    [self addSubview:self.topView];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = [NSString stringWithFormat:@"%@限时抢购, 我要报名!", [@(238000) generateMoneyString]];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont systemFontOfSize:20.0f];
    [self.topView addSubview:self.titleLabel];
    
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cancelButton setImage:[UIImage imageNamed:@"ic_homepage_groupbuy_close"] forState:UIControlStateNormal];
    [self.cancelButton addTarget:self action:@selector(cancelTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:self.cancelButton];
    
    
    self.subtitleLabel = [[UILabel alloc] init];
    self.subtitleLabel.text = @"报名信息";
    self.subtitleLabel.textColor = [UIColor HHOrange];
    self.subtitleLabel.font = [UIFont systemFontOfSize:16.0f];
    [self addSubview:self.subtitleLabel];
    
    self.nameField = [self buildFieldWithPlaceHolder:@"您的真实姓名"];
    self.nameField.returnKeyType = UIReturnKeyNext;
    [self addSubview:self.nameField];
    
    self.numberField = [self buildFieldWithPlaceHolder:@"您的联系方式"];
    MMNumberKeyboard *keyboard = [[MMNumberKeyboard alloc] initWithFrame:CGRectZero];
    keyboard.allowsDecimalPoint = NO;
    keyboard.returnKeyTitle = @"完成";
    self.numberField.inputView = keyboard;
    [self addSubview:self.numberField];
    
    
    self.confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [self.confirmButton addTarget:self action:@selector(confirmTapped) forControlEvents:UIControlEventTouchUpInside];
    self.confirmButton.layer.masksToBounds = YES;
    self.confirmButton.layer.cornerRadius = kRadius;
    self.confirmButton.layer.borderWidth = 0;
    self.confirmButton.layer.borderColor = [UIColor HHOrange].CGColor;
    self.confirmButton.backgroundColor = [UIColor HHConfirmRed];
    [self.confirmButton setTitle:@"立刻抢团购" forState:UIControlStateNormal];
    [self.confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self addSubview:self.confirmButton];
    
    self.ruleLabel = [[UILabel alloc] init];
    self.ruleLabel.numberOfLines = 0;
    [self addSubview:self.ruleLabel];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    paragraphStyle.lineSpacing = 6.0f;
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"活动截止日期为2016年6月1日, 名额有限\n" attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:12.0f], NSForegroundColorAttributeName:[UIColor HHOrange], NSParagraphStyleAttributeName:paragraphStyle}];
    NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:@"团购名额抢购成功后, 小哈客服会马上联系您\n如有疑问可直接拨打客服热线: 400-001-6006\n或联系QQ客服: 3319762526" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0f], NSForegroundColorAttributeName:[UIColor HHOrange], NSParagraphStyleAttributeName:paragraphStyle}];
    [attrString appendAttributedString:attrString2];
    self.ruleLabel.attributedText = attrString;

    [self makeConstraints];
    
    if ([HHStudentStore sharedInstance].currentStudent.studentId) {
        self.nameField.text = [HHStudentStore sharedInstance].currentStudent.name;
        self.numberField.text = [HHStudentStore sharedInstance].currentStudent.cellPhone;
    }
}

- (void)makeConstraints {
    [self.topView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.top);
        make.left.equalTo(self.left);
        make.width.equalTo(self.width);
        make.height.mas_equalTo(70.0f);
    }];
    
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topView.centerY);
        make.left.equalTo(self.topView.left).offset(15.0f);
    }];
    
    [self.cancelButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topView.centerY);
        make.right.equalTo(self.topView.right).offset(-15.0f);
    }];
    
    [self.subtitleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.bottom).offset(25.0f);
        make.centerX.equalTo(self.centerX);
    }];
    
    [self.nameField makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.centerX);
        make.top.equalTo(self.topView.bottom).offset(60.0f);
        make.width.mas_equalTo(275.0f);
        make.height.mas_equalTo(kRadius * 2.0f);
    }];
    
    [self.numberField makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.centerX);
        make.top.equalTo(self.nameField.bottom).offset(15.0f);
        make.width.mas_equalTo(275.0f);
        make.height.mas_equalTo(kRadius * 2.0f);
    }];
    
    [self.confirmButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.centerX);
        make.top.equalTo(self.numberField.bottom).offset(30.0f);
        make.width.mas_equalTo(275.0f);
        make.height.mas_equalTo(kRadius * 2.0f);
    }];
    
    [self.ruleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.centerX);
        make.top.equalTo(self.confirmButton.bottom).offset(15.0f);
        make.width.mas_equalTo(275.0f);
    }];
}

- (UITextField *)buildFieldWithPlaceHolder:(NSString *)placehHolder {
    UITextField *textField = [[UITextField alloc] init];
    textField.borderStyle = UITextBorderStyleNone;
    textField.placeholder = placehHolder;
    textField.textAlignment = NSTextAlignmentCenter;
    textField.tintColor = [UIColor HHOrange];
    textField.textColor = [UIColor HHOrange];
    textField.layer.masksToBounds = YES;
    textField.layer.cornerRadius = kRadius;
    textField.font = [UIFont systemFontOfSize:15.0f];
    textField.layer.borderColor = [UIColor HHLightLineGray].CGColor;
    textField.layer.borderWidth = 1.0f/[UIScreen mainScreen].scale;
    textField.delegate = self;
    [textField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    return textField;
}

- (void)textFieldChanged:(UITextField *)textField {
    NSString *text = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([text isEqualToString:@""]) {
        textField.layer.borderColor = [UIColor HHLightLineGray].CGColor;
    } else {
        textField.layer.borderColor = [UIColor HHOrange].CGColor;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([self.nameField isEqual:textField]) {
        [textField resignFirstResponder];
        [self.numberField becomeFirstResponder];
    }
    return YES;
}

- (void)cancelTapped {
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}

- (void)confirmTapped {
    if ([self.nameField.text isEqualToString:@""]) {
        [[HHToastManager sharedManager] showErrorToastWithText:@"请输入您的真实姓名"];
        return;
    }
    
    if ([self.numberField.text isEqualToString:@""]) {
        [[HHToastManager sharedManager] showErrorToastWithText:@"请输入您的联系方式"];
        return;
    }
    
    if (![[HHPhoneNumberUtility sharedInstance] isValidPhoneNumber:self.numberField.text]) {
        [[HHToastManager sharedManager] showErrorToastWithText:@"请输入有效的联系方式"];
        return;
    }
    
    if (self.confirmBlock) {
        self.confirmBlock(self.nameField.text, self.numberField.text);
    }
}


@end
