//
//  HHCitySelectView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 1/2/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHCitySelectView.h"
#import "UIColor+HHColor.h"
#import "Masonry.h"

@implementation HHCitySelectView

- (instancetype)initWithCities:(NSArray *)cities frame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor HHLightBackgroudGray];
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    self.scrollView.scrollEnabled = YES;
    [self addSubview:self.scrollView];
    
    self.bottomLine = [[UIView alloc] initWithFrame:CGRectZero];
    self.bottomLine.backgroundColor = [UIColor HHLightLineGray];
    [self addSubview:self.bottomLine];
    
    self.confirmButton = [[HHButton alloc] init];
    [self.confirmButton HHOrangeTextButton];
    [self.confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [self.confirmButton addTarget:self action:@selector(confirmButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.confirmButton];
    
    [self makeConstraints];
}

#pragma mark - Auto Layout 

- (void)makeConstraints {
    [self.scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.top);
        make.height.mas_equalTo(CGRectGetHeight(self.bounds)-41.0f);
        make.width.equalTo(self.width).offset(-20.0f);
        make.centerX.equalTo(self.centerX);
    }];
    
    [self.bottomLine makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView.bottom);
        make.height.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
        make.width.equalTo(self.width).offset(-20.0f);
        make.centerX.equalTo(self.centerX);
    }];
    
    [self.confirmButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomLine.bottom);
        make.height.mas_equalTo(40.0f);
        make.width.equalTo(self.width).offset(-20.0f);
        make.centerX.equalTo(self.centerX);
    }];
}

#pragma mark - Button Actions 

- (void)confirmButtonTapped {
    
}

@end
