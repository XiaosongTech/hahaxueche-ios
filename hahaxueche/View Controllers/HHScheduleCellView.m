//
//  HHScheduleCellView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 9/5/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import "HHScheduleCellView.h"
#import "UIColor+HHColor.h"
#import "HHAutoLayoutUtility.h"

@implementation HHScheduleCellView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.iconImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.iconImageView];
    
    self.arrowImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.arrowImageView.image = [UIImage imageNamed:@"gray_arrow"];
    self.arrowImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.arrowImageView sizeToFit];
    [self addSubview:self.arrowImageView];
    
    self.titleLabel = [self createLabelWithFont:[UIFont fontWithName:@"STHeitiSC-Medium" size:15.0f] textColor:[UIColor colorWithRed:0.38 green:0.4 blue:0.44 alpha:1]];
    self.subTitleLabel = [self createLabelWithFont:[UIFont fontWithName:@"STHeitiSC-Light" size:13.0f] textColor:[UIColor HHGrayTextColor]];
    
    self.line = [[UIView alloc] initWithFrame:CGRectZero];
    self.line.translatesAutoresizingMaskIntoConstraints = NO;
    self.line.backgroundColor = [UIColor HHGrayLineColor];
    [self addSubview:self.line];
    
    [self autoLayoutSubviews];
}

- (UILabel *)createLabelWithFont:(UIFont *)font textColor:(UIColor *)textColor {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = font;
    label.textColor = textColor;
    [label sizeToFit];
    [self addSubview:label];
    return label;
}

- (void)autoLayoutSubviews {
    NSArray *constraints = @[
                             [HHAutoLayoutUtility setCenterY:self.iconImageView multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility horizontalAlignToSuperViewLeft:self.iconImageView constant:10.0f],
                             
                             [HHAutoLayoutUtility setCenterY:self.titleLabel multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility horizontalNext:self.titleLabel toView:self.iconImageView constant:5.0f],
                             
                             [HHAutoLayoutUtility setCenterY:self.arrowImageView multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility horizontalAlignToSuperViewRight:self.arrowImageView constant:-10.0f],
                             
                             [HHAutoLayoutUtility setCenterY:self.subTitleLabel multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility horizontalAlignToSuperViewRight:self.subTitleLabel constant:-30.0f],
                             
                             [HHAutoLayoutUtility verticalAlignToSuperViewBottom:self.line constant:0],
                             [HHAutoLayoutUtility horizontalAlignToSuperViewLeft:self.line constant:10.0f],
                             [HHAutoLayoutUtility setViewHeight:self.line multiplier:0 constant:1.0f],
                             [HHAutoLayoutUtility setViewWidth:self.line multiplier:1.0f constant:-20.0f],
                             
                             ];
    [self addConstraints:constraints];
}

- (void)setupViewsWithImage:(UIImage *)image title:(NSString *)title subTitle:(NSString *)subTitle showLine:(BOOL)showLine {
    self.iconImageView.image = image;
    [self.iconImageView sizeToFit];
    
    self.titleLabel.text = title;
    self.subTitleLabel.text = subTitle;
    
    if (showLine) {
        self.line.hidden = NO;
    } else {
        self.line.hidden = YES;
    }
}


@end
