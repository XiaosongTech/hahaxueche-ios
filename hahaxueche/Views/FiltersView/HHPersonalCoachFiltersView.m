//
//  HHPersonalCoachFiltersView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 18/10/2016.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHPersonalCoachFiltersView.h"
#import "Masonry.h"
#import "HHSliderView.h"
#import "HHCheckBoxView.h"
#import "HHButton.h"
#import "UIColor+HHColor.h"
#import "HHConfirmScheduleBookView.h"

@interface HHPersonalCoachFiltersView ()

@property (nonatomic, strong) HHSliderView *priceSliderView;
@property (nonatomic, strong) HHCheckBoxView *c1CheckBoxView;
@property (nonatomic, strong) HHCheckBoxView *c2CheckBoxView;
@property (nonatomic, strong) HHConfirmCancelButtonsView *buttonsView;
@property (nonatomic, strong) UIView *horizontalLine;


@end

@implementation HHPersonalCoachFiltersView

- (instancetype)initWithFilters:(HHPersonalCoachFilters *)coachFilters frame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.coachFilters = coachFilters;
        
        self.priceSliderView = [[HHSliderView alloc] initWithTilte:@"价格筛选" values:@[@(50000), @(100000), @(150000), @(200000)] defaultValue:@(200000) sliderValueMode:SliderValueModePrice];
        [self addSubview:self.priceSliderView];
        
        self.horizontalLine = [[UIView alloc] init];
        self.horizontalLine.backgroundColor = [UIColor HHLightLineGray];
        [self addSubview:self.horizontalLine];
        
        self.c1CheckBoxView = [[HHCheckBoxView alloc] initWithTilte:@"手动档（C1）" isChecked:YES];
        [self addSubview:self.c1CheckBoxView];
        
        self.c2CheckBoxView = [[HHCheckBoxView alloc] initWithTilte:@"自动档（C2）" isChecked:YES];
        [self addSubview:self.c2CheckBoxView];

        
        self.buttonsView = [[HHConfirmCancelButtonsView alloc] initWithLeftTitle:@"取消" rightTitle:@"确认"];
        [self.buttonsView.leftButton addTarget:self action:@selector(cancelTapped) forControlEvents:UIControlEventTouchUpInside];
        [self.buttonsView.rightButton addTarget:self action:@selector(confirmTapped) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.buttonsView];
        
        [self.priceSliderView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.top);
            make.left.equalTo(self.left);
            make.width.equalTo(self.width);
            make.height.mas_equalTo(100.0f);
        }];
        
        [self.horizontalLine makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.priceSliderView.bottom).offset(10.0f);
            make.centerX.equalTo(self.centerX);
            make.width.equalTo(self.width).offset(-40.0f);
            make.height.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
        }];
        
        [self.c1CheckBoxView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.horizontalLine.bottom);
            make.left.equalTo(self.left).offset(20.0f);
            make.width.equalTo(self).multipliedBy(0.5f).offset(-20.0f);
            make.height.mas_equalTo(60.0f);
        }];
        
        [self.c2CheckBoxView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.horizontalLine.bottom);
            make.right.equalTo(self.right).offset(-20.0f);
            make.width.equalTo(self).multipliedBy(0.5f).offset(-20.0f);
            make.height.mas_equalTo(60.0f);
        }];

        
        [self.buttonsView makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.bottom);
            make.centerX.equalTo(self.centerX);
            make.width.equalTo(self.width);
            make.height.mas_equalTo(50.0f);
        }];
    }
    return self;
}

- (void)cancelTapped {
    
}

- (void)confirmTapped {
    
}

@end
