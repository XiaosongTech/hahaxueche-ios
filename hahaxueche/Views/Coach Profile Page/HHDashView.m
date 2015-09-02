//
//  HHDashView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 7/22/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import "HHDashView.h"
#import "HHAutoLayoutUtility.h"
#import "UIColor+HHColor.h"


@implementation HHDashView

- (instancetype)initWithValueTextColor:(UIColor *)textColor rightLine:(BOOL)rightLine {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.keyLabel = [self createLabelWithFont:[UIFont fontWithName:@"STHeitiSC-Medium" size:12.0f] textColor:[UIColor HHGrayTextColor]];
        self.valueLabel = [self createLabelWithFont:[UIFont fontWithName:@"STHeitiSC-Medium" size:15.0f] textColor:textColor];
        if (rightLine) {
            self.rightLine = [[UIView alloc] initWithFrame:CGRectZero];
            self.rightLine.translatesAutoresizingMaskIntoConstraints = NO;
            self.rightLine.backgroundColor = [UIColor HHGrayLineColor];
            [self addSubview:self.rightLine];
        }
        [self autoLayoutSubviews];
        
    }
    return self;
}

- (UILabel *)createLabelWithFont:(UIFont *)font textColor:(UIColor *)textColor {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.font = font;
    label.textColor = textColor;
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    return label;
}

- (void)autoLayoutSubviews {
    NSArray *constraints = nil;
    if (self.rightLine) {
        constraints = @[
                        [HHAutoLayoutUtility setCenterY:self.keyLabel multiplier:1.0f constant:-10.0f],
                        [HHAutoLayoutUtility setCenterX:self.keyLabel multiplier:1.0f constant:0],
                                 
                        [HHAutoLayoutUtility setCenterY:self.valueLabel multiplier:1.0f constant:10.0f],
                        [HHAutoLayoutUtility setCenterX:self.valueLabel multiplier:1.0f constant:0],
                                 
                        [HHAutoLayoutUtility setCenterY:self.rightLine multiplier:1.0f constant:0],
                        [HHAutoLayoutUtility horizontalAlignToSuperViewRight:self.rightLine constant:-1.0f],
                        [HHAutoLayoutUtility setViewHeight:self.rightLine multiplier:1.0f constant:-20.0f],
                        [HHAutoLayoutUtility setViewWidth:self.rightLine multiplier:0 constant:1.0f],
                        ];
    } else {
        constraints = @[
                        [HHAutoLayoutUtility setCenterY:self.keyLabel multiplier:1.0f constant:-10.0f],
                        [HHAutoLayoutUtility setCenterX:self.keyLabel multiplier:1.0f constant:0],
                        
                        [HHAutoLayoutUtility setCenterY:self.valueLabel multiplier:1.0f constant:10.0f],
                        [HHAutoLayoutUtility setCenterX:self.valueLabel multiplier:1.0f constant:0],
                        
                        ];

    }
   
    [self addConstraints:constraints];
    
}

- (void)setupViewWithKey:(NSString *)key value:(NSString *)value {
    self.keyLabel.text = key;
    self.valueLabel.text = value;
}

@end
