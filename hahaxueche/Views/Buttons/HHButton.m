//
//  HHButton.m
//  hahaxueche
//
//  Created by Zixiao Wang on 7/12/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import "HHButton.h"
#import "UIColor+HHColor.h"
#import "UIImage+HHImage.h"
#import <QuartzCore/QuartzCore.h>


@implementation HHButton

- (HHButton *)initFloatButtonWithTitle:(NSString *)title frame:(CGRect)frame backgroundColor:(UIColor *)color {
    self = [super init];
    if (self) {
        [self setTitle:title forState:UIControlStateNormal];
        self.frame = frame;
        [self setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont fontWithName:@"SourceHanSansSC-Regular" size:14];
        self.backgroundColor = color;
        self.clipsToBounds = YES;
        self.layer.cornerRadius = CGRectGetHeight(frame)/2;
        self.layer.shadowColor = [UIColor darkGrayColor].CGColor;
        self.layer.shadowOpacity = 0.8;
        self.layer.shadowRadius = 1.0f;
        self.layer.shadowOffset = CGSizeMake(1.0, 1.0f);
        self.layer.masksToBounds = NO;
    }
    return self;
}


- (HHButton *)initDropDownButtonWithTitle:(NSString *)title frame:(CGRect)frame {
    self = [super init];
    if (self) {
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        self.frame = frame;
        self.titleLabel.font = [UIFont fontWithName:@"SourceHanSansSC-Medium" size:15];
        self.backgroundColor = [UIColor HHOrange];
    }
    return self;
}

- (HHButton *)initThinBorderButtonWithTitle:(NSString *)title textColor:(UIColor *)textColor font:(UIFont *)font borderColor:(UIColor *)borderColor backgroundColor:(UIColor *)backgroundColor {
    self = [super init];
    if (self) {
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:textColor forState:UIControlStateNormal];
        self.titleLabel.font = font;;
        self.backgroundColor = backgroundColor;
        self.layer.masksToBounds = YES;
        self.layer.borderColor = borderColor.CGColor;
        self.layer.borderWidth = 1.0f;
        self.layer.cornerRadius = 5.0f;
        [self setBackgroundImage:[UIImage imageWithColor:[UIColor HHOrange]] forState:UIControlStateHighlighted];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    }
    return self;
}

- (HHButton *)initOrangeThinBorderButtonWithTitle:(NSString *)title textColor:(UIColor *)textColor font:(UIFont *)font {
    self = [super init];
    if (self) {
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:textColor forState:UIControlStateNormal];
        self.titleLabel.font = font;;
        self.backgroundColor = [UIColor HHOrange];
        self.layer.masksToBounds = YES;
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        self.layer.borderWidth = 1.0f;
        self.layer.cornerRadius = 5.0f;
        [self setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateHighlighted];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    }
    return self;
}


- (HHButton *)initSolidButtonWithTitle:(NSString *)title textColor:(UIColor *)textColor font:(UIFont *)font {
    self = [super init];
    if (self) {
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:textColor forState:UIControlStateNormal];
        self.titleLabel.font = font;;
        self.backgroundColor = [UIColor HHOrange];
         self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 5.0f;
        [self setTitleColor:[UIColor colorWithRed:0.87 green:0.87 blue:0.87 alpha:1] forState:UIControlStateHighlighted];
    }
    return self;

}




@end