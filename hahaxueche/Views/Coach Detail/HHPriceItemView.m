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
        
        self.productTypeLabel = [self buildLabel];
        self.productTypeLabel.layer.masksToBounds = YES;
        self.productTypeLabel.layer.borderWidth = 2.0f/[UIScreen mainScreen].scale;
        self.priceLabel.layer.cornerRadius = 5.0f;
        [self addSubview:self.productTypeLabel];
        
        
        self.priceLabel = [[UILabel alloc] init];
        self.priceLabel.font = [UIFont systemFontOfSize:18.0f];
        [self addSubview:self.priceLabel];
        
        self.detailLabel = [[UILabel alloc] init];
        self.detailLabel.textColor = [UIColor HHLightTextGray];
        self.detailLabel.font = [UIFont systemFontOfSize:16.0f];
        [self addSubview:self.detailLabel];
        
        
        self.botLine = [[UIView alloc] init];
        self.botLine.backgroundColor = [UIColor HHLightLineGray];
        [self addSubview:self.botLine];
        

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

- (void)setupWithPrice:(NSNumber *)price productText:(NSString *)productText detailText:(NSString *)detailText priceColor:(UIColor *)priceColor showBotLine:(BOOL)showBotLine {
    self.priceLabel.text = [price generateMoneyString];
    
    self.productTypeLabel.text = productText;
    self.detailLabel.text = detailText;
    
    self.productTypeLabel.textColor = priceColor;
    self.productTypeLabel.layer.borderColor = priceColor.CGColor;
    self.priceLabel.textColor = priceColor;
    
    [self.productTypeLabel sizeToFit];
    
    [self.productTypeLabel remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left).offset(20.0f);
        make.centerY.equalTo(self.centerY);
        make.width.mas_equalTo(42.0f);
        make.height.mas_equalTo(20.0f);

    }];
    
    [self.priceLabel remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.right).offset(-20.0f);
        make.centerY.equalTo(self.productTypeLabel.centerY);
    }];
    
    [self.detailLabel remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.productTypeLabel.right).offset(8.0f);
        make.centerY.equalTo(self.centerY);
    }];
    
    if (showBotLine) {
        self.botLine.hidden = NO;
    } else {
        self.botLine.hidden = YES;
    }
    [self.botLine remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bottom);
        make.left.equalTo(self.productTypeLabel.left);
        make.right.equalTo(self.right);
        make.height.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
    }];

    
    
}


@end
