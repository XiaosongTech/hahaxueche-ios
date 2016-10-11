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
        
        self.licenseTypeView = [[UIImageView alloc] init];
        [self addSubview:self.licenseTypeView];
        [self.licenseTypeView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.left).offset(20.0f);
            make.bottom.equalTo(self.centerY).offset(-2.0f);
        }];
        
        self.productTypeView = [[UIImageView alloc] init];
        [self addSubview:self.productTypeView];
        [self.productTypeView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.licenseTypeView.right).offset(5.0f);
            make.centerY.equalTo(self.licenseTypeView.centerY);
        }];
        
        
        self.priceLabel = [[UILabel alloc] init];
        self.priceLabel.textColor = [UIColor HHOrange];
        self.priceLabel.font = [UIFont systemFontOfSize:18.0f];
        [self addSubview:self.priceLabel];
        [self.priceLabel makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.right).offset(-20.0f);
            make.centerY.equalTo(self.licenseTypeView.centerY);
        }];
        
        
        
        self.detailLabel = [[UILabel alloc] init];
        self.detailLabel.textColor = [UIColor HHLightTextGray];
        self.detailLabel.font = [UIFont systemFontOfSize:15.0f];
        [self addSubview:self.detailLabel];
        [self.detailLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.licenseTypeView.left);
            make.top.equalTo(self.centerY).offset(3.0f);
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

- (void)setupWithPrice:(NSNumber *)price licenseImage:(UIImage *)licenseImage productImage:(UIImage *)productImage detailText:(NSString *)detailText {
    self.priceLabel.text = [price generateMoneyString];
    self.licenseTypeView.image = licenseImage;
    self.productTypeView.image = productImage;
    self.detailLabel.text = detailText;
}


@end
