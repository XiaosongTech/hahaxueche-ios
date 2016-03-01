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
#import "NSNumber+HHNumber.h"
#import "HHFormatUtility.h"

static CGFloat kNumberLabelRadius = 12.0f;

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
    self.stepNumberLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.stepNumberLabel];
    
    self.feeNameLabel = [self buildLabel];
    self.feeNameLabel.numberOfLines = 0;
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
    label.font = [UIFont systemFontOfSize:14.0f];
    return label;
}

- (void)makeConstraints {
    [self.stepNumberLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.centerY);
        make.left.equalTo(self.contentView.left).offset(10.0f);
        make.width.mas_equalTo(kNumberLabelRadius * 2.0f);
        make.height.mas_equalTo(kNumberLabelRadius * 2.0f);
    }];
    
    [self.feeNameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.centerY);
        make.left.equalTo(self.stepNumberLabel.right).offset(10.0f);
        make.width.mas_lessThanOrEqualTo(70.0f);
        make.height.equalTo(self.height);
    }];
    
    [self.feeAmountLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.centerY);
        make.left.equalTo(self.feeNameLabel.right).offset(10.0f);
    }];
    
    [self.rightButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.centerY);
        make.right.equalTo(self.contentView.right).offset(-5.0f);
        make.width.mas_equalTo(40.0f);
        make.height.mas_equalTo(40.0f);
    }];
    
    [self.statusLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.centerY);
        make.right.equalTo(self.rightButton.left).offset(-10.0f);
    }];
}

- (void)rightButtonTapped {
    if (self.rightButtonBlock) {
        self.rightButtonBlock();
    }
}

- (void)setupCellWithPaymentStage:(HHPaymentStage *)paymentStage currentStatge:(NSNumber *)currentStage {
    self.stepNumberLabel.text = [paymentStage.stageNumber stringValue];
    self.feeNameLabel.text = paymentStage.stageName;
    self.feeAmountLabel.text = [paymentStage.stageAmount generateMoneyString];
    
    if ([currentStage integerValue] == [paymentStage.stageNumber integerValue]) {
        self.stepNumberLabel.layer.masksToBounds = YES;
        self.stepNumberLabel.layer.borderWidth = 1.0f/[UIScreen mainScreen].scale;
        self.stepNumberLabel.layer.cornerRadius = kNumberLabelRadius;
        self.stepNumberLabel.layer.borderColor = [UIColor HHOrange].CGColor;
        
        self.stepNumberLabel.textColor = [UIColor HHOrange];
        self.feeNameLabel.textColor = [UIColor HHOrange];
        self.feeAmountLabel.textColor = [UIColor HHOrange];
        self.statusLabel.textColor = [UIColor HHOrange];
        
        self.statusLabel.text = @"待打款";
        [self.rightButton setImage:[UIImage imageNamed:@"ic_paylist_message_btn_unfocus"] forState:UIControlStateNormal];
        
    } else if ([currentStage integerValue] < [paymentStage.stageNumber integerValue] ) {
        self.stepNumberLabel.layer.masksToBounds = YES;
        self.stepNumberLabel.layer.borderWidth = 1.0f/[UIScreen mainScreen].scale;
        self.stepNumberLabel.layer.cornerRadius = kNumberLabelRadius;
        self.stepNumberLabel.layer.borderColor = [UIColor HHTextDarkGray].CGColor;
        
        self.stepNumberLabel.textColor = [UIColor HHTextDarkGray];
        self.feeNameLabel.textColor = [UIColor HHTextDarkGray];
        self.feeAmountLabel.textColor = [UIColor HHTextDarkGray];
        self.statusLabel.textColor = [UIColor HHTextDarkGray];
        
        self.statusLabel.text = @"待打款";
        [self.rightButton setImage:[UIImage imageNamed:@"ic_paylist_message_btn_unfocus"] forState:UIControlStateNormal];


    } else {
        self.stepNumberLabel.layer.borderWidth = 0;
        self.stepNumberLabel.textColor = [UIColor HHLightestTextGray];
        self.feeNameLabel.textColor = [UIColor HHLightestTextGray];
        self.feeAmountLabel.textColor = [UIColor HHLightestTextGray];
        self.statusLabel.textColor = [UIColor HHLightestTextGray];
        
        if ([paymentStage.reviewable boolValue]) {
            [self.rightButton remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.contentView.centerY);
                make.right.equalTo(self.contentView.right).offset(-5.0f);
                make.width.mas_equalTo(40.0f);
                make.height.mas_equalTo(20.0f);
            }];
            [self.rightButton setImage:nil forState:UIControlStateNormal];
            self.rightButton.titleLabel.font = [UIFont systemFontOfSize:11.0f];
            self.rightButton.layer.masksToBounds = YES;
            self.rightButton.layer.cornerRadius = 10.0f;
            [self.rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            if ([paymentStage.reviewed boolValue]) {
                [self.rightButton setTitle:@"已评价" forState:UIControlStateNormal];
                [self.rightButton setBackgroundColor:[UIColor colorWithRed:0.86 green:0.86 blue:0.86 alpha:1]];
                

            } else {
                [self.rightButton setTitle:@"待评价" forState:UIControlStateNormal];
                [self.rightButton setBackgroundColor:[UIColor HHOrange]];

            }
            
            

        } else {
            [self.rightButton setImage:[UIImage imageNamed:@"ic_paylist_message_btn_unfocus"] forState:UIControlStateNormal];

        }
        self.statusLabel.text = [NSString stringWithFormat:@"%@ 已打款", [[HHFormatUtility dateFormatter] stringFromDate:paymentStage.paidAt]];
    }
    
}

@end
