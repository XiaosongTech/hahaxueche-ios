//
//  HHPaymentStatusCell.m
//  hahaxueche
//
//  Created by Zixiao Wang on 2/21/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHPaymentStatusCell.h"
#import "Masonry.h"
#import "UIColor+HHColor.h"

@implementation HHPaymentStatusCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    self.stepNumberLabel = [self buildLabel];
    [self.contentView addSubview:self.stepNumberLabel];
    
    self.feeNameLabel = [self buildLabel];
    [self.contentView addSubview:self.feeNameLabel];
    
    self.feeAmountLabel = [self buildLabel];
    [self.contentView addSubview:self.feeAmountLabel];
    
    self.statusLabel = [self buildLabel];
    [self.contentView addSubview:self.statusLabel];
    
    self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.rightButton addTarget:self action:@selector(rightButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.rightButton];
    
    [self makeConstraints];
}

- (UILabel *)buildLabel {
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor HHLightTextGray];
    label.font = [UIFont systemFontOfSize:15.0f];
    return label;
}

- (void)makeConstraints {
    [self.stepNumberLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.centerY);
        make.left.equalTo(self.contentView.left).offset(20.0f);
    }];
    
    [self.feeNameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.centerY);
        make.left.equalTo(self.stepNumberLabel.right).offset(30.0f);
    }];
    
    [self.feeAmountLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.centerY);
        make.left.equalTo(self.feeNameLabel.right).offset(30.0f);
    }];
    
    [self.rightButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.centerY);
        make.right.equalTo(self.contentView.right).offset(-5.0f);
        make.width.mas_equalTo(40.0f);
        make.height.mas_equalTo(40.0f);
    }];
    
    [self.statusLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.centerY);
        make.right.equalTo(self.rightButton.left).offset(-30.0f);
    }];
}

- (void)rightButtonTapped {
    if (self.rightButtonBlock) {
        self.rightButtonBlock();
    }
}

- (void)setupCellWithPaymentStatus:(HHPaymentStage *)paymentStatus {
    self.stepNumberLabel.text = @"1";
    self.feeNameLabel.text = @"考试费";
    self.feeAmountLabel.text = @"￥300";
    self.statusLabel.text = @"待打款";
    [self.rightButton setImage:[UIImage imageNamed:@"ic_paylist_message_btn_unfocus"] forState:UIControlStateNormal];
}

@end
