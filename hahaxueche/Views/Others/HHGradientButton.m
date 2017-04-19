//
//  HHGradientButton.m
//  hahaxueche
//
//  Created by Zixiao Wang on 18/04/2017.
//  Copyright © 2017 Zixiao Wang. All rights reserved.
//

#import "HHGradientButton.h"
#import "UIColor+HHColor.h"
#import <QuartzCore/QuartzCore.h>

@implementation HHGradientButton

- (instancetype)initWithType:(NSInteger)type {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0];
        self.layer.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0].CGColor;;
        
        if (type == 0) {
            self.gradientLayer = [CAGradientLayer layer];
            self.gradientLayer.colors = @[(id)[UIColor colorWithRed:1.00 green:0.79 blue:0.21 alpha:1.00].CGColor, (id)[UIColor HHOrange].CGColor];
            self.gradientLayer.startPoint = CGPointMake(0, 1);
            self.gradientLayer.endPoint = CGPointMake(1, 0);
        } else {
            
        }
       
        [self.layer insertSublayer:self.gradientLayer atIndex:0];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.gradientLayer.frame = self.bounds;
}

@end
