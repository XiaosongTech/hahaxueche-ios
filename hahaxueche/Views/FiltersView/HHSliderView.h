//
//  HHSliderView.h
//  hahaxueche
//
//  Created by Zixiao Wang on 1/13/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StepSlider/StepSlider.h>

typedef NS_ENUM(NSInteger, SliderValueMode) {
    SliderValueModeDistance,
    SliderValueModePrice,
};

@interface HHSliderView : UIView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) StepSlider *slider;
@property (nonatomic, strong) NSArray *values;
@property (nonatomic, strong) NSNumber *selectedValue;
@property (nonatomic, strong) NSMutableArray *valueLabels;
@property (nonatomic, strong) UIView *bottomLine;

- (instancetype)initWithTilte:(NSString *)title values:(NSArray *)values defaultValue:(NSNumber *)defaultValue sliderValueMode:(SliderValueMode)sliderValueMode;

@end
