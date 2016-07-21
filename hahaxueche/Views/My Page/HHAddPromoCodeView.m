//
//  HHAddPromoCodeView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 7/19/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHAddPromoCodeView.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"

@implementation HHAddPromoCodeView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.topView = [[UIView alloc] init];
        self.topView.backgroundColor = [UIColor HHOrange];
        [self addSubview:self.topView];
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.text = @"添加优惠券";
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.font = [UIFont systemFontOfSize:20.0f];
        [self.topView addSubview:self.titleLabel];
        
        self.subTitleLabel = [[UILabel alloc] init];
        self.subTitleLabel.text = @"请输入优惠码";
        self.subTitleLabel.textColor = [UIColor HHOrange];
        self.subTitleLabel.font = [UIFont systemFontOfSize:15.0f];
        [self.topView addSubview:self.subTitleLabel];
        
        self.promoCodeField = [[UITextField alloc] init];
        self.promoCodeField.borderStyle = UITextBorderStyleNone;
        self.promoCodeField.layer.borderColor = [UIColor HHOrange].CGColor;
        self.promoCodeField.layer.borderWidth = 1.0f/[UIScreen mainScreen].scale;
        self.promoCodeField.layer.cornerRadius = 25.0f;
        self.promoCodeField.textAlignment = NSTextAlignmentCenter;
        self.promoCodeField.tintColor = [UIColor HHOrange];
        self.promoCodeField.keyboardType = UIKeyboardTypeNumberPad;
        self.promoCodeField.textColor = [UIColor HHOrange];
        [self.promoCodeField becomeFirstResponder];
        [self addSubview:self.promoCodeField];
        
        self.buttonsView = [[HHConfirmCancelButtonsView alloc] initWithLeftTitle:@"取消" rightTitle:@"确认"];
        [self.buttonsView.rightButton addTarget:self action:@selector(confirmButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        [self.buttonsView.leftButton addTarget:self action:@selector(cancelButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.buttonsView];
        [self addSubview:self.buttonsView];
        
        
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
        
        [self.subTitleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.centerX);
            make.top.equalTo(self.topView.bottom).offset(20.0f);
        }];
        
        [self.promoCodeField makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.centerX);
            make.top.equalTo(self.subTitleLabel.bottom).offset(10.0f);
            make.width.equalTo(self.width).offset(-60.0f);
            make.height.mas_equalTo(50.0f);
        }];
        
        [self.buttonsView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left);
            make.bottom.equalTo(self.bottom);
            make.width.equalTo(self.width);
            make.height.mas_equalTo(50.0f);
        }];
        
        
    }
    return self;
}

- (void)confirmButtonTapped {
    if(self.confirmBlock) {
        self.confirmBlock(self.promoCodeField.text);
    }
}

- (void)cancelButtonTapped {
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}

@end
