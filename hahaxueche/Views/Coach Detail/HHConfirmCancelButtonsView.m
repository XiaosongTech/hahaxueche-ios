//
//  HHConfirmCancelButtonsView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 2/12/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHConfirmCancelButtonsView.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"

@implementation HHConfirmCancelButtonsView

- (instancetype)initWithLeftTitle:(NSString *)leftTitle rightTitle:(NSString *)rightTitle {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.leftButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [self.leftButton setTitleColor:[UIColor HHCancelRed] forState:UIControlStateNormal];
        [self.leftButton setTitle:leftTitle forState:UIControlStateNormal];
        [self addSubview:self.leftButton];
        
        self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.rightButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [self.rightButton setTitleColor:[UIColor HHConfirmGreen] forState:UIControlStateNormal];
        [self.rightButton setTitle:rightTitle forState:UIControlStateNormal];
        [self addSubview:self.rightButton];
        
        self.verticalLine = [[UIView alloc] init];
        self.verticalLine.backgroundColor = [UIColor HHLightLineGray];
        [self addSubview:self.verticalLine];
        
        self.horizontalLine = [[UIView alloc] init];
        self.horizontalLine.backgroundColor = [UIColor HHLightLineGray];
        [self addSubview:self.horizontalLine];
        
        [self makeConstraints];
    }
    return self;
}

- (void)makeConstraints {
    [self.leftButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.top);
        make.left.equalTo(self.left);
        make.width.equalTo(self.width).multipliedBy(0.5f);
        make.height.equalTo(self.height);
    }];
    
    [self.rightButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.top);
        make.left.equalTo(self.leftButton.right);
        make.width.equalTo(self.width).multipliedBy(0.5f);
        make.height.equalTo(self.height);
    }];
    
    [self.verticalLine makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
        make.height.equalTo(self.height).offset(-20.0f);
    }];
    
    [self.horizontalLine makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.top);
        make.width.equalTo(self.width);
        make.height.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
        make.left.equalTo(self.left);
    }];
}

@end
