//
//  HHPriceView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 9/5/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHPriceView.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"
#import "NSNumber+HHNumber.h"

@implementation HHPriceView

- (instancetype)initWithTitle:(NSString *)title subTitle:(NSString *)subTitle price:(NSNumber *)price {
    self = [super init];
    if (self) {
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.text = title;
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.layer.masksToBounds = YES;
        self.titleLabel.layer.cornerRadius = 5.0f;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.backgroundColor = [UIColor HHOrange];
        self.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        [self addSubview:self.titleLabel];
        
        [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left);
            make.centerY.equalTo(self.centerY);
            make.width.mas_equalTo(30.0f);
        }];
        
        self.subTitleLabel = [[UILabel alloc] init];
        self.subTitleLabel.text = subTitle;
        self.subTitleLabel.font = [UIFont systemFontOfSize:12.0f];
        self.subTitleLabel.textColor = [UIColor HHLightTextGray];
        [self addSubview:self.subTitleLabel];
        [self.subTitleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel.right).offset(5.0f);
            make.centerY.equalTo(self.centerY);
        }];
        
        self.priceLabel = [[UILabel alloc] init];
        self.priceLabel.text = [price generateMoneyString];
        self.priceLabel.font = [UIFont systemFontOfSize:15.0f];
        self.priceLabel.textColor = [UIColor HHOrange];
        [self addSubview:self.priceLabel];
        
        [self.priceLabel makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.right).offset(-15.0f);
            make.centerY.equalTo(self.centerY);
        }];
        
        self.topLine = [[UIView alloc] init];
        self.topLine.backgroundColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
        [self addSubview:self.topLine];
        [self.topLine makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left);
            make.top.equalTo(self.top);
            make.width.equalTo(self.width);
            make.height.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
        }];
    }
    return self;
}

@end
