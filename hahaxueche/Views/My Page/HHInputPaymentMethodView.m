//
//  HHInputPaymentMethodView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 4/29/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHInputPaymentMethodView.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"
#import "HHToastManager.h"

@implementation HHInputPaymentMethodView

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
    self.titleLabel.text = @"提现到支付宝";
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont systemFontOfSize:20.0f];
    [self.topView addSubview:self.titleLabel];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentLeft;
    paragraphStyle.lineSpacing = 8.0f;
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"1.提现金额将于1-3个工作日打入您的支付宝账户\n2.如果提现失败请及时联系客服人员帮助\n" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f], NSForegroundColorAttributeName:[UIColor HHLightTextGray], NSParagraphStyleAttributeName:paragraphStyle}];
    NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:@"客服电话: 400-001-6006" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f], NSForegroundColorAttributeName:[UIColor HHOrange], NSParagraphStyleAttributeName:paragraphStyle}];
    [attrString appendAttributedString:attrString2];
    
    self.infoLabel = [[UILabel alloc] init];
    self.infoLabel.numberOfLines = 0;
    self.infoLabel.attributedText = attrString;
    self.infoLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.infoLabel];
    
    self.accountField = [self buildTextFieldWithPlaceholder:@"输入支付宝账号"];
    self.accountField.returnKeyType = UIReturnKeyNext;
    [self addSubview:self.accountField];
    
    self.ownerNameField = [self buildTextFieldWithPlaceholder:@"输入支付宝真实姓名"];
    self.ownerNameField.returnKeyType = UIReturnKeyDone;
    [self addSubview:self.ownerNameField];
    
    self.firstLine = [[UIView alloc] init];
    self.firstLine.backgroundColor = [UIColor HHLightLineGray];
    [self addSubview:self.firstLine];
    
    self.secondLine = [[UIView alloc] init];
    self.secondLine.backgroundColor = [UIColor HHLightLineGray];
    [self addSubview:self.secondLine];
    
    
    self.buttonsView = [[HHConfirmCancelButtonsView alloc] initWithLeftTitle:@"取消" rightTitle:@"确认"];
    [self.buttonsView.leftButton addTarget:self action:@selector(cancelTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonsView.rightButton addTarget:self action:@selector(confirmTapped) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.buttonsView];
    [self makeConstraints];
}

- (UITextField *)buildTextFieldWithPlaceholder:(NSString *)placeholder {
    UITextField *field = [[UITextField alloc] init];
    field.borderStyle = UITextBorderStyleNone;
    field.placeholder = placeholder;
    field.font = [UIFont systemFontOfSize:16.0f];
    field.tintColor = [UIColor HHOrange];
    field.textColor = [UIColor HHOrange];
    field.delegate = self;
    return field;
}

- (void)makeConstraints {
    [self.topView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.top);
        make.left.equalTo(self.left);
        make.width.equalTo(self.width);
        make.height.mas_equalTo(60.0f);
    }];
    
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topView.centerY);
        make.left.equalTo(self.topView.left).offset(20.0f);
    }];
    
    [self.accountField makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left).offset(20.0f);
        make.top.equalTo(self.topView.bottom);
        make.right.equalTo(self.right).offset(-20.0f);
        make.height.mas_equalTo(50.0f);
    }];
    
    [self.firstLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left).offset(20.0f);
        make.top.equalTo(self.accountField.bottom);
        make.right.equalTo(self.right).offset(-20.0f);
        make.height.mas_equalTo(1.0f/[UIScreen mainScreen].scale);

    }];
    
    [self.ownerNameField makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left).offset(20.0f);
        make.top.equalTo(self.firstLine.bottom);
        make.right.equalTo(self.right).offset(-20.0f);
        make.height.mas_equalTo(50.0f);
    }];
    
    [self.secondLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left);
        make.top.equalTo(self.ownerNameField.bottom);
        make.right.equalTo(self.right);
        make.height.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
        
    }];
    
    [self.infoLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left).offset(20.0f);
        make.top.equalTo(self.ownerNameField.bottom).offset(10.0f);
        make.right.equalTo(self.right).offset(-20.0f);
    }];
    
    [self.buttonsView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bottom);
        make.left.equalTo(self.left);
        make.width.equalTo(self.width);
        make.height.mas_equalTo(60.0f);
    }];
}

- (void)cancelTapped {
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}

- (void)confirmTapped {
    if ([self.accountField.text isEqualToString:@""]) {
        [[HHToastManager sharedManager] showErrorToastWithText:@"支付宝账号为空!"];
        return;
    }
    
    if ([self.ownerNameField.text isEqualToString:@""]) {
        [[HHToastManager sharedManager] showErrorToastWithText:@"支付宝真是姓名为空!"];
        return;
    }
    if (self.confirmBlock) {
        self.confirmBlock(self.accountField.text, self.ownerNameField.text);
    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if ([self.accountField isEqual:textField]) {
        [self.ownerNameField becomeFirstResponder];
    }
    return YES;
}


@end
