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
        
        self.licenseTypeLabel = [self buildLabel];
        [self addSubview:self.licenseTypeLabel];
        
        self.productTypeLabel = [self buildLabel];
        self.productTypeLabel.backgroundColor = [UIColor HHOrange];
        [self addSubview:self.productTypeLabel];
        
        
        self.priceLabel = [[UILabel alloc] init];
        self.priceLabel.textColor = [UIColor HHOrange];
        self.priceLabel.font = [UIFont systemFontOfSize:18.0f];
        [self addSubview:self.priceLabel];
        
        self.detailLabel = [[UILabel alloc] init];
        self.detailLabel.textColor = [UIColor HHLightTextGray];
        self.detailLabel.font = [UIFont systemFontOfSize:15.0f];
        [self addSubview:self.detailLabel];
        
        
        self.topLine = [[UIView alloc] init];
        self.topLine.backgroundColor = [UIColor HHLightLineGray];
        [self addSubview:self.topLine];
        

    }
    return self;
}

- (UILabel *)buildLabel {
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:12.0f];
    label.textColor = [UIColor whiteColor];
    label.layer.masksToBounds = YES;
    label.layer.cornerRadius = 5.0f;
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

- (void)setupWithPrice:(NSNumber *)price licenseType:(NSInteger)licenseType productText:(NSString *)productText detailText:(NSString *)detailText {
    self.priceLabel.text = [price generateMoneyString];
    
    NSString *typeString = @"C1手动挡";
    self.licenseTypeLabel.backgroundColor = [UIColor HHDarkOrange];
    if(licenseType == 2) {
        typeString = @"C2自动挡";
        self.licenseTypeLabel.backgroundColor = [UIColor colorWithRed:1.00 green:0.80 blue:0.21 alpha:1.00];
    }
    self.licenseTypeLabel.text = typeString;
    self.productTypeLabel.text = productText;
    self.detailLabel.text = detailText;
    
    [self.licenseTypeLabel sizeToFit];
    [self.productTypeLabel sizeToFit];
    
    [self.licenseTypeLabel remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left).offset(20.0f);
        make.bottom.equalTo(self.centerY).offset(-2.0f);
        make.width.mas_equalTo(CGRectGetWidth(self.licenseTypeLabel.frame) + 6.0f);
        make.height.mas_equalTo(CGRectGetHeight(self.licenseTypeLabel.frame) + 2.0f);
    }];
    
    [self.productTypeLabel remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.licenseTypeLabel.right).offset(7.0f);
        make.bottom.equalTo(self.centerY).offset(-2.0f);
        make.width.mas_equalTo(CGRectGetWidth(self.productTypeLabel.frame) + 6.0f);
        make.height.mas_equalTo(CGRectGetHeight(self.productTypeLabel.frame) + 2.0f);

    }];
    
    [self.priceLabel remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.right).offset(-20.0f);
        make.centerY.equalTo(self.licenseTypeLabel.centerY);
    }];
    
    [self.detailLabel remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.licenseTypeLabel.left);
        make.top.equalTo(self.centerY).offset(3.0f);
    }];
    
    [self.topLine remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.top);
        make.left.equalTo(self.left);
        make.width.equalTo(self.width);
        make.height.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
    }];

    
    
}


@end
