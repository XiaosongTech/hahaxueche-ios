//
//  HHDropDownButton.m
//  hahaxueche
//
//  Created by Zixiao Wang on 7/8/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import "HHDropDownButton.h"
#import "UIColor+HHColor.h"
#import <QuartzCore/QuartzCore.h>

@implementation HHDropDownButton

- (instancetype)initWithTitle:(NSString *)title frame:(CGRect)frame {
    self = [UIButton buttonWithType:UIButtonTypeCustom];
    if (self) {
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor HHOrange] forState:UIControlStateHighlighted];
        self.frame = frame;
        self.titleLabel.font = [UIFont fontWithName:@"SourceHanSansSC-Medium" size:16];
        self.backgroundColor = [UIColor clearColor];
        self.layer.borderWidth = 0.5f;
        self.layer.borderColor = [UIColor colorWithRed:0.28 green:0.27 blue:0.24 alpha:1].CGColor;
        self.layer.masksToBounds = YES;
    }
    return self;
}

@end
