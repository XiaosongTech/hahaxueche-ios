//
//  HHFiltersView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 1/13/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHFiltersView.h"
#import "Masonry.h"
#import "HHSliderView.h"
#import "HHSwitchView.h"
#import "HHCheckBoxView.h"
#import "HHButton.h"
#import "UIColor+HHColor.h"
#import "HHToastManager.h"

static CGFloat const kCellHeight = 60.0f;

@interface HHFiltersView ()

@property (nonatomic, strong) HHSliderView *distanceSliderView;
@property (nonatomic, strong) HHSliderView *priceSliderView;
@property (nonatomic, strong) HHSwitchView *goldenCoachSwitchView;
@property (nonatomic, strong) HHSwitchView *vipCoachSwitchView;
@property (nonatomic, strong) HHCheckBoxView *c1CheckBoxView;
@property (nonatomic, strong) HHCheckBoxView *c2CheckBoxView;

@property (nonatomic, strong) HHButton *confirmButton;
@property (nonatomic, strong) HHButton *cancelButton;
@property (nonatomic, strong) UIView *horizontalLine;
@property (nonatomic, strong) UIView *verticalLine;

@property (nonatomic, strong) NSArray *priceValues;
@property (nonatomic, strong) NSArray *distanceValues;

@property (nonatomic, strong) HHCity *city;

@end

@implementation HHFiltersView

- (instancetype)initWithFilters:(HHCoachFilters *)coachFilters frame:(CGRect)frame city:(HHCity *)city {
    self = [super initWithFrame:frame];
    if (self) {
        self.city = city;
        self.backgroundColor = [UIColor whiteColor];
        self.coachFilters = coachFilters;
        
        self.distanceValues = self.city.distanceRanges;
        self.priceValues = self.city.priceRanges;
        self.distanceSliderView = [[HHSliderView alloc] initWithTilte:@"距离筛选" values:self.distanceValues defaultValue:self.coachFilters.distance sliderValueMode:SliderValueModeDistance];
        [self addSubview:self.distanceSliderView];
        
        self.priceSliderView = [[HHSliderView alloc] initWithTilte:@"价格筛选" values:self.priceValues defaultValue:self.coachFilters.price sliderValueMode:SliderValueModePrice];
        [self addSubview:self.priceSliderView];
        
        self.goldenCoachSwitchView = [[HHSwitchView alloc] initWithTitle:@"只显示金牌教练" isToggleOn:[self.coachFilters.onlyGoldenCoach boolValue]];
        [self addSubview:self.goldenCoachSwitchView];
        
        self.vipCoachSwitchView = [[HHSwitchView alloc] initWithTitle:@"只显示VIP班教练" isToggleOn:[self.coachFilters.onlyVIPCoach boolValue]];
        [self addSubview:self.vipCoachSwitchView];
        
        BOOL c1Checked = YES;
        BOOL c2Checked = YES;
        if ([coachFilters.licenseType integerValue] == 1) {
            c2Checked = NO;
        } else if ([coachFilters.licenseType integerValue] == 2) {
            c1Checked = NO;
        }
        self.c1CheckBoxView = [[HHCheckBoxView alloc] initWithTilte:@"手动档（C1）" isChecked:c1Checked];
        [self addSubview:self.c1CheckBoxView];
        
        self.c2CheckBoxView = [[HHCheckBoxView alloc] initWithTilte:@"自动档（C2）" isChecked:c2Checked];
        [self addSubview:self.c2CheckBoxView];
        
        self.horizontalLine = [[UIView alloc] init];
        self.horizontalLine.backgroundColor = [UIColor HHLightLineGray];
        [self addSubview:self.horizontalLine];
        
        self.confirmButton = [[HHButton alloc] init];
        [self.confirmButton HHConfirmButton];
        [self.confirmButton addTarget:self action:@selector(confirmTapped) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.confirmButton];
        
        self.cancelButton = [[HHButton alloc] init];
        [self.cancelButton HHCancelButton];
        [self.cancelButton addTarget:self action:@selector(cancelTapped) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.cancelButton];
        
        self.verticalLine = [[UIView alloc] init];
        self.verticalLine.backgroundColor = [UIColor HHLightLineGray];
        [self addSubview:self.verticalLine];
        
        [self makeConstraints];
    }
    return self;
}

- (void)makeConstraints {
    [self.distanceSliderView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.top);
        make.left.equalTo(self.left);
        make.width.equalTo(self.width);
        make.height.mas_equalTo(100.0f);
    }];
    
    [self.priceSliderView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.distanceSliderView.bottom);
        make.left.equalTo(self.left);
        make.width.equalTo(self.width);
        make.height.mas_equalTo(100.0f);
    }];
    
    [self.goldenCoachSwitchView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.priceSliderView.bottom);
        make.left.equalTo(self.left);
        make.width.equalTo(self.width);
        make.height.mas_equalTo(kCellHeight);
    }];
    
    [self.vipCoachSwitchView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.goldenCoachSwitchView.bottom);
        make.left.equalTo(self.left);
        make.width.equalTo(self.width);
        make.height.mas_equalTo(kCellHeight);
    }];
    
    [self.c1CheckBoxView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.vipCoachSwitchView.bottom);
        make.left.equalTo(self.left).offset(20.0f);
        make.width.equalTo(self).multipliedBy(0.5f).offset(-20.0f);
        make.height.mas_equalTo(kCellHeight);
    }];
    
    [self.c2CheckBoxView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.vipCoachSwitchView.bottom);
        make.right.equalTo(self.right).offset(-20.0f);
        make.width.equalTo(self).multipliedBy(0.5f).offset(-20.0f);
        make.height.mas_equalTo(kCellHeight);
    }];
    
    [self.horizontalLine makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.c1CheckBoxView.bottom);
        make.centerX.equalTo(self.centerX);
        make.width.equalTo(self.width).offset(-40.0f);
        make.height.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
    }];
    
    [self.confirmButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cancelButton.right);
        make.height.mas_equalTo(kCellHeight);
        make.top.equalTo(self.horizontalLine.bottom);
        make.width.equalTo(self.width).multipliedBy(0.5f).offset(-20.0f);
    }];
    [self.cancelButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left).offset(20.0f);
        make.height.mas_equalTo(kCellHeight);
        make.top.equalTo(self.horizontalLine.bottom);
        make.width.equalTo(self.width).multipliedBy(0.5f).offset(-20.0f);
    }];
    
    [self.verticalLine makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.centerX);
        make.centerY.equalTo(self.bottom).offset(-25.0f);
        make.width.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
        make.height.mas_equalTo(kCellHeight/2.0f);
    }];
}

- (void)confirmTapped {
    if (self.c1CheckBoxView.checkBox.on && self.c2CheckBoxView.checkBox.on) {
        self.coachFilters.licenseType = @(3);
        
    } else if (self.c1CheckBoxView.checkBox.on && !self.c2CheckBoxView.checkBox.on) {
        self.coachFilters.licenseType = @(1);
        
    } else if (!self.c1CheckBoxView.checkBox.on && self.c2CheckBoxView.checkBox.on) {
        self.coachFilters.licenseType = @(2);
    } else {
        [[HHToastManager sharedManager] showErrorToastWithText:@"请在C1手动档和C2自动挡中至少选择一个"];
        return;
    }

    self.coachFilters.price = self.priceValues[self.priceSliderView.slider.index];
    self.coachFilters.distance = self.distanceValues[self.distanceSliderView.slider.index];
    self.coachFilters.onlyGoldenCoach = @(self.goldenCoachSwitchView.toggle.isOn);
    self.coachFilters.onlyVIPCoach = @(self.vipCoachSwitchView.toggle.isOn);
    
    if (self.confirmBlock) {
        self.confirmBlock(self.coachFilters);
    }
}

- (void)cancelTapped {
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}

@end
