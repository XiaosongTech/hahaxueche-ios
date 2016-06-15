//
//  HHPriceItemView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 6/2/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHPriceItemView.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"
#import "NSNumber+HHNumber.h"

@implementation HHPriceItemView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.priceLabel = [[UILabel alloc] init];
        self.priceLabel.textColor = [UIColor HHOrange];
        self.priceLabel.font = [UIFont systemFontOfSize:18.0f];
        [self addSubview:self.priceLabel];
        [self.priceLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left).offset(18.0f);
            make.centerY.equalTo(self.centerY).offset(-12.0f);
        }];
        
        self.iconView = [[UIImageView alloc] init];
        [self addSubview:self.iconView];
        [self.iconView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.priceLabel.right).offset(5.0f);
            make.centerY.equalTo(self.priceLabel.centerY);
        }];
        
        self.marketPriceLabel = [[UILabel alloc] init];
        [self addSubview:self.marketPriceLabel];
        [self.marketPriceLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconView.right).offset(5.0f);
            make.centerY.equalTo(self.priceLabel.centerY);
        }];
        
        self.detailLabel = [[UILabel alloc] init];
        self.detailLabel.textColor = [UIColor HHLightTextGray];
        self.detailLabel.font = [UIFont systemFontOfSize:15.0f];
        [self addSubview:self.detailLabel];
        [self.detailLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.priceLabel.left).offset(3.0f);
            make.top.equalTo(self.priceLabel.bottom).offset(5.0f);
        }];
        
        self.priceDetailButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.priceDetailButton setTitle:@"价格明细" forState:UIControlStateNormal];
        [self.priceDetailButton setTitleColor:[UIColor HHOrange] forState:UIControlStateNormal];
        self.priceDetailButton.layer.masksToBounds = YES;
        self.priceDetailButton.layer.borderColor = [UIColor HHOrange].CGColor;
        self.priceDetailButton.layer.borderWidth = 1.0f/[UIScreen mainScreen].scale;
        self.priceDetailButton.layer.cornerRadius = 2.0f;
        self.priceDetailButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        [self.priceDetailButton addTarget:self action:@selector(priceDetailButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.priceDetailButton];
        
        [self.priceDetailButton makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.right).offset(-18.0f);
            make.centerY.equalTo(self.centerY);
            make.width.mas_equalTo(60.0f);
            make.height.mas_equalTo(25.0f);
        }];
        
        self.topLine = [[UIView alloc] init];
        self.topLine.backgroundColor = [UIColor HHLightLineGray];
        [self addSubview:self.topLine];
        [self.topLine makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.top);
            make.left.equalTo(self.left);
            make.width.equalTo(self.width);
            make.height.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
        }];

    }
    return self;
}

- (void)setupWithPrice:(NSNumber *)price iconImage:(UIImage *)iconImage marketPrice:(NSNumber *)marketPrice detailText:(NSString *)detailText {
    self.priceLabel.text = [price generateMoneyString];
    self.iconView.image = iconImage;
    self.marketPriceLabel.attributedText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"门市价:%@", [marketPrice generateMoneyString]] attributes:@{NSStrikethroughStyleAttributeName:@(1), NSFontAttributeName:[UIFont systemFontOfSize:12.0f], NSForegroundColorAttributeName:[UIColor HHLightestTextGray]}];
    
    [self.marketPriceLabel sizeToFit];
    
    self.detailLabel.text = detailText;
}

- (void)priceDetailButtonTapped {
    if (self.priceDetailBlock) {
        self.priceDetailBlock();
    }
}

@end
