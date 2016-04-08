//
//  HHTryCoachView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 2/12/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHTryCoachView.h"
#import "Masonry.h"
#import "UIColor+HHColor.h"
#import <ActionSheetPicker.h>
#import "HHFormatUtility.h"
#import "HHPhoneNumberUtility.h"
#import "HHToastManager.h"
#import "HHStudentStore.h"
#import "NSDate+DateTools.h"

@implementation HHTryCoachView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    self.firstLabel = [[UILabel alloc] init];
    self.firstLabel.text = @"预约信息";
    self.firstLabel.textColor = [UIColor HHOrange];
    self.firstLabel.font = [UIFont systemFontOfSize:18.0f];
    [self addSubview:self.firstLabel];
    
    self.secondLabel = [[UILabel alloc] init];
    self.secondLabel.text = @"预约时间";
    self.secondLabel.textColor = [UIColor HHOrange];
    self.secondLabel.font = [UIFont systemFontOfSize:18.0f];
    [self addSubview:self.secondLabel];
    
    self.infoLabel = [[UILabel alloc] init];
    self.infoLabel.text = @"学员可直接拨打客服热线400-001-6006\n或联系QQ客服:3319762526 免费预约试学";
    self.infoLabel.numberOfLines = 2;
    self.infoLabel.textColor = [UIColor HHOrange];
    self.infoLabel.font = [UIFont systemFontOfSize:12.0f];
    [self addSubview:self.infoLabel];
    
    self.nameField = [self buildFieldWithPlaceHolder:@"您的真实姓名"];
    if ([HHStudentStore sharedInstance].currentStudent.name) {
        self.nameField.text = [HHStudentStore sharedInstance].currentStudent.name;
    }
    self.nameField.returnKeyType = UIReturnKeyNext;
    [self addSubview:self.nameField];
    
    self.numberField = [self buildFieldWithPlaceHolder:@"您的联系方式"];
    if ([HHStudentStore sharedInstance].currentStudent.cellPhone) {
        self.numberField.text = [HHStudentStore sharedInstance].currentStudent.cellPhone;
    }
    self.numberField.returnKeyType = UIReturnKeyDone;
    [self addSubview:self.numberField];
    
    self.firstDateButton = [self buildButtonWithTitle:@"首选时间"];
    [self.firstDateButton addTarget:self action:@selector(showDatePicker:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.firstDateButton];
    
    self.secDateButton = [self buildButtonWithTitle:@"备选时间"];
    [self.secDateButton addTarget:self action:@selector(showDatePicker:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.secDateButton];
    
    self.buttonsView = [[HHConfirmCancelButtonsView alloc] initWithLeftTitle:@"免费预约" rightTitle:@"取消返回"];
    [self.buttonsView.leftButton addTarget:self action:@selector(confirmButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonsView.rightButton addTarget:self action:@selector(cancelButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.buttonsView];
    
    [self makeConstraints];
}

- (void)makeConstraints {
    [self.firstLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.top).offset(20.0f);
        make.centerX.equalTo(self.centerX);
    }];
    
    [self.nameField makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.firstLabel.bottom).offset(15.0f);
        make.centerX.equalTo(self.centerX);
        make.width.equalTo(self.width).offset(-80.0f);
        make.height.mas_equalTo(40.0f);
    }];
    
    [self.numberField makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameField.bottom).offset(15.0f);
        make.centerX.equalTo(self.centerX);
        make.width.equalTo(self.width).offset(-80.0f);
        make.height.mas_equalTo(40.0f);
    }];
    
    [self.secondLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.numberField.bottom).offset(20.0f);
        make.centerX.equalTo(self.centerX);
    }];
    
    [self.firstDateButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.secondLabel.bottom).offset(15.0f);
        make.centerX.equalTo(self.centerX);
        make.width.equalTo(self.width).offset(-80.0f);
        make.height.mas_equalTo(40.0f);
    }];
    
    [self.secDateButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.firstDateButton.bottom).offset(15.0f);
        make.centerX.equalTo(self.centerX);
        make.width.equalTo(self.width).offset(-80.0f);
        make.height.mas_equalTo(40.0f);
    }];
    
    [self.infoLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.secDateButton.bottom).offset(20.0f);
        make.centerX.equalTo(self.centerX);
    }];
    
    [self.buttonsView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left);
        make.bottom.equalTo(self.bottom);
        make.width.equalTo(self.width);
        make.height.mas_equalTo(50.0f);
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
    textField.layer.cornerRadius = 20.0f;
    textField.font = [UIFont systemFontOfSize:15.0f];
    textField.layer.borderColor = [UIColor HHLightLineGray].CGColor;
    textField.layer.borderWidth = 1.0f/[UIScreen mainScreen].scale;
    textField.delegate = self;
    [textField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    return textField;
}

- (UIButton *)buildButtonWithTitle:(NSString *)title {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 20.0f;
    button.layer.borderColor = [UIColor HHLightLineGray].CGColor;
    button.layer.borderWidth = 1.0f/[UIScreen mainScreen].scale;
    [button setTitleColor:[UIColor HHLightLineGray] forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    return button;
}

#pragma mark - TextField Delegate Methods 

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField isEqual:self.nameField]) {
        [textField resignFirstResponder];
        [self.numberField becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    return NO;
}

#pragma mark - Button Actions

- (void)showDatePicker:(UIButton *)button {
    [self.nameField resignFirstResponder];
    [self.numberField resignFirstResponder];
    [ActionSheetDatePicker showPickerWithTitle:nil datePickerMode:UIDatePickerModeDate selectedDate:[NSDate date] minimumDate:[[NSDate date] dateByAddingDays:1] maximumDate:nil doneBlock:^(ActionSheetDatePicker *picker, id selectedDate, id origin) {
        if ([button isEqual:self.firstDateButton]) {
            self.firstDate = selectedDate;
            [self.firstDateButton setTitle:[[HHFormatUtility fullDateFormatter] stringFromDate:self.firstDate] forState:UIControlStateNormal];
            [self.firstDateButton setTitleColor:[UIColor HHOrange] forState:UIControlStateNormal];
            self.firstDateButton.layer.borderColor = [UIColor HHOrange].CGColor;
        } else {
            self.secDate = selectedDate;
            [self.secDateButton setTitle:[[HHFormatUtility fullDateFormatter] stringFromDate:self.secDate] forState:UIControlStateNormal];
            [self.secDateButton setTitleColor:[UIColor HHOrange] forState:UIControlStateNormal];
            self.secDateButton.layer.borderColor = [UIColor HHOrange].CGColor;
        }
    } cancelBlock:nil origin:self];
}

- (void)confirmButtonTapped {
    if (![self.nameField.text length]) {
        [[HHToastManager sharedManager] showErrorToastWithText:@"请输入真实姓名"];
        return;
    }
    if (![[HHPhoneNumberUtility sharedInstance] isValidPhoneNumber:self.numberField.text]) {
        [[HHToastManager sharedManager] showErrorToastWithText:@"请输入真实有效的手机号"];
        return;
    }
    
    if (!self.firstDate || !self.secDate) {
        [[HHToastManager sharedManager] showErrorToastWithText:@"请输入首选时间和备选时间"];
        return;
    }
    if (self.confirmBlock) {
        self.confirmBlock(self.nameField.text, self.numberField.text, self.firstDate, self.secDate);
    }
}

- (void)cancelButtonTapped {
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}

- (void)textFieldChanged:(UITextField *)textField {
    NSString *text = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([text isEqualToString:@""]) {
        textField.layer.borderColor = [UIColor HHLightLineGray].CGColor;
    } else {
        textField.layer.borderColor = [UIColor HHOrange].CGColor;
    }
}

@end
