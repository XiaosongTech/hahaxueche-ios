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
#import "HHToastManager.h"

@interface HHPersonalCoachFiltersView ()

@property (nonatomic, strong) HHSliderView *priceSliderView;
@property (nonatomic, strong) HHCheckBoxView *c1CheckBoxView;
@property (nonatomic, strong) HHCheckBoxView *c2CheckBoxView;
@property (nonatomic, strong) HHConfirmCancelButtonsView *buttonsView;
@property (nonatomic, strong) NSArray *priceValues;


@end

@implementation HHPersonalCoachFiltersView

- (instancetype)initWithFilters:(HHPersonalCoachFilters *)coachFilters frame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.coachFilters = coachFilters;
        
        self.priceValues = @[@(50000), @(100000), @(150000), @(200000)];
        self.priceSliderView = [[HHSliderView alloc] initWithTilte:@"价格筛选" values:self.priceValues defaultValue:coachFilters.priceLimit sliderValueMode:SliderValueModePrice];
        [self addSubview:self.priceSliderView];
        
        if (!coachFilters.licenseType) {
            self.c1CheckBoxView = [[HHCheckBoxView alloc] initWithTilte:@"手动档（C1）" isChecked:YES];
            [self addSubview:self.c1CheckBoxView];
            
            self.c2CheckBoxView = [[HHCheckBoxView alloc] initWithTilte:@"自动档（C2）" isChecked:YES];
            [self addSubview:self.c2CheckBoxView];

        } else if ([coachFilters.licenseType integerValue] == 1) {
            self.c1CheckBoxView = [[HHCheckBoxView alloc] initWithTilte:@"手动档（C1）" isChecked:YES];
            [self addSubview:self.c1CheckBoxView];
            
            self.c2CheckBoxView = [[HHCheckBoxView alloc] initWithTilte:@"自动档（C2）" isChecked:NO];
            [self addSubview:self.c2CheckBoxView];
        } else {
            self.c1CheckBoxView = [[HHCheckBoxView alloc] initWithTilte:@"手动档（C1）" isChecked:NO];
            [self addSubview:self.c1CheckBoxView];
            
            self.c2CheckBoxView = [[HHCheckBoxView alloc] initWithTilte:@"自动档（C2）" isChecked:YES];
            [self addSubview:self.c2CheckBoxView];
        }
        
        
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
        
        [self.c1CheckBoxView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.priceSliderView.bottom);
            make.left.equalTo(self.left).offset(20.0f);
            make.width.equalTo(self).multipliedBy(0.5f).offset(-20.0f);
            make.height.mas_equalTo(60.0f);
        }];
        
        [self.c2CheckBoxView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.priceSliderView.bottom);
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
    if(self.cancelAction) {
        self.cancelAction();
    }
}

- (void)confirmTapped {
    if (self.c1CheckBoxView.checkBox.on && self.c2CheckBoxView.checkBox.on) {
        self.coachFilters.licenseType = nil;
        
    } else if (self.c1CheckBoxView.checkBox.on && !self.c2CheckBoxView.checkBox.on) {
        self.coachFilters.licenseType = @(1);
        
    } else if (!self.c1CheckBoxView.checkBox.on && self.c2CheckBoxView.checkBox.on) {
        self.coachFilters.licenseType = @(2);
    } else {
        [[HHToastManager sharedManager] showErrorToastWithText:@"请在C1手动档和C2自动挡中至少选择一个"];
        return;
    }
    
    self.coachFilters.priceLimit = self.priceValues[self.priceSliderView.slider.index];

    
    if (self.confirmAction) {
        self.confirmAction(self.coachFilters);
    }
}

@end
