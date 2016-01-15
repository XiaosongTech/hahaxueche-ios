//
//  HHSwitchView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 1/14/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHSwitchView.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"

@implementation HHSwitchView

- (instancetype)initWithTitle:(NSString *)title isToggleOn:(BOOL)isToggleOn {
    self = [super init];
    if (self) {
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.text = title;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.textColor = [UIColor HHLightTextGray];
        self.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [self addSubview:self.titleLabel];
        
        
        self.toggle = [[UISwitch alloc] init];
        self.toggle.onTintColor = [UIColor HHOrange];
        [self.toggle setOn:isToggleOn];
        [self addSubview:self.toggle];
        
        self.bottomLine = [[UIView alloc] init];
        self.bottomLine.backgroundColor = [UIColor HHLightLineGray];
        [self addSubview:self.bottomLine];
        
        [self makeConstraints];
    }
    return self;
}

- (void)makeConstraints {
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.centerY);
        make.left.equalTo(self.left).offset(20.0f);
        make.height.equalTo(self.height);
    }];
    
    [self.toggle makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.right).offset(-20.0f);
        make.centerY.equalTo(self.centerY);
    }];
    
    [self.bottomLine makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.centerX);
        make.width.equalTo(self.width).offset(-40.0f);
        make.bottom.equalTo(self.bottom);
        make.height.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
    }];
}

@end
