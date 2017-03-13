//
//  HHCoachPriceInfoView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 09/03/2017.
//  Copyright © 2017 Zixiao Wang. All rights reserved.
//

#import "HHCoachPriceInfoView.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"
#import "NSNumber+HHNumber.h"
#import "HHConstantsStore.h"

@implementation HHCoachPriceInfoView

- (instancetype)initWithClassType:(CoachProductType)type coach:(HHCoach *)coach {
    self = [super init];
    if (self) {
        self.type = type;
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.textColor = [UIColor HHOrange];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        self.titleLabel.layer.masksToBounds = YES;
        self.titleLabel.layer.cornerRadius = 5.0f;
        self.titleLabel.layer.borderWidth = 1.0f/[UIScreen mainScreen].scale;
        self.titleLabel.layer.borderColor = [UIColor HHOrange].CGColor;
        [self addSubview:self.titleLabel];
        [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.centerY).offset(-5.0f);
            make.left.equalTo(self.left).offset(20.0f);
            make.width.mas_equalTo(45.0f);
            make.height.mas_equalTo(20.0f);
        }];
        
        self.subTitleLabel = [self buildLabelWithTextColor:[UIColor HHLightTextGray]];
        [self addSubview:self.subTitleLabel];
        [self.subTitleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.centerY).offset(5.0f);
            make.left.equalTo(self.left).offset(20.0f);
        }];
        
        self.purchaseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.purchaseButton addTarget:self action:@selector(purchaseTapped) forControlEvents:UIControlEventTouchUpInside];
        self.purchaseButton.backgroundColor = [UIColor HHDarkOrange];
        self.purchaseButton.layer.masksToBounds = YES;
        self.purchaseButton.layer.cornerRadius = 5.0f;
        [self.purchaseButton setTitle:@"报名" forState:UIControlStateNormal];
        [self.purchaseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.purchaseButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [self addSubview:self.purchaseButton];
        [self.purchaseButton makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.subTitleLabel.centerY);
            make.right.equalTo(self.right).offset(-20.0f);
            make.width.mas_equalTo(40.0f);
            make.height.mas_equalTo(20.0f);
        }];
        
        self.priceLabel = [self buildLabelWithTextColor:[UIColor HHDarkOrange]];
        [self addSubview:self.priceLabel];
        [self.priceLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.subTitleLabel.centerY);
            make.right.equalTo(self.purchaseButton.left).offset(-10.0f);
        }];
        
        self.arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_coachmsg_more_arrow"]];
        [self addSubview:self.arrowView];
        [self.arrowView makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.titleLabel.centerY);
            make.right.equalTo(self.right).offset(-20.0f);
        }];
        
        self.topLine = [[UIView alloc] init];
        self.topLine.backgroundColor = [UIColor HHLightLineGray];
        [self addSubview:self.topLine];
        [self.topLine makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.top);
            make.left.equalTo(self.left).offset(20.0f);
            make.right.equalTo(self.right);
            make.height.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
        }];
        
        switch (type) {
            case CoachProductTypeStandard: {
                self.titleLabel.text = @"超值班";
                self.subTitleLabel.text = @"四人一车, 高性价比";
            } break;
                
            case CoachProductTypeVIP: {
                self.titleLabel.text = @"VIP班";
                self.subTitleLabel.text = @"一人一车, 极速拿证";
                
            } break;
                
            case CoachProductTypeC2Standard: {
                self.titleLabel.text = @"超值班";
                self.subTitleLabel.text = @"四人一车, 高性价比";
            } break;
                
            case CoachProductTypeC2VIP: {
                self.titleLabel.text = @"VIP班";
                self.subTitleLabel.text = @"一人一车, 极速拿证";
                
            } break;
                
            case CoachProductTypeC1Wuyou: {
                self.titleLabel.text = @"无忧班";
                self.subTitleLabel.text = @"包补考费, 不过包赔";
                
            } break;
                
            case CoachProductTypeC2Wuyou: {
                self.titleLabel.text = @"无忧班";
                self.subTitleLabel.text = @"包补考费, 不过包赔";
            } break;
                
            default:
                break;
                
        }
        self.priceLabel.text = [[coach getPriceProductType:type] generateMoneyString];

    }
    return self;
}

- (UILabel *)buildLabelWithTextColor:(UIColor *)textColor {
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:16.0f];
    label.textColor = textColor;
    return label;
}

- (void)purchaseTapped {
    if (self.purchaseBlock) {
        self.purchaseBlock(self.type);
    }
}

@end
