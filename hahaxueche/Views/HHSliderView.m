//
//  HHSliderView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 1/13/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHSliderView.h"
#import "Masonry.h"
#import "UIColor+HHColor.h"
#import "HHFormatUtility.h"

static CGFloat const kBigCircleRadius = 12.0f;
static CGFloat const kSmallCircleRadius = 5.0f;
static CGFloat const kSliderLeftRightPadding = 30.0f;

@implementation HHSliderView

- (instancetype)initWithTilte:(NSString *)title values:(NSArray *)values defaultValue:(NSNumber *)defaultValue sliderValueMode:(SliderValueMode)sliderValueMode {
    self = [super init];
    if (self) {
        self.values = values;
        self.selectedValue = defaultValue;
        self.valueLabels = [NSMutableArray array];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.titleLabel.text = title;
        self.titleLabel.textColor = [UIColor HHLightTextGray];
        self.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [self addSubview:self.titleLabel];
        
        self.slider = [[StepSlider alloc] initWithFrame:CGRectZero];
        self.slider.maxCount = self.values.count;
        self.slider.index = [values indexOfObject:defaultValue];
        self.slider.trackColor = [UIColor colorWithRed:0.957 green:0.957 blue:0.957 alpha:1];
        self.slider.tintColor = [UIColor HHOrange];
        self.slider.sliderCircleColor = [UIColor HHOrange];
        self.slider.sliderCircleRadius = kBigCircleRadius;
        self.slider.trackCircleRadius = kSmallCircleRadius;
        [self.slider addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:self.slider];
        
        for (NSNumber *value in self.values) {
            UILabel *valueLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            switch (sliderValueMode) {
                case SliderValueModeDistance: {
                    valueLabel.text = [NSString stringWithFormat:@"%@km", [value stringValue]];
                } break;
                case SliderValueModePrice: {
                    valueLabel.text = [[HHFormatUtility moneyFormatter] stringFromNumber:value];
                } break;
                    
                default:
                    break;
            }
                       valueLabel.font = [UIFont systemFontOfSize:12.0f];
            if ([value floatValue] <= [defaultValue floatValue]) {
                valueLabel.textColor = [UIColor HHLightTextGray];
            } else {
                valueLabel.textColor = [UIColor colorWithRed:0.859 green:0.859 blue:0.859 alpha:1];
            }
            [self addSubview:valueLabel];
            [self.valueLabels addObject:valueLabel];
        }
        
        self.bottomLine = [[UIView alloc] initWithFrame:CGRectZero];
        self.bottomLine.backgroundColor = [UIColor HHLightLineGray];
        [self addSubview:self.bottomLine];
        
        [self makeConstraints];
    }
    return self;
}

- (void)makeConstraints {
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.top).offset(15.0f);
        make.centerX.equalTo(self.centerX);
    }];
    
    
    for (int i = 0; i < self.valueLabels.count; i++) {
        UILabel *label = self.valueLabels[i];
        [label makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.bottom).offset(-15.0f);
            CGFloat offSet = kSliderLeftRightPadding + kBigCircleRadius + (CGRectGetWidth([[UIScreen mainScreen] bounds]) - kSliderLeftRightPadding * 2 - kBigCircleRadius * 2 - 20.0f) * i / (self.valueLabels.count - 1);
            make.centerX.equalTo(self.left).offset(offSet);
        }];
       
    }
    UILabel *label = [self.valueLabels firstObject];
    [self.slider makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(label.top);
        make.centerX.equalTo(self.centerX);
        make.height.mas_equalTo(30.0f);
        make.width.equalTo(self.width).offset(-2 * kSliderLeftRightPadding);
    }];
    
    [self.bottomLine makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bottom);
        make.width.equalTo(self.width).offset(-40.0f);
        make.centerX.equalTo(self.centerX);
        make.height.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
    }];

}



- (void)valueChanged:(StepSlider *)slider {
    for (int i = 0; i < self.valueLabels.count; i++) {
        UILabel *valueLabel = self.valueLabels[i];
        if (slider.index >= i) {
            valueLabel.textColor = [UIColor HHLightTextGray];
        } else {
            valueLabel.textColor = [UIColor colorWithRed:0.859 green:0.859 blue:0.859 alpha:1];
        }
    }

}

@end
