//
//  HHGetNumberTableViewCell.m
//  hahaxueche
//
//  Created by Zixiao Wang on 08/05/2017.
//  Copyright © 2017 Zixiao Wang. All rights reserved.
//

#import "HHGetNumberTableViewCell.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"
#import "HHStudentStore.h"
#import "HHPhoneNumberUtility.h"
#import "HHToastManager.h"

@implementation HHGetNumberTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor HHLightBackgroudGray];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    self.mainView = [[UIView alloc] init];
    self.mainView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.mainView];
    
    self.imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_schooldetails_tg_hui_big"]];
    [self.mainView addSubview:self.imgView];
    
    self.textField = [[UITextField alloc] init];
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 35)];
    self.textField.leftView = paddingView;
    self.textField.leftViewMode = UITextFieldViewModeAlways;
    self.textField.tintColor = [UIColor HHOrange];
    self.textField.layer.borderColor = [UIColor HHLightLineGray].CGColor;
    self.textField.layer.masksToBounds = YES;
    self.textField.font = [UIFont systemFontOfSize:12.0f];
    self.textField.placeholder = @"请输入手机号";
    self.textField.layer.borderWidth = 1.0f;
    [self.mainView addSubview:self.textField];
    
    if ([HHStudentStore sharedInstance].currentStudent.cellPhone) {
        self.textField.text = [HHStudentStore sharedInstance].currentStudent.cellPhone;
    }
    
    self.confirmButton = [[HHGradientButton alloc] initWithType:1];
    [self.confirmButton setTitle:@"获取最新团购" forState:UIControlStateNormal];
    self.confirmButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    [self.confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.confirmButton addTarget:self action:@selector(confirmTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.mainView addSubview:self.confirmButton];
    
    [self makeConstraints];
}

- (void)makeConstraints {
    [self.mainView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left);
        make.top.equalTo(self.contentView.top).offset(10.0f);
        make.width.equalTo(self.contentView.width);
        make.bottom.equalTo(self.contentView.bottom);
    }];
    
    [self.imgView makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.centerX);
        make.top.equalTo(self.mainView.top).offset(20.0f);
    }];
    
    [self.textField makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mainView.left).offset(15.0f);
        make.top.equalTo(self.imgView.bottom).offset(20.0f);
        make.width.equalTo(self.mainView.width).multipliedBy(3.0f/5.0f);
        make.height.mas_equalTo(35.0f);
    }];
    
    [self.confirmButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.textField.right);
        make.top.equalTo(self.textField.top);
        make.right.equalTo(self.mainView.right).offset(-15.0f);
        make.height.mas_equalTo(35.0f);
    }];
}

- (void)confirmTapped {
    if (![[HHPhoneNumberUtility sharedInstance] isValidPhoneNumber:self.textField.text]) {
        [[HHToastManager sharedManager] showErrorToastWithText:@"请输入正确的手机号"];
        return;
    }
    if (self.confirmBlock) {
        self.confirmBlock(self.textField.text);
    }
}


@end
