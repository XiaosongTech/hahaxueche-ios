//
//  HHPriceDetailView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 2/13/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHPriceDetailView.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"
#import "NSNumber+HHNumber.h"
#import "HHConstantsStore.h"
#import "HHCity.h"
#import "HHCityFixedFee.h"

@implementation HHPriceDetailView

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title totalPrice:(NSNumber *)totalPrice showOKButton:(BOOL)showOKButton {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.text = title;
        self.titleLabel.textColor = [UIColor HHTextDarkGray];
        self.titleLabel.font = [UIFont systemFontOfSize:20.0f];
        [self addSubview:self.titleLabel];
        
        self.totalPriceLabel = [[UILabel alloc] init];
        self.totalPriceLabel.attributedText = [self buildPriceTextWithPrice:totalPrice];
        [self addSubview:self.totalPriceLabel];
        
        self.topLine = [[UIView alloc] init];
        self.topLine.backgroundColor = [UIColor HHLightLineGray];
        [self addSubview:self.topLine];
        
        HHCity *city = [[HHConstantsStore sharedInstance] getAuthedUserCity];
        int i = 0;
        NSInteger traningFee = [totalPrice integerValue];
        for (HHCityFixedFee *fee in city.cityFixedFees) {
            NSString *value = [fee.feeAmount generateMoneyString];
            if ([fee.feeAmount integerValue] == 0) {
                value = @"免费赠送";
            }
            [self addPriceItemViewWithTitle:fee.feeName value:value index:i];
            traningFee = traningFee - [fee.feeAmount integerValue];
            i++;
        }
        
        [self addPriceItemViewWithTitle:@"培训费（您的教练）" value:[@(traningFee) generateMoneyString] index:i];
        
        self.midLine = [[UIView alloc] init];
        self.midLine.backgroundColor = [UIColor HHLightLineGray];
        [self addSubview:self.midLine];
        
        self.otherFeesLabel = [[UILabel alloc] init];
        self.otherFeesLabel.text = title;
        self.otherFeesLabel.numberOfLines = 0;
        self.otherFeesLabel.text = @"备注：以下费用根据个人实际情况需要另外缴纳\n\n补考费（车管所）——按车管所公示价格收取\n模拟考试费（考场）——按考场公示价格收取";
        self.otherFeesLabel.textColor = [UIColor HHLightTextGray];
        self.otherFeesLabel.font = [UIFont systemFontOfSize:12.0f];
        [self addSubview:self.otherFeesLabel];
        
        if (!showOKButton) {
            self.buttonsView = [[HHConfirmCancelButtonsView alloc] initWithLeftTitle:@"确认付款" rightTitle:@"取消返回"];
            [self addSubview:self.buttonsView];
            
            [self.buttonsView.leftButton addTarget:self action:@selector(confirmButtonTapped) forControlEvents:UIControlEventTouchUpInside];
            [self.buttonsView.rightButton addTarget:self action:@selector(cancelButtonTapped) forControlEvents:UIControlEventTouchUpInside];
            self.otherFeesLabel.hidden = YES;
            self.midLine.hidden = YES;
        } else {
            self.okButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.okButton setTitle:@"知道了" forState:UIControlStateNormal];
            [self.okButton setTitleColor:[UIColor HHOrange] forState:UIControlStateNormal];
            self.okButton.titleLabel.font = [UIFont systemFontOfSize:18.0f];
            [self.okButton addTarget:self action:@selector(cancelButtonTapped) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:self.okButton];
            
            self.botLine = [[UIView alloc] init];
            self.botLine.backgroundColor = [UIColor HHLightLineGray];
            [self addSubview:self.botLine];
            
            self.otherFeesLabel.hidden = NO;
            self.midLine.hidden = NO;
        }
        
        
        [self makeConstraints];
        
    }
    return self;
}

- (NSMutableAttributedString *)buildPriceTextWithPrice:(NSNumber *)price {
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"合计: "] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20.0f], NSForegroundColorAttributeName:[UIColor HHTextDarkGray]}];
    
     NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:[price generateMoneyString] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20.0f], NSForegroundColorAttributeName:[UIColor HHOrange]}];
    
    [attrString appendAttributedString:attrString2];
    return attrString;
}

- (void)makeConstraints {
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.top).offset(15.0f);
        make.left.equalTo(self.left).offset(20.0f);
    }];
    
    [self.totalPriceLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.top).offset(15.0f);
        make.right.equalTo(self.right).offset(-20.0f);
    }];
    
    [self.topLine makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.bottom).offset(15.0f);
        make.left.equalTo(self.left);
        make.width.equalTo(self.width);
        make.height.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
    }];
    HHCity *city = [[HHConstantsStore sharedInstance] getAuthedUserCity];
    [self.midLine makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topLine.bottom).offset((city.cityFixedFees.count + 1) * 50.0f);
        make.left.equalTo(self.left).offset(20.0f);
        make.width.equalTo(self.width).offset(-40.0f);
        make.height.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
    }];
    
    [self.otherFeesLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.midLine.bottom).offset(10.0f);
        make.left.equalTo(self.left).offset(20.0f);
        make.width.equalTo(self.width).offset(-40.0f);
    }];
    
    if (self.buttonsView) {
        [self.buttonsView makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.bottom);
            make.left.equalTo(self.left);
            make.width.equalTo(self.width);
            make.height.mas_equalTo(50.0f);
        }];
    } else {
        [self.okButton makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.bottom);
            make.left.equalTo(self.left);
            make.width.equalTo(self.width);
            make.height.mas_equalTo(50.0f);
        }];
        [self.botLine makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.okButton.top);
            make.left.equalTo(self.left);
            make.width.equalTo(self.width);
            make.height.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
        }];
    }
    
}

- (void)addPriceItemViewWithTitle:(NSString *)title value:(NSString *)value index:(NSInteger) index {
    UIView *view  = [[UIView alloc] init];
    [self addSubview:view];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = title;
    titleLabel.textColor = [UIColor HHLightTextGray];
    titleLabel.font = [UIFont systemFontOfSize:18.0f];
    [view addSubview:titleLabel];
    
    UILabel *valueLabel = [[UILabel alloc] init];
    valueLabel.text = value;
    valueLabel.textColor = [UIColor HHOrange];
    valueLabel.font = [UIFont systemFontOfSize:18.0f];
    [view addSubview:valueLabel];
    
    [titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.left).offset(20.0f);
        make.centerY.equalTo(view.centerY);
    }];
    
    [valueLabel makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view.right).offset(-20.0f);
        make.centerY.equalTo(view.centerY);
    }];
    
    [view makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topLine.bottom).offset(index * 50.0f);
        make.width.equalTo(self.width);
        make.height.mas_equalTo(50.0f);
        make.left.equalTo(self.left);
    }];
}

- (void)confirmButtonTapped {
    if (self.confirmBlock) {
        self.confirmBlock();
    }
}

- (void)cancelButtonTapped {
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}

@end