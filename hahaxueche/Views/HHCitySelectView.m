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

static CGFloat const kCityButtonWidth = 85.0f;

@implementation HHCitySelectView

- (instancetype)initWithCities:(NSArray *)cities frame:(CGRect)frame selectedCity:(HHCity *)selectedCity {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor HHLightBackgroudGray];
        self.cities = cities;
        self.selectedCity = selectedCity;
        self.cityButtons = [NSMutableArray array];
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.titleLabel.text = @"所在城市";
    self.titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    self.titleLabel.textColor = [UIColor HHLightTextGray];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.titleLabel];
    
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
    
    for (int i = 0; i < self.cities.count; i++) {
        HHButton *cityButton = [[HHButton alloc] init];
        HHCity *city = self.cities[i];
        if(self.selectedCity) {
            if (city.cityId == self.selectedCity.cityId) {
                cityButton.backgroundColor = [UIColor HHOrange];
                [cityButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                
            } else {
                cityButton.backgroundColor = [UIColor whiteColor];
                [cityButton setTitleColor:[UIColor colorWithRed:0.573 green:0.573 blue:0.573 alpha:1] forState:UIControlStateNormal];
                
            }

        } else {
            cityButton.backgroundColor = [UIColor whiteColor];
            [cityButton setTitleColor:[UIColor colorWithRed:0.573 green:0.573 blue:0.573 alpha:1] forState:UIControlStateNormal];
        }
        cityButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        [cityButton setTitle:city.cityName forState:UIControlStateNormal];
        cityButton.tag = i;
        [cityButton addTarget:self action:@selector(cityButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:cityButton];
        [self.cityButtons addObject:cityButton];
    }
    
    [self makeConstraints];
}

#pragma mark - Auto Layout 

- (void)makeConstraints {
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.top).offset(5.0f);
        make.height.mas_equalTo(30.0f);
        make.width.equalTo(self.width).offset(-20.0f);
        make.centerX.equalTo(self.centerX);
    }];
    
    [self.confirmButton makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bottom);
        make.height.mas_equalTo(45.0f);
        make.width.equalTo(self.width).offset(-20.0f);
        make.centerX.equalTo(self.centerX);
    }];
    
    
    [self.bottomLine makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.confirmButton.top);
        make.height.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
        make.width.equalTo(self.width).offset(-20.0f);
        make.centerX.equalTo(self.centerX);
    }];
    
    [self.scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.bottom).offset(5.0f);
        make.bottom.equalTo(self.bottomLine.top);
        make.width.equalTo(self.width).offset(-20.0f);
        make.centerX.equalTo(self.centerX);
    }];
    
    
    
    
    
    for (int i = 0; i < self.cities.count; i++) {
        HHButton *cityButton = self.cityButtons[i];
        [cityButton makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(kCityButtonWidth);
            make.height.mas_equalTo(40.0f);
            make.top.mas_equalTo((i/3) * 50.0f);
            make.left.equalTo(self.scrollView.left).offset((i % 3) * (((CGRectGetWidth(self.bounds) - 20.0f - kCityButtonWidth * 3.0f))/2.0f + kCityButtonWidth));
            
        }];
    }
}

#pragma mark - Button Actions 

- (void)confirmButtonTapped {
    if (self.completion) {
        self.completion(self.selectedCity);
    }
}

- (void)cityButtonSelected:(HHButton *)button {
    for (HHButton *cityButton in self.cityButtons) {
        if (cityButton.tag == button.tag) {
            cityButton.backgroundColor = [UIColor HHOrange];
            [cityButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.selectedCity = self.cities[button.tag];
        } else {
            cityButton.backgroundColor = [UIColor whiteColor];
            [cityButton setTitleColor:[UIColor colorWithRed:0.573 green:0.573 blue:0.573 alpha:1] forState:UIControlStateNormal];
        }
    }
}


@end
