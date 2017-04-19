//
//  HHGenericPhoneView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 19/04/2017.
//  Copyright © 2017 Zixiao Wang. All rights reserved.
//

#import "HHGenericPhoneView.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"
#import "HHStudentStore.h"
#import "HHPhoneNumberUtility.h"
#import "HHToastManager.h"

@implementation HHGenericPhoneView

- (instancetype)initWithTitle:(NSString *)title placeHolder:(NSString *)placeHolder buttonTitle:(NSString *)buttonTitle {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, 270.0f, 170.0f);
        self.backgroundColor = [UIColor whiteColor];
        
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        self.titleLabel.textColor = [UIColor HHOrange];
        self.titleLabel.text = title;
        [self addSubview:self.titleLabel];
        [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.centerX);
            make.top.equalTo(self.top).offset(15.0f);
        }];
        
        
        UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 45)];
        paddingView.backgroundColor = [UIColor HHLightBackgroudGray];
        
        self.inputField = [[UITextField alloc] init];
        if ([[HHStudentStore sharedInstance].currentStudent isLoggedIn]) {
             self.inputField.text = [HHStudentStore sharedInstance].currentStudent.cellPhone;
        }
       
        self.inputField.placeholder = placeHolder;
        self.inputField.font = [UIFont systemFontOfSize:13.0f];
        self.inputField.backgroundColor = [UIColor HHLightBackgroudGray];
        self.inputField.tintColor = [UIColor HHOrange];
        self.inputField.leftView = paddingView;
        self.inputField.leftViewMode = UITextFieldViewModeAlways;
        [self addSubview:self.inputField];
        [self.inputField makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.centerX);
            make.top.equalTo(self.titleLabel.bottom).offset(15.0f);
            make.width.equalTo(self.width).offset(-60.0f);
            make.height.mas_equalTo(45.0f);
        }];
        
        
        self.button = [[HHGradientButton alloc] initWithType:0];
        self.button.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        [self.button setTitle:buttonTitle forState:UIControlStateNormal];
        [self.button addTarget:self action:@selector(buttonTapped) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.button];
        [self.button makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.centerX);
            make.top.equalTo(self.inputField.bottom).offset(10.0f);
            make.width.equalTo(self.width).offset(-60.0f);
            make.height.mas_equalTo(45.0f);
        }];
    }
    return self;
}

- (void)buttonTapped {
    if (![[HHPhoneNumberUtility sharedInstance] isValidPhoneNumber:self.inputField.text]) {
        [[HHToastManager sharedManager] showErrorToastWithText:@"请输入正确的手机号"];
        return;
    }
    if (self.buttonAction) {
        self.buttonAction(self.inputField.text);
    }
}



@end
