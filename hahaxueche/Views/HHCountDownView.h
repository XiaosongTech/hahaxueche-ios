//
//  HHCountDownView.h
//  hahaxueche
//
//  Created by Zixiao Wang on 7/26/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CountDown.h"


@interface HHCountDownView : UIView

@property (nonatomic, strong) UILabel *dayNumberLabel;
@property (nonatomic, strong) UILabel *dayLabel;
@property (nonatomic, strong) UILabel *hourNumberLabel;
@property (nonatomic, strong) UILabel *hourLabel;
@property (nonatomic, strong) UILabel *minNumberLabel;
@property (nonatomic, strong) UILabel *minLabel;
@property (nonatomic, strong) UILabel *secNumberLabel;
@property (nonatomic, strong) UILabel *secLabel;

@property (nonatomic, strong) CountDown *countDown;

- (instancetype)initWithStartDate:(NSDate *)strtDate finishDate:(NSDate *)finishDate numberColor:(UIColor *)numberColor textColor:(UIColor *)textColor numberFont:(UIFont *)numberFont textFont:(UIFont *)textFont;

@end
