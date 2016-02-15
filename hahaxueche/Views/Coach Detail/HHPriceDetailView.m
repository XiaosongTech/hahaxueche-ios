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

@implementation HHPriceDetailView

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title totalPrice:(NSNumber *)totalPrice priceParts:(NSArray *)priceParts showOKButton:(BOOL)showOKButton {
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
        
        [self addPriceItemViewWithTitle:@"报名费" value:[@(200) generateMoneyString] index:0];
        
        if (!showOKButton) {
            self.buttonsView = [[HHConfirmCancelButtonsView alloc] initWithLeftTitle:@"确认付款" rightTitle:@"取消返回"];
            [self addSubview:self.buttonsView];
            
            [self.buttonsView.leftButton addTarget:self action:@selector(confirmButtonTapped) forControlEvents:UIControlEventTouchUpInside];
            [self.buttonsView.rightButton addTarget:self action:@selector(cancelButtonTapped) forControlEvents:UIControlEventTouchUpInside];
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
        }
        
        
        [self makeConstraints];
        
    }
    return self;
}

- (NSMutableAttributedString *)buildPriceTextWithPrice:(NSNumber *)price {
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"合计: "] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20.0f], NSForegroundColorAttributeName:[UIColor HHTextDarkGray]}];
    
     NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:[@(2850) generateMoneyString] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20.0f], NSForegroundColorAttributeName:[UIColor HHOrange]}];
    
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
