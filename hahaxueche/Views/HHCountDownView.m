//
//  HHCountDownView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 7/26/16.
//  Copyright © 2016 Zixiao Wang. All rights reserved.
//

#import "HHCountDownView.h"
#import "Masonry.h"

@implementation HHCountDownView

- (instancetype)initWithStartDate:(NSDate *)strtDate finishDate:(NSDate *)finishDate numberColor:(UIColor *)numberColor textColor:(UIColor *)textColor numberFont:(UIFont *)numberFont textFont:(UIFont *)textFont {
    self = [super init];
    if (self) {
        self.countDown = [[CountDown alloc] init];
        
        self.dayNumberLabel = [self buildLabelTextColor:numberColor font:numberFont];
        [self addSubview:self.dayNumberLabel];
        
        self.hourNumberLabel = [self buildLabelTextColor:numberColor font:numberFont];
        [self addSubview:self.hourNumberLabel];
        
        self.minNumberLabel = [self buildLabelTextColor:numberColor font:numberFont];
        [self addSubview:self.minNumberLabel];
        
        self.secNumberLabel = [self buildLabelTextColor:numberColor font:numberFont];
        [self addSubview:self.secNumberLabel];
        
        
        self.dayLabel = [self buildLabelTextColor:textColor font:textFont];
        self.dayLabel.text = @"天";
        [self addSubview:self.dayLabel];
        
        self.minLabel = [self buildLabelTextColor:textColor font:textFont];
        self.minLabel.text = @"分";
        [self addSubview:self.minLabel];
        
        self.secLabel = [self buildLabelTextColor:textColor font:textFont];
        self.secLabel.text = @"秒";
        [self addSubview:self.secLabel];
        
        self.hourLabel = [self buildLabelTextColor:textColor font:textFont];
        self.hourLabel.text = @"时";
        [self addSubview:self.hourLabel];
        
        [self.dayNumberLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.centerY);
            make.left.equalTo(self.left);
            make.width.mas_equalTo(CGRectGetWidth(self.dayNumberLabel.bounds));
        }];
        
        [self.dayLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.centerY);
            make.left.equalTo(self.dayNumberLabel.right);
        }];
        
        [self.hourNumberLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.centerY);
            make.left.equalTo(self.dayLabel.right);
            make.width.mas_equalTo(CGRectGetWidth(self.hourNumberLabel.bounds));
        }];
        
        [self.hourLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.centerY);
            make.left.equalTo(self.hourNumberLabel.right);
        }];
        
        
        [self.minNumberLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.centerY);
            make.left.equalTo(self.hourLabel.right);
            make.width.mas_equalTo(CGRectGetWidth(self.minNumberLabel.bounds));
        }];
        
        [self.minLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.centerY);
            make.left.equalTo(self.minNumberLabel.right);
        }];
        
        [self.secNumberLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.centerY);
            make.left.equalTo(self.minLabel.right);
            make.width.mas_equalTo(CGRectGetWidth(self.secNumberLabel.bounds));
        }];
        
        [self.secLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.centerY);
            make.left.equalTo(self.secNumberLabel.right);
        }];
        
        [self.countDown countDownWithStratDate:strtDate finishDate:finishDate completeBlock:^(NSInteger day, NSInteger hour, NSInteger minute, NSInteger second) {
            self.dayNumberLabel.text = [NSString stringWithFormat:@"%ld", (long)day];
            self.hourNumberLabel.text = [NSString stringWithFormat:@"%ld", (long)hour];
            self.minNumberLabel.text = [NSString stringWithFormat:@"%ld", (long)minute];
            self.secNumberLabel.text = [NSString stringWithFormat:@"%ld", (long)second];
            
        }];

        
    }
    return self;
}

- (void)dealloc {
    [self.countDown destoryTimer];
}

- (UILabel *)buildLabelTextColor:(UIColor *)textColor font:(UIFont *)textFont {
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"60";
    label.textColor = textColor;
    label.font = textFont;
    [label sizeToFit];
    return label;
}


@end
