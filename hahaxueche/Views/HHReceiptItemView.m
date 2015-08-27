//
//  HHReceiptItemView.m
//  hahaxueche
//
//  Created by Zixiao Wang on 8/27/15.
//  Copyright (c) 2015 Zixiao Wang. All rights reserved.
//

#import "HHReceiptItemView.h"
#import "HHAutoLayoutUtility.h"
#import "UIColor+HHColor.h"

@implementation HHReceiptItemView

- (instancetype)initWithFrame:(CGRect)frame keyTitle:(NSString *)keyTitle value:(NSString *)value {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.keyLabel = [self createLabelWithTitle:keyTitle font:[UIFont fontWithName:@"SourceHanSansCN-Normal" size:12.0f] textColor:[UIColor HHGrayTextColor]];
        self.valueLabel = [self createLabelWithTitle:value font:[UIFont fontWithName:@"SourceHanSansCN-Normal" size:12.0f] textColor:[UIColor HHGrayTextColor]];
        [self autoLayoutSubviews];
    }
    return self;
}

- (void)autoLayoutSubviews {
    NSArray *constraints = @[
                             [HHAutoLayoutUtility horizontalAlignToSuperViewLeft:self.keyLabel constant:0],
                             [HHAutoLayoutUtility verticalAlignToSuperViewTop:self.keyLabel constant:0],
                             
                             [HHAutoLayoutUtility setCenterY:self.valueLabel toView:self.keyLabel multiplier:1.0f constant:0],
                             [HHAutoLayoutUtility setCenterX:self.valueLabel multiplier:2.0f constant:-CGRectGetWidth(self.valueLabel.bounds)/2.0f]
                             ];
    [self addConstraints:constraints];
}


- (UILabel *)createLabelWithTitle:(NSString *)title font:(UIFont *)font textColor:(UIColor *)textColor {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.text = title;
    label.font = font;
    label.textColor = textColor;
    [self addSubview:label];
    [label sizeToFit];
    return label;
}

@end
