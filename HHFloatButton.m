//
//  HHFloatButton.m
//  hahaxueche
//
//  Created by Zixiao Wang on 7/7/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import "HHFloatButton.h"
#import "UIColor+HHColor.h"

@implementation HHFloatButton

- (instancetype)initWithTitle:(NSString *)title frame:(CGRect)frame backgroundColor:(UIColor *)color {
    self = [UIButton buttonWithType:UIButtonTypeCustom];
    if (self) {
        [self setTitle:title forState:UIControlStateNormal];
        self.frame = frame;
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont fontWithName:@"SourceHanSansSC-Regular" size:13];
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

@end
