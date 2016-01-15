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

static CGFloat const kCellHeight = 60.0f;

@interface HHFiltersView ()

@property (nonatomic, strong) HHSliderView *distanceSliderView;
@property (nonatomic, strong) HHSliderView *priceSliderView;
@property (nonatomic, strong) HHSwitchView *goldenCoachSwitchView;
@property (nonatomic, strong) HHCheckBoxView *c1CheckBoxView;
@property (nonatomic, strong) HHCheckBoxView *c2CheckBoxView;

@property (nonatomic, strong) HHButton *confirmButton;
@property (nonatomic, strong) HHButton *cancelButton;
@property (nonatomic, strong) UIView *horizontalLine;
@property (nonatomic, strong) UIView *verticalLine;

@end

@implementation HHFiltersView

- (instancetype)initWithFilters:(HHCoachFilters *)coachFilters frame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.coachFilters = coachFilters;
        self.distanceSliderView = [[HHSliderView alloc] initWithTilte:@"距离筛选" values:@[@(2), @(2.5), @(3), @(3.5)] defaultValue:self.coachFilters.distance sliderValueMode:SliderValueModeDistance];
        [self addSubview:self.distanceSliderView];
        
        self.priceSliderView = [[HHSliderView alloc] initWithTilte:@"价格筛选" values:@[@(2000), @(2500), @(3000), @(3500)] defaultValue:self.coachFilters.price sliderValueMode:SliderValueModePrice];
        [self addSubview:self.priceSliderView];
        
        self.goldenCoachSwitchView = [[HHSwitchView alloc] initWithTitle:@"只显示金牌教练" isToggleOn:[self.coachFilters.onlyGoldenCoach boolValue]];
        [self addSubview:self.goldenCoachSwitchView];
        
        self.c1CheckBoxView = [[HHCheckBoxView alloc] initWithTilte:@"手动档（C1）" isChecked:NO];
        [self addSubview:self.c1CheckBoxView];
        
        self.c2CheckBoxView = [[HHCheckBoxView alloc] initWithTilte:@"自动档（C2）" isChecked:YES];
        [self addSubview:self.c2CheckBoxView];
        
        self.horizontalLine = [[UIView alloc] init];
        self.horizontalLine.backgroundColor = [UIColor HHLightLineGray];
        [self addSubview:self.horizontalLine];
        
        self.confirmButton = [[HHButton alloc] init];
        [self.confirmButton HHConfirmButton];
        [self addSubview:self.confirmButton];
        
        self.cancelButton = [[HHButton alloc] init];
        [self.cancelButton HHCancelButton];
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
    
    [self.c1CheckBoxView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.goldenCoachSwitchView.bottom);
        make.left.equalTo(self.left).offset(20.0f);
        make.width.equalTo(self).multipliedBy(0.5f).offset(-20.0f);
        make.height.mas_equalTo(kCellHeight);
    }];
    
    [self.c2CheckBoxView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.goldenCoachSwitchView.bottom);
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
        make.left.equalTo(self.left).offset(20.0f);
        make.height.mas_equalTo(kCellHeight);
        make.top.equalTo(self.horizontalLine.bottom);
        make.width.equalTo(self.width).multipliedBy(0.5f).offset(-20.0f);
    }];
    [self.cancelButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.confirmButton.right);
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

@end
